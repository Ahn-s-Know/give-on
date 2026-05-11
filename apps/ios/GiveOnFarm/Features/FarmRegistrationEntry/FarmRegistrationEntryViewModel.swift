import Foundation

class FarmRegistrationEntryViewModel: ObservableObject {
    @Published var farmName = ""
    @Published var location = ""
    @Published var isVoiceMode = false
    @Published var isManualMode = false

    func registerWithVoice() {
        // Voice registration implementation
    }

    func registerManual(name: String, location: String) {
        self.farmName = name
        self.location = location
        // Manual registration implementation
    }
}
