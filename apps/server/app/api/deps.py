"""FastAPI 공통 의존성"""
from typing import AsyncGenerator
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db

# DB 세션 의존성 (재export)
async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async for session in get_db():
        yield session
