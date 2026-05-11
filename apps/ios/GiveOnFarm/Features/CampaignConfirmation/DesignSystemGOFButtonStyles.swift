import SwiftUI

/// GiveOnFarm 앱의 버튼 스타일 모음
/// 일관성 있는 버튼 디자인을 위한 재사용 가능한 버튼 스타일

// MARK: - Primary Button Style

/// 주요 액션 버튼 (녹색 배경, 흰색 텍스트)
struct GOFPrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.gof.buttonLarge)
            .foregroundColor(.gof.white)
            .frame(height: .gof.heightMedium)
            .frame(maxWidth: .infinity)
            .background(Color.gof.primaryGreen)
            .cornerRadius(.gof.radiusFull)
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1.0) : 0.6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

/// 보조 버튼 (흰색 배경, 회색 테두리)
struct GOFSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.gof.subtitleRegular)
            .foregroundColor(.gof.textSecondary)
            .frame(height: .gof.heightMedium)
            .frame(maxWidth: .infinity)
            .background(Color.gof.white)
            .cornerRadius(.gof.radiusFull)
            .overlay(
                RoundedRectangle(cornerRadius: .gof.radiusFull)
                    .stroke(Color.gof.borderDefault, lineWidth: .gof.borderThin)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Outline Button Style

/// 외곽선 버튼 (투명 배경, 녹색 테두리)
struct GOFOutlineButtonStyle: ButtonStyle {
    var isSelected: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.gof.body)
            .foregroundColor(isSelected ? .gof.accentGreen : .gof.textTertiary)
            .frame(height: .gof.iconBack)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.gof.backgroundSelected : .gof.white)
            .cornerRadius(.gof.radiusFull)
            .overlay(
                RoundedRectangle(cornerRadius: .gof.radiusFull)
                    .stroke(
                        isSelected ? Color.gof.accentGreen : Color.gof.borderDefault,
                        lineWidth: .gof.borderThin
                    )
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Small Button Style

/// 작은 버튼 (흰색 배경, 회색 테두리)
struct GOFSmallButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.gof.buttonSmall)
            .foregroundColor(.gof.textTertiary)
            .frame(maxWidth: .infinity)
            .frame(height: .gof.heightSmall)
            .background(Color.gof.white)
            .cornerRadius(.gof.radiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: .gof.radiusSmall)
                    .stroke(Color.gof.borderDefault, lineWidth: .gof.borderThin)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Gray Button Style

/// 회색 버튼 (회색 배경, 테두리 없음)
struct GOFGrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.gof.button)
            .foregroundColor(.gof.textDisabled)
            .frame(maxWidth: .infinity)
            .frame(height: .gof.heightMedium)
            .background(Color.gof.backgroundGray)
            .cornerRadius(.gof.radiusFull)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Checkbox Button Style

/// 체크박스 스타일 버튼
struct GOFCheckboxButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .gof.sm) {
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .font(.gof.iconMedium)
                .foregroundColor(isSelected ? .gof.accentGreen : .gof.borderDefault)
            
            configuration.label
                .font(.gof.body)
                .foregroundColor(.gof.textPrimary)
            
            Spacer()
        }
        .padding(.gof.md - 3)
        .background(isSelected ? Color.gof.backgroundSelectedLight : .gof.white)
        .cornerRadius(.gof.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: .gof.radiusMedium)
                .stroke(
                    isSelected ? Color.gof.accentGreen : Color.gof.borderDefault,
                    lineWidth: .gof.borderThin
                )
        )
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - View Extension for Button Styles

extension View {
    /// 주요 버튼 스타일 적용
    func gofPrimaryButton(isEnabled: Bool = true) -> some View {
        self.buttonStyle(GOFPrimaryButtonStyle(isEnabled: isEnabled))
    }
    
    /// 보조 버튼 스타일 적용
    func gofSecondaryButton() -> some View {
        self.buttonStyle(GOFSecondaryButtonStyle())
    }
    
    /// 외곽선 버튼 스타일 적용
    func gofOutlineButton(isSelected: Bool = false) -> some View {
        self.buttonStyle(GOFOutlineButtonStyle(isSelected: isSelected))
    }
    
    /// 작은 버튼 스타일 적용
    func gofSmallButton() -> some View {
        self.buttonStyle(GOFSmallButtonStyle())
    }
    
    /// 회색 버튼 스타일 적용
    func gofGrayButton() -> some View {
        self.buttonStyle(GOFGrayButtonStyle())
    }
    
    /// 체크박스 버튼 스타일 적용
    func gofCheckboxButton(isSelected: Bool) -> some View {
        self.buttonStyle(GOFCheckboxButtonStyle(isSelected: isSelected))
    }
}

// MARK: - Preview

#Preview("Button Styles") {
    VStack(spacing: 20) {
        Button("주요 버튼") {}
            .gofPrimaryButton()
        
        Button("비활성화 버튼") {}
            .gofPrimaryButton(isEnabled: false)
        
        Button("보조 버튼") {}
            .gofSecondaryButton()
        
        Button("외곽선 버튼") {}
            .gofOutlineButton()
        
        Button("선택된 외곽선 버튼") {}
            .gofOutlineButton(isSelected: true)
        
        HStack {
            Button("작은 버튼 1") {}
                .gofSmallButton()
            
            Button("작은 버튼 2") {}
                .gofSmallButton()
        }
        
        Button("회색 버튼") {}
            .gofGrayButton()
        
        Button {
        } label: {
            Text("체크박스 옵션")
        }
        .gofCheckboxButton(isSelected: false)
        
        Button {
        } label: {
            Text("선택된 체크박스 옵션")
        }
        .gofCheckboxButton(isSelected: true)
    }
    .padding()
}
