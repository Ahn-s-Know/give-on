"""
SQLAlchemy 데이터베이스 설정 (async)
PostgreSQL + asyncpg
"""
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base
from sqlalchemy.pool import NullPool
import logging

from app.config import get_settings

logger = logging.getLogger(__name__)

settings = get_settings()

# 베이스 클래스 (모든 ORM 모델이 상속받을 베이스)
Base = declarative_base()


def get_async_engine():
    """비동기 엔진 생성"""
    # SQLite 옵션
    engine_kwargs = {
        "echo": settings.DEBUG,  # SQL 쿼리 출력 (디버그 모드)
    }

    # SQLite인 경우 추가 옵션
    if "sqlite" in settings.DATABASE_URL:
        engine_kwargs["connect_args"] = {"check_same_thread": False}
    else:
        # PostgreSQL인 경우
        engine_kwargs["pool_pre_ping"] = True
        engine_kwargs["pool_recycle"] = 3600
        engine_kwargs["poolclass"] = NullPool

    return create_async_engine(settings.DATABASE_URL, **engine_kwargs)


# 비동기 세션 팩토리
AsyncSessionLocal = async_sessionmaker(
    get_async_engine(),
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
    autocommit=False,
)


async def get_db():
    """
    FastAPI 의존성: DB 세션 제공

    사용 예:
    @app.get("/farms")
    async def get_farms(db: AsyncSession = Depends(get_db)):
        ...
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
        except Exception as e:
            await session.rollback()
            logger.error(f"Database error: {e}")
            raise
        finally:
            await session.close()


async def init_db():
    """
    애플리케이션 시작 시 테이블 생성
    (마이그레이션을 사용할 경우는 Alembic으로 대체)
    """
    engine = get_async_engine()
    async with engine.begin() as conn:
        # 이미 존재하는 테이블을 제외하고 생성
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Database tables created/verified")


async def close_db():
    """애플리케이션 종료 시 DB 연결 종료"""
    engine = get_async_engine()
    await engine.dispose()
    logger.info("Database connections closed")
