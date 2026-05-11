import SwiftUI

@MainActor
final class DamageReportInputMethodViewModel: ObservableObject {
    @Published var selectedMethod: InputMethod?

    enum InputMethod {
        case voice
        case manual
    }

    func selectVoiceInput() {
        selectedMethod = .voice
        proceedWithMethod(.voice)
    }

    func selectManualInput() {
        selectedMethod = .manual
        proceedWithMethod(.manual)
    }

    private func proceedWithMethod(_ method: InputMethod) {
        Task {
            // Navigation would happen here
            print("Selected input method: \(method)")
        }
    }
}
