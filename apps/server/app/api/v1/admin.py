"""관리자 전용 API 라우터"""
from typing import List

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_session
from app.models.farm import Farm
from app.models.alert import Alert
from app.models.donation import Donation
from app.repositories.farm_repo import get_farms_with_risk
from app.repositories.alert_repo import get_today_alerts

router = APIRouter(prefix="/admin", tags=["admin"])


@router.get("/dashboard")
async def dashboard_stats(
    session: AsyncSession = Depends(get_session),
):
    """관리자 대시보드 요약 수치"""
    # 전체 활성 농가 수
    farm_count_result = await session.execute(
        select(func.count(Farm.id)).where(Farm.is_active == True)
    )
    total_farms = farm_count_result.scalar() or 0

    # 오늘 경보 수 (위험도별)
    today_alerts = await get_today_alerts(session)
    risk_counts = {"caution": 0, "danger": 0, "emergency": 0}
    for a in today_alerts:
        if a.risk_level in risk_counts:
            risk_counts[a.risk_level] += 1

    # 기부 총액
    donation_sum_result = await session.execute(
        select(func.sum(Donation.amount)).where(Donation.status == "completed")
    )
    total_donated = donation_sum_result.scalar() or 0

    return {
        "total_farms": total_farms,
        "today_alerts": {
            "caution": risk_counts["caution"],
            "danger": risk_counts["danger"],
            "emergency": risk_counts["emergency"],
            "total": len(today_alerts),
        },
        "total_donated": total_donated,
    }


@router.get("/farms")
async def admin_farm_list(
    risk_level: str = Query(default=None),
    session: AsyncSession = Depends(get_session),
):
    """전국 농가 목록 + 위험도 (관리자용)"""
    farms = await get_farms_with_risk(session)
    if risk_level:
        farms = [f for f in farms if f.get("current_risk") == risk_level]
    return {"farms": farms, "total": len(farms)}


@router.get("/alerts/today")
async def admin_today_alerts(
    session: AsyncSession = Depends(get_session),
):
    """오늘 발송된 경보 전체"""
    alerts = await get_today_alerts(session)
    return {"alerts": [
        {
            "id": a.id,
            "farm_id": a.farm_id,
            "risk_level": a.risk_level,
            "message": a.message,
            "is_sent": a.is_sent,
            "created_at": a.created_at.isoformat(),
        }
        for a in alerts
    ]}
