"""피해 신고 ORM 모델"""
from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, ForeignKey
from sqlalchemy.sql import func
from app.database import Base


class DamageReport(Base):
    """농가 피해 신고"""
    __tablename__ = "damage_reports"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=False)
    dead_count = Column(Integer, nullable=False)                    # 폐사 두수
    cause = Column(String(20), nullable=False)                      # heatwave|cold_wave|storm
    estimated_loss = Column(Integer, nullable=True)                 # 피해액 (원)
    farmer_note = Column(Text, nullable=True)                       # 농가 한마디
    story_title = Column(Text, nullable=True)                       # Claude API 생성 제목
    story_content = Column(Text, nullable=True)                     # Claude API 생성 스토리
    needs = Column(Text, nullable=True)                             # JSON 배열: '["냉방팬","사료"]'
    is_published = Column(Boolean, default=False)                   # 기부 페이지 공개 여부
    created_at = Column(DateTime, server_default=func.now())

    def __repr__(self):
        return f"<DamageReport id={self.id} farm_id={self.farm_id} cause={self.cause} dead={self.dead_count}>"
