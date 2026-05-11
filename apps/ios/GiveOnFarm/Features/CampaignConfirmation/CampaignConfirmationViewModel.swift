import SwiftUI

@MainActor
final class CampaignConfirmationViewModel: ObservableObject {
    @Published var campaignTitle: String
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(campaignTitle: String) {
        self.campaignTitle = campaignTitle
    }

    func confirmCampaign() {
        isLoading = true
        Task {
            do {
                // API call to create campaign
                // let response = try await API.createCampaign(title: campaignTitle)
                print("Campaign confirmed: \(campaignTitle)")
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
