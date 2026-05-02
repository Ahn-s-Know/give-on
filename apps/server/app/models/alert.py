"""경보 알림 ORM 모델"""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, Boolean
from sqlalchemy.sql import func
from app.database import Base


class Alert(Base):
    """경보 로그"""
    __tablename__ = "alerts"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=False)
    risk_level = Column(String(20), nullable=False)  # safe, caution, danger, emergency
    temperature = Column(Integer, nullable=True)  # 당시 기온
    humidity = Column(Integer, nullable=True)  # 당시 습도
    message = Column(Text, nullable=False)  # AI 경보 메시지 (150자 이내)
    is_sent = Column(Boolean, default=False)           # FCM 발송 여부
    sent_via = Column(String(100), nullable=True)      # 발송 채널 JSON e.g. '["fcm","sms"]'
    created_at = Column(DateTime, server_default=func.now())

    def __repr__(self):
        return f"<Alert farm_id={self.farm_id} - {self.risk_level}>"
