import SwiftUI

/// GiveOnFarm 앱의 스페이싱 및 레이아웃 상수
enum GOFSpacing {
    // MARK: - Padding
    
    /// 최소 패딩 (8pt)
    static let xs: CGFloat = 8
    
    /// 작은 패딩 (12pt)
    static let sm: CGFloat = 12
    
    /// 기본 패딩 (16pt)
    static let md: CGFloat = 16
    
    /// 큰 패딩 (20pt)
    static let lg: CGFloat = 20
    
    /// 매우 큰 패딩 (24pt)
    static let xl: CGFloat = 24
    
    /// 초대형 패딩 (32pt)
    static let xxl: CGFloat = 32
    
    // MARK: - Corner Radius
    
    /// 작은 둥근 모서리 (4pt)
    static let radiusSmall: CGFloat = 4
    
    /// 기본 둥근 모서리 (8pt)
    static let radiusMedium: CGFloat = 8
    
    /// 큰 둥근 모서리 (12pt)
    static let radiusLarge: CGFloat = 12
    
    /// 매우 큰 둥근 모서리 (16pt)
    static let radiusXLarge: CGFloat = 16
    
    /// 원형 (999pt)
    static let radiusFull: CGFloat = 999
    
    // MARK: - Border Width
    
    /// 기본 테두리 두께 (1pt)
    static let borderThin: CGFloat = 1
    
    /// 두꺼운 테두리 (2pt)
    static let borderThick: CGFloat = 2
    
    // MARK: - Heights
    
    /// 작은 버튼/입력 필드 높이 (40pt)
    static let heightSmall: CGFloat = 40
    
    /// 기본 버튼/입력 필드 높이 (52pt)
    static let heightMedium: CGFloat = 52
    
    /// 헤더 높이 (64pt)
    static let heightHeader: CGFloat = 64
    
    // MARK: - Icon Sizes
    
    /// 작은 아이콘 (16pt)
    static let iconSmall: CGFloat = 16
    
    /// 기본 아이콘 (20pt)
    static let iconMedium: CGFloat = 20
    
    /// 큰 아이콘 (24pt)
    static let iconLarge: CGFloat = 24
    
    /// 매우 큰 아이콘 (32pt)
    static let iconXLarge: CGFloat = 32
    
    /// 헤더 백 버튼 아이콘 (32pt)
    static let iconBack: CGFloat = 32
    
    /// 특별 아이콘 (40pt)
    static let iconSpecial: CGFloat = 40
    
    /// 성공 아이콘 (64pt)
    static let iconSuccess: CGFloat = 64
    
    /// 초대형 아이콘 (96pt)
    static let iconHuge: CGFloat = 96
}

// MARK: - CGFloat Extension for easier access

extension CGFloat {
    static let gof = GOFSpacing.self
}
