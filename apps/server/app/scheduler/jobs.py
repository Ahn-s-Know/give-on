"""
APScheduler 작업 정의
- 30분마다: 기상 수집 + 위험도 판단 + 경보 발송
- 매일 07:00: 오늘 위험 예보 선발송
- 매일 00:00: 오래된 기상 로그 정리
"""
import logging
from datetime import datetime, timedelta

from sqlalchemy import select, delete

from app.database import get_session_maker
from app.integrations.kma_client import KMAClient
from app.agent.alert_generator import process_farm_alert
from app.integrations.fcm_client import send_farm_alert, parse_device_tokens
from app.integrations.kakao_client import send_farm_alert_sms
from app.models.farm import Farm
from app.models.alert import Alert
from app.models.weather import WeatherLog

logger = logging.getLogger(__name__)


async def collect_weather_and_alert():
    """
    30분마다 실행:
    1. 활성 농가 전체 기상 데이터 수집
    2. 축종별 위험도 판단
    3. danger/emergency → Claude API 경보 메시지 생성
    4. FCM + 알림톡 발송
    5. WeatherLog + Alert DB 저장
    """
    logger.info("🌤️ 기상 수집 + 경보 판단 작업 시작")
    session_maker = get_session_maker()
    kma_client = KMAClient()

    try:
        async with session_maker() as session:
            # 활성 농가 조회
            result = await session.execute(
                select(Farm).where(Farm.is_active == True)
            )
            farms = result.scalars().all()
            logger.info(f"  활성 농가 {len(farms)}개 처리 시작")

            alert_count = 0
            for farm in farms:
                try:
                    # 기상 데이터 수집
                    weather = await kma_client.get_weather(farm.latitude, farm.longitude)
                    if weather is None:
                        continue

                    # WeatherLog 저장
                    weather_log = WeatherLog(
                        latitude=farm.latitude,
                        longitude=farm.longitude,
                        temperature=weather.temperature,
                        humidity=weather.humidity,
                        wind_speed=weather.wind_speed,
                        precipitation=weather.precipitation,
                        weather_condition=weather.weather_condition,
                        forecast_max_temp=weather.forecast_max_temp,
                        forecast_min_temp=weather.forecast_min_temp,
                    )
                    session.add(weather_log)

                    # 경보 처리 (위험도 판단 + 메시지 생성 + DB 저장)
                    alert = await process_farm_alert(farm, weather, session)

                    if alert:
                        alert_count += 1
                        # FCM 발송
                        tokens = parse_device_tokens(farm.device_tokens)
                        if tokens:
                            sent = await send_farm_alert(farm, alert)
                            if sent:
                                alert.is_sent = True
                                import json
                                alert.sent_via = json.dumps(["fcm"])

                        # 알림톡 발송 (FCM 없는 고령 농가)
                        if not tokens and farm.kakao_id:
                            await send_farm_alert_sms(farm, alert)
                            alert.sent_via = '["sms"]'

                        await session.commit()

                except Exception as e:
                    logger.error(f"  farm_id={farm.id} 처리 실패: {e}")
                    await session.rollback()
                    continue

        logger.info(f"✅ 기상 수집 완료 — 경보 발송 {alert_count}건")

    except Exception as e:
        logger.error(f"collect_weather_and_alert 실패: {e}")
    finally:
        await kma_client.close()


async def send_daily_morning_report():
    """
    매일 07:00: 오늘 위험 예보 선발송
    최고기온 예보 기준으로 danger 예상 농가에 선제 경보
    """
    logger.info("🌅 일일 아침 브리핑 발송 시작")
    # TODO: 내일 최고기온 기준 위험 예상 농가 선별 → 선제 경보


async def cleanup_old_logs():
    """
    매일 00:00: 30일 이상된 기상 로그 삭제
    """
    logger.info("🧹 오래된 기상 로그 정리 시작")
    cutoff = datetime.utcnow() - timedelta(days=30)
    session_maker = get_session_maker()

    try:
        async with session_maker() as session:
            result = await session.execute(
                delete(WeatherLog).where(WeatherLog.collected_at < cutoff)
            )
            await session.commit()
            logger.info(f"  기상 로그 {result.rowcount}건 삭제 완료")
    except Exception as e:
        logger.error(f"cleanup_old_logs 실패: {e}")
