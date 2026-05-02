"""농가 관련 Pydantic 스키마"""
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field


class FarmCreate(BaseModel):
    """농가 등록 요청"""
    name: str = Field(..., max_length=100, description="농장명")
    owner_name: str = Field(..., max_length=100, description="농가주 이름")
    livestock_type: str = Field(..., description="축종: chicken|pig|cattle|duck")
    livestock_count: int = Field(..., gt=0, description="사육 두수")
    location: str = Field(..., description="주소")
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    phone_number: Optional[str] = None
    kakao_id: Optional[str] = None


class FarmUpdate(BaseModel):
    """농가 정보 수정"""
    name: Optional[str] = None
    livestock_count: Optional[int] = None
    phone_number: Optional[str] = None
    kakao_id: Optional[str] = None
    is_active: Optional[bool] = None


class FarmResponse(BaseModel):
    """농가 응답"""
    id: int
    name: str
    owner_name: str
    livestock_type: str
    livestock_count: int
    location: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    phone_number: Optional[str] = None
    subscription: str = "basic"
    is_active: bool
    created_at: datetime

    model_config = {"from_attributes": True}


class FarmListResponse(BaseModel):
    """농가 목록 응답 (지도용 — 현재 위험도 포함)"""
    id: int
    name: str
    livestock_type: str
    livestock_count: int
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    current_risk: Optional[str] = None
    last_alert_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class FCMTokenRequest(BaseModel):
    """FCM 토큰 등록/갱신"""
    token: str = Field(..., description="FCM 디바이스 토큰")


class ChecklistCompleteRequest(BaseModel):
    """체크리스트 완료 저장"""
    alert_id: Optional[int] = None
    item_id: int
    item_text: str
