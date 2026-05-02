"""기부 관련 Pydantic 스키마"""
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field


class DonationCreate(BaseModel):
    """기부 생성 요청"""
    farm_id: int
    donor_name: Optional[str] = None
    amount: int = Field(..., gt=0, description="기부금액 (원)")
    message: Optional[str] = None
    payment_method: Optional[str] = "kakaopay"


class DonationResponse(BaseModel):
    """기부 생성 응답"""
    donation_id: int
    amount: int
    tax_deduct: int          # 세액공제 (amount × 15%)
    reward_points: int       # 지역화폐 포인트 (amount × 5%)
    status: str

    model_config = {"from_attributes": True}


class DonationDetailResponse(BaseModel):
    """기부 상세 응답"""
    id: int
    farm_id: Optional[int] = None
    donor_name: Optional[str] = None
    amount: int
    message: Optional[str] = None
    payment_method: Optional[str] = None
    status: str
    tax_receipt_issued: bool
    reward_points: int
    created_at: datetime
    confirmed_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class DonationCompleteRequest(BaseModel):
    """결제 완료 콜백"""
    payment_key: str
    amount: int


class DamageReportCreate(BaseModel):
    """피해 신고"""
    farm_id: int
    dead_count: int = Field(..., gt=0)
    cause: str = Field(..., description="heatwave|cold_wave|storm")
    estimated_loss: Optional[int] = None
    farmer_note: Optional[str] = None


class DamageReportResponse(BaseModel):
    """피해 신고 응답 (스토리 포함)"""
    id: int
    farm_id: int
    dead_count: int
    cause: str
    story_title: Optional[str] = None
    story_content: Optional[str] = None
    needs: Optional[List[str]] = None
    is_published: bool
    created_at: datetime

    model_config = {"from_attributes": True}
