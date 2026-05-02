"""
Claude API 연동 모듈
- 위험 경보 메시지 생성 (danger/emergency 단계)
- 피해 농가 기부 페이지 스토리 자동 생성
- 비용 최적화: caution은 템플릿, danger 이상만 API 호출
"""
import asyncio
import json
import logging
from typing import Optional

logger = logging.getLogger(__name__)


def _get_client():
    """Anthropic 클라이언트 생성 (지연 초기화)"""
    try:
        import anthropic
        from app.config import get_settings
        settings = get_settings()
        if not settings.ANTHROPIC_API_KEY:
            return None
        return anthropic.Anthropic(api_key=settings.ANTHROPIC_API_KEY)
    except Exception as e:
        logger.warning(f"Anthropic 클라이언트 초기화 실패: {e}")
        return None


def _get_model() -> str:
    from app.config import get_settings
    return get_settings().CLAUDE_MODEL


# ──────────────────────────────────────────────
# 폴백 템플릿 (API 실패 시)
# ──────────────────────────────────────────────
_FALLBACK_ALERTS = {
    "danger": {
        "chicken": "⚠️ 닭 사육 위험 단계입니다. 즉시 환풍기를 최대로 가동하고 음수 온도를 20°C 이하로 유지해 주세요.",
        "pig": "⚠️ 돼지 사육 위험 단계입니다. 환기를 최대화하고 냉수를 충분히 공급해 주세요.",
        "cattle": "⚠️ 한파 위험 단계입니다. 방풍벽을 점검하고 보온등을 가동해 주세요.",
        "duck": "⚠️ 오리 사육 위험 단계입니다. 즉시 환풍기를 가동하고 음수 온도를 점검해 주세요.",
    },
    "emergency": {
        "chicken": "🚨 긴급! 닭 폐사 위험. 즉시 긴급 환기 가동 + 수의사 연락 바랍니다.",
        "pig": "🚨 긴급! 돼지 폐사 위험. 냉수 스프링클러 가동 + 수의사 즉시 연락하세요.",
        "cattle": "🚨 긴급! 한파 비상. 축사 내부 가온 + 수의사 즉시 연락 바랍니다.",
        "duck": "🚨 긴급! 오리 폐사 위험. 즉시 긴급 환기 가동 + 수의사 연락 바랍니다.",
    },
}


async def generate_alert_message(
    farm_info: dict,
    weather_data: dict,
    risk_level: str,
) -> str:
    """
    위험 단계에 맞는 맞춤 경보 메시지 생성.

    Parameters
    ----------
    farm_info : dict
        농장 정보. 키: name, livestock_type, livestock_count, location
    weather_data : dict
        기상 정보. 키: temperature, humidity, forecast_max_temp, forecast_min_temp
    risk_level : str
        "caution" | "danger" | "emergency"

    Returns
    -------
    str
        150자 이내 경보 메시지
    """
    livestock_type = farm_info.get("livestock_type", "chicken")

    # caution 단계: 템플릿 사용 (Claude API 호출 없음)
    if risk_level == "caution":
        from app.agent.risk_engine import get_caution_template
        return get_caution_template(livestock_type, weather_data.get("temperature", 0))

    # danger/emergency: Claude API 호출
    client = _get_client()
    if client is None:
        # API 키 없거나 초기화 실패 → 폴백
        fallback = _FALLBACK_ALERTS.get(risk_level, {}).get(livestock_type, "⚠️ 기상 위험 경보. 축사 환경을 즉시 점검하세요.")
        return fallback

    prompt = f"""당신은 축산 농가에게 기후 위험 경보를 전달하는 전문 시스템입니다.
아래 정보를 바탕으로 농가에게 보낼 경보 메시지를 작성해주세요.

농장 정보:
- 농장명: {farm_info.get('name', '')}
- 위치: {farm_info.get('location', '')}
- 축종: {livestock_type}
- 사육 규모: {farm_info.get('livestock_count', 0)}두(수)

현재 기상:
- 기온: {weather_data.get('temperature', 0):.1f}°C
- 습도: {weather_data.get('humidity', 0):.0f}%
- 내일 최고기온 예측: {weather_data.get('forecast_max_temp', 0):.1f}°C

위험 단계: {risk_level}

요구사항:
- 150자 이내로 작성 (SMS 전송 고려)
- 지금 당장 해야 할 행동 1~2가지 포함
- 공포감이 아닌 구체적 행동 지침 중심
- 경어체 사용
- 위험 단계 이모지 포함 (caution:⚠️, danger:⚠️, emergency:🚨)
- 다른 설명 없이 메시지만 출력"""

    try:
        response = await asyncio.to_thread(
            client.messages.create,
            model=_get_model(),
            max_tokens=300,
            messages=[{"role": "user", "content": prompt}],
        )
        message = response.content[0].text.strip()
        # 150자 초과 시 자르기
        if len(message) > 150:
            message = message[:147] + "..."
        return message
    except Exception as e:
        logger.error(f"Claude API 경보 메시지 생성 실패: {e}")
        fallback = _FALLBACK_ALERTS.get(risk_level, {}).get(livestock_type, "⚠️ 기상 위험 경보. 축사 환경을 즉시 점검하세요.")
        return fallback


async def generate_farm_story(damage_report: dict) -> dict:
    """
    피해 신고 데이터 → 기부 페이지 스토리 자동 생성.

    Parameters
    ----------
    damage_report : dict
        피해 정보. 키: region, livestock_type, dead_count, cause, farmer_note(optional)

    Returns
    -------
    dict
        {"title": str, "story": str, "needs": list[str]}
    """
    client = _get_client()
    if client is None:
        return _fallback_story(damage_report)

    cause_map = {
        "heatwave": "폭염",
        "cold_wave": "한파",
        "storm": "폭설·강풍",
    }
    cause_text = cause_map.get(damage_report.get("cause", "heatwave"), "기상 재해")

    prompt = f"""피해 농가의 상황을 바탕으로 기부 페이지에 올릴 스토리를 작성해주세요.

피해 정보:
- 농가 위치: {damage_report.get('region', '')}
- 축종: {damage_report.get('livestock_type', '')}
- 폐사 두수: {damage_report.get('dead_count', 0)}마리
- 피해 원인: {cause_text}
- 농가 한마디: {damage_report.get('farmer_note', '(없음)')}

요구사항:
- 제목: 20자 이내의 공감을 끄는 제목
- 스토리: 200~300자, 사실 기반, 과장 없이, 경어체
- 필요 물품: 3가지 이내 (냉방팬, 사료, 방역용품 중 상황에 맞게)
- 반드시 아래 JSON 형식으로만 반환 (다른 텍스트 없이):
{{"title": "...", "story": "...", "needs": ["...", "..."]}}"""

    try:
        response = await asyncio.to_thread(
            client.messages.create,
            model=_get_model(),
            max_tokens=600,
            messages=[{"role": "user", "content": prompt}],
        )
        raw = response.content[0].text.strip()
        # JSON 파싱
        result = json.loads(raw)
        return {
            "title": result.get("title", "")[:20],
            "story": result.get("story", ""),
            "needs": result.get("needs", [])[:3],
        }
    except json.JSONDecodeError:
        logger.error("Claude 스토리 응답 JSON 파싱 실패")
        return _fallback_story(damage_report)
    except Exception as e:
        logger.error(f"Claude API 스토리 생성 실패: {e}")
        return _fallback_story(damage_report)


def _fallback_story(damage_report: dict) -> dict:
    """API 실패 시 기본 스토리 반환"""
    livestock = damage_report.get("livestock_type", "가축")
    region = damage_report.get("region", "")
    dead = damage_report.get("dead_count", 0)
    return {
        "title": f"{region} 농가 피해 복구 지원",
        "story": f"{region} 축산 농가에서 기상 재해로 {livestock} {dead}마리가 폐사하는 피해를 입었습니다. 농가 복구를 위한 여러분의 따뜻한 도움이 필요합니다.",
        "needs": ["사료", "방역용품"],
    }
