"""
룰 기반 위험도 판단 엔진
AI 불필요 — 축산 전문 임계값으로 처리, TDD 개발
"""
from typing import Optional

# ──────────────────────────────────────────────
# 축종별 위험도 임계값
# ──────────────────────────────────────────────
THRESHOLDS: dict = {
    "chicken": {          # 육계·산란계 (고온에 가장 취약)
        "caution":   {"temp_min": 30.0},
        "danger":    {"temp_min": 33.0},
        "emergency": {"temp_min": 36.0},
    },
    "pig": {              # 돼지 (온도+습도 복합 고려)
        "caution":   {"temp_min": 28.0, "humidity_min": 65.0},
        "danger":    {"temp_min": 30.0, "humidity_min": 70.0},
        "emergency": {"temp_min": 33.0},
    },
    "cattle": {           # 한우·젖소 (동절기 한파 기준 — 저온 위험)
        "caution":   {"temp_max": -5.0},
        "danger":    {"temp_max": -10.0},
        "emergency": {"temp_max": -15.0},
    },
    "duck": {             # 오리
        "caution":   {"temp_min": 32.0},
        "danger":    {"temp_min": 35.0},
        "emergency": {"temp_min": 38.0},
    },
}

# 위험도 우선순위 (높을수록 심각)
RISK_PRIORITY = {"safe": 0, "caution": 1, "danger": 2, "emergency": 3}

# 체크리스트 — 축종 × 위험도
_CHECKLISTS: dict = {
    "chicken": {
        "caution": [
            "환풍기 가동 상태 확인",
            "음수 온도 25°C 이하 유지",
            "차광막 설치 상태 점검",
        ],
        "danger": [
            "환풍기 최대 가동 확인",
            "음수 온도 20°C 이하 유지",
            "차광막 설치 상태 점검",
            "사료 급여 시간 서늘한 시간대로 조정",
        ],
        "emergency": [
            "즉시 긴급 환기 가동",
            "음수 20°C 이하 유지",
            "차광막 설치",
            "사육 밀도 즉시 분산",
            "수의사 연락",
        ],
    },
    "pig": {
        "caution": [
            "환기 시설 정상 가동 확인",
            "음수 공급 충분히 확인",
            "사료 급여 시간 조정 (서늘한 시간대)",
        ],
        "danger": [
            "환기 시설 최대 가동",
            "음수 공급 확인 및 증량",
            "쿨링패드 가동",
            "사료 급여 시간 새벽·저녁으로 조정",
        ],
        "emergency": [
            "즉시 긴급 환기 최대 가동",
            "냉수 스프링클러 가동",
            "수의사 즉시 연락",
            "사육 밀도 분산",
        ],
    },
    "cattle": {
        "caution": [
            "방풍벽 설치 상태 확인",
            "보온등 가동 확인",
            "물 공급 동결 여부 점검",
        ],
        "danger": [
            "방풍벽 보강",
            "보온등 추가 설치",
            "음수 가열 장치 가동",
            "사료 에너지 함량 증가",
        ],
        "emergency": [
            "즉시 축사 내부 온도 올리기",
            "보온등 전량 가동",
            "수의사 연락",
            "비닐 커튼 등 추가 보온재 설치",
        ],
    },
    "duck": {
        "caution": [
            "환풍기 가동 상태 확인",
            "음수 온도 점검",
            "차광망 설치 확인",
        ],
        "danger": [
            "환풍기 최대 가동",
            "음수 온도 20°C 이하 유지",
            "차광망 강화",
            "사육 밀도 점검",
        ],
        "emergency": [
            "즉시 긴급 환기 가동",
            "냉수 공급 최대화",
            "수의사 즉시 연락",
            "사육 밀도 분산",
        ],
    },
}

# 주의 단계 템플릿 메시지 (Claude API 호출 없이 사용)
_CAUTION_TEMPLATES: dict = {
    "chicken": "현재 기온이 {temp:.1f}°C입니다. 닭 사육에 주의가 필요한 날씨입니다. 환풍기 가동 상태를 확인하고 음수 온도를 유지해 주세요.",
    "pig": "현재 기온 {temp:.1f}°C, 돼지 사육 주의 단계입니다. 환기 시설을 확인하고 충분한 음수를 공급해 주세요.",
    "cattle": "현재 기온이 {temp:.1f}°C로 한우·젖소 주의 단계입니다. 방풍벽과 보온 상태를 점검해 주세요.",
    "duck": "현재 기온 {temp:.1f}°C, 오리 사육 주의 단계입니다. 환풍기 가동과 차광망 설치를 확인해 주세요.",
}


def calculate_risk_level(
    livestock_type: str,
    temperature: float,
    humidity: Optional[float] = None,
) -> str:
    """
    축종별 기온·습도 기준으로 위험도 계산.

    Parameters
    ----------
    livestock_type : str
        축종. "chicken" | "pig" | "cattle" | "duck"
    temperature : float
        현재 기온 (°C)
    humidity : float, optional
        현재 습도 (%). 돼지 caution/danger 판단에 사용.

    Returns
    -------
    str
        "safe" | "caution" | "danger" | "emergency"
    """
    thresholds = THRESHOLDS.get(livestock_type)
    if not thresholds:
        return "safe"

    current_risk = "safe"

    for level in ("caution", "danger", "emergency"):
        cond = thresholds.get(level, {})

        # 온도 조건 확인
        temp_min = cond.get("temp_min")
        temp_max = cond.get("temp_max")

        temp_ok = True
        if temp_min is not None:
            temp_ok = temperature >= temp_min
        elif temp_max is not None:
            temp_ok = temperature <= temp_max

        if not temp_ok:
            continue

        # 습도 조건 확인 (있을 경우 AND 조건)
        humidity_min = cond.get("humidity_min")
        if humidity_min is not None:
            # 돼지 caution/danger: 온도 AND 습도 모두 충족해야 함
            # emergency는 온도만으로 판단
            if humidity is None or humidity < humidity_min:
                # emergency 조건은 습도 무관 (온도만)
                if level != "emergency":
                    continue

        # 조건 충족 → 위험도 갱신 (더 심각한 쪽으로)
        if RISK_PRIORITY[level] > RISK_PRIORITY[current_risk]:
            current_risk = level

    return current_risk


def get_checklist_items(livestock_type: str, risk_level: str) -> list:
    """
    축종·위험도에 맞는 대응 체크리스트 반환.

    Parameters
    ----------
    livestock_type : str
        축종
    risk_level : str
        위험도 ("safe" | "caution" | "danger" | "emergency")

    Returns
    -------
    list[str]
        대응 행동 목록
    """
    if risk_level == "safe":
        return ["오늘은 안전한 사육 환경입니다. 정기 점검을 유지하세요."]

    animal_list = _CHECKLISTS.get(livestock_type, {})
    items = animal_list.get(risk_level, ["환경 모니터링 강화"])
    return items


def get_caution_template(livestock_type: str, temperature: float) -> str:
    """
    주의 단계 템플릿 메시지 반환 (Claude API 호출 없이 사용).

    Parameters
    ----------
    livestock_type : str
        축종
    temperature : float
        현재 기온 (°C)

    Returns
    -------
    str
        경보 메시지 (템플릿 기반)
    """
    template = _CAUTION_TEMPLATES.get(
        livestock_type,
        "현재 기온 {temp:.1f}°C. 축사 환경을 점검해 주세요.",
    )
    return template.format(temp=temperature)
