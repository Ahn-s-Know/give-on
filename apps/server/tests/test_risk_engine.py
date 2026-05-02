"""
위험도 판단 엔진 단위 테스트 (TDD)
"""
import pytest
from app.agent.risk_engine import (
    calculate_risk_level,
    get_checklist_items,
    get_caution_template,
)


class TestChickenRisk:
    """닭(육계·산란계) 위험도 테스트"""

    def test_safe(self):
        assert calculate_risk_level("chicken", 25.0) == "safe"

    def test_safe_just_below_caution(self):
        assert calculate_risk_level("chicken", 29.9) == "safe"

    def test_caution_at_boundary(self):
        assert calculate_risk_level("chicken", 30.0) == "caution"

    def test_caution_above_boundary(self):
        assert calculate_risk_level("chicken", 31.5) == "caution"

    def test_danger_at_boundary(self):
        assert calculate_risk_level("chicken", 33.0) == "danger"

    def test_danger_above_boundary(self):
        assert calculate_risk_level("chicken", 34.0) == "danger"

    def test_emergency_at_boundary(self):
        assert calculate_risk_level("chicken", 36.0) == "emergency"

    def test_emergency_above(self):
        assert calculate_risk_level("chicken", 37.0) == "emergency"
        assert calculate_risk_level("chicken", 40.0) == "emergency"


class TestPigRisk:
    """돼지 위험도 테스트 (온도+습도 복합 조건)"""

    def test_safe_low_temp(self):
        assert calculate_risk_level("pig", 25.0) == "safe"

    def test_safe_high_temp_low_humidity(self):
        # 온도는 주의 이상이지만 습도 조건 미달
        assert calculate_risk_level("pig", 29.0, humidity=50.0) == "safe"

    def test_caution_temp_and_humidity(self):
        assert calculate_risk_level("pig", 29.0, humidity=66.0) == "caution"

    def test_caution_exact_boundary(self):
        assert calculate_risk_level("pig", 28.0, humidity=65.0) == "caution"

    def test_danger_temp_and_humidity(self):
        assert calculate_risk_level("pig", 31.0, humidity=72.0) == "danger"

    def test_emergency_by_temp_only(self):
        # emergency는 온도만으로 판단 (33도 이상)
        assert calculate_risk_level("pig", 33.0) == "emergency"
        assert calculate_risk_level("pig", 35.0, humidity=40.0) == "emergency"

    def test_no_humidity_caution_not_triggered(self):
        # 습도 정보 없으면 복합 조건 미충족
        result = calculate_risk_level("pig", 29.0, humidity=None)
        assert result in ("safe",)


class TestCattleRisk:
    """한우·젖소 위험도 테스트 (동절기 저온 기준)"""

    def test_safe_above_minus_5(self):
        assert calculate_risk_level("cattle", 0.0) == "safe"
        assert calculate_risk_level("cattle", -3.0) == "safe"
        assert calculate_risk_level("cattle", 20.0) == "safe"

    def test_caution_at_minus_5(self):
        assert calculate_risk_level("cattle", -5.0) == "caution"

    def test_caution_between(self):
        assert calculate_risk_level("cattle", -7.0) == "caution"

    def test_danger_at_minus_10(self):
        assert calculate_risk_level("cattle", -10.0) == "danger"

    def test_danger_between(self):
        assert calculate_risk_level("cattle", -12.0) == "danger"

    def test_emergency_at_minus_15(self):
        assert calculate_risk_level("cattle", -15.0) == "emergency"

    def test_emergency_below(self):
        assert calculate_risk_level("cattle", -16.0) == "emergency"
        assert calculate_risk_level("cattle", -20.0) == "emergency"


class TestDuckRisk:
    """오리 위험도 테스트"""

    def test_safe(self):
        assert calculate_risk_level("duck", 25.0) == "safe"
        assert calculate_risk_level("duck", 31.9) == "safe"

    def test_caution_at_boundary(self):
        assert calculate_risk_level("duck", 32.0) == "caution"

    def test_danger_at_boundary(self):
        assert calculate_risk_level("duck", 35.0) == "danger"

    def test_emergency_at_boundary(self):
        assert calculate_risk_level("duck", 38.0) == "emergency"

    def test_emergency_above(self):
        assert calculate_risk_level("duck", 39.0) == "emergency"


class TestUnknownLivestockType:
    """알 수 없는 축종 — 안전하게 폴백"""

    def test_unknown_type_returns_safe(self):
        assert calculate_risk_level("horse", 40.0) == "safe"
        assert calculate_risk_level("", 35.0) == "safe"
        assert calculate_risk_level("fish", -20.0) == "safe"


class TestChecklistItems:
    """체크리스트 반환 테스트"""

    def test_chicken_danger_returns_list(self):
        items = get_checklist_items("chicken", "danger")
        assert isinstance(items, list)
        assert len(items) > 0

    def test_chicken_emergency_returns_list(self):
        items = get_checklist_items("chicken", "emergency")
        assert isinstance(items, list)
        assert len(items) > 0

    def test_safe_returns_message(self):
        items = get_checklist_items("chicken", "safe")
        assert isinstance(items, list)
        assert len(items) > 0

    def test_pig_danger_returns_list(self):
        items = get_checklist_items("pig", "danger")
        assert isinstance(items, list)
        assert len(items) > 0

    def test_cattle_caution_returns_list(self):
        items = get_checklist_items("cattle", "caution")
        assert isinstance(items, list)
        assert len(items) > 0

    def test_unknown_type_returns_default(self):
        items = get_checklist_items("horse", "danger")
        assert isinstance(items, list)
        assert len(items) > 0


class TestCautionTemplate:
    """주의 단계 템플릿 메시지 테스트"""

    def test_chicken_caution_template_not_empty(self):
        msg = get_caution_template("chicken", 31.0)
        assert isinstance(msg, str)
        assert len(msg) > 0

    def test_pig_caution_template_contains_temp(self):
        msg = get_caution_template("pig", 29.5)
        assert "29.5" in msg

    def test_cattle_caution_template_not_empty(self):
        msg = get_caution_template("cattle", -6.0)
        assert isinstance(msg, str)
        assert len(msg) > 0

    def test_unknown_type_returns_default_template(self):
        msg = get_caution_template("horse", 30.0)
        assert isinstance(msg, str)
        assert len(msg) > 0
