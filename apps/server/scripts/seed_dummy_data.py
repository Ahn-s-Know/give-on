"""
더미 데이터 생성 스크립트
실행: python -m scripts.seed_dummy_data
또는: python scripts/seed_dummy_data.py
"""
import sys
import asyncio
import traceback
from pathlib import Path
from datetime import datetime, timedelta

# 프로젝트 루트를 Python 경로에 추가
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

print("🔍 모듈 임포트 중...\n")

try:
    print("  ✓ sqlalchemy 임포트 시도...")
    from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker

    print("  ✓ app.config 임포트 시도...")
    from app.config import get_settings

    print("  ✓ app.database 임포트 시도...")
    from app.database import Base

    print("  ✓ app.models 임포트 시도...")
    from app.models import Farm, WeatherLog, Alert, Donation, Reward, DamageReport, ChecklistLog

    print("\n✅ 모든 모듈 임포트 성공!\n")

except ImportError as e:
    print(f"\n❌ 임포트 오류 발생!")
    print(f"\n상세 에러 메시지:")
    print(f"  {type(e).__name__}: {e}\n")
    traceback.print_exc()
    sys.exit(1)
except Exception as e:
    print(f"\n❌ 예상치 못한 오류!")
    print(f"  {type(e).__name__}: {e}\n")
    traceback.print_exc()
    sys.exit(1)


async def init_db():
    """데이터베이스 초기화 (테이블 생성)"""
    settings = get_settings()

    if "sqlite" in settings.DATABASE_URL:
        engine_kwargs = {"echo": False, "connect_args": {"check_same_thread": False}}
    else:
        from sqlalchemy.pool import NullPool
        engine_kwargs = {"echo": False, "pool_pre_ping": True, "poolclass": NullPool}

    engine = create_async_engine(settings.DATABASE_URL, **engine_kwargs)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("✅ 데이터베이스 테이블 생성 완료")
    return engine


async def seed_data(engine):
    """더미 데이터 삽입"""
    async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    async with async_session() as session:

        # ──────────────────────────────────────────────
        # 1. 농가 데이터 (12개)
        # ──────────────────────────────────────────────
        now = datetime.utcnow()

        farms = [
            Farm(name="행복한 닭농장", owner_name="이영희", livestock_type="chicken",
                 livestock_count=5000, location="경주시 안강읍 경동로",
                 latitude=35.9042, longitude=129.2002, phone_number="010-1234-5678",
                 nx=102, ny=76, is_active=True),
            Farm(name="신선한 돼지농장", owner_name="김철수", livestock_type="pig",
                 livestock_count=200, location="원주시 소금산로",
                 latitude=37.3382, longitude=127.9164, phone_number="010-2345-6789",
                 nx=86, ny=97, is_active=True),
            Farm(name="초원의 소 목장", owner_name="박민준", livestock_type="cattle",
                 livestock_count=80, location="제주시 한경면 저지로",
                 latitude=33.3847, longitude=126.4214, phone_number="010-3456-7890",
                 nx=52, ny=38, is_active=True),
            Farm(name="오리네 농장", owner_name="정수현", livestock_type="duck",
                 livestock_count=1000, location="여주시 점봉리",
                 latitude=37.2913, longitude=127.6261, phone_number="010-4567-8901",
                 nx=91, ny=95, is_active=True),
            Farm(name="태양닭 육계농장", owner_name="이대로", livestock_type="chicken",
                 livestock_count=3000, location="전주시 완산구 평화동",
                 latitude=35.8242, longitude=127.1565, phone_number="010-5678-9012",
                 nx=63, ny=89, is_active=True),
            Farm(name="파란하늘 산란계", owner_name="최지현", livestock_type="chicken",
                 livestock_count=8000, location="안성시 공도읍 진사리",
                 latitude=37.0104, longitude=127.1961, phone_number="010-6789-0123",
                 nx=75, ny=100, is_active=True),
            Farm(name="한우명가 목장", owner_name="윤성호", livestock_type="cattle",
                 livestock_count=120, location="횡성군 둔내면",
                 latitude=37.5156, longitude=128.2145, phone_number="010-7890-1234",
                 nx=98, ny=106, is_active=True),
            Farm(name="평창 흑돼지농장", owner_name="강미라", livestock_type="pig",
                 livestock_count=350, location="평창군 봉평면",
                 latitude=37.6124, longitude=128.4865, phone_number="010-8901-2345",
                 nx=104, ny=110, is_active=True),
            Farm(name="남해 청정 오리농장", owner_name="홍길동", livestock_type="duck",
                 livestock_count=2000, location="남해군 삼동면",
                 latitude=34.8073, longitude=127.9347, phone_number="010-9012-3456",
                 nx=91, ny=56, is_active=True),
            Farm(name="속초 젖소목장", owner_name="임채원", livestock_type="cattle",
                 livestock_count=60, location="속초시 영랑동",
                 latitude=38.2070, longitude=128.5918, phone_number="010-0123-4567",
                 nx=109, ny=128, is_active=True),
            Farm(name="금산 오계농장", owner_name="배수지", livestock_type="chicken",
                 livestock_count=1500, location="금산군 금성면",
                 latitude=36.1100, longitude=127.4882, phone_number="010-1357-2468",
                 nx=71, ny=82, is_active=True),
            Farm(name="제천 흑한우목장", owner_name="서도진", livestock_type="cattle",
                 livestock_count=95, location="제천시 봉양읍",
                 latitude=37.1296, longitude=128.2095, phone_number="010-2468-1357",
                 nx=96, ny=103, is_active=True),
        ]
        session.add_all(farms)
        await session.flush()  # ID 확보
        print(f"✅ {len(farms)}개 농가 데이터 생성")

        # ──────────────────────────────────────────────
        # 2. 기상 데이터 (15개)
        # ──────────────────────────────────────────────
        weather_logs = [
            WeatherLog(latitude=35.9042, longitude=129.2002, temperature=34.5,
                       humidity=72.0, wind_speed=1.2, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=36.0, forecast_min_temp=26.0),
            WeatherLog(latitude=35.9042, longitude=129.2002, temperature=29.2,
                       humidity=62.0, wind_speed=2.8, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=31.5, forecast_min_temp=23.5),
            WeatherLog(latitude=37.3382, longitude=127.9164, temperature=32.1,
                       humidity=68.0, wind_speed=2.1, precipitation=0.0,
                       weather_condition="clear", forecast_max_temp=33.0, forecast_min_temp=25.0),
            WeatherLog(latitude=37.3382, longitude=127.9164, temperature=33.5,
                       humidity=71.0, wind_speed=1.9, precipitation=0.0,
                       weather_condition="clear", forecast_max_temp=34.5, forecast_min_temp=26.0),
            WeatherLog(latitude=33.3847, longitude=126.4214, temperature=25.3,
                       humidity=72.0, wind_speed=4.5, precipitation=2.5,
                       weather_condition="cloudy", forecast_max_temp=27.0, forecast_min_temp=20.0),
            WeatherLog(latitude=37.2913, longitude=127.6261, temperature=30.2,
                       humidity=60.0, wind_speed=2.5, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=33.5, forecast_min_temp=24.0),
            WeatherLog(latitude=35.8242, longitude=127.1565, temperature=36.8,
                       humidity=55.0, wind_speed=1.1, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=38.0, forecast_min_temp=27.0),
            WeatherLog(latitude=37.0104, longitude=127.1961, temperature=28.0,
                       humidity=65.0, wind_speed=3.0, precipitation=0.0,
                       weather_condition="partly_cloudy", forecast_max_temp=30.0, forecast_min_temp=22.0),
            WeatherLog(latitude=37.5156, longitude=128.2145, temperature=22.5,
                       humidity=58.0, wind_speed=5.2, precipitation=0.0,
                       weather_condition="clear", forecast_max_temp=24.0, forecast_min_temp=16.0),
            WeatherLog(latitude=37.6124, longitude=128.4865, temperature=29.5,
                       humidity=69.0, wind_speed=2.3, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=31.0, forecast_min_temp=23.0),
            WeatherLog(latitude=34.8073, longitude=127.9347, temperature=31.0,
                       humidity=63.0, wind_speed=3.7, precipitation=0.0,
                       weather_condition="clear", forecast_max_temp=33.0, forecast_min_temp=25.0),
            WeatherLog(latitude=38.2070, longitude=128.5918, temperature=20.1,
                       humidity=54.0, wind_speed=6.0, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=22.0, forecast_min_temp=14.0),
            WeatherLog(latitude=36.1100, longitude=127.4882, temperature=35.2,
                       humidity=58.0, wind_speed=1.5, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=37.0, forecast_min_temp=27.0),
            WeatherLog(latitude=37.1296, longitude=128.2095, temperature=24.0,
                       humidity=61.0, wind_speed=4.1, precipitation=1.0,
                       weather_condition="partly_cloudy", forecast_max_temp=26.0, forecast_min_temp=18.0),
            WeatherLog(latitude=35.9042, longitude=129.2002, temperature=37.1,
                       humidity=75.0, wind_speed=0.8, precipitation=0.0,
                       weather_condition="sunny", forecast_max_temp=38.5, forecast_min_temp=28.0),
        ]
        session.add_all(weather_logs)
        await session.flush()
        print(f"✅ {len(weather_logs)}개 기상 데이터 생성")

        # ──────────────────────────────────────────────
        # 3. 경보 데이터 (15개, 다양한 risk_level)
        # ──────────────────────────────────────────────
        alerts = [
            Alert(farm_id=1, risk_level="emergency", temperature=37, humidity=75,
                  message="🚨 긴급! 현재 37°C 폭염으로 닭 집단 폐사 위험. 즉시 냉방·환기·음수 점검 필요.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=1, risk_level="danger", temperature=34, humidity=72,
                  message="⚠️ 위험: 34°C 고온. 환기팬 최대 가동, 물 자동 공급 시스템 점검하세요.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=1, risk_level="caution", temperature=29, humidity=65,
                  message="⚠️ 주의: 기온 상승 추세. 내일 최고 31.5°C 예상. 선제적 환기 관리 권장.",
                  is_sent=False),
            Alert(farm_id=2, risk_level="emergency", temperature=33, humidity=71,
                  message="🚨 긴급! 돼지 폭염 임계점 초과(33°C, 습도71%). 스프링클러 즉시 가동하세요.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=2, risk_level="danger", temperature=32, humidity=68,
                  message="⚠️ 위험: 고온다습. 사료 섭취량 감소 우려. 물 공급량 30% 증량 조치.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=3, risk_level="caution", temperature=25, humidity=72,
                  message="⚠️ 주의: 습도 72% 고습. 축사 환기 강화하고 발굽 상태 점검하세요.",
                  is_sent=False),
            Alert(farm_id=4, risk_level="safe", temperature=30, humidity=60,
                  message="✅ 안전: 현재 기상은 오리 사육에 적합합니다. 정상 관리 유지하세요.",
                  is_sent=False),
            Alert(farm_id=5, risk_level="emergency", temperature=36, humidity=55,
                  message="🚨 긴급! 36.8°C 극심한 폭염. 닭 긴급 대피 조치 및 119 신고 준비하세요.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=5, risk_level="danger", temperature=33, humidity=58,
                  message="⚠️ 위험: 닭 위험 온도 돌파. 차광막 설치·물 분무·환기팬 점검 즉시 시행.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=6, risk_level="danger", temperature=31, humidity=67,
                  message="⚠️ 위험: 산란계 폭염 스트레스. 산란율 저하 우려. 쿨링패드 가동하세요.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=7, risk_level="safe", temperature=22, humidity=58,
                  message="✅ 안전: 한우 사육에 쾌적한 기상 조건입니다.", is_sent=False),
            Alert(farm_id=8, risk_level="caution", temperature=29, humidity=69,
                  message="⚠️ 주의: 흑돼지 더위 시작 구간. 사육밀도 조정 권장.", is_sent=False),
            Alert(farm_id=9, risk_level="caution", temperature=31, humidity=63,
                  message="⚠️ 주의: 오리 고온 주의 구간. 수조 수온 관리 필요.", is_sent=False),
            Alert(farm_id=11, risk_level="emergency", temperature=35, humidity=58,
                  message="🚨 긴급! 오계 폭염 임계 초과. 품종 특성상 더위에 취약. 즉각 조치 요망.",
                  is_sent=True, sent_via='["fcm"]'),
            Alert(farm_id=12, risk_level="safe", temperature=24, humidity=61,
                  message="✅ 안전: 제천 한우 적정 기상. 정상 관리 유지하세요.", is_sent=False),
        ]
        session.add_all(alerts)
        await session.flush()
        print(f"✅ {len(alerts)}개 경보 데이터 생성")

        # ──────────────────────────────────────────────
        # 4. 피해 신고 (10개, is_published=True 포함)
        # ──────────────────────────────────────────────
        damage_reports = [
            DamageReport(farm_id=1, dead_count=320, cause="heatwave",
                         estimated_loss=4800000, farmer_note="이틀 새 닭들이 폐사했습니다. 냉방 장비가 버티질 못했어요.",
                         story_title="37도 폭염에 무너진 이영희 농가의 닭 320마리",
                         story_content="경주시 안강읍에서 닭 5000마리를 키우는 이영희 씨. 이틀간 이어진 37°C 폭염으로 냉방 장비가 과부하되어 닭 320마리가 폐사하는 피해를 입었습니다. 10년 넘게 지켜온 농장이 기후 위기 앞에 무너지는 순간이었습니다.",
                         needs='["냉방팬 2대","차광막","응급 음수대"]',
                         is_published=True),
            DamageReport(farm_id=2, dead_count=45, cause="heatwave",
                         estimated_loss=9000000, farmer_note="돼지들이 쓰러지는 걸 보고 얼마나 무서웠는지...",
                         story_title="고온다습에 무너진 원주 돼지농장 김철수 씨",
                         story_content="원주시에서 돼지 200마리를 기르는 김철수 씨. 33°C를 넘는 폭염과 70% 이상의 습도로 돼지 45마리가 폐사했습니다. 스프링클러 고장이 피해를 키웠습니다.",
                         needs='["스프링클러 부품","사료","수의사 왕진비"]',
                         is_published=True),
            DamageReport(farm_id=5, dead_count=500, cause="heatwave",
                         estimated_loss=6000000, farmer_note="36도가 넘는 날이 사흘이나 이어졌습니다.",
                         story_title="3일 연속 폭염, 전주 이대로 씨 닭 500마리 집단 폐사",
                         story_content="전주시에서 육계 농장을 운영하는 이대로 씨. 3일 연속 36°C를 넘는 폭염이 이어지며 전체 사육 두수의 17%에 달하는 닭 500마리가 폐사하는 대규모 피해를 입었습니다.",
                         needs='["긴급 냉방 장비","전기료 지원","병아리 입식 지원"]',
                         is_published=True),
            DamageReport(farm_id=6, dead_count=200, cause="heatwave",
                         estimated_loss=3200000, farmer_note="산란계라 산란율도 반 이하로 뚝 떨어졌어요.",
                         story_title="폭염으로 무너진 안성 최지현 씨 산란계 농장",
                         story_content="안성시에서 산란계 8000마리를 기르는 최지현 씨. 폭염으로 닭 200마리가 폐사하고 산란율이 정상의 40% 수준으로 급감했습니다.",
                         needs='["쿨링패드","전해질 영양제","계란 판매 손실 보전"]',
                         is_published=True),
            DamageReport(farm_id=11, dead_count=150, cause="heatwave",
                         estimated_loss=5250000, farmer_note="오계는 더위에 더 약해서 정말 힘들었습니다.",
                         story_title="천연기념물 오계 150마리, 폭염에 쓰러지다",
                         story_content="금산군에서 희귀 오계 1500마리를 사육하는 배수지 씨. 폭염으로 오계 150마리가 폐사했습니다. 오계는 일반 닭보다 더위에 취약해 피해가 컸습니다.",
                         needs='["냉방 시설 보강","오계 입식비","사료 지원"]',
                         is_published=True),
            DamageReport(farm_id=8, dead_count=30, cause="heatwave",
                         estimated_loss=7500000, farmer_note="흑돼지 특성상 회복이 더 어렵습니다.",
                         story_title="평창 흑돼지 30마리 폭염 폐사, 강미라 씨 농가",
                         story_content="평창군 봉평면에서 흑돼지를 기르는 강미라 씨. 이상 고온으로 흑돼지 30마리가 폐사했습니다.",
                         needs='["스프링클러","돈사 단열재"]',
                         is_published=True),
            DamageReport(farm_id=4, dead_count=80, cause="heatwave",
                         estimated_loss=2400000, farmer_note="오리는 물을 좋아하는데 수온이 너무 올라버렸어요.",
                         story_title="여주 정수현 씨 오리농장 폭염 피해",
                         story_content="여주시에서 오리 1000마리를 기르는 정수현 씨. 기록적인 폭염으로 수조 수온이 35°C를 넘어 오리 80마리가 폐사했습니다.",
                         needs='["수조 냉각 장치","사료"]',
                         is_published=True),
            DamageReport(farm_id=9, dead_count=60, cause="heatwave",
                         estimated_loss=1800000, farmer_note="남해까지 이렇게 더울 줄 몰랐습니다.",
                         story_title="남해 청정 오리농장 홍길동 씨 폭염 피해",
                         story_content="남해군에서 청정 오리를 기르는 홍길동 씨. 남해 지역도 예외 없는 폭염으로 오리 60마리가 폐사했습니다.",
                         needs='["차광 시설","음수대 보강"]',
                         is_published=False),
            DamageReport(farm_id=1, dead_count=100, cause="storm",
                         estimated_loss=2500000, farmer_note="갑작스러운 우박에 닭장 지붕이 뚫렸어요.",
                         story_title="우박 피해로 무너진 경주 이영희 씨 닭장",
                         story_content="경주 이영희 씨 농장에 갑작스러운 우박이 내려 닭장 지붕이 파손되었습니다. 이 과정에서 닭 100마리가 폐사하고 시설 피해도 컸습니다.",
                         needs='["닭장 지붕 복구 자재","입식 닭"]',
                         is_published=False),
            DamageReport(farm_id=3, dead_count=5, cause="cold_wave",
                         estimated_loss=3000000, farmer_note="1월 한파가 이렇게 심할 줄...",
                         story_title="제주 한파로 쓰러진 초원목장 박민준 씨 한우",
                         story_content="제주시 한경면에서 한우를 기르는 박민준 씨. 이례적인 한파로 한우 5마리가 폐사했습니다.",
                         needs='["축사 보온재","사료 지원"]',
                         is_published=False),
        ]
        session.add_all(damage_reports)
        await session.flush()
        print(f"✅ {len(damage_reports)}개 피해 신고 데이터 생성")

        # ──────────────────────────────────────────────
        # 5. 기부 데이터 (12개)
        # ──────────────────────────────────────────────
        donations = [
            Donation(farm_id=1, donor_name="홍길동", amount=50000, message="힘내세요! 폭염 이겨내시길 바랍니다.",
                     payment_method="kakaopay", status="completed", reward_points=2500, tax_receipt_issued=True,
                     created_at=now - timedelta(days=2), confirmed_at=now - timedelta(days=2)),
            Donation(farm_id=1, donor_name=None, amount=10000, message="익명으로 응원합니다.",
                     payment_method="card", status="completed", reward_points=500, tax_receipt_issued=False,
                     created_at=now - timedelta(days=1), confirmed_at=now - timedelta(days=1)),
            Donation(farm_id=1, donor_name="이지영", amount=30000, message="농부님 고생 많으세요.",
                     payment_method="naverpay", status="completed", reward_points=1500, tax_receipt_issued=True,
                     created_at=now - timedelta(hours=12), confirmed_at=now - timedelta(hours=12)),
            Donation(farm_id=2, donor_name="박서연", amount=100000, message="우리 먹거리 지켜주셔서 감사합니다.",
                     payment_method="kakaopay", status="completed", reward_points=5000, tax_receipt_issued=True,
                     created_at=now - timedelta(days=3), confirmed_at=now - timedelta(days=3)),
            Donation(farm_id=2, donor_name="김도현", amount=20000, message="돼지 친구들 살려주세요.",
                     payment_method="card", status="completed", reward_points=1000, tax_receipt_issued=False,
                     created_at=now - timedelta(days=1), confirmed_at=now - timedelta(days=1)),
            Donation(farm_id=5, donor_name="최승현", amount=50000, message="무더위 이겨내세요!",
                     payment_method="kakaopay", status="completed", reward_points=2500, tax_receipt_issued=True,
                     created_at=now - timedelta(days=4), confirmed_at=now - timedelta(days=4)),
            Donation(farm_id=5, donor_name="정다은", amount=30000, message="농장 빠른 회복 바랍니다.",
                     payment_method="naverpay", status="completed", reward_points=1500, tax_receipt_issued=False,
                     created_at=now - timedelta(days=2), confirmed_at=now - timedelta(days=2)),
            Donation(farm_id=6, donor_name=None, amount=5000, message="작지만 도움이 되길.",
                     payment_method="card", status="completed", reward_points=250, tax_receipt_issued=False,
                     created_at=now - timedelta(hours=6), confirmed_at=now - timedelta(hours=6)),
            Donation(farm_id=11, donor_name="임소율", amount=50000, message="오계가 사라지면 안 되죠!",
                     payment_method="kakaopay", status="completed", reward_points=2500, tax_receipt_issued=True,
                     created_at=now - timedelta(days=1), confirmed_at=now - timedelta(days=1)),
            Donation(farm_id=11, donor_name="강현준", amount=10000, message="화이팅!",
                     payment_method="card", status="completed", reward_points=500, tax_receipt_issued=False,
                     created_at=now - timedelta(hours=3), confirmed_at=now - timedelta(hours=3)),
            Donation(farm_id=3, donor_name="송지우", amount=30000, message="제주 한우 힘내세요.",
                     payment_method="kakaopay", status="completed", reward_points=1500, tax_receipt_issued=True,
                     created_at=now - timedelta(days=5), confirmed_at=now - timedelta(days=5)),
            Donation(farm_id=4, donor_name="전하진", amount=15000, message="여주 오리 응원해요.",
                     payment_method="naverpay", status="pending", reward_points=0, tax_receipt_issued=False,
                     created_at=now - timedelta(hours=1)),
        ]
        session.add_all(donations)
        await session.flush()
        print(f"✅ {len(donations)}개 기부 데이터 생성")

        # ──────────────────────────────────────────────
        # 6. 리워드 데이터 (confirmed 기부에 대해)
        # ──────────────────────────────────────────────
        rewards = [
            Reward(donation_id=1, points=2500, tax_deduct=7500, local_currency="경상북도지역화폐",
                   status="issued", issued_at=now - timedelta(days=2)),
            Reward(donation_id=2, points=500, tax_deduct=1500, local_currency=None,
                   status="issued", issued_at=now - timedelta(days=1)),
            Reward(donation_id=3, points=1500, tax_deduct=4500, local_currency="전주사랑상품권",
                   status="issued", issued_at=now - timedelta(hours=12)),
            Reward(donation_id=4, points=5000, tax_deduct=15000, local_currency="강원지역화폐",
                   status="issued", issued_at=now - timedelta(days=3)),
            Reward(donation_id=5, points=1000, tax_deduct=3000, local_currency=None,
                   status="issued", issued_at=now - timedelta(days=1)),
            Reward(donation_id=6, points=2500, tax_deduct=7500, local_currency="전북사랑상품권",
                   status="issued", issued_at=now - timedelta(days=4)),
            Reward(donation_id=7, points=1500, tax_deduct=4500, local_currency=None,
                   status="pending", issued_at=None),
            Reward(donation_id=8, points=250, tax_deduct=750, local_currency=None,
                   status="issued", issued_at=now - timedelta(hours=6)),
            Reward(donation_id=9, points=2500, tax_deduct=7500, local_currency="충청남도지역화폐",
                   status="issued", issued_at=now - timedelta(days=1)),
            Reward(donation_id=10, points=500, tax_deduct=1500, local_currency=None,
                   status="issued", issued_at=now - timedelta(hours=3)),
            Reward(donation_id=11, points=1500, tax_deduct=4500, local_currency="제주사랑상품권",
                   status="issued", issued_at=now - timedelta(days=5)),
        ]
        session.add_all(rewards)
        await session.flush()
        print(f"✅ {len(rewards)}개 리워드 데이터 생성")

        # ──────────────────────────────────────────────
        # 7. 체크리스트 이행 로그 (12개)
        # ──────────────────────────────────────────────
        checklist_logs = [
            ChecklistLog(farm_id=1, alert_id=1, item_id=1, item_text="환기팬 최대 가동 확인",
                         completed_at=now - timedelta(hours=5)),
            ChecklistLog(farm_id=1, alert_id=1, item_id=2, item_text="음수대 물 온도 25°C 이하 유지",
                         completed_at=now - timedelta(hours=4, minutes=30)),
            ChecklistLog(farm_id=1, alert_id=1, item_id=3, item_text="사육밀도 기준치 10% 감축",
                         completed_at=now - timedelta(hours=4)),
            ChecklistLog(farm_id=1, alert_id=2, item_id=1, item_text="차광막 설치 완료",
                         completed_at=now - timedelta(days=1, hours=3)),
            ChecklistLog(farm_id=2, alert_id=4, item_id=1, item_text="스프링클러 가동 확인",
                         completed_at=now - timedelta(hours=6)),
            ChecklistLog(farm_id=2, alert_id=4, item_id=2, item_text="돈사 내 온도계 교정",
                         completed_at=now - timedelta(hours=5, minutes=30)),
            ChecklistLog(farm_id=2, alert_id=4, item_id=3, item_text="물 공급량 30% 증량 조치",
                         completed_at=now - timedelta(hours=5)),
            ChecklistLog(farm_id=5, alert_id=8, item_id=1, item_text="긴급 냉방팬 추가 가동",
                         completed_at=now - timedelta(hours=8)),
            ChecklistLog(farm_id=5, alert_id=8, item_id=2, item_text="수의사 긴급 방문 요청",
                         completed_at=now - timedelta(hours=7)),
            ChecklistLog(farm_id=6, alert_id=10, item_id=1, item_text="쿨링패드 가동 확인",
                         completed_at=now - timedelta(hours=3)),
            ChecklistLog(farm_id=6, alert_id=10, item_id=2, item_text="산란 환경 온도 26°C 유지",
                         completed_at=now - timedelta(hours=2)),
            ChecklistLog(farm_id=11, alert_id=14, item_id=1, item_text="오계 사육장 차광 90% 이상 확보",
                         completed_at=now - timedelta(hours=4)),
        ]
        session.add_all(checklist_logs)
        await session.flush()
        print(f"✅ {len(checklist_logs)}개 체크리스트 이행 로그 생성")

        await session.commit()

        print("\n" + "=" * 55)
        print("🎉 더미 데이터 생성 완료!")
        print("=" * 55)
        print(f"  농가         : {len(farms)}개")
        print(f"  기상 데이터  : {len(weather_logs)}개")
        print(f"  경보         : {len(alerts)}개")
        print(f"  피해 신고    : {len(damage_reports)}개 (공개 {sum(1 for d in damage_reports if d.is_published)}개)")
        print(f"  기부         : {len(donations)}개")
        print(f"  리워드       : {len(rewards)}개")
        print(f"  체크리스트   : {len(checklist_logs)}개")
        print("=" * 55)


async def main():
    print("📊 더미 데이터 생성 스크립트 시작...\n")
    engine = await init_db()
    await seed_data(engine)
    await engine.dispose()
    print("\n✨ 완료! 'uvicorn app.main:app --reload'로 서버를 시작하세요.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except Exception as e:
        print(f"\n❌ 오류 발생: {e}")
        traceback.print_exc()
        sys.exit(1)
