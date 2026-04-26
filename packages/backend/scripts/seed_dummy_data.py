"""
더미 데이터 생성 스크립트
실행: python -m scripts.seed_dummy_data
"""
import asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from app.config import get_settings
from app.database import Base
from app.models import Farm, WeatherLog, Alert

settings = get_settings()


async def init_db():
    """데이터베이스 초기화 (테이블 생성)"""
    engine = create_async_engine(settings.DATABASE_URL, echo=False)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("✅ 데이터베이스 테이블 생성 완료")
    return engine


async def seed_data(engine):
    """더미 데이터 삽입"""
    async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    async with async_session() as session:
        # 1. 농가 데이터 (5개)
        farms = [
            Farm(
                name="행복한 닭농장",
                owner_name="이영희",
                livestock_type="chicken",
                livestock_count=5000,
                location="경주시 안강읍 경동로",
                latitude=35.9042,
                longitude=129.2002,
                phone_number="010-1234-5678",
                is_active=True,
            ),
            Farm(
                name="신선한 돼지농장",
                owner_name="김철수",
                livestock_type="pig",
                livestock_count=200,
                location="원주시 소금산로",
                latitude=37.3382,
                longitude=127.9164,
                phone_number="010-2345-6789",
                is_active=True,
            ),
            Farm(
                name="초원의 소 목장",
                owner_name="박민준",
                livestock_type="cattle",
                livestock_count=80,
                location="제주시 한경면 저지로",
                latitude=33.3847,
                longitude=126.4214,
                phone_number="010-3456-7890",
                is_active=True,
            ),
            Farm(
                name="오리네 농장",
                owner_name="정수현",
                livestock_type="duck",
                livestock_count=1000,
                location="여주시 점봉리",
                latitude=37.2913,
                longitude=127.6261,
                phone_number="010-4567-8901",
                is_active=True,
            ),
            Farm(
                name="다목적 축산농장",
                owner_name="이대로",
                livestock_type="chicken",
                livestock_count=3000,
                location="전주시 완산구 평화동",
                latitude=35.8242,
                longitude=127.1565,
                phone_number="010-5678-9012",
                is_active=True,
            ),
        ]
        session.add_all(farms)
        await session.commit()
        print(f"✅ {len(farms)}개 농가 데이터 생성 완료")

        # 2. 기상 데이터 (15개)
        weather_logs = [
            WeatherLog(
                latitude=35.9042,
                longitude=129.2002,
                temperature=28.5,
                humidity=65.0,
                wind_speed=3.2,
                precipitation=0.0,
                weather_condition="sunny",
                forecast_max_temp=30.0,
                forecast_min_temp=22.0,
            ),
            WeatherLog(
                latitude=35.9042,
                longitude=129.2002,
                temperature=29.2,
                humidity=62.0,
                wind_speed=2.8,
                precipitation=0.0,
                weather_condition="sunny",
                forecast_max_temp=31.5,
                forecast_min_temp=23.5,
            ),
            WeatherLog(
                latitude=37.3382,
                longitude=127.9164,
                temperature=32.1,
                humidity=58.0,
                wind_speed=2.1,
                precipitation=0.0,
                weather_condition="clear",
                forecast_max_temp=33.0,
                forecast_min_temp=25.0,
            ),
            WeatherLog(
                latitude=37.3382,
                longitude=127.9164,
                temperature=33.5,
                humidity=55.0,
                wind_speed=1.9,
                precipitation=0.0,
                weather_condition="clear",
                forecast_max_temp=34.5,
                forecast_min_temp=26.0,
            ),
            WeatherLog(
                latitude=33.3847,
                longitude=126.4214,
                temperature=25.3,
                humidity=72.0,
                wind_speed=4.5,
                precipitation=2.5,
                weather_condition="cloudy",
                forecast_max_temp=27.0,
                forecast_min_temp=20.0,
            ),
            WeatherLog(
                latitude=33.3847,
                longitude=126.4214,
                temperature=26.1,
                humidity=70.0,
                wind_speed=4.2,
                precipitation=1.2,
                weather_condition="partly_cloudy",
                forecast_max_temp=28.0,
                forecast_min_temp=21.0,
            ),
            WeatherLog(
                latitude=37.2913,
                longitude=127.6261,
                temperature=30.2,
                humidity=60.0,
                wind_speed=2.5,
                precipitation=0.0,
                weather_condition="sunny",
                forecast_max_temp=32.0,
                forecast_min_temp=24.0,
            ),
            WeatherLog(
                latitude=37.2913,
                longitude=127.6261,
                temperature=31.5,
                humidity=58.0,
                wind_speed=2.3,
                precipitation=0.0,
                weather_condition="clear",
                forecast_max_temp=33.5,
                forecast_min_temp=25.5,
            ),
        ]
        session.add_all(weather_logs)
        await session.commit()
        print(f"✅ {len(weather_logs)}개 기상 데이터 생성 완료")

        # 3. 경보 데이터 (8개)
        alerts = [
            Alert(
                farm_id=1,
                risk_level="danger",
                temperature=29,
                humidity=65,
                message="⚠️ 닭들을 위해 적절한 환기가 필요합니다. 내일 최고 31도 예상됩니다.",
            ),
            Alert(
                farm_id=1,
                risk_level="caution",
                temperature=28,
                humidity=68,
                message="⚠️ 습도 관리에 주의해주세요. 곰팡이 감염 위험이 있습니다.",
            ),
            Alert(
                farm_id=2,
                risk_level="emergency",
                temperature=33,
                humidity=55,
                message="🚨 긴급! 돼지의 체온 관리가 필수입니다. 냉방 시스템 점검 요청!",
            ),
            Alert(
                farm_id=2,
                risk_level="danger",
                temperature=32,
                humidity=58,
                message="⚠️ 고온 주의. 물 공급을 충분히 하고 사료 급여를 조절해주세요.",
            ),
            Alert(
                farm_id=3,
                risk_level="caution",
                temperature=25,
                humidity=72,
                message="⚠️ 습도가 높으니 축사 내 환기를 강화해주세요.",
            ),
            Alert(
                farm_id=4,
                risk_level="safe",
                temperature=30,
                humidity=60,
                message="✅ 현재 기상은 오리 사육에 적합한 상태입니다.",
            ),
            Alert(
                farm_id=5,
                risk_level="danger",
                temperature=28,
                humidity=70,
                message="⚠️ 온·습도 관리에 주의. 내일도 높은 기온이 예상됩니다.",
            ),
            Alert(
                farm_id=1,
                risk_level="safe",
                temperature=25,
                humidity=60,
                message="✅ 오늘은 닭 사육에 안전한 기상 조건입니다.",
            ),
        ]
        session.add_all(alerts)
        await session.commit()
        print(f"✅ {len(alerts)}개 경보 데이터 생성 완료")

        print("\n" + "=" * 50)
        print("🎉 더미 데이터 생성이 완료되었습니다!")
        print("=" * 50)


async def main():
    """메인 함수"""
    print("📊 더미 데이터 생성 스크립트 시작...\n")
    engine = await init_db()
    await seed_data(engine)
    await engine.dispose()
    print("\n✨ 완료! 이제 'uvicorn app.main:app --reload'로 서버를 시작할 수 있습니다.")


if __name__ == "__main__":
    asyncio.run(main())
