import SwiftUI

@main
struct GiveOnFarmApp: App {
    @AppStorage("isRegistered") private var isRegistered: Bool = false

    var body: some Scene {
        WindowGroup {
            if isRegistered {
                GOFTabView()
            } else {
                FarmRegistrationEntryView(isRegistered: $isRegistered)
            }
        }
    }
}
