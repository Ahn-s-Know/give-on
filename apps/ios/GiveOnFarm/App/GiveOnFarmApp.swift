// GiveOnFarmApp.swift
// Give On Farm — 앱 진입점

import SwiftUI
import UserNotifications

@main
struct GiveOnFarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var onboardingCompleted = UserDefaultsManager.shared.onboardingCompleted

    var body: some Scene {
        WindowGroup {
            if onboardingCompleted {
                HomeView()
            } else {
                OnboardingView(onboardingCompleted: $onboardingCompleted)
            }
        }
    }
}
