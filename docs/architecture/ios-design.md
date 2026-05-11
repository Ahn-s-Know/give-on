# Give On Farm — iOS 앱 설계서

> 기후 위기로부터 축산 농가를 지키는 AI 플랫폼  
> Swift 6 · SwiftUI · iOS 15+  
> 최종 수정: 2026-05-10

---

## 목차

1. [앱 개요](#1-앱-개요)
2. [기술 스택](#2-기술-스택)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [아키텍처 — MVVM](#4-아키텍처--mvvm)
5. [화면 구성 및 네비게이션](#5-화면-구성-및-네비게이션)
6. [기능별 화면 상세](#6-기능별-화면-상세)
7. [디자인 시스템](#7-디자인-시스템)
8. [네트워크 레이어](#8-네트워크-레이어)
9. [푸시 알림 (FCM)](#9-푸시-알림-fcm)
10. [데이터 모델](#10-데이터-모델)
11. [API 연동 명세](#11-api-연동-명세)
12. [개발 체크리스트](#12-개발-체크리스트)

---

## 1. 앱 개요

**Give On Farm**은 축산 농가가 사용하는 iOS 전용 앱으로, 세 가지 핵심 기능을 제공한다.

| 기능 | 설명 |
|---|---|
| 위험도 모니터링 | 기상청 데이터 + AI 기반 실시간 위험 단계 표시 |
| 피해 신고 | 자연재해 피해 사진·내용 등록 → 기부 캠페인 자동 생성 |
| 경보 알림 | FCM 푸시로 긴급 기상 경보 즉시 수신 |

### 사용자

- 축산 농가 운영자 (주요: 50대 이상, 스마트폰 사용 경험 다양)
- 음성 입력 지원으로 접근성 확보

### 핵심 지표

- 위험도 화면 로딩: **3초 이내**
- FCM 수신 → 배너 표시: **즉시**
- 피해 신고 완료 플로우: **5분 이내**

---

## 2. 기술 스택

| 항목 | 기술 |
|---|---|
| 언어 | Swift 6 |
| UI 프레임워크 | SwiftUI |
| 최소 배포 대상 | iOS 15.0 |
| 동시성 | async/await, `@MainActor` |
| 네트워크 | URLSession (async/await) |
| 로컬 저장소 | UserDefaults (`@AppStorage`) |
| 푸시 알림 | Firebase Cloud Messaging (FCM) |
| 프로젝트 관리 | XcodeGen (`project.yml`) |
| 아키텍처 | MVVM |

---

## 3. 프로젝트 구조

```
apps/ios/GiveOnFarm/
├── project.yml                          # XcodeGen 설정
│
├── GiveOnFarm/
│   └── GiveOnFarmApp.swift              # 앱 진입점, 온보딩/홈 라우팅
│
└── Features/                            # 기능별 모듈
    │
    ├── FarmRegistrationEntry/           # 온보딩 진입 (최초 실행)
    │   ├── FarmRegistrationEntryView.swift
    │   └── FarmRegistrationEntryViewModel.swift
    │
    ├── FarmLocationRegistration/        # 농장 위치 등록
    │   ├── FarmLocationRegistrationView.swift
    │   └── FarmLocationRegistrationViewModel.swift
    │
    ├── FarmStatus/                      # 메인 탭 화면들
    │   ├── GOFTabView.swift             # TabView 컨테이너
    │   ├── FarmStatusView.swift         # 홈 — 위험도 현황
    │   ├── FarmStatusViewModel.swift
    │   ├── DamageReportMainView.swift   # 피해 신고 탭
    │   ├── CampaignListView.swift       # 캠페인 탭
    │   └── SettingsView.swift           # 설정 탭
    │
    ├── DamageReportInputMethod/         # 피해 신고 — 입력 방식 선택
    ├── DamageInformation/               # 피해 신고 — 피해 정보 입력
    ├── MediaRegistration/               # 피해 신고 — 사진 등록
    ├── CampaignStoryCreation/           # 피해 신고 — AI 스토리 생성
    ├── CampaignConfirmation/            # 피해 신고 — 최종 확인
    ├── DamageReportCompletion/          # 피해 신고 — 완료
    │
    ├── Alert/                           # 경보 이력
    ├── MyPage/                          # 마이페이지
    └── Settings/                        # 설정 (FarmStatus 내 SettingsView와 통합)

    │
    │   [디자인 시스템 — CampaignConfirmation 폴더에 위치]
    ├── DesignSystemGOFColors.swift      # 색상 시스템
    ├── DesignSystemGOFTypography.swift  # 타이포그래피
    ├── DesignSystemGOFSpacing.swift     # 스페이싱·레이아웃 상수
    ├── DesignSystemGOFComponents.swift  # 재사용 UI 컴포넌트
    └── DesignSystemGOFButtonStyles.swift # 버튼 스타일
```

> **TODO:** 디자인 시스템 파일을 `GiveOnFarm/DesignSystem/` 디렉토리로 이동 필요.  
> `project.yml` sources에 해당 경로 추가 필요.

---

## 4. 아키텍처 — MVVM

```
View ──(observe)──▶ ViewModel ──(call)──▶ Repository / Service
 │                     │                        │
 │                     │ @Published             │
 │◀─(update)───────────┘                        │
 │                                              ▼
 │                                         APIClient
 │                                              │
 │                                              ▼
 │                                       FastAPI Backend
 └─────────────────────────────────────────────▶ (navigate, sheet)
```

### 규칙

| 레이어 | 역할 | 예시 |
|---|---|---|
| View | SwiftUI 화면 렌더링만 | `FarmStatusView` |
| ViewModel | 상태 관리, 비즈니스 로직 | `FarmStatusViewModel` |
| Model | Codable 데이터 구조 | `FarmRiskResponse` |
| APIClient | URLSession 네트워크 | `APIClient.shared` |
| Storage | UserDefaults 래핑 | `UserDefaultsManager` |

### ViewModel 패턴

```swift
@MainActor
final class FarmStatusViewModel: ObservableObject {
    @Published var riskLevel: RiskLevel = .safe
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchRisk() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await APIClient.shared.getFarmRisk()
            riskLevel = RiskLevel(rawValue: response.riskLevel) ?? .safe
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

---

## 5. 화면 구성 및 네비게이션

### 앱 진입 흐름

```
앱 실행
    │
    ▼
GiveOnFarmApp
    │
    ├─ isRegistered = false ──▶ FarmRegistrationEntryView (온보딩)
    │                               │
    │                    ┌──────────┴──────────┐
    │                    ▼                     ▼
    │              음성으로 등록            직접 입력
    │                    │                     │
    │                    └──────────┬──────────┘
    │                               ▼
    │                    FarmLocationRegistrationView
    │                               │
    │                               ▼
    │                    isRegistered = true
    │
    └─ isRegistered = true ──▶ GOFTabView (메인)
```

### 탭 구성

```
GOFTabView
├── [홈]      FarmStatusView        house.fill
├── [피해신고] DamageReportMainView  exclamationmark.triangle.fill
├── [캠페인]  CampaignListView      megaphone.fill
└── [설정]    SettingsView          gearshape.fill
```

### 피해 신고 플로우 (Full Screen Cover)

```
DamageReportMainView
    │
    └─ "피해 신고 시작하기" 버튼
            │
            ▼
DamageReportInputMethodView   (1단계: 입력 방식 선택)
            │
            ▼
DamageInformationView         (2단계: 피해 정보 입력)
            │
            ▼
MediaRegistrationView         (3단계: 사진 등록)
            │
            ▼
CampaignStoryCreationView     (4단계: AI 스토리 생성)
            │
            ▼
CampaignConfirmationModal     (5단계: 최종 확인)
            │
            ▼
DamageReportCompletionView    (완료 화면)
```

---

## 6. 기능별 화면 상세

### 6-1. 온보딩 — 농장 등록 (`FarmRegistrationEntryView`)

**목적:** 최초 실행 시 농장 등록 유도

**UI 구성:**
- 브랜드 제목: "Give On" + "농장 등록"
- 설명 텍스트: "음성 입력 버튼을 누르고 말씀하시면 자동으로 등록됩니다."
- 주요 버튼: **음성으로 등록** (Primary Green, 풀 알약 형태)
- 보조 버튼: **직접 입력** (흰색 배경, 회색 테두리)
- 버전 표시: "Give On App v1.0"

**시트 동작:**
- 음성 모드: 반투명 오버레이 + 마이크 아이콘 시트
- 수동 모드: 농장명·위치 입력 폼 시트

**상태 전환:**
- 등록 완료 → `isRegistered = true` → `GOFTabView` 표시

---

### 6-2. 홈 — 농장 위험도 현황 (`FarmStatusView`)

**목적:** 현재 농장의 위험 단계와 기상 정보 한눈에 표시

**UI 구성:**

```
┌─────────────────────────────────┐
│ Give On                    🔔   │  ← 헤더 (흰 배경, 하단 구분선)
├─────────────────────────────────┤
│                                 │
│         ⬤ (160px 원)           │  ← 위험도 신호등 (primaryGreen)
│      ✓ (80px 체크마크)           │
│                                 │
│           안전                   │  ← 위험 단계 라벨
│   현재 농장은 안전해요             │
│   오늘도 좋은 하루 보내세요!        │
│                                 │
├─────────────────────────────────┤
│ ☀️ 오늘의 날씨                   │  ← 날씨 카드
│  기온: 22°C  습도: 58%  바람: 2m/s│
└─────────────────────────────────┘
```

**위험 단계별 표시:**

| 단계 | 색상 | 배경 | 텍스트 |
|---|---|---|---|
| `safe` | `#52b788` (Risk Safe Green) | 연한 녹색 | "안전" |
| `caution` | `#f4a261` (Amber) | 연한 황색 | "주의" |
| `danger` | `#e07a5f` (Terracotta) | 연한 주황 | "위험" |
| `emergency` | `#e63946` (Harvest Red) | `surface-dark` 전체 | "긴급" + 펄스 애니메이션 |

**API 호출:**
- `GET /api/v1/farms/{farm_id}/risk` — 30초 폴링 또는 앱 foreground 복귀 시

---

### 6-3. 피해 신고 탭 (`DamageReportMainView`)

**목적:** 피해 신고 진입 및 이력 확인

**UI 구성:**
- 헤더: "피해 신고"
- 정보 배너: `GOFInfoBanner` — "농작물 피해를 신고하세요"
- CTA: "피해 신고 시작하기" (`gofPrimaryButton`)
- 최근 신고 내역 리스트 (없으면 빈 상태 표시)

**화면 전환:**
- "피해 신고 시작하기" → `fullScreenCover` → `DamageReportInputMethodView`

---

### 6-4. 피해 신고 플로우 상세

#### 1단계: 입력 방식 선택 (`DamageReportInputMethodView`)
- 음성 입력 / 직접 입력 선택
- 접근성 우선 — 고령 농가 고려

#### 2단계: 피해 정보 입력 (`DamageInformationView`)
- `GOFSectionTitle`: 피해 작물, 피해 면적, 피해 원인
- `GOFTextField`: 수치 입력
- `GOFTextEditor`: 피해 설명 (500자 이내)
- `GOFStepIndicator`: "2/5 단계"

#### 3단계: 사진 등록 (`MediaRegistrationView`)
- 최대 5장
- `DashedBorder` 점선 테두리 업로드 존
- PHPickerViewController 연동
- 원본 사진 그대로 — 필터 없음 (디자인 원칙)

#### 4단계: AI 스토리 생성 (`CampaignStoryCreationView`)
- 입력 데이터 → 백엔드 → Claude API → 스토리 반환
- 생성 중: `GOFLoadingOverlay`
- 생성 완료: 편집 가능한 스토리 미리보기

#### 5단계: 최종 확인 (`CampaignConfirmationModal`)
- 제목·스토리·사진 최종 확인
- "공개 동의 후 등록" CTA
- `GOFSuccessIcon` 체크마크 표시

#### 완료 (`DamageReportCompletionView`)
- 성공 피드백
- 캠페인 공개 안내
- 홈으로 돌아가기

---

### 6-5. 캠페인 목록 (`CampaignListView`)

**목적:** 현재 모금 중인 캠페인 목록 표시

**UI 구성:**
- 헤더: "캠페인" + 알림 버튼
- 섹션: "진행 중인 캠페인"
- 캠페인 카드 (`GOFCard`):
  - 제목, 설명 (2줄)
  - 현재/목표 금액 (primaryGreen)
  - 참여자 수
- 빈 상태: 메가폰 아이콘 + "진행 중인 캠페인이 없습니다"

**데이터:**
- `GET /api/v1/donations/farms` — 기부 가능 농가 목록

---

### 6-6. 설정 (`SettingsView`)

**목적:** 알림 설정, 앱 정보, 계정 관리

**UI 구성:**
- 프로필 섹션: 원형 아바타 + 이름 + 이메일
- 알림 설정: 푸시 알림 토글, 날씨 경보 토글 (`Toggle`, tint: primaryGreen)
- 앱 정보: 버전, 개발자
- 계정: 로그아웃 버튼 (error 색상)

---

## 7. 디자인 시스템

### 7-1. 색상 (`GOFColors`)

```swift
// Primary
primaryGreen    = #1F6F4A   // Primary CTA, 액티브 탭, 강조
lightGreen      = #A5F3C5   // 선택 배경, 성공 상태
darkGreen       = #1D3224   // 헤더 아이콘, 다크 강조
accentGreen     = #00562D   // 강조 액션

// Text
textPrimary     = #191C18   // 본문 제목 (따뜻한 검정)
textSecondary   = #5E5E5B   // 보조 텍스트 (회색)
textTertiary    = #3F493F   // 세번째 계층 텍스트
textPlaceholder = #6F7A71   // 플레이스홀더

// Background
backgroundPrimary = #F9F9F3 // 페이지 배경 (따뜻한 아이보리)
backgroundCard    = #F3F4ED // 카드 배경

// Semantic
error           = #BC1A1A   // 에러, 로그아웃
borderDivider   = #E1E2DC   // 구분선 (연한 베이지)
borderDefault   = #BFC9C0   // 입력 필드 테두리
```

> **위험도 신호등 색상** (디자인 시스템 문서 기준):
> - Safe: `#52b788` / Caution: `#f4a261` / Danger: `#e07a5f` / Emergency: `#e63946`

---

### 7-2. 타이포그래피 (`GOFTypography`)

| 토큰 | 크기 | 굵기 | 사용 |
|---|---|---|---|
| `largeTitle` | 24pt | Bold | 화면 제목, 헤더 |
| `title` | 20pt | Bold | 섹션 제목 |
| `subtitle` | 17pt | Bold | 카드 제목, 그룹 헤더 |
| `subtitleMedium` | 17pt | Medium | 부제목 |
| `body` | 15pt | Regular | 본문 텍스트 |
| `bodyMedium` | 15pt | Medium | 강조 본문 |
| `caption` | 13pt | Regular | 메타 정보, 타임스탬프 |
| `captionBold` | 13pt | Bold | 금액 강조, 배지 |
| `button` | 17pt | Medium | 버튼 라벨 |
| `buttonSmall` | 13pt | Medium | 보조 버튼 |
| `icon` | 16pt | Semibold | 아이콘 |

---

### 7-3. 스페이싱 (`GOFSpacing`)

| 토큰 | 값 | 사용 |
|---|---|---|
| `xs` | 8pt | 작은 간격, 아이콘-텍스트 |
| `sm` | 12pt | 소형 컴포넌트 내부 |
| `md` | 16pt | 기본 패딩 |
| `lg` | 20pt | 섹션 패딩, 수평 여백 |
| `xl` | 24pt | 카드 내부 패딩 |
| `xxl` | 32pt | 섹션 간격 |
| `heightHeader` | 64pt | 헤더 높이 |
| `heightMedium` | 52pt | 버튼 높이 |
| `radiusLarge` | 12pt | 카드, 배너 |
| `radiusFull` | 999pt | 버튼 (pill), 원형 |

---

### 7-4. 공용 컴포넌트

| 컴포넌트 | 설명 |
|---|---|
| `GOFHeader` | 뒤로가기 + 제목 헤더 |
| `GOFStepIndicator` | "2/5 단계" 텍스트 |
| `GOFSectionTitle` | 섹션 제목 (필수 * 표시 옵션) |
| `GOFTextField` | 단일 라인 입력 (suffix 옵션) |
| `GOFTextEditor` | 멀티라인 입력 (글자수 표시 옵션) |
| `GOFInfoBanner` | 아이콘 + 제목 + 설명 배너 |
| `GOFCard` | 카드 컨테이너 |
| `GOFSuccessIcon` | 체크마크 성공 아이콘 |
| `GOFLoadingOverlay` | 로딩 오버레이 |

### 7-5. 버튼 스타일 (`DesignSystemGOFButtonStyles`)

```swift
// 사용법
Button("피해 신고 시작하기") { }
    .gofPrimaryButton()      // 녹색 풀 알약 — 주요 CTA

Button("나중에") { }
    .gofSecondaryButton()    // 흰색 + 녹색 테두리

Button("로그아웃") { }
    .gofDestructiveButton()  // 에러 빨강
```

---

## 8. 네트워크 레이어

### APIClient (`Core/Network/APIClient.swift`)

```swift
@MainActor
final class APIClient: @unchecked Sendable {
    static let shared = APIClient()

    private let baseURL = "https://give-on.railway.app"  // 환경변수로 관리
    private let session = URLSession.shared
    private let timeout: TimeInterval = 15

    func get<T: Codable>(_ path: String) async throws -> T { ... }
    func post<T: Codable, B: Encodable>(_ path: String, body: B) async throws -> T { ... }
    func patch<T: Codable, B: Encodable>(_ path: String, body: B) async throws -> T { ... }
}
```

### 에러 처리

```swift
enum APIError: LocalizedError {
    case networkError(Error)
    case serverError(Int, String?)   // HTTP status + message
    case decodingError(Error)
    case unauthorized
}
```

### Endpoints (`Core/Network/Endpoints.swift`)

```swift
enum Endpoints {
    static let farms = "/api/v1/farms"
    static func farmRisk(_ id: String) -> String { "/api/v1/farms/\(id)/risk" }
    static func farmAlerts(_ id: String) -> String { "/api/v1/farms/\(id)/alerts" }
    static func fcmToken(_ id: String) -> String { "/api/v1/farms/\(id)/fcm-token" }
    static func damageReport(_ id: String) -> String { "/api/v1/farms/\(id)/damage" }
    static let campaigns = "/api/v1/donations/farms"
}
```

---

## 9. 푸시 알림 (FCM)

### 설정 흐름

```
앱 실행
    │
    ▼
NotificationManager.requestPermission()
    │
    ▼
UNUserNotificationCenter.requestAuthorization()
    │
    ├─ 허용 → UIApplication.registerForRemoteNotifications()
    │              │
    │              ▼
    │         FCM 토큰 발급 (messaging(_:didReceiveRegistrationToken:))
    │              │
    │              ▼
    │         APIClient.updateFCMToken(token)
    │         POST /api/v1/farms/{farm_id}/fcm-token
    │
    └─ 거부 → 알림 없이 앱 계속 사용 가능
```

### 포그라운드 알림

```swift
// 앱 실행 중에도 배너 표시
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .badge]
}
```

### 알림 payload 구조

```json
{
  "notification": {
    "title": "⚠️ 위험 단계 경보",
    "body": "현재 34°C입니다. 환풍기를 즉시 최대로 가동하세요."
  },
  "data": {
    "risk_level": "danger",
    "farm_id": "abc123",
    "alert_id": "xyz789"
  }
}
```

### 알림 탭 처리

- `risk_level` in `["danger", "emergency"]` → 홈 탭 이동 + 위험도 갱신
- 기타 → 경보 이력 탭 이동

---

## 10. 데이터 모델

### FarmRiskResponse

```swift
struct FarmRiskResponse: Codable {
    let farmId: String
    let riskLevel: String          // "safe" | "caution" | "danger" | "emergency"
    let currentWeather: WeatherData
    let forecast: ForecastData
    let alertMessage: String?
    let checklist: [ChecklistItem]
}

struct WeatherData: Codable {
    let temperature: Double
    let humidity: Double
    let measuredAt: String
}

struct ForecastData: Codable {
    let tomorrowMax: Double
    let heatwaveAlert: Bool
}

struct ChecklistItem: Codable, Identifiable {
    let id: Int
    let item: String
    var completed: Bool
}
```

### RiskLevel (Domain Enum)

```swift
enum RiskLevel: String, Comparable {
    case safe = "safe"
    case caution = "caution"
    case danger = "danger"
    case emergency = "emergency"

    var displayName: String {
        switch self {
        case .safe:      return "안전"
        case .caution:   return "주의"
        case .danger:    return "위험"
        case .emergency: return "긴급"
        }
    }

    var signalColor: Color {
        switch self {
        case .safe:      return Color(hex: "#52b788")
        case .caution:   return Color(hex: "#f4a261")
        case .danger:    return Color(hex: "#e07a5f")
        case .emergency: return Color(hex: "#e63946")
        }
    }

    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        let order: [RiskLevel] = [.safe, .caution, .danger, .emergency]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
```

### DamageReport (신고 요청)

```swift
struct DamageReportRequest: Encodable {
    let deadCount: Int
    let cause: String              // "heatwave" | "cold_wave" | "storm"
    let estimatedLoss: Int?
    let farmerNote: String?
    let photoUrls: [String]
}

struct DamageReportResponse: Codable {
    let reportId: String
    let storyTitle: String         // Claude API 생성
    let storyContent: String
    let needs: [String]
    let isPublished: Bool
}
```

### Campaign (캠페인 목록)

```swift
struct Campaign: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let currentAmount: Int
    let goalAmount: Int
    let participantCount: Int
    let riskLevel: String
    let region: String
    let livestockType: String
}
```

### UserDefaultsManager

```swift
// 저장 키
enum Key: String, CaseIterable {
    case farmId         = "farm_id"
    case fcmToken       = "fcm_token"
    case isRegistered   = "isRegistered"
    case notifyEnabled  = "notify_enabled"
    case weatherAlert   = "weather_alert_enabled"
}
```

---

## 11. API 연동 명세

| 화면 | HTTP | 엔드포인트 | 용도 |
|---|---|---|---|
| 온보딩 완료 | POST | `/api/v1/farms` | 농장 신규 등록 |
| 홈 위험도 | GET | `/api/v1/farms/{id}/risk` | 현재 위험도 + 날씨 |
| 경보 이력 | GET | `/api/v1/farms/{id}/alerts` | 경보 발송 이력 |
| 체크리스트 완료 | POST | `/api/v1/farms/{id}/checklist` | 체크 완료 저장 |
| 피해 신고 제출 | POST | `/api/v1/farms/{id}/damage` | 피해 신고 + 스토리 생성 |
| FCM 토큰 갱신 | POST | `/api/v1/farms/{id}/fcm-token` | 토큰 등록/갱신 |
| 캠페인 목록 | GET | `/api/v1/donations/farms` | 기부 가능 캠페인 |

### 응답 예시 — 위험도 조회

```json
{
  "farm_id": "abc123",
  "risk_level": "danger",
  "current_weather": {
    "temperature": 34.2,
    "humidity": 71,
    "measured_at": "2026-07-15T14:30:00+09:00"
  },
  "forecast": {
    "tomorrow_max": 37.0,
    "heatwave_alert": true
  },
  "alert_message": "현재 34.2°C로 닭 위험 수준입니다. 즉시 환풍기를 최대로 가동하고 음수 온도를 20°C 이하로 유지해 주세요.",
  "checklist": [
    { "id": 1, "item": "환풍기 최대 가동 확인", "completed": false },
    { "id": 2, "item": "음수 온도 20°C 이하 유지", "completed": false },
    { "id": 3, "item": "차광막 설치 상태 점검", "completed": false }
  ]
}
```

---

## 12. 개발 체크리스트

### 인프라

- [ ] Firebase 프로젝트 생성 + `GoogleService-Info.plist` 추가
- [ ] APNs 키 업로드 (Apple Developer → Keys)
- [ ] `project.yml` 최종 정리 (소스 경로, 디자인 시스템 경로 통합)
- [ ] 환경별 baseURL 분리 (DEBUG / RELEASE)

### 온보딩

- [ ] 음성 입력 → STT 연동 (SFSpeechRecognizer)
- [ ] 농장 등록 완료 → UserDefaults 저장 + 탭뷰 전환
- [ ] 위치 등록: 지도 피커 (MapKit)

### 홈 — 위험도

- [ ] `FarmStatusViewModel` 구현 (API 호출, 상태 관리)
- [ ] `RiskLevel` enum + 신호등 UI 컴포넌트 완성
- [ ] 위험 단계별 배경색·애니메이션 적용
- [ ] 날씨 데이터 API 연동
- [ ] 체크리스트 완료 → 백엔드 저장
- [ ] 30초 폴링 또는 앱 foreground 복귀 시 자동 갱신

### 피해 신고

- [ ] 5단계 플로우 네비게이션 구현
- [ ] `PHPickerViewController` 사진 선택
- [ ] Supabase Storage 사진 업로드
- [ ] AI 스토리 생성 API 연동 (로딩 상태 처리)
- [ ] 신고 완료 후 캠페인 탭 자동 갱신

### 푸시 알림

- [ ] `NotificationManager` 권한 요청 플로우
- [ ] FCM 토큰 → 백엔드 등록
- [ ] 포그라운드 알림 배너 표시
- [ ] 알림 탭 → 화면 이동 딥링크

### 설정

- [ ] 알림 토글 — `UserDefaults` 동기화
- [ ] 로그아웃 → `isRegistered = false` → 온보딩 화면

### 품질

- [ ] Swift 6 concurrency 경고 없음 (`@MainActor`, `@unchecked Sendable`)
- [ ] 다크 모드 (선택 사항 — 디자인 시스템이 Light 기준)
- [ ] Dynamic Type 대응 (접근성)
- [ ] TestFlight 내부 배포

---

*이 문서는 `docs/architecture/overview.md` 섹션 3 및 `docs/design/give_on_design.md` 디자인 시스템을 iOS 개발 관점에서 구체화한 문서입니다.*  
*버전: 1.0 | 작성: 2026-05-10*
