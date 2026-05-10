import SwiftUI

/// GiveOnFarm 앱의 타이포그래피 시스템
/// 모든 화면에서 일관성 있는 폰트를 사용하기 위한 중앙 집중식 폰트 정의
enum GOFTypography {
    // MARK: - Headings
    
    /// 대형 제목 (24pt, Bold)
    static let largeTitle = Font.system(size: 24, weight: .bold, design: .default)
    
    /// 제목 (20pt, Bold)
    static let title = Font.system(size: 20, weight: .bold, design: .default)
    
    /// 중간 제목 (20pt, Medium)
    static let titleMedium = Font.system(size: 20, weight: .medium, design: .default)
    
    /// 일반 제목 (20pt, Regular)
    static let titleRegular = Font.system(size: 20, weight: .regular, design: .default)
    
    /// 부제목 (17pt, Bold)
    static let subtitle = Font.system(size: 17, weight: .bold, design: .default)
    
    /// 중간 부제목 (17pt, Medium)
    static let subtitleMedium = Font.system(size: 17, weight: .medium, design: .default)
    
    /// 일반 부제목 (17pt, Regular)
    static let subtitleRegular = Font.system(size: 17, weight: .regular, design: .default)
    
    // MARK: - Body Text
    
    /// 본문 텍스트 (15pt, Regular)
    static let body = Font.system(size: 15, weight: .regular, design: .default)
    
    /// 중간 본문 텍스트 (15pt, Medium)
    static let bodyMedium = Font.system(size: 15, weight: .medium, design: .default)
    
    /// 굵은 본문 텍스트 (15pt, Bold)
    static let bodyBold = Font.system(size: 15, weight: .bold, design: .default)
    
    // MARK: - Small Text
    
    /// 작은 텍스트 (13pt, Regular)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
    
    /// 중간 작은 텍스트 (13pt, Medium)
    static let captionMedium = Font.system(size: 13, weight: .medium, design: .default)
    
    /// 굵은 작은 텍스트 (13pt, Bold)
    static let captionBold = Font.system(size: 13, weight: .bold, design: .default)
    
    // MARK: - Button Text
    
    /// 주요 버튼 텍스트 (20pt, Bold)
    static let buttonLarge = Font.system(size: 20, weight: .bold, design: .default)
    
    /// 중간 버튼 텍스트 (20pt, Medium)
    static let buttonLargeMedium = Font.system(size: 20, weight: .medium, design: .default)
    
    /// 일반 버튼 텍스트 (17pt, Medium)
    static let button = Font.system(size: 17, weight: .medium, design: .default)
    
    /// 작은 버튼 텍스트 (13pt, Medium)
    static let buttonSmall = Font.system(size: 13, weight: .medium, design: .default)
    
    // MARK: - Special
    
    /// 아이콘 크기 - 큰 (28pt, Semibold)
    static let iconLarge = Font.system(size: 28, weight: .semibold)
    
    /// 아이콘 크기 - 중간 (20pt)
    static let iconMedium = Font.system(size: 20)
    
    /// 아이콘 크기 - 일반 (16pt, Semibold)
    static let icon = Font.system(size: 16, weight: .semibold)
    
    /// 아이콘 크기 - 작은 (14pt, Semibold)
    static let iconSmall = Font.system(size: 14, weight: .semibold)
}

// MARK: - Font Extension for easier access

extension Font {
    static let gof = GOFTypography.self
}
