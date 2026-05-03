// UserDefaultsManager.swift
// Give On Farm — 농가 설정 로컬 저장

import Foundation

final class UserDefaultsManager: @unchecked Sendable {
    static let shared = UserDefaultsManager()

    private let defaults = UserDefaults.standard
    private init() {}

    // MARK: - Keys
    private enum Key: String, CaseIterable {
        case farmId = "give_on_farm_id"
        case farmName = "give_on_farm_name"
        case livestockType = "give_on_livestock_type"
        case livestockCount = "give_on_livestock_count"
        case notificationEnabled = "give_on_notification_enabled"
        case onboardingCompleted = "give_on_onboarding_completed"
        case kakaoAlimtalk = "give_on_kakao_alimtalk"
    }

    // MARK: - Farm Info
    var farmId: Int? {
        get { defaults.object(forKey: Key.farmId.rawValue) as? Int }
        set { defaults.set(newValue, forKey: Key.farmId.rawValue) }
    }

    var farmName: String? {
        get { defaults.string(forKey: Key.farmName.rawValue) }
        set { defaults.set(newValue, forKey: Key.farmName.rawValue) }
    }

    var livestockType: String? {
        get { defaults.string(forKey: Key.livestockType.rawValue) }
        set { defaults.set(newValue, forKey: Key.livestockType.rawValue) }
    }

    var livestockCount: Int {
        get { defaults.integer(forKey: Key.livestockCount.rawValue) }
        set { defaults.set(newValue, forKey: Key.livestockCount.rawValue) }
    }

    // MARK: - Flags
    var onboardingCompleted: Bool {
        get { defaults.bool(forKey: Key.onboardingCompleted.rawValue) }
        set { defaults.set(newValue, forKey: Key.onboardingCompleted.rawValue) }
    }

    var notificationEnabled: Bool {
        get { defaults.bool(forKey: Key.notificationEnabled.rawValue) }
        set { defaults.set(newValue, forKey: Key.notificationEnabled.rawValue) }
    }

    var kakaoAlimtalkEnabled: Bool {
        get { defaults.bool(forKey: Key.kakaoAlimtalk.rawValue) }
        set { defaults.set(newValue, forKey: Key.kakaoAlimtalk.rawValue) }
    }

    // MARK: - Reset
    func clearAll() {
        Key.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) }
    }
}
