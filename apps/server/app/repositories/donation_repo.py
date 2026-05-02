"""기부 DB 접근 레이어"""
import json
import logging
from typing import Optional, List

from sqlalchemy import select, desc
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.donation import Donation
from app.models.damage_report import DamageReport
from app.models.reward import Reward

logger = logging.getLogger(__name__)


async def create_donation(session: AsyncSession, data: dict) -> Donation:
    amount = data["amount"]
    data["reward_points"] = int(amount * 0.05)

    donation = Donation(**data)
    session.add(donation)
    await session.commit()
    await session.refresh(donation)
    return donation


async def confirm_donation(
    session: AsyncSession,
    donation_id: int,
    payment_key: str,
) -> Optional[Donation]:
    from datetime import datetime

    result = await session.execute(
        select(Donation).where(Donation.id == donation_id)
    )
    donation = result.scalar_one_or_none()
    if not donation:
        return None

    donation.payment_key = payment_key
    donation.status = "completed"
    donation.confirmed_at = datetime.utcnow()

    # 리워드 생성
    reward = Reward(
        donation_id=donation.id,
        points=donation.reward_points,
        tax_deduct=int(donation.amount * 0.15),
        status="pending",
    )
    session.add(reward)
    await session.commit()
    await session.refresh(donation)
    return donation


async def get_donations_list(session: AsyncSession, limit: int = 20) -> List[Donation]:
    result = await session.execute(
        select(Donation).order_by(desc(Donation.created_at)).limit(limit)
    )
    return result.scalars().all()


async def create_damage_report(session: AsyncSession, data: dict) -> DamageReport:
    """피해 신고 + Claude API 스토리 자동 생성"""
    from app.agent.claude_agent import generate_farm_story
    from app.repositories.farm_repo import get_farm_by_id

    farm = await get_farm_by_id(session, data["farm_id"])
    if farm:
        try:
            story = await generate_farm_story({
                "region": farm.location,
                "livestock_type": farm.livestock_type,
                "dead_count": data["dead_count"],
                "cause": data["cause"],
                "farmer_note": data.get("farmer_note", ""),
            })
            data["story_title"] = story.get("title", "")
            data["story_content"] = story.get("story", "")
            data["needs"] = json.dumps(story.get("needs", []), ensure_ascii=False)
        except Exception as e:
            logger.error(f"스토리 생성 실패: {e}")

    report = DamageReport(**data)
    session.add(report)
    await session.commit()
    await session.refresh(report)
    return report


async def get_published_damage_reports(session: AsyncSession) -> List[DamageReport]:
    result = await session.execute(
        select(DamageReport)
        .where(DamageReport.is_published == True)
        .order_by(desc(DamageReport.created_at))
    )
    return result.scalars().all()
