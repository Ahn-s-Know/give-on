"""
FastAPI 애플리케이션 진입점
"""
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.database import init_db, close_db

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    앱 시작/종료 이벤트 처리
    """
    # 시작 시
    logger.info(f"🚀 Starting {settings.APP_NAME} ({settings.ENVIRONMENT})")
    await init_db()
    yield
    # 종료 시
    logger.info("🛑 Shutting down")
    await close_db()


# FastAPI 앱 생성
app = FastAPI(
    title=settings.APP_NAME,
    description="기후 위기로부터 축산 농가를 보호하는 AI 플랫폼",
    version="0.1.0",
    lifespan=lifespan,
)

# CORS 미들웨어
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """헬스 체크"""
    return {
        "message": "Give On API is running",
        "environment": settings.ENVIRONMENT,
        "app_name": settings.APP_NAME,
    }


@app.get("/health")
async def health_check():
    """헬스 체크 엔드포인트"""
    return {"status": "ok"}


@app.get("/docs")
async def docs():
    """Swagger UI로 리다이렉트"""
    return {"message": "Go to /docs for API documentation"}


# TODO: 라우터 추가
# from app.api import farms, donations, alerts
# app.include_router(farms.router, prefix=settings.API_PREFIX, tags=["farms"])
# app.include_router(donations.router, prefix=settings.API_PREFIX, tags=["donations"])
# app.include_router(alerts.router, prefix=settings.API_PREFIX, tags=["alerts"])


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        log_level="info",
    )
