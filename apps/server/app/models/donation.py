"""기부 내역 ORM 모델"""
from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, ForeignKey
from sqlalchemy.sql import func
from app.database import Base


class Donation(Base):
    """기부 내역"""
    __tablename__ = "donations"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=True)
    donor_name = Column(Text, nullable=True)                        # 기부자 이름 (익명 허용)
    amount = Column(Integer, nullable=False)                        # 기부금액 (원)
    message = Column(Text, nullable=True)                           # 응원 메시지
    payment_key = Column(Text, nullable=True)                       # 결제 키 (카카오페이)
    payment_method = Column(String(20), nullable=True)              # kakaopay|naverpay|card
    status = Column(String(20), default="pending")                  # pending|completed|failed
    tax_receipt_issued = Column(Boolean, default=False)             # 세액공제 영수증 발행 여부
    reward_points = Column(Integer, default=0)                      # 지급 포인트 (금액 × 5%)
    created_at = Column(DateTime, server_default=func.now())
    confirmed_at = Column(DateTime, nullable=True)                  # 결제 완료 시각

    def __repr__(self):
        return f"<Donation id={self.id} farm_id={self.farm_id} amount={self.amount} status={self.status}>"
