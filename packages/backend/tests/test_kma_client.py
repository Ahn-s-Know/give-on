"""
기상청 API 클라이언트 테스트
"""
import pytest
import asyncio
from app.data.kma_client import KMAClient, LatLngToGrid, WeatherData


class TestLatLngToGrid:
    """좌표 변환 테스트"""

    def test_seoul_coord_conversion(self):
        """서울 좌표 변환 테스트"""
        # 서울 (37.5665, 126.9780)
        x, y = LatLngToGrid.dfs_xy_conv("toXY", 37.5665, 126.9780)
        assert isinstance(x, int)
        assert isinstance(y, int)
        assert x > 0 and y > 0
        print(f"✅ 서울 좌표 변환: (37.5665, 126.9780) → ({x}, {y})")

    def test_busan_coord_conversion(self):
        """부산 좌표 변환 테스트"""
        # 부산 (35.1796, 129.0756)
        x, y = LatLngToGrid.dfs_xy_conv("toXY", 35.1796, 129.0756)
        assert isinstance(x, int)
        assert isinstance(y, int)
        print(f"✅ 부산 좌표 변환: (35.1796, 129.0756) → ({x}, {y})")

    def test_jeju_coord_conversion(self):
        """제주 좌표 변환 테스트"""
        # 제주 (33.3847, 126.5631)
        x, y = LatLngToGrid.dfs_xy_conv("toXY", 33.3847, 126.5631)
        assert isinstance(x, int)
        assert isinstance(y, int)
        print(f"✅ 제주 좌표 변환: (33.3847, 126.5631) → ({x}, {y})")


class TestKMAClient:
    """기상청 API 클라이언트 테스트"""

    def test_dummy_data_seoul(self):
        """서울 더미 데이터 테스트"""
        client = KMAClient()
        weather = client._get_dummy_data(37.5665, 126.9780)

        assert isinstance(weather, WeatherData)
        assert weather.latitude == 37.5665
        assert weather.longitude == 126.9780
        assert weather.temperature > 0
        assert 0 <= weather.humidity <= 100
        assert weather.wind_speed >= 0
        assert weather.precipitation >= 0
        print(f"✅ 서울 더미 데이터: {weather.temperature}°C, {weather.humidity}%")

    def test_dummy_data_different_locations(self):
        """다양한 위치의 더미 데이터 테스트"""
        client = KMAClient()

        locations = [
            ("서울", 37.5665, 126.9780),
            ("부산", 35.1796, 129.0756),
            ("대구", 35.8714, 128.5937),
            ("인천", 37.4563, 126.7052),
            ("제주", 33.3847, 126.5631),
        ]

        for name, lat, lon in locations:
            weather = client._get_dummy_data(lat, lon)
            assert weather.latitude == lat
            assert weather.longitude == lon
            assert weather.temperature > 0
            print(f"  ✅ {name}: {weather.temperature:.1f}°C")

    @pytest.mark.asyncio
    async def test_get_weather_async(self):
        """비동기 날씨 조회 테스트"""
        client = KMAClient()

        # API 키 없음 → 더미 데이터 반환
        weather = await client.get_weather(37.5665, 126.9780)

        assert weather is not None
        assert weather.latitude == 37.5665
        assert weather.longitude == 126.9780
        assert weather.temperature > 0
        print(f"✅ 비동기 날씨 조회: {weather.temperature}°C")

        await client.close()

    @pytest.mark.asyncio
    async def test_weather_data_structure(self):
        """날씨 데이터 구조 테스트"""
        client = KMAClient()
        weather = await client.get_weather(37.5665, 126.9780)

        # 필수 필드 확인
        assert hasattr(weather, "latitude")
        assert hasattr(weather, "longitude")
        assert hasattr(weather, "temperature")
        assert hasattr(weather, "humidity")
        assert hasattr(weather, "wind_speed")
        assert hasattr(weather, "precipitation")
        assert hasattr(weather, "weather_condition")

        print(f"""
✅ 날씨 데이터 구조 검증:
  - 위도: {weather.latitude}
  - 경도: {weather.longitude}
  - 기온: {weather.temperature}°C
  - 습도: {weather.humidity}%
  - 풍속: {weather.wind_speed} m/s
  - 강수: {weather.precipitation} mm
  - 상태: {weather.weather_condition}
        """)

        await client.close()


# 수동 테스트 실행
if __name__ == "__main__":
    print("\n🧪 기상청 API 클라이언트 테스트\n")

    # 1. 좌표 변환 테스트
    print("=" * 50)
    print("1️⃣  좌표 변환 테스트")
    print("=" * 50)
    test_grid = TestLatLngToGrid()
    test_grid.test_seoul_coord_conversion()
    test_grid.test_busan_coord_conversion()
    test_grid.test_jeju_coord_conversion()

    # 2. 더미 데이터 테스트
    print("\n" + "=" * 50)
    print("2️⃣  더미 데이터 테스트")
    print("=" * 50)
    test_client = TestKMAClient()
    test_client.test_dummy_data_seoul()
    test_client.test_dummy_data_different_locations()

    # 3. 비동기 테스트
    print("\n" + "=" * 50)
    print("3️⃣  비동기 조회 테스트")
    print("=" * 50)

    async def run_async_tests():
        await test_client.test_get_weather_async()
        await test_client.test_weather_data_structure()

    asyncio.run(run_async_tests())

    print("\n✅ 모든 테스트 완료!")
