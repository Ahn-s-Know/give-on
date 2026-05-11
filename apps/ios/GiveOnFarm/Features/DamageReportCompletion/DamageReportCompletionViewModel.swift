import SwiftUI

@MainActor
final class DamageReportCompletionViewModel: ObservableObject {
    @Published var isLoading = false

    func returnHome() {
        // Navigate back to home
        // In real implementation, this would use NavigationStack or similar
        // For now, just trigger the navigation
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            // Navigation would happen here
        }
    }
}
