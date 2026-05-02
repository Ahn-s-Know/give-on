"""농가 관련 API 라우터"""
import logging
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_session
from app.schemas.farm import (
    FarmCreate,
    FarmUpdate,
    FarmResponse,
    FarmListResponse,
    FCMTokenRequest,
    ChecklistCompleteRequest,
)
from app.repositories.farm_repo import (
    get_all_active_farms,
    get_farm_by_id,
    create_farm,
    update_farm_tokens,
    get_farms_with_risk,
)
from app.repositories.alert_repo import get_alerts_by_farm
from app.schemas.alert import AlertResponse, RiskResponse
from app.agent.risk_engine import calculate_risk_level, get_checklist_items
from app.integrations.kma_client import KMAClient
from app.models.checklist_log import ChecklistLog

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/farms", tags=["farms"])


@router.get("", response_model=List[dict])
async def list_farms(
    session: AsyncSession = Depends(get_session),
):
    """전체 농가 목록 (지도용 — 현재 위험도 포함)"""
    return await get_farms_with_risk(session)


@router.post("", response_model=FarmResponse, status_code=201)
async def register_farm(
    body: FarmCreate,
    session: AsyncSession = Depends(get_session),
):
    """농가 등록 (앱 온보딩)"""
    farm = await create_farm(session, body.model_dump())
    return farm


@router.get("/{farm_id}", response_model=FarmResponse)
async def get_farm(
    farm_id: int,
    session: AsyncSession = Depends(get_session),
):
    """농가 상세 정보"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")
    return farm


@router.patch("/{farm_id}", response_model=FarmResponse)
async def update_farm(
    farm_id: int,
    body: FarmUpdate,
    session: AsyncSession = Depends(get_session),
):
    """농가 정보 수정"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")

    update_data = body.model_dump(exclude_none=True)
    for key, value in update_data.items():
        setattr(farm, key, value)

    await session.commit()
    await session.refresh(farm)
    return farm


@router.post("/{farm_id}/token", status_code=200)
async def register_fcm_token(
    farm_id: int,
    body: FCMTokenRequest,
    session: AsyncSession = Depends(get_session),
):
    """FCM 토큰 등록·갱신"""
    ok = await update_farm_tokens(session, farm_id, body.token)
    if not ok:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")
    return {"message": "FCM 토큰 등록 완료"}


@router.get("/{farm_id}/risk", response_model=RiskResponse)
async def get_farm_risk(
    farm_id: int,
    session: AsyncSession = Depends(get_session),
):
    """농가 현재 위험도 실시간 조회"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")

    kma = KMAClient()
    try:
        weather = await kma.get_weather(farm.latitude, farm.longitude)
    finally:
        await kma.close()

    if not weather:
        return RiskResponse(farm_id=farm_id, risk_level="safe", checklist=[])

    risk_level = calculate_risk_level(
        farm.livestock_type, weather.temperature, weather.humidity
    )
    checklist = get_checklist_items(farm.livestock_type, risk_level)

    # 최신 경보 메시지
    alerts = await get_alerts_by_farm(session, farm_id, limit=1)
    alert_message = alerts[0].message if alerts else None

    return RiskResponse(
        farm_id=farm_id,
        risk_level=risk_level,
        current_weather={
            "temperature": weather.temperature,
            "humidity": weather.humidity,
            "measured_at": weather.measured_at.isoformat() if hasattr(weather, "measured_at") and weather.measured_at else None,
        },
        alert_message=alert_message,
        checklist=checklist,
    )


@router.get("/{farm_id}/alerts", response_model=List[AlertResponse])
async def get_farm_alerts(
    farm_id: int,
    limit: int = Query(default=10, le=50),
    session: AsyncSession = Depends(get_session),
):
    """농가 경보 이력"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")
    return await get_alerts_by_farm(session, farm_id, limit=limit)


@router.post("/{farm_id}/checklist", status_code=201)
async def save_checklist(
    farm_id: int,
    body: ChecklistCompleteRequest,
    session: AsyncSession = Depends(get_session),
):
    """대응 체크리스트 완료 저장 (보험사 이력용)"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        raise HTTPException(status_code=404, detail="농가를 찾을 수 없습니다.")

    log = ChecklistLog(
        farm_id=farm_id,
        alert_id=body.alert_id,
        item_id=body.item_id,
        item_text=body.item_text,
    )
    session.add(log)
    await session.commit()
    return {"message": "체크리스트 저장 완료"}
