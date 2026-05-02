// AppDelegate.swift
// Give On Farm — FCM 설정

import UIKit
import UserNotifications

// Firebase import: 프로젝트에 FirebaseMessaging SPM 패키지 추가 후 주석 해제
// import FirebaseCore
// import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Firebase 초기화 (SPM 패키지 추가 후 주석 해제)
        // FirebaseApp.configure()
        // Messaging.messaging().delegate = NotificationManager.shared

        // 알림 센터 delegate 등록
        UNUserNotificationCenter.current().delegate = NotificationManager.shared

        // 알림 권한 요청
        Task {
            await NotificationManager.shared.requestPermission()
        }

        return true
    }

    // APNs 토큰 수신 → FCM에 전달
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Messaging.messaging().apnsToken = deviceToken
        print("APNs 토큰 등록 완료")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs 토큰 등록 실패: \(error.localizedDescription)")
    }
}

/*
 FCM 연동 체크리스트:
 1. Firebase Console → 프로젝트 생성
 2. iOS 앱 추가 → GoogleService-Info.plist 다운로드 후 프로젝트에 추가
 3. SPM: https://github.com/firebase/firebase-ios-sdk → FirebaseMessaging 추가
 4. Apple Developer → Keys → APNs 인증 키 생성 → Firebase에 업로드
 5. 위 주석 처리된 코드 활성화
 */
