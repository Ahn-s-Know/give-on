import SwiftUI

struct GOFTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                FarmStatusView()
            }
            .tabItem {
                Label("홈", systemImage: "house.fill")
            }
            
            NavigationView {
                DamageReportMainView()
            }
            .tabItem {
                Label("피해신고", systemImage: "exclamationmark.triangle.fill")
            }
            
            NavigationView {
                CampaignListView()
            }
            .tabItem {
                Label("캠페인", systemImage: "megaphone.fill")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("설정", systemImage: "gearshape.fill")
            }
        }
        .tint(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
    }
}

// MARK: - Previews

#Preview {
    GOFTabView()
}
