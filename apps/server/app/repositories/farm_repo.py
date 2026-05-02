"""농가 DB 접근 레이어"""
import json
import logging
from typing import Optional, List

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.farm import Farm
from app.integrations.kma_client import LatLngToGrid

logger = logging.getLogger(__name__)


async def get_all_active_farms(session: AsyncSession) -> List[Farm]:
    result = await session.execute(select(Farm).where(Farm.is_active == True))
    return result.scalars().all()


async def get_farm_by_id(session: AsyncSession, farm_id: int) -> Optional[Farm]:
    result = await session.execute(select(Farm).where(Farm.id == farm_id))
    return result.scalar_one_or_none()


async def create_farm(session: AsyncSession, data: dict) -> Farm:
    # 위도/경도 → 기상청 격자 좌표 자동 계산
    lat = data.get("latitude")
    lon = data.get("longitude")
    if lat and lon:
        try:
            nx, ny = LatLngToGrid.dfs_xy_conv("toXY", lat, lon)
            data["nx"] = nx
            data["ny"] = ny
        except Exception as e:
            logger.warning(f"격자 좌표 변환 실패: {e}")

    farm = Farm(**data)
    session.add(farm)
    await session.commit()
    await session.refresh(farm)
    return farm


async def update_farm_tokens(session: AsyncSession, farm_id: int, token: str) -> bool:
    """FCM 토큰 등록/갱신"""
    farm = await get_farm_by_id(session, farm_id)
    if not farm:
        return False

    existing = json.loads(farm.device_tokens or "[]")
    if isinstance(existing, list):
        if token not in existing:
            existing.append(token)
    else:
        existing = [token]

    await session.execute(
        update(Farm).where(Farm.id == farm_id).values(device_tokens=json.dumps(existing))
    )
    await session.commit()
    return True


async def get_farms_with_risk(session: AsyncSession) -> List[dict]:
    """지도용 농가 목록 + 최신 위험도"""
    from sqlalchemy import desc
    from app.models.alert import Alert

    farms = await get_all_active_farms(session)
    result = []
    for farm in farms:
        # 최신 경보 조회
        alert_result = await session.execute(
            select(Alert)
            .where(Alert.farm_id == farm.id)
            .order_by(desc(Alert.created_at))
            .limit(1)
        )
        latest_alert = alert_result.scalar_one_or_none()
        result.append({
            "id": farm.id,
            "name": farm.name,
            "livestock_type": farm.livestock_type,
            "livestock_count": farm.livestock_count,
            "latitude": farm.latitude,
            "longitude": farm.longitude,
            "current_risk": latest_alert.risk_level if latest_alert else "safe",
            "last_alert_at": latest_alert.created_at if latest_alert else None,
        })
    return result
