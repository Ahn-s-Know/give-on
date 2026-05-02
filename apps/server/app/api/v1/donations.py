"""기부 관련 API 라우터"""
import json
import logging
from typing import List

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_session
from app.schemas.donation import (
    DonationCreate,
    DonationResponse,
    DonationDetailResponse,
    DonationCompleteRequest,
    DamageReportCreate,
    DamageReportResponse,
)
from app.repositories.donation_repo import (
    create_donation,
    confirm_donation,
    get_donations_list,
    create_damage_report,
    get_published_damage_reports,
)

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/donations", tags=["donations"])


@router.get("/farms", response_model=List[dict])
async def list_donation_farms(
    session: AsyncSession = Depends(get_session),
):
    """기부 가능 농가 목록 (피해 신고 + 공개된 항목)"""
    reports = await get_published_damage_reports(session)
    result = []
    for r in reports:
        needs = []
        if r.needs:
            try:
                needs = json.loads(r.needs)
            except Exception:
                pass
        result.append({
            "damage_report_id": r.id,
            "farm_id": r.farm_id,
            "story_title": r.story_title,
            "story_content": r.story_content,
            "needs": needs,
            "dead_count": r.dead_count,
            "cause": r.cause,
            "created_at": r.created_at.isoformat(),
        })
    return result


@router.post("", response_model=DonationResponse, status_code=201)
async def create_new_donation(
    body: DonationCreate,
    session: AsyncSession = Depends(get_session),
):
    """기부 생성 (결제 전)"""
    data = body.model_dump()
    donation = await create_donation(session, data)
    return DonationResponse(
        donation_id=donation.id,
        amount=donation.amount,
        tax_deduct=int(donation.amount * 0.15),
        reward_points=donation.reward_points,
        status=donation.status,
    )


@router.post("/{donation_id}/complete", response_model=DonationDetailResponse)
async def complete_donation(
    donation_id: int,
    body: DonationCompleteRequest,
    session: AsyncSession = Depends(get_session),
):
    """결제 완료 콜백 처리"""
    donation = await confirm_donation(session, donation_id, body.payment_key)
    if not donation:
        raise HTTPException(status_code=404, detail="기부 내역을 찾을 수 없습니다.")
    return donation


@router.get("", response_model=List[DonationDetailResponse])
async def list_donations(
    limit: int = Query(default=20, le=100),
    session: AsyncSession = Depends(get_session),
):
    """기부 내역 목록"""
    return await get_donations_list(session, limit=limit)


@router.post("/damage-report", response_model=DamageReportResponse, status_code=201)
async def submit_damage_report(
    body: DamageReportCreate,
    session: AsyncSession = Depends(get_session),
):
    """피해 신고 → Claude API 스토리 자동 생성"""
    data = body.model_dump()
    report = await create_damage_report(session, data)

    needs = []
    if report.needs:
        try:
            needs = json.loads(report.needs)
        except Exception:
            pass

    return DamageReportResponse(
        id=report.id,
        farm_id=report.farm_id,
        dead_count=report.dead_count,
        cause=report.cause,
        story_title=report.story_title,
        story_content=report.story_content,
        needs=needs,
        is_published=report.is_published,
        created_at=report.created_at,
    )
