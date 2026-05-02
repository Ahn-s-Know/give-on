"""
FastAPI 애플리케이션 진입점
Give On API — 기후 위기로부터 축산 농가를 보호하는 AI 플랫폼
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
    """앱 시작/종료 이벤트 처리"""
    logger.info(f"🚀 Starting {settings.APP_NAME} ({settings.ENVIRONMENT})")

    # DB 초기화
    await init_db()

    # 스케줄러 시작
    scheduler = None
    try:
        from app.scheduler.runner import start_scheduler
        scheduler = start_scheduler()
    except Exception as e:
        logger.error(f"스케줄러 시작 실패: {e}")

    yield

    # 종료 처리
    logger.info("🛑 Shutting down")
    if scheduler:
        from app.scheduler.runner import stop_scheduler
        stop_scheduler()
    await close_db()


# FastAPI 앱 생성
app = FastAPI(
    title=settings.APP_NAME,
    description="기후 위기로부터 축산 농가를 보호하는 AI 플랫폼 — 위험 경보 + 시민 기부 연결",
    version="0.1.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS 미들웨어
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ──────────────────────────────────────────────
# 라우터 등록
# ──────────────────────────────────────────────
from app.api.v1.farms import router as farms_router
from app.api.v1.alerts import router as alerts_router
from app.api.v1.donations import router as donations_router
from app.api.v1.admin import router as admin_router

app.include_router(farms_router, prefix=settings.API_PREFIX)
app.include_router(alerts_router, prefix=settings.API_PREFIX)
app.include_router(donations_router, prefix=settings.API_PREFIX)
app.include_router(admin_router, prefix=settings.API_PREFIX)


# ──────────────────────────────────────────────
# 기본 엔드포인트
# ──────────────────────────────────────────────
@app.get("/")
async def root():
    """서비스 정보"""
    return {
        "service": settings.APP_NAME,
        "version": "0.1.0",
        "environment": settings.ENVIRONMENT,
        "docs": "/docs",
    }


@app.get("/health")
async def health_check():
    """헬스 체크"""
    return {"status": "ok"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        log_level="info",
    )
