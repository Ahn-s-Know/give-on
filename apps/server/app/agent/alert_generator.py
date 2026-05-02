"""
경보 생성 오케스트레이터
위험도 판단 → 메시지 생성 → DB 저장까지 통합 처리
"""
import logging
from typing import Optional

from sqlalchemy.ext.asyncio import AsyncSession

from app.agent.risk_engine import calculate_risk_level, get_caution_template
from app.agent.claude_agent import generate_alert_message
from app.models.alert import Alert

logger = logging.getLogger(__name__)


async def process_farm_alert(
    farm,
    weather_data,
    db_session: AsyncSession,
) -> Optional[Alert]:
    """
    농가 1건에 대한 경보 처리 파이프라인.

    1. calculate_risk_level — 룰 기반 위험도 계산
    2. safe → None 반환 (경보 불필요)
    3. caution → 템플릿 메시지 (Claude API 미호출)
    4. danger / emergency → Claude API 맞춤 메시지 생성
    5. Alert DB 저장 후 반환

    Parameters
    ----------
    farm : Farm ORM instance
        농가 정보
    weather_data : WeatherData (dataclass)
        기상 수집 데이터
    db_session : AsyncSession
        DB 세션

    Returns
    -------
    Alert | None
        생성된 경보 객체 또는 None(safe)
    """
    risk_level = calculate_risk_level(
        livestock_type=farm.livestock_type,
        temperature=weather_data.temperature,
        humidity=weather_data.humidity,
    )

    if risk_level == "safe":
        return None

    farm_info = {
        "name": farm.name,
        "livestock_type": farm.livestock_type,
        "livestock_count": farm.livestock_count,
        "location": farm.location,
    }
    weather_dict = {
        "temperature": weather_data.temperature,
        "humidity": weather_data.humidity,
        "forecast_max_temp": getattr(weather_data, "forecast_max_temp", 0) or 0,
        "forecast_min_temp": getattr(weather_data, "forecast_min_temp", 0) or 0,
    }

    try:
        message = await generate_alert_message(farm_info, weather_dict, risk_level)
    except Exception as e:
        logger.error(f"메시지 생성 실패 farm_id={farm.id}: {e}")
        message = f"⚠️ 기상 {risk_level} 경보. 축사 환경을 즉시 점검하세요."

    alert = Alert(
        farm_id=farm.id,
        risk_level=risk_level,
        temperature=int(weather_data.temperature),
        humidity=int(weather_data.humidity) if weather_data.humidity else None,
        message=message,
        is_sent=False,
    )

    try:
        db_session.add(alert)
        await db_session.commit()
        await db_session.refresh(alert)
        logger.info(f"경보 저장 farm_id={farm.id} level={risk_level}")
    except Exception as e:
        await db_session.rollback()
        logger.error(f"경보 DB 저장 실패 farm_id={farm.id}: {e}")
        return None

    return alert
