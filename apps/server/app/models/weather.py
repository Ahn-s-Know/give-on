"""기상 데이터 ORM 모델"""
from sqlalchemy import Column, Integer, Float, DateTime, String
from sqlalchemy.sql import func
from app.database import Base


class WeatherLog(Base):
    """기상청 API 수집 데이터"""
    __tablename__ = "weather_logs"

    id = Column(Integer, primary_key=True, index=True)
    latitude = Column(Float, nullable=False)  # 위도
    longitude = Column(Float, nullable=False)  # 경도
    temperature = Column(Float, nullable=False)  # 현재 기온 (°C)
    humidity = Column(Float, nullable=False)  # 습도 (%)
    wind_speed = Column(Float, nullable=True)  # 풍속 (m/s)
    precipitation = Column(Float, nullable=True)  # 강수량 (mm)
    weather_condition = Column(String(50), nullable=True)  # 날씨 상태 (clear, cloudy, rainy, etc.)
    forecast_max_temp = Column(Float, nullable=True)  # 내일 최고기온 예보
    forecast_min_temp = Column(Float, nullable=True)  # 내일 최저기온 예보
    collected_at = Column(DateTime, server_default=func.now())

    def __repr__(self):
        return f"<WeatherLog {self.temperature}°C @ ({self.latitude}, {self.longitude})>"
