"""
기상청 공공데이터 API 클라이언트
출처: https://www.data.go.kr (공공데이터포털)

API 명세:
- 서비스: 동네예보 조회
- 엔드포인트: https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst
- 인증: serviceKey (API 키)
- 응답: JSON (기온, 습도, 풍속, 강수량, 날씨 상태 등)

좌표 변환:
- 입력: 위도/경도 (WGS84)
- 변환: 기상청 격자 좌표 (LCC)
"""

import httpx
import logging
from typing import Optional, Dict, Any
from datetime import datetime, timedelta
from dataclasses import dataclass

from app.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()


@dataclass
class WeatherData:
    """기상 데이터 모델"""
    latitude: float
    longitude: float
    temperature: float  # 기온 (°C)
    humidity: float  # 습도 (%)
    wind_speed: float  # 풍속 (m/s)
    precipitation: float  # 강수량 (mm)
    weather_condition: str  # 날씨 상태 (clear, cloudy, rainy, etc.)
    forecast_max_temp: Optional[float] = None  # 내일 최고기온
    forecast_min_temp: Optional[float] = None  # 내일 최저기온
    timestamp: Optional[str] = None  # 데이터 수집 시간


class LatLngToGrid:
    """
    WGS84 위도/경도 → 기상청 격자 좌표 변환
    공공데이터포털 기상청 API 요구 사항
    """

    # 기상청 격자 설정
    RE = 6371.00877  # 지구 반지름 (km)
    GRID = 5.0  # 격자 간격 (km)
    SLAT1 = 30.0  # 표준 위도 1
    SLAT2 = 60.0  # 표준 위도 2
    OLON = 126.0  # 기준점 경도
    OLAT = 38.0  # 기준점 위도
    XO = 43  # 기준점 X
    YO = 136  # 기준점 Y

    @staticmethod
    def dfs_xy_conv(code: str, v1: float, v2: float) -> tuple:
        """
        WGS84 → 기상청 격자 좌표 변환

        Args:
            code: "toXY" (위도/경도→격자) 또는 "toLL" (격자→위도/경도)
            v1: 위도 (또는 X)
            v2: 경도 (또는 Y)

        Returns:
            (X, Y) 격자 좌표 또는 (위도, 경도)
        """
        import math

        DEGRAD = math.pi / 180.0
        RADEQ = 180.0 / math.pi

        if code == "toXY":
            lat, lon = v1, v2
            re = LatLngToGrid.RE / LatLngToGrid.GRID
            slat1 = LatLngToGrid.SLAT1 * DEGRAD
            slat2 = LatLngToGrid.SLAT2 * DEGRAD
            olon = LatLngToGrid.OLON * DEGRAD
            olat = LatLngToGrid.OLAT * DEGRAD

            sn = math.tan(math.pi / 4.0 + slat2 / 2.0) / math.tan(
                math.pi / 4.0 + slat1 / 2.0
            )
            sn = math.log(math.cos(slat1) / math.cos(slat2)) / math.log(sn)
            sf = math.tan(math.pi / 4.0 + slat1 / 2.0)
            sf = (math.pow(sf, sn) * math.cos(slat1)) / sn
            ro = math.tan(math.pi / 4.0 + olat / 2.0)
            ro = (re * sf) / math.pow(ro, sn)

            ra = math.tan(math.pi / 4.0 + (lat * DEGRAD) / 2.0)
            ra = (re * sf) / math.pow(ra, sn)
            theta = lon * DEGRAD - olon
            if theta > math.pi:
                theta -= 2.0 * math.pi
            if theta < -math.pi:
                theta += 2.0 * math.pi
            theta *= sn

            x = (ra * math.sin(theta)) + LatLngToGrid.XO
            y = (ro - ra * math.cos(theta)) + LatLngToGrid.YO

            return (int(x + 1.5), int(y + 1.5))

        elif code == "toLL":
            x, y = v1, v2
            re = LatLngToGrid.RE / LatLngToGrid.GRID
            slat1 = LatLngToGrid.SLAT1 * DEGRAD
            slat2 = LatLngToGrid.SLAT2 * DEGRAD
            olon = LatLngToGrid.OLON * DEGRAD
            olat = LatLngToGrid.OLAT * DEGRAD

            sn = math.tan(math.pi / 4.0 + slat2 / 2.0) / math.tan(
                math.pi / 4.0 + slat1 / 2.0
            )
            sn = math.log(math.cos(slat1) / math.cos(slat2)) / math.log(sn)
            sf = math.tan(math.pi / 4.0 + slat1 / 2.0)
            sf = (math.pow(sf, sn) * math.cos(slat1)) / sn
            ro = math.tan(math.pi / 4.0 + olat / 2.0)
            ro = (re * sf) / math.pow(ro, sn)

            xn = x - LatLngToGrid.XO
            yn = ro - (y - LatLngToGrid.YO)

            ra = math.sqrt(xn * xn + yn * yn)
            if sn < 0.0:
                ra = -ra
            ra = (re * sf) / math.pow(ra, sn)
            theta = math.atan2(xn, yn)

            lat = (2.0 * math.atan(math.pow(sf / ra, 1.0 / sn)) - math.pi / 2.0) * RADEQ
            lon = (theta / sn + olon) * RADEQ

            return (lat, lon)


class KMAClient:
    """기상청 API 클라이언트"""

    def __init__(self):
        self.api_key = settings.KMA_API_KEY
        self.base_url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        self.client = httpx.AsyncClient(timeout=10.0)

    async def get_weather(self, latitude: float, longitude: float) -> Optional[WeatherData]:
        """
        위도/경도로부터 날씨 데이터 조회

        Args:
            latitude: 위도 (예: 37.5665 - 서울)
            longitude: 경도 (예: 126.9780 - 서울)

        Returns:
            WeatherData 또는 None (오류 발생 시)
        """
        if not self.api_key:
            logger.warning("⚠️  KMA_API_KEY가 설정되지 않았습니다. 더미 데이터를 반환합니다.")
            return self._get_dummy_data(latitude, longitude)

        try:
            # 격자 좌표 변환
            nx, ny = LatLngToGrid.dfs_xy_conv("toXY", latitude, longitude)
            logger.info(f"📍 좌표 변환: ({latitude}, {longitude}) → ({nx}, {ny})")

            # 현재 시간 기준 예보 요청
            now = datetime.now()
            base_date = now.strftime("%Y%m%d")  # YYYYMMDD
            base_time = (now.replace(hour=now.hour // 3 * 3, minute=0, second=0)).strftime(
                "%H%M"
            )  # 03시간 단위

            logger.info(f"🌡️  기상청 API 호출: {base_date} {base_time}")

            params = {
                "serviceKey": self.api_key,
                "pageNo": 1,
                "numOfRows": 60,
                "dataType": "JSON",
                "base_date": base_date,
                "base_time": base_time,
                "nx": nx,
                "ny": ny,
            }

            response = await self.client.get(self.base_url, params=params)
            response.raise_for_status()

            result = response.json()

            # API 응답 파싱
            if result["response"]["header"]["resultCode"] != "00":
                logger.error(f"❌ API 오류: {result['response']['header']['resultMsg']}")
                return self._get_dummy_data(latitude, longitude)

            items = result["response"]["body"]["items"]["item"]
            weather_data = self._parse_kma_response(items, latitude, longitude)
            logger.info(f"✅ 기상 데이터 수신: {weather_data.temperature}°C, {weather_data.humidity}%")

            return weather_data

        except Exception as e:
            logger.error(f"❌ 기상청 API 호출 오류: {e}")
            logger.info("📊 더미 데이터를 반환합니다.")
            return self._get_dummy_data(latitude, longitude)

    def _parse_kma_response(
        self, items: list, latitude: float, longitude: float
    ) -> WeatherData:
        """기상청 API 응답 파싱"""
        # 카테고리별 데이터 분류
        data_dict = {}
        for item in items:
            category = item["category"]
            obstime = item.get("obstime", item.get("fcstTime", ""))

            if category not in data_dict:
                data_dict[category] = {}
            data_dict[category][obstime] = item["obsrValue"] if "obsrValue" in item else item.get(
                "fcstValue"
            )

        # 기온(T1H), 습도(REH), 풍속(WS), 강수(RN1)
        latest_time = list(data_dict.get("T1H", {}).keys())[0] if data_dict.get("T1H") else ""

        temperature = float(data_dict.get("T1H", {}).get(latest_time, 25.0))
        humidity = float(data_dict.get("REH", {}).get(latest_time, 60.0))
        wind_speed = float(data_dict.get("WS", {}).get(latest_time, 2.0))
        precipitation = float(data_dict.get("RN1", {}).get(latest_time, 0.0))

        # 날씨 상태 결정 (강수 여부로 간단히 판단)
        weather_condition = "rainy" if precipitation > 0 else "clear"

        return WeatherData(
            latitude=latitude,
            longitude=longitude,
            temperature=temperature,
            humidity=humidity,
            wind_speed=wind_speed,
            precipitation=precipitation,
            weather_condition=weather_condition,
            timestamp=datetime.now().isoformat(),
        )

    def _get_dummy_data(self, latitude: float, longitude: float) -> WeatherData:
        """테스트용 더미 데이터"""
        # 위치에 따라 다른 더미 데이터 생성
        temp_offset = abs(latitude - 37.5665) + abs(longitude - 126.9780)  # 서울 기준
        return WeatherData(
            latitude=latitude,
            longitude=longitude,
            temperature=25.0 + temp_offset,
            humidity=60.0,
            wind_speed=2.5,
            precipitation=0.0,
            weather_condition="clear",
            forecast_max_temp=28.0,
            forecast_min_temp=18.0,
            timestamp=datetime.now().isoformat(),
        )

    async def close(self):
        """클라이언트 종료"""
        await self.client.aclose()


# 글로벌 클라이언트 인스턴스
_kma_client: Optional[KMAClient] = None


async def get_kma_client() -> KMAClient:
    """KMA 클라이언트 싱글톤"""
    global _kma_client
    if _kma_client is None:
        _kma_client = KMAClient()
    return _kma_client
