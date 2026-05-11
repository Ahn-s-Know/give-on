import SwiftUI

/// GiveOnFarm 앱의 재사용 가능한 UI 컴포넌트

// MARK: - Header View

/// 표준 헤더 컴포넌트 (뒤로가기 버튼 + 제목)
struct GOFHeader: View {
    let title: String
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: .gof.xs) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.gof.icon)
                        .foregroundColor(.gof.darkGreen)
                        .frame(width: .gof.iconBack, height: .gof.iconBack)
                        .contentShape(Rectangle())
                }
                
                Text(title)
                    .font(.gof.largeTitle)
                    .foregroundColor(.gof.textPrimary)
                    .tracking(-0.24)
                
                Spacer()
            }
            .padding(.horizontal, .gof.lg)
            .frame(height: .gof.heightHeader)
            .background(Color.gof.white)
            .overlay(
                Rectangle()
                    .fill(Color.gof.borderDivider)
                    .frame(height: .gof.borderThin),
                alignment: .bottom
            )
        }
    }
}

// MARK: - Step Indicator

/// 단계 표시 컴포넌트 (예: "2/3 단계")
struct GOFStepIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        Text("\(currentStep)/\(totalSteps) 단계")
            .font(.gof.captionMedium)
            .foregroundColor(.gof.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Section Title

/// 섹션 제목 컴포넌트 (필수 표시 포함 옵션)
struct GOFSectionTitle: View {
    let title: String
    let isRequired: Bool
    
    init(_ title: String, isRequired: Bool = false) {
        self.title = title
        self.isRequired = isRequired
    }
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title + " ")
                .font(.gof.subtitle)
                .foregroundColor(.gof.textPrimary)
            
            if isRequired {
                Text("*")
                    .font(.gof.subtitle)
                    .foregroundColor(.gof.error)
            }
        }
    }
}

// MARK: - Text Field

/// 표준 텍스트 입력 필드
struct GOFTextField: View {
    let placeholder: String
    @Binding var text: String
    var suffix: String? = nil
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.gof.body)
                .foregroundColor(.gof.textPrimary)
                .keyboardType(keyboardType)
            
            if let suffix = suffix {
                Text(suffix)
                    .font(.gof.body)
                    .foregroundColor(.gof.textSecondary)
            }
        }
        .padding(.gof.md)
        .background(Color.gof.white)
        .cornerRadius(.gof.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: .gof.radiusMedium)
                .stroke(Color.gof.borderDefault, lineWidth: .gof.borderThin)
        )
    }
}

// MARK: - Text Editor

/// 표준 멀티라인 텍스트 입력 필드
struct GOFTextEditor: View {
    let placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 120
    var maxCharacters: Int? = nil
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 3) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.gof.body)
                    .foregroundColor(.gof.textPrimary)
                    .padding(.gof.md + 1)
                    .frame(minHeight: minHeight)
                    .background(Color.gof.white)
                    .cornerRadius(.gof.radiusMedium)
                    .overlay(
                        RoundedRectangle(cornerRadius: .gof.radiusMedium)
                            .stroke(Color.gof.borderDefault, lineWidth: .gof.borderThin)
                    )
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.gof.body)
                        .foregroundColor(.gof.textPlaceholder)
                        .padding(.gof.md + 1)
                        .allowsHitTesting(false)
                }
            }
            
            if let maxCharacters = maxCharacters {
                Text("\(text.count) / \(maxCharacters)자")
                    .font(.gof.caption)
                    .foregroundColor(.gof.textPlaceholder)
            }
        }
    }
}

// MARK: - Info Banner

/// 정보 배너 컴포넌트 (아이콘 + 제목 + 설명)
struct GOFInfoBanner: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: .gof.md) {
            Image(systemName: icon)
                .font(.gof.iconMedium)
                .foregroundColor(.gof.white)
                .frame(width: .gof.iconSpecial, height: .gof.iconSpecial)
                .background(Color.gof.primaryGreen)
                .cornerRadius(.gof.radiusFull)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.gof.subtitleMedium)
                    .foregroundColor(.gof.textPrimary)
                
                Text(description)
                    .font(.gof.bodyMedium)
                    .foregroundColor(.gof.textTertiary)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
        .padding(21)
        .background(Color.gof.backgroundCard)
        .cornerRadius(.gof.radiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: .gof.radiusLarge)
                .stroke(Color.gof.borderDivider, lineWidth: .gof.borderThin)
        )
    }
}

// MARK: - Card Container

/// 카드 컨테이너 컴포넌트
struct GOFCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.gof.md + 1)
            .background(Color.gof.backgroundCard)
            .cornerRadius(.gof.radiusLarge)
            .overlay(
                RoundedRectangle(cornerRadius: .gof.radiusLarge)
                    .stroke(Color.gof.borderDivider, lineWidth: .gof.borderThin)
            )
    }
}

// MARK: - Success Icon

/// 성공 아이콘 (체크마크)
struct GOFSuccessIcon: View {
    var size: CGFloat = 96
    
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundColor(.gof.white)
            .frame(width: size, height: size)
            .background(Color.gof.primaryGreen)
            .cornerRadius(size / 2)
            .shadow(color: .gof.black.opacity(0.06), radius: 12, x: 0, y: 8)
    }
}

// MARK: - Loading Overlay

/// 로딩 오버레이
struct GOFLoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.gof.black.opacity(0.4)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gof.white))
                .scaleEffect(1.5)
                .padding(.gof.xl)
                .background(
                    RoundedRectangle(cornerRadius: .gof.radiusLarge)
                        .fill(Color.gof.white.opacity(0.9))
                )
        }
    }
}

// MARK: - Preview

#Preview("Components") {
    ScrollView {
        VStack(spacing: 20) {
            GOFHeader(title: "피해 신고") {
                print("Back tapped")
            }
            
            VStack(spacing: 20) {
                GOFStepIndicator(currentStep: 2, totalSteps: 3)
                
                GOFSectionTitle("작물 선택", isRequired: true)
                
                GOFTextField(
                    placeholder: "피해 면적 입력",
                    text: .constant(""),
                    suffix: "평",
                    keyboardType: .numberPad
                )
                
                GOFTextEditor(
                    placeholder: "상세 내용을 입력하세요",
                    text: .constant(""),
                    maxCharacters: 500
                )
                
                GOFInfoBanner(
                    icon: "lightbulb.fill",
                    title: "AI가 스토리를 다듬어 드립니다.",
                    description: "어려웠던 일, 필요한 도움을 편하게 적어주세요."
                )
                
                GOFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("카드 제목")
                            .font(.gof.subtitle)
                        Text("카드 내용입니다.")
                            .font(.gof.body)
                            .foregroundColor(.gof.textSecondary)
                    }
                }
                
                GOFSuccessIcon()
            }
            .padding()
        }
    }
}
