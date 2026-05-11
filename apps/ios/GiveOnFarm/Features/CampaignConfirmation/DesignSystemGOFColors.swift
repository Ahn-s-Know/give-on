import SwiftUI

/// GiveOnFarm 앱의 색상 시스템
/// 모든 화면에서 일관성 있는 색상을 사용하기 위한 중앙 집중식 색상 정의
enum GOFColors {
    // MARK: - Primary Colors
    
    /// 주요 녹색 (Primary Green) - 주요 액션 버튼, 강조
    static let primaryGreen = Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1))
    
    /// 밝은 녹색 (Light Green) - 선택된 상태, 강조 배경
    static let lightGreen = Color(UIColor(red: 0.647, green: 0.953, blue: 0.773, alpha: 1))
    
    /// 진한 녹색 (Dark Green) - 헤더, 타이틀
    static let darkGreen = Color(UIColor(red: 0.114, green: 0.196, blue: 0.145, alpha: 1))
    
    /// 액센트 녹색 (Accent Green) - 활성 상태
    static let accentGreen = Color(UIColor(red: 0.000, green: 0.337, blue: 0.212, alpha: 1))
    
    /// 밝은 녹색 텍스트
    static let lightGreenText = Color(UIColor(red: 0.631, green: 0.937, blue: 0.753, alpha: 1))
    
    /// 아이콘 녹색
    static let iconGreen = Color(UIColor(red: 0.090, green: 0.545, blue: 0.306, alpha: 1))
    
    // MARK: - Text Colors
    
    /// 주요 텍스트 색상 (거의 검정)
    static let textPrimary = Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1))
    
    /// 보조 텍스트 색상 (회색)
    static let textSecondary = Color(UIColor(red: 0.369, green: 0.369, blue: 0.357, alpha: 1))
    
    /// 세 번째 텍스트 색상 (연한 회색)
    static let textTertiary = Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1))
    
    /// Placeholder 텍스트
    static let textPlaceholder = Color(UIColor(red: 0.435, green: 0.478, blue: 0.443, alpha: 1))
    
    /// 비활성화된 텍스트
    static let textDisabled = Color(UIColor(red: 0.388, green: 0.388, blue: 0.373, alpha: 1))
    
    // MARK: - Border Colors
    
    /// 기본 테두리 색상
    static let borderDefault = Color(UIColor(red: 0.749, green: 0.788, blue: 0.753, alpha: 1))
    
    /// 구분선 색상
    static let borderDivider = Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1))
    
    // MARK: - Background Colors
    
    /// 기본 배경색 (연한 아이보리)
    static let backgroundPrimary = Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1))
    
    /// 카드/컨테이너 배경색 (연한 베이지)
    static let backgroundCard = Color(UIColor(red: 0.953, green: 0.956, blue: 0.929, alpha: 1))
    
    /// 회색 배경
    static let backgroundGray = Color(UIColor(red: 0.882, green: 0.875, blue: 0.859, alpha: 1))
    
    /// 선택된 아이템 배경 (반투명 녹색)
    static let backgroundSelected = Color(UIColor(red: 0.647, green: 0.953, blue: 0.773, alpha: 0.2))
    
    /// 선택된 아이템 배경 (매우 연한)
    static let backgroundSelectedLight = Color(UIColor(red: 0.647, green: 0.953, blue: 0.773, alpha: 0.05))
    
    // MARK: - Semantic Colors
    
    /// 에러/경고 빨강
    static let error = Color(UIColor(red: 0.737, green: 0.102, blue: 0.102, alpha: 1))

    /// 성공 녹색
    static let success = primaryGreen

    /// 흰색
    static let white = Color.white

    /// 검정 (오버레이)
    static let black = Color.black

    // MARK: - Risk Level Colors (위험도 신호등)

    /// 안전 (#52b788)
    static let riskSafe = Color(UIColor(red: 0.322, green: 0.718, blue: 0.533, alpha: 1))

    /// 주의 (#f4a261)
    static let riskCaution = Color(UIColor(red: 0.957, green: 0.635, blue: 0.380, alpha: 1))

    /// 위험 (#e07a5f)
    static let riskDanger = Color(UIColor(red: 0.878, green: 0.478, blue: 0.373, alpha: 1))

    /// 긴급 (#e63946) — Harvest Red
    static let riskEmergency = Color(UIColor(red: 0.902, green: 0.224, blue: 0.275, alpha: 1))

    // MARK: - Emergency Surface

    /// 긴급 상태 전체 배경 (#1a2e1e) — 짙은 녹색
    static let surfaceDark = Color(UIColor(red: 0.102, green: 0.180, blue: 0.118, alpha: 1))

    /// 긴급 배경 위 텍스트 (#f0f0ec) — 따뜻한 오프화이트
    static let onDark = Color(UIColor(red: 0.941, green: 0.941, blue: 0.925, alpha: 1))
}

// MARK: - Color Extension for easier access

internal extension Color {
    static let gof = GOFColors.self
}
