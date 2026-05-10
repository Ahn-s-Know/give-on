import SwiftUI

/// GiveOnFarm 앱의 메인 탭 뷰
struct GOFTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case report
        case campaign
        case settings
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 탭 콘텐츠
            Group {
                switch selectedTab {
                case .home:
                    FarmStatusView()
                case .report:
                    DamageReportMainView()
                case .campaign:
                    CampaignListView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 커스텀 탭바
            GOFTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

/// GiveOnFarm 앱의 커스텀 탭바
struct GOFTabBar: View {
    @Binding var selectedTab: GOFTabView.Tab
    
    var body: some View {
        HStack(spacing: 0) {
            tabBarItem(
                icon: "house.fill",
                label: "홈",
                tab: .home
            )
            
            tabBarItem(
                icon: "exclamationmark.triangle.fill",
                label: "피해신고",
                tab: .report
            )
            
            tabBarItem(
                icon: "megaphone.fill",
                label: "캠페인",
                tab: .campaign
            )
            
            tabBarItem(
                icon: "gearshape.fill",
                label: "설정",
                tab: .settings
            )
        }
        .frame(height: 60)
        .background(Color.gof.white)
        .overlay(
            Rectangle()
                .fill(Color.gof.borderDivider)
                .frame(height: .gof.borderThin),
            alignment: .top
        )
    }
    
    private func tabBarItem(icon: String, label: String, tab: GOFTabView.Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.gof.iconMedium)
                    .foregroundColor(selectedTab == tab ? .gof.primaryGreen : .gof.textSecondary)
                
                Text(label)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(selectedTab == tab ? .gof.primaryGreen : .gof.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    GOFTabView()
}
