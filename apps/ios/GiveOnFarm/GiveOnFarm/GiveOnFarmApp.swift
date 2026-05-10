import SwiftUI

@main
struct GiveOnFarmApp: App {
    #if DEBUG
    @AppStorage("isRegistered") private var isRegistered: Bool = true
    #else
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    #endif

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
