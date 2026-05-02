"""
카카오 알림톡 클라이언트
고령 농가(스마트폰 미사용자) 대상 SMS 보조 알림
Phase 1: 기본 구조만 구현, Phase 2에서 실제 연동
"""
import logging
from typing import Optional

logger = logging.getLogger(__name__)


async def send_alimtalk(
    phone_number: str,
    template_code: str,
    variables: dict,
) -> bool:
    """
    카카오 알림톡 발송.

    Parameters
    ----------
    phone_number : str
        수신자 전화번호 (010-xxxx-xxxx)
    template_code : str
        알림톡 템플릿 코드 (카카오 비즈니스에서 심사 완료된 템플릿)
    variables : dict
        템플릿 변수 치환값

    Returns
    -------
    bool
        발송 성공 여부
    """
    from app.config import get_settings
    settings = get_settings()

    if not getattr(settings, "KAKAO_ALIMTALK_KEY", None):
        logger.debug("KAKAO_ALIMTALK_KEY 미설정 — 알림톡 스킵")
        return False

    # TODO Phase 2: 카카오 Bizm API 실제 연동
    # POST https://alimtalk-api.kakao.com/v2/sender/send
    logger.info(f"[STUB] 알림톡 발송 → {phone_number} template={template_code}")
    return True


async def send_farm_alert_sms(farm, alert) -> bool:
    """
    농가 경보 알림톡 발송 (편의 함수).
    FCM 토큰 없는 고령 농가 대상.

    Parameters
    ----------
    farm : Farm ORM 객체
    alert : Alert ORM 객체

    Returns
    -------
    bool
    """
    if not farm.phone_number:
        return False

    # kakao_id 없으면 SMS 발송 불가
    if not farm.kakao_id:
        logger.debug(f"kakao_id 없음 farm_id={farm.id} — 알림톡 스킵")
        return False

    template_code = {
        "caution": "RISK_CAUTION_V1",
        "danger": "RISK_DANGER_V1",
        "emergency": "RISK_EMERGENCY_V1",
    }.get(alert.risk_level, "RISK_CAUTION_V1")

    variables = {
        "farm_name": farm.name,
        "risk_level": alert.risk_level,
        "message": alert.message[:80],  # 알림톡 본문 길이 제한
    }

    return await send_alimtalk(
        phone_number=farm.phone_number,
        template_code=template_code,
        variables=variables,
    )
