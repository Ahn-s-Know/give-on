// NotificationManager.swift
// Give On Farm — FCM 푸시 알림 설정

import Foundation
import UserNotifications

#if canImport(FirebaseMessaging)
import FirebaseMessaging
#endif

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    private override init() { super.init() }

    // MARK: - 권한 요청
    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            UserDefaultsManager.shared.notificationEnabled = granted
            if granted {
                await MainActor.run {
                    #if canImport(UIKit)
                    import UIKit
                    UIApplication.shared.registerForRemoteNotifications()
                    #endif
                }
            }
        } catch {
            print("알림 권한 요청 실패: \(error)")
        }
    }

    // MARK: - FCM 토큰 갱신 → 백엔드 등록
    func didReceiveFCMToken(_ token: String) {
        Task {
            try? await APIClient.shared.updateFCMToken(token)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    /// 포그라운드에서도 배너 + 소리로 알림 표시
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }

    /// 알림 탭 → 경보 상세 화면으로 이동
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        let alertId = userInfo["alert_id"] as? String
        let riskLevel = userInfo["risk_level"] as? String ?? ""
        print("알림 탭: alert_id=\(alertId ?? "nil"), risk_level=\(riskLevel)")
        // TODO: DeepLink 처리 — AlertDetailView 이동
    }
}
