"""경보 DB 접근 레이어"""
from typing import Optional, List

from sqlalchemy import select, desc
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.alert import Alert


async def get_latest_alerts(
    session: AsyncSession,
    limit: int = 20,
    risk_level: Optional[str] = None,
) -> List[Alert]:
    query = select(Alert).order_by(desc(Alert.created_at)).limit(limit)
    if risk_level:
        query = query.where(Alert.risk_level == risk_level)
    result = await session.execute(query)
    return result.scalars().all()


async def get_alerts_by_farm(
    session: AsyncSession,
    farm_id: int,
    limit: int = 10,
) -> List[Alert]:
    result = await session.execute(
        select(Alert)
        .where(Alert.farm_id == farm_id)
        .order_by(desc(Alert.created_at))
        .limit(limit)
    )
    return result.scalars().all()


async def get_today_alerts(session: AsyncSession) -> List[Alert]:
    from datetime import datetime, timedelta
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    result = await session.execute(
        select(Alert)
        .where(Alert.created_at >= today_start)
        .order_by(desc(Alert.created_at))
    )
    return result.scalars().all()
