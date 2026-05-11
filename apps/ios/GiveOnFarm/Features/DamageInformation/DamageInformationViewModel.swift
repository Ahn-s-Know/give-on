import SwiftUI

@MainActor
final class DamageInformationViewModel: ObservableObject {
    @Published var selectedCrop: String?
    @Published var damageArea = ""
    @Published var selectedSymptoms: Set<String> = []
    @Published var additionalNotes = ""

    var isValid: Bool {
        selectedCrop != nil && !damageArea.isEmpty
    }

    func nextStep() {
        guard isValid else { return }

        let damageInfo = DamageInfo(
            crop: selectedCrop ?? "",
            area: Double(damageArea) ?? 0,
            symptoms: Array(selectedSymptoms),
            additionalNotes: additionalNotes
        )

        // Submit to backend
        submitDamageInfo(damageInfo)
    }

    private func submitDamageInfo(_ info: DamageInfo) {
        Task {
            do {
                // API call
                // let response = try await API.submitDamageInfo(info)
                print("Damage info submitted: \(info)")
            } catch {
                print("Error submitting damage info: \(error)")
            }
        }
    }
}

struct DamageInfo {
    let crop: String
    let area: Double
    let symptoms: [String]
    let additionalNotes: String
}
