"""리워드 지급 내역 ORM 모델"""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base


class Reward(Base):
    """기부 리워드 (세액공제 + 지역화폐 포인트)"""
    __tablename__ = "rewards"

    id = Column(Integer, primary_key=True, index=True)
    donation_id = Column(Integer, ForeignKey("donations.id"), nullable=False)
    points = Column(Integer, nullable=False)                # 지급 포인트 (기부금액 × 5%)
    tax_deduct = Column(Integer, nullable=False)            # 세액공제 금액 (기부금액 × 15%)
    local_currency = Column(String(100), nullable=True)     # 예: "경기지역화폐"
    status = Column(String(20), default="pending")          # pending|issued|used
    issued_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now())

    def __repr__(self):
        return f"<Reward id={self.id} donation_id={self.donation_id} points={self.points} status={self.status}>"
