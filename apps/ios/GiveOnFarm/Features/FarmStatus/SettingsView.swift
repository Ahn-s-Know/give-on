import SwiftUI

/// 설정 화면
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var weatherAlertsEnabled = true
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Text("설정")

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
            
            ScrollView {
                VStack(spacing: .gof.xl) {
                    // 프로필 섹션
                    profileSection
                    
                    // 알림 설정
                    settingsSection(title: "알림 설정") {
                        settingsToggle(
                            title: "푸시 알림",
                            description: "중요한 소식을 알려드립니다",
                            isOn: $notificationsEnabled
                        )
                        
                        settingsToggle(
                            title: "날씨 경보",
                            description: "위험 기상 정보를 받습니다",
                            isOn: $weatherAlertsEnabled
                        )
                    }
                    
                    // 앱 정보
                    settingsSection(title: "앱 정보") {
                        settingsRow(title: "버전", value: "1.0.0")
                        settingsRow(title: "개발자", value: "GiveOnFarm Team")
                    }
                    
                    // 계정
                    settingsSection(title: "계정") {
                        settingsButton(title: "로그아웃", color: .gof.error)
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.gof.lg)
            }
            .background(Color.gof.backgroundPrimary)
        }
        .background {
            VStack(spacing: 0) {
                Color.gof.white
                Color.gof.backgroundPrimary
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Subviews
    
    private var profileSection: some View {
        HStack(spacing: .gof.md) {
            // 프로필 이미지
            Circle()
                .fill(Color.gof.lightGreen)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.gof.primaryGreen)
                )
            
            // 사용자 정보
            VStack(alignment: .leading, spacing: 4) {
                Text("농부님")
                    .font(.gof.subtitle)
                    .foregroundColor(.gof.textPrimary)
                
                Text("farmer@example.com")
                    .font(.gof.caption)
                    .foregroundColor(.gof.textSecondary)
            }
            
            Spacer()
            
            // 편집 버튼
            Button {
                // 프로필 편집
            } label: {
                Image(systemName: "chevron.right")
                    .font(.gof.caption)
                    .foregroundColor(.gof.textSecondary)
            }
        }
        .padding(.gof.md)
        .background(Color.gof.white)
        .cornerRadius(.gof.radiusLarge)
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .gof.md) {
            Text(title)
                .font(.gof.subtitle)
                .foregroundColor(.gof.textPrimary)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color.gof.white)
            .cornerRadius(.gof.radiusLarge)
        }
    }
    
    private func settingsToggle(title: String, description: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.gof.body)
                    .foregroundColor(.gof.textPrimary)
                
                Text(description)
                    .font(.gof.caption)
                    .foregroundColor(.gof.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.gof.primaryGreen)
        }
        .padding(.gof.md)
    }
    
    private func settingsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.gof.body)
                .foregroundColor(.gof.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.gof.body)
                .foregroundColor(.gof.textSecondary)
        }
        .padding(.gof.md)
    }
    
    private func settingsButton(title: String, color: Color = .gof.textPrimary) -> some View {
        Button {
            // 액션
        } label: {
            HStack {
                Text(title)
                    .font(.gof.body)
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.gof.caption)
                    .foregroundColor(.gof.textSecondary)
            }
            .padding(.gof.md)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    SettingsView()
}
