"""
Firebase Cloud Messaging (FCM) 클라이언트
농가 iOS 앱에 푸시 알림 발송
"""
import json
import logging
from typing import Optional

logger = logging.getLogger(__name__)


def _get_firebase_app():
    """Firebase Admin SDK 초기화 (지연)"""
    try:
        import firebase_admin
        from firebase_admin import credentials
        from app.config import get_settings

        settings = get_settings()
        if not settings.FIREBASE_CREDENTIALS_PATH:
            logger.warning("FIREBASE_CREDENTIALS_PATH 미설정 — FCM 비활성화")
            return None

        # 이미 초기화된 경우 재사용
        try:
            return firebase_admin.get_app()
        except ValueError:
            pass

        cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
        return firebase_admin.initialize_app(cred)
    except Exception as e:
        logger.warning(f"Firebase 초기화 실패: {e}")
        return None


async def send_push_notification(
    device_tokens: list,
    title: str,
    body: str,
    data: Optional[dict] = None,
) -> dict:
    """
    FCM 멀티캐스트 푸시 알림 발송.

    Parameters
    ----------
    device_tokens : list[str]
        FCM 토큰 목록 (농가 기기)
    title : str
        알림 제목
    body : str
        알림 본문 (경보 메시지)
    data : dict, optional
        추가 데이터 페이로드 (farm_id, risk_level, alert_id 등)

    Returns
    -------
    dict
        {"success_count": int, "failure_count": int, "responses": list}
    """
    if not device_tokens:
        return {"success_count": 0, "failure_count": 0, "responses": []}

    app = _get_firebase_app()
    if app is None:
        logger.warning(f"FCM 미활성화 — 알림 스킵 (token_count={len(device_tokens)})")
        return {"success_count": 0, "failure_count": len(device_tokens), "responses": []}

    try:
        from firebase_admin import messaging

        notification = messaging.Notification(title=title, body=body)
        str_data = {k: str(v) for k, v in (data or {}).items()}

        message = messaging.MulticastMessage(
            notification=notification,
            data=str_data,
            tokens=device_tokens,
            apns=messaging.APNSConfig(
                payload=messaging.APNSPayload(
                    aps=messaging.Aps(
                        sound="default",
                        badge=1,
                    )
                )
            ),
        )

        import asyncio
        response = await asyncio.to_thread(messaging.send_each_for_multicast, message)

        logger.info(
            f"FCM 발송 완료 — 성공 {response.success_count}건 / 실패 {response.failure_count}건"
        )
        return {
            "success_count": response.success_count,
            "failure_count": response.failure_count,
            "responses": [
                {"success": r.success, "error": str(r.exception) if r.exception else None}
                for r in response.responses
            ],
        }
    except Exception as e:
        logger.error(f"FCM 발송 실패: {e}")
        return {"success_count": 0, "failure_count": len(device_tokens), "responses": []}


def parse_device_tokens(tokens_json: Optional[str]) -> list:
    """
    Farm.device_tokens (JSON 문자열) → list 변환.

    Parameters
    ----------
    tokens_json : str | None
        '[\"token1\",\"token2\"]' 형식 또는 단일 토큰 문자열

    Returns
    -------
    list[str]
    """
    if not tokens_json:
        return []
    try:
        parsed = json.loads(tokens_json)
        if isinstance(parsed, list):
            return [t for t in parsed if t]
        return [str(parsed)]
    except (json.JSONDecodeError, TypeError):
        # 단일 토큰 문자열인 경우
        return [tokens_json] if tokens_json else []


async def send_farm_alert(farm, alert) -> bool:
    """
    농가 경보 푸시 알림 발송 (Alert + Farm 객체 기반 편의 함수).

    Parameters
    ----------
    farm : Farm
        농가 ORM 객체
    alert : Alert
        경보 ORM 객체

    Returns
    -------
    bool
        발송 성공 여부
    """
    tokens = parse_device_tokens(farm.device_tokens)
    if not tokens:
        logger.info(f"FCM 토큰 없음 farm_id={farm.id} — 알림 스킵")
        return False

    risk_emoji = {
        "caution": "⚠️",
        "danger": "⚠️",
        "emergency": "🚨",
    }.get(alert.risk_level, "📢")

    title = f"{risk_emoji} {'긴급 ' if alert.risk_level == 'emergency' else ''}위험 경보"

    result = await send_push_notification(
        device_tokens=tokens,
        title=title,
        body=alert.message,
        data={
            "farm_id": farm.id,
            "risk_level": alert.risk_level,
            "alert_id": alert.id,
        },
    )
    return result["success_count"] > 0
