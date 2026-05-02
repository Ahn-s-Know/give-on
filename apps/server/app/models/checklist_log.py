"""체크리스트 이행 로그 ORM 모델"""
from sqlalchemy import Column, Integer, Text, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base


class ChecklistLog(Base):
    """농가 체크리스트 이행 기록 (보험사 제출용)"""
    __tablename__ = "checklist_logs"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=False)
    alert_id = Column(Integer, ForeignKey("alerts.id"), nullable=True)  # 연관 경보
    item_id = Column(Integer, nullable=False)                            # 체크리스트 항목 번호
    item_text = Column(Text, nullable=False)                            # 항목 내용
    completed_at = Column(DateTime, server_default=func.now())

    def __repr__(self):
        return f"<ChecklistLog id={self.id} farm_id={self.farm_id} item_id={self.item_id}>"
