"""
환경 변수 로드 및 설정 관리 (pydantic-settings)
"""
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """애플리케이션 설정"""

    # 앱 기본 설정
    APP_NAME: str = "Give On API"
    DEBUG: bool = False
    ENVIRONMENT: str = "development"  # development, staging, production

    # 데이터베이스
    DATABASE_URL: str = "postgresql+asyncpg://user:password@localhost:5432/giveon_db"

    # 기상청 API
    KMA_API_KEY: str = ""
    KMA_BASE_URL: str = "https://api.openweathermap.org/data/2.5"  # 또는 기상청 공공데이터포털

    # Claude API
    ANTHROPIC_API_KEY: str = ""
    CLAUDE_MODEL: str = "claude-3-5-haiku-20241022"

    # Firebase FCM
    FIREBASE_CREDENTIALS_PATH: str = ""  # ./firebase-adminsdk.json 경로
    FCM_SERVER_KEY: str = ""

    # 스케줄러 설정
    SCHEDULER_ENABLED: bool = True
    SCHEDULER_INTERVAL_MINUTES: int = 30  # 30분 주기

    # API 설정
    API_PREFIX: str = "/api/v1"
    CORS_ORIGINS: list = ["http://localhost:3000", "http://localhost:3001"]

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = True


@lru_cache()
def get_settings() -> Settings:
    """설정 싱글톤 인스턴스 반환"""
    return Settings()
