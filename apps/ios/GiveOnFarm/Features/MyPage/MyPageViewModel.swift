import Foundation

class MyPageViewModel: ObservableObject {
    @Published var userName = "김지수님"
    @Published var farmName = "포천 왓살농장"
    @Published var ongoingCampaigns = 2
    @Published var completedCampaigns = 14
}
