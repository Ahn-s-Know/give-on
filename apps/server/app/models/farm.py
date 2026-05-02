"""농가 정보 ORM 모델"""
from sqlalchemy import Column, String, Integer, Float, DateTime, Boolean
from sqlalchemy.sql import func
from app.database import Base


class Farm(Base):
    """농가 정보"""
    __tablename__ = "farms"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)  # 농장명
    owner_name = Column(String(100), nullable=False)  # 농가주 이름
    livestock_type = Column(String(20), nullable=False)  # 축종 (chicken, pig, cattle, duck)
    livestock_count = Column(Integer, nullable=False)  # 축산 두수
    location = Column(String(200), nullable=False)  # 위치 (주소)
    latitude = Column(Float, nullable=True)  # 위도
    longitude = Column(Float, nullable=True)  # 경도
    phone_number = Column(String(20), nullable=True)  # 전화번호
    nx = Column(Integer, nullable=True)              # 기상청 격자 X 좌표 (자동 계산)
    ny = Column(Integer, nullable=True)              # 기상청 격자 Y 좌표 (자동 계산)
    kakao_id = Column(String(100), nullable=True)    # 카카오 알림톡 수신용 (고령 농가)
    subscription = Column(String(20), default="basic")  # basic | pro
    device_tokens = Column(String(1000), nullable=True)  # FCM 토큰 (JSON 배열)
    is_active = Column(Boolean, default=True)  # 활성 상태
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    def __repr__(self):
        return f"<Farm {self.name} - {self.livestock_type}x{self.livestock_count}>"
