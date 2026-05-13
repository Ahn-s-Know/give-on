"""
SQLAlchemy 데이터베이스 설정 (async)
SQLite (개발) + PostgreSQL (프로덕션) 지원
"""
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base
import logging
from typing import Optional

logger = logging.getLogger(__name__)

# 베이스 클래스 (모든 ORM 모델이 상속받을 베이스)
Base = declarative_base()

# 전역 엔진 및 세션 팩토리 (Lazy Loading)
_engine = None
_AsyncSessionLocal = None


def get_async_engine():
    """
    비동기 엔진 생성 (싱글톤)
    Lazy Loading으로 필요할 때만 생성
    """
    global _engine

    if _engine is not None:
        return _engine

    from app.config import get_settings
    settings = get_settings()

    # SQLite vs PostgreSQL 설정
    engine_kwargs = {
        "echo": settings.DEBUG,  # SQL 쿼리 출력 (디버그 모드)
    }

    if "sqlite" in settings.DATABASE_URL:
        # SQLite 설정
        engine_kwargs["connect_args"] = {"check_same_thread": False}
        logger.info(f"📁 SQLite 데이터베이스 연결: {settings.DATABASE_URL}")
    else:
        # PostgreSQL 설정
        from sqlalchemy.pool import NullPool
        engine_kwargs["pool_pre_ping"] = True
        engine_kwargs["pool_recycle"] = 3600
        engine_kwargs["poolclass"] = NullPool
        logger.info(f"🗄️  PostgreSQL 데이터베이스 연결: {settings.DATABASE_URL.split('@')[1] if '@' in settings.DATABASE_URL else settings.DATABASE_URL}")

    _engine = create_async_engine(settings.DATABASE_URL, **engine_kwargs)
    return _engine


def get_session_maker():
    """
    비동기 세션 팩토리 생성 (싱글톤)
    Lazy Loading으로 필요할 때만 생성
    """
    global _AsyncSessionLocal

    if _AsyncSessionLocal is not None:
        return _AsyncSessionLocal

    _AsyncSessionLocal = async_sessionmaker(
        get_async_engine(),
        class_=AsyncSession,
        expire_on_commit=False,
        autoflush=False,
        autocommit=False,
    )
    return _AsyncSessionLocal


# 편의용 별칭 (기존 코드와 호환성)
@property
def AsyncSessionLocal():
    return get_session_maker()


async def get_db():
    """
    FastAPI 의존성: DB 세션 제공

    사용 예:
    @app.get("/farms")
    async def get_farms(db: AsyncSession = Depends(get_db)):
        ...
    """
    async_session = get_session_maker()
    async with async_session() as session:
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
