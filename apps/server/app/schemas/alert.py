"""경보 관련 Pydantic 스키마"""
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel


class AlertResponse(BaseModel):
    """경보 응답"""
    id: int
    farm_id: int
    risk_level: str
    temperature: Optional[float] = None
    humidity: Optional[float] = None
    message: str
    is_sent: bool = False
    created_at: datetime

    model_config = {"from_attributes": True}


class RiskResponse(BaseModel):
    """현재 위험도 조회 응답"""
    farm_id: int
    risk_level: str
    current_weather: Optional[dict] = None
    alert_message: Optional[str] = None
    checklist: List[str] = []
