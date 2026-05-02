"""경보 관련 API 라우터"""
from typing import List, Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_session
from app.schemas.alert import AlertResponse
from app.repositories.alert_repo import get_latest_alerts, get_today_alerts

router = APIRouter(prefix="/alerts", tags=["alerts"])


@router.get("", response_model=List[AlertResponse])
async def list_alerts(
    risk_level: Optional[str] = Query(default=None, description="caution|danger|emergency"),
    limit: int = Query(default=20, le=100),
    session: AsyncSession = Depends(get_session),
):
    """최신 경보 목록"""
    return await get_latest_alerts(session, limit=limit, risk_level=risk_level)


@router.get("/today", response_model=List[AlertResponse])
async def today_alerts(
    session: AsyncSession = Depends(get_session),
):
    """오늘 발송된 경보 전체"""
    return await get_today_alerts(session)
