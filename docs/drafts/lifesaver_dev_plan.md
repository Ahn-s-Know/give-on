# LifeSaver 개발 플랜

> 팀 구성: macOS/iOS 개발자 1 + 프론트엔드 개발자 1  
> 기간: 4주 MVP → 공모전 제출  
> 최종 수정: 2026-04-22

---

## 목차

1. [전체 아키텍처 개요](#1-전체-아키텍처-개요)
2. [백엔드 — Python FastAPI](#2-백엔드--python-fastapi)
3. [농가 iOS 앱 — SwiftUI](#3-농가-ios-앱--swiftui)
4. [시민 웹 — Next.js](#4-시민-웹--nextjs)
5. [관리자 PWA — Next.js (반응형)](#5-관리자-pwa--nextjs-반응형)
6. [공통 인프라](#6-공통-인프라)
7. [개발 일정 (4주)](#7-개발-일정-4주)
8. [API 명세](#8-api-명세)
9. [DB 스키마](#9-db-스키마)
10. [환경 변수 관리](#10-환경-변수-관리)

---

## 1. 전체 아키텍처 개요

### 시스템 구성도

```
┌─────────────────────────────────────────────────────────────┐
│                       클라이언트                             │
│                                                             │
│  [농가 iOS 앱]    [시민 웹]         [관리자 PWA]            │
│  Swift/SwiftUI    Next.js           Next.js (반응형)        │
│  FCM 푸시 수신    기부·결제          지도·대시보드            │
└────────┬──────────────┬──────────────────┬──────────────────┘
         │              │                  │
         └──────────────┴──────────────────┘
                              │ REST API (HTTPS)
                              ↓
         ┌────────────────────────────────────────┐
         │         Python FastAPI 서버             │
         │                                        │
         │  ┌──────────┐   ┌──────────────────┐  │
         │  │ 스케줄러  │   │   AI Agent Core  │  │
         │  │APScheduler│  │  LangChain +     │  │
         │  │30분 주기  │   │  Claude API      │  │
         │  └──────────┘   └──────────────────┘  │
         │                                        │
         │  ┌──────────┐   ┌──────────────────┐  │
         │  │룰 엔진    │   │   알림 발송       │  │
         │  │축종별     │   │   FCM / 알림톡   │  │
         │  │임계값     │   │                  │  │
         │  └──────────┘   └──────────────────┘  │
         └───────────────────────┬────────────────┘
                                 │
              ┌──────────────────┼──────────────────┐
              ↓                  ↓                  ↓
         [PostgreSQL]     [기상청 API]        [Claude API]
         (Supabase)       공공데이터 6종      claude-haiku-4-5
```

### 기술 스택 한눈에

| 레이어 | 기술 | 담당자 |
|---|---|---|
| iOS 앱 | Swift 6, SwiftUI, FCM | macOS 개발자 |
| 웹 공통 | Next.js 15, Tailwind CSS | 프론트엔드 개발자 |
| 백엔드 | Python 3.12, FastAPI | macOS 개발자 |
| AI | Claude API (claude-haiku-4-5), LangChain | macOS 개발자 |
| DB | PostgreSQL (Supabase) | 공통 |
| 인프라 | Railway.app, Vercel | 공통 |

---

## 2. 백엔드 — Python FastAPI

### 2-1. 프로젝트 구조

```
lifesaver-backend/
├── app/
│   ├── main.py                    # FastAPI 앱 진입점
│   ├── config.py                  # 환경변수 로드 (pydantic-settings)
│   ├── database.py                # Supabase/SQLAlchemy 연결
│   │
│   ├── api/                       # REST API 라우터
│   │   ├── __init__.py
│   │   ├── farms.py               # 농가 관련 엔드포인트
│   │   ├── donations.py           # 기부 관련 엔드포인트
│   │   ├── alerts.py              # 경보 조회 엔드포인트
│   │   ├── rewards.py             # 리워드 엔드포인트
│   │   └── admin.py               # 관리자 전용 엔드포인트
│   │
│   ├── agent/                     # AI Agent 핵심
│   │   ├── __init__.py
│   │   ├── risk_engine.py         # 룰 기반 위험도 판단 엔진
│   │   ├── claude_agent.py        # Claude API 연동
│   │   ├── alert_generator.py     # 경보 메시지 생성
│   │   └── story_generator.py     # 피해 스토리 생성 (기부 페이지용)
│   │
│   ├── data/                      # 공공데이터 수집
│   │   ├── __init__.py
│   │   ├── kma_client.py          # 기상청 API 클라이언트
│   │   ├── airkorea_client.py     # 에어코리아 API 클라이언트
│   │   └── scheduler.py           # APScheduler 스케줄 정의
│   │
│   ├── notifications/             # 알림 발송
│   │   ├── __init__.py
│   │   ├── fcm.py                 # Firebase Cloud Messaging
│   │   └── kakao_alimtalk.py      # 카카오 알림톡 (고령 농가 SMS)
│   │
│   ├── models/                    # SQLAlchemy ORM 모델
│   │   ├── __init__.py
│   │   ├── farm.py
│   │   ├── alert.py
│   │   ├── donation.py
│   │   └── reward.py
│   │
│   └── schemas/                   # Pydantic 스키마 (요청/응답)
│       ├── __init__.py
│       ├── farm.py
│       ├── alert.py
│       ├── donation.py
│       └── reward.py
│
├── tests/
│   ├── test_risk_engine.py
│   ├── test_alert_generator.py
│   └── test_kma_client.py
│
├── requirements.txt
├── .env.example
├── Dockerfile
└── README.md
```

### 2-2. 핵심 모듈 상세

#### `agent/risk_engine.py` — 룰 기반 위험도 판단

```python
# 축종별 임계값 (AI 불필요 — 규칙으로 처리)
THRESHOLDS = {
    "chicken": {  # 육계·산란계
        "caution":   {"temp": 30.0},
        "danger":    {"temp": 33.0},
        "emergency": {"temp": 36.0},
    },
    "pig": {      # 돼지
        "caution":   {"temp": 28.0, "humidity": 65.0},
        "danger":    {"temp": 30.0, "humidity": 70.0},
        "emergency": {"temp": 33.0},
    },
    "cattle": {   # 한우·젖소 (동절기 기준)
        "caution":   {"temp": -5.0},
        "danger":    {"temp": -10.0},
        "emergency": {"temp": -15.0},
    },
    "duck": {     # 오리
        "caution":   {"temp": 32.0},
        "danger":    {"temp": 35.0},
        "emergency": {"temp": 38.0},
    },
}

def calculate_risk_level(
    livestock_type: str,
    temperature: float,
    humidity: float | None = None
) -> str:
    """
    returns: "safe" | "caution" | "danger" | "emergency"
    """
    ...
```

#### `agent/claude_agent.py` — Claude API 연동

```python
import anthropic

client = anthropic.Anthropic(api_key=settings.ANTHROPIC_API_KEY)

async def generate_alert_message(
    farm_info: dict,
    weather_data: dict,
    risk_level: str
) -> str:
    """
    위험 단계에 맞는 맞춤 경보 메시지 생성
    농가 축종, 두수, 위치, 현재 기상을 반영
    """
    prompt = f"""
당신은 축산 농가에게 기후 위험 경보를 전달하는 전문 시스템입니다.
아래 정보를 바탕으로 농가에게 보낼 경보 메시지를 작성해주세요.

농장 정보:
- 위치: {farm_info['region']}
- 축종: {farm_info['livestock_type']}
- 사육 규모: {farm_info['count']}두(수)

현재 기상:
- 기온: {weather_data['temperature']}°C
- 습도: {weather_data['humidity']}%
- 내일 최고기온 예측: {weather_data['tomorrow_max']}°C

위험 단계: {risk_level}

요구사항:
- 150자 이내로 작성 (SMS 전송 고려)
- 지금 당장 해야 할 행동 1~2가지 포함
- 공포감이 아닌 구체적 행동 지침 중심
- 경어체 사용
"""
    message = client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=300,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text
```

#### `agent/story_generator.py` — 피해 스토리 생성 (기부 페이지)

```python
async def generate_farm_story(damage_report: dict) -> dict:
    """
    피해 신고 데이터 → 기부 페이지 스토리 자동 생성
    returns: { "title": str, "story": str, "needs": list[str] }
    """
    prompt = f"""
피해 농가의 상황을 바탕으로 기부 페이지에 올릴 스토리를 작성해주세요.

피해 정보:
- 농가 위치: {damage_report['region']}
- 축종: {damage_report['livestock_type']}
- 폐사 두수: {damage_report['dead_count']}
- 피해 원인: {damage_report['cause']}
- 농가 한마디: {damage_report.get('farmer_note', '')}

요구사항:
- 제목: 20자 이내의 공감을 끄는 제목
- 스토리: 200~300자, 사실 기반, 과장 없이
- 필요 물품: 3가지 이내 (냉방팬, 사료, 방역용품 중)
- JSON 형식으로 반환: {{"title": "...", "story": "...", "needs": ["..."]}}
"""
    ...
```

#### `data/kma_client.py` — 기상청 API

```python
import httpx
from app.config import settings

KMA_BASE_URL = "http://apis.data.go.kr/1360000"

async def get_village_forecast(nx: int, ny: int) -> dict:
    """
    기상청 동네예보 조회 (3시간 단위)
    nx, ny: 기상청 격자 좌표 (농가 위치에서 변환)
    """
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{KMA_BASE_URL}/VilageFcstInfoService_2.0/getVilageFcst",
            params={
                "serviceKey": settings.KMA_API_KEY,
                "numOfRows": 100,
                "pageNo": 1,
                "dataType": "JSON",
                "base_date": today_str(),
                "base_time": "0500",
                "nx": nx,
                "ny": ny,
            }
        )
    return parse_forecast(response.json())

async def get_special_weather_report() -> list[dict]:
    """
    기상특보 조회 — 폭염·한파 특보 발령 즉시 긴급 경보 트리거
    """
    ...
```

#### `data/scheduler.py` — 자동화 스케줄러

```python
from apscheduler.schedulers.asyncio import AsyncIOScheduler

scheduler = AsyncIOScheduler()

@scheduler.scheduled_job("interval", minutes=30)
async def collect_weather_and_check_risk():
    """
    30분마다 실행:
    1. 모든 등록 농가의 기상 데이터 수집
    2. 축종별 위험도 판단
    3. 위험 단계 시 Claude API 경보 메시지 생성
    4. FCM 푸시 알림 발송
    """
    farms = await get_all_active_farms()
    for farm in farms:
        weather = await get_village_forecast(farm.nx, farm.ny)
        risk = calculate_risk_level(farm.livestock_type, weather)

        if risk in ["danger", "emergency"]:
            message = await generate_alert_message(farm, weather, risk)
            await send_fcm_push(farm.device_tokens, message)
            await save_alert_log(farm.id, risk, message)

@scheduler.scheduled_job("cron", hour=7, minute=0)
async def send_daily_morning_report():
    """
    매일 오전 7시: 오늘 위험 예보 요약 발송
    """
    ...
```

### 2-3. 의존성 (requirements.txt)

```
fastapi==0.115.0
uvicorn==0.32.0
pydantic==2.9.0
pydantic-settings==2.6.0
sqlalchemy==2.0.36
asyncpg==0.30.0          # PostgreSQL 비동기 드라이버
anthropic==0.40.0        # Claude API
langchain==0.3.7         # Agent 오케스트레이션
langchain-anthropic==0.3.0
httpx==0.28.0            # 비동기 HTTP (기상청 API)
apscheduler==3.10.4      # 스케줄러
firebase-admin==6.6.0    # FCM 푸시
python-dotenv==1.0.1
pytest==8.3.0
pytest-asyncio==0.24.0
```

### 2-4. 로컬 실행

```bash
# 가상환경 생성
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 환경변수 설정
cp .env.example .env
# .env 파일에 API 키 입력

# 개발 서버 실행
uvicorn app.main:app --reload --port 8000

# 스케줄러 포함 실행 (프로덕션)
python -m app.main
```

---

## 3. 농가 iOS 앱 — SwiftUI

### 3-1. 프로젝트 구조

```
LifeSaverFarm/
├── LifeSaverFarmApp.swift         # 앱 진입점, AppDelegate 설정
│
├── Core/
│   ├── Network/
│   │   ├── APIClient.swift        # URLSession 기반 네트워크
│   │   ├── Endpoints.swift        # API 엔드포인트 상수
│   │   └── Models/                # Codable 응답 모델
│   │       ├── FarmResponse.swift
│   │       ├── AlertResponse.swift
│   │       └── WeatherResponse.swift
│   │
│   ├── Notifications/
│   │   ├── NotificationManager.swift  # FCM 토큰 등록·갱신
│   │   └── NotificationDelegate.swift # 포그라운드 알림 처리
│   │
│   └── Storage/
│       └── UserDefaultsManager.swift  # 농가 설정 로컬 저장
│
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift       # 최초 실행: 농장 등록
│   │   └── OnboardingViewModel.swift
│   │
│   ├── Home/
│   │   ├── HomeView.swift             # 메인 위험도 화면
│   │   ├── HomeViewModel.swift
│   │   ├── RiskSignalView.swift       # 신호등 위젯
│   │   └── WeatherSummaryView.swift   # 현재 기상 요약
│   │
│   ├── Alert/
│   │   ├── AlertDetailView.swift      # 경보 상세 + 대응 가이드
│   │   ├── ChecklistView.swift        # 대응 체크리스트
│   │   └── AlertHistoryView.swift     # 경보 이력
│   │
│   ├── DamageReport/
│   │   ├── DamageReportView.swift     # 피해 신고 폼
│   │   └── DamageReportViewModel.swift
│   │
│   └── Settings/
│       ├── SettingsView.swift          # 농장 정보·알림 설정
│       └── FarmSetupView.swift         # 축종·규모 등록
│
├── DesignSystem/
│   ├── Colors.swift                    # 앱 컬러 팔레트
│   ├── Typography.swift
│   └── Components/
│       ├── RiskBadge.swift             # 위험도 배지 컴포넌트
│       ├── ActionButton.swift
│       └── InfoCard.swift
│
└── Resources/
    ├── Assets.xcassets
    ├── GoogleService-Info.plist        # FCM 설정
    └── Info.plist
```

### 3-2. 핵심 화면 설계

#### HomeView — 메인 위험도 화면

```swift
struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 위험도 신호등 (가장 크게)
                RiskSignalView(level: viewModel.riskLevel)
                    .frame(maxWidth: .infinity)
                    .padding()

                // 현재 기상 요약
                WeatherSummaryCard(
                    temperature: viewModel.currentTemp,
                    humidity: viewModel.currentHumidity,
                    forecast: viewModel.tomorrowMax
                )

                // AI 경보 메시지 (있을 때만 표시)
                if let message = viewModel.latestAlertMessage {
                    AlertMessageCard(message: message)
                }

                // 대응 체크리스트
                ChecklistCard(
                    items: viewModel.checklistItems,
                    onToggle: viewModel.toggleChecklistItem
                )

                // 피해 신고 버튼 (위험 단계 이상일 때)
                if viewModel.riskLevel >= .danger {
                    Button("피해 신고하기") {
                        viewModel.showDamageReport = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
        }
        .navigationTitle("내 농장")
        .refreshable { await viewModel.refresh() }
        .sheet(isPresented: $viewModel.showDamageReport) {
            DamageReportView()
        }
    }
}
```

#### RiskSignalView — 신호등 컴포넌트

```swift
enum RiskLevel: Int, Comparable {
    case safe = 0, caution = 1, danger = 2, emergency = 3

    var color: Color {
        switch self {
        case .safe:      return .green
        case .caution:   return .yellow
        case .danger:    return .orange
        case .emergency: return .red
        }
    }

    var label: String {
        switch self {
        case .safe:      return "안전"
        case .caution:   return "주의"
        case .danger:    return "위험"
        case .emergency: return "긴급"
        }
    }

    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct RiskSignalView: View {
    let level: RiskLevel

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(level.color)
                .frame(width: 100, height: 100)
                .shadow(color: level.color.opacity(0.4), radius: 12)

            Text(level.label)
                .font(.title2.bold())
                .foregroundColor(level.color)

            Text("오늘 내 농장 위험도")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
```

#### NotificationManager — FCM 푸시 설정

```swift
import FirebaseMessaging
import UserNotifications

class NotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    // FCM 토큰 갱신 → 백엔드 서버에 등록
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        Task {
            await APIClient.shared.updateFCMToken(token)
        }
    }

    // 포그라운드 알림 처리 (앱 실행 중에도 배너 표시)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }
}
```

### 3-3. 주요 의존성 (Swift Package Manager)

```
dependencies:
  - Firebase iOS SDK (FirebaseMessaging, FirebaseAnalytics)
  - Alamofire 5.x (네트워크, 선택)
```

### 3-4. 개발 체크리스트

- [ ] Xcode 프로젝트 생성 (iOS 17+ 타겟)
- [ ] Firebase 프로젝트 생성 + `GoogleService-Info.plist` 추가
- [ ] FCM 인증서 설정 (APNs 키 업로드)
- [ ] 농장 등록 온보딩 플로우
- [ ] HomeView 위험도 신호등 UI
- [ ] FCM 푸시 수신 + 포그라운드 처리
- [ ] 체크리스트 완료 → 백엔드 이력 저장
- [ ] 피해 신고 폼 + 사진 첨부 (선택)
- [ ] TestFlight 배포 (내부 테스트)

---

## 4. 시민 웹 — Next.js

### 4-1. 프로젝트 구조

```
lifesaver-web/
├── app/                           # Next.js 15 App Router
│   ├── layout.tsx                 # 공통 레이아웃
│   ├── page.tsx                   # 메인 페이지 (기부 랜딩)
│   │
│   ├── donate/
│   │   ├── page.tsx               # 기부 목록 (피해 농가 카드)
│   │   └── [farmId]/
│   │       ├── page.tsx           # 개별 농가 기부 페이지
│   │       └── complete/
│   │           └── page.tsx       # 기부 완료 + 리워드 안내
│   │
│   ├── map/
│   │   └── page.tsx               # 전국 피해 현황 지도
│   │
│   └── my/
│       └── page.tsx               # 내 기부 이력 + 리워드
│
├── components/
│   ├── ui/                        # 공통 UI 컴포넌트
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   └── Badge.tsx
│   │
│   ├── donate/
│   │   ├── FarmCard.tsx           # 피해 농가 카드
│   │   ├── DonationForm.tsx       # 기부 폼 (금액·물품 선택)
│   │   ├── PaymentButton.tsx      # 카카오페이·네이버페이
│   │   └── RewardSummary.tsx      # 세액공제 + 포인트 안내
│   │
│   ├── map/
│   │   └── DamageMap.tsx          # 카카오맵 기반 피해 현황
│   │
│   └── layout/
│       ├── Header.tsx
│       └── Footer.tsx
│
├── lib/
│   ├── api.ts                     # 백엔드 API 클라이언트
│   ├── kakao-pay.ts               # 카카오페이 SDK 연동
│   └── utils.ts
│
├── types/
│   ├── farm.ts
│   └── donation.ts
│
├── public/
│   ├── manifest.json              # PWA용 (관리자 공유)
│   └── icons/
│
└── next.config.ts
```

### 4-2. 핵심 화면 상세

#### 메인 페이지 (`app/page.tsx`)

```
┌─────────────────────────────────────┐
│  LifeSaver                    [로그인]│
├─────────────────────────────────────┤
│                                     │
│  "지금 이 순간,                      │
│   농가가 도움이 필요합니다"            │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔴 긴급  전북 정읍 닭 농장   │    │
│  │ 폐사 2만6천 수 — 오늘 접수  │    │
│  │ [5,000원] [1만원] [직접입력] │    │
│  │          [지금 기부하기]     │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌──────────┐ ┌──────────┐         │
│  │ 경기 안성  │ │ 충남 홍성  │        │
│  │ 주의 단계  │ │ 안전     │         │
│  └──────────┘ └──────────┘         │
│                                     │
│  [전체 현황 지도 보기]               │
│                                     │
│  최근 기부: 서울 강남구 시민 5,000원  │
│  최근 기부: 경기 성남시 시민 1만원    │
└─────────────────────────────────────┘
```

#### 기부 페이지 (`app/donate/[farmId]/page.tsx`)

```typescript
// 서버 컴포넌트 — SEO, OG 태그 자동 생성
export async function generateMetadata({ params }: Props) {
    const farm = await getFarm(params.farmId);
    return {
        title: `${farm.story.title} — LifeSaver`,
        openGraph: {
            title: farm.story.title,
            description: farm.story.story.slice(0, 100),
            // SNS 공유 시 카드 미리보기
        },
    };
}

export default async function FarmDonatePage({ params }: Props) {
    const farm = await getFarm(params.farmId);

    return (
        <div>
            {/* AI가 생성한 스토리 */}
            <FarmStory title={farm.story.title} content={farm.story.story} />

            {/* 필요 물품 선택 */}
            <NeedsSelector items={farm.story.needs} />

            {/* 기부 금액 입력 */}
            <DonationForm farmId={params.farmId} />

            {/* 리워드 미리보기 */}
            <RewardPreview />
        </div>
    );
}
```

#### DonationForm 컴포넌트

```typescript
"use client";

export function DonationForm({ farmId }: { farmId: string }) {
    const [amount, setAmount] = useState(10000);
    const [isProcessing, setIsProcessing] = useState(false);

    const taxDeduction = Math.floor(amount * 0.15);
    const rewardPoints = Math.floor(amount * 0.05);

    const handleKakaoPay = async () => {
        setIsProcessing(true);
        const { redirectUrl } = await initKakaoPayment({ farmId, amount });
        window.location.href = redirectUrl;
    };

    return (
        <div>
            {/* 금액 빠른 선택 */}
            <div className="grid grid-cols-4 gap-2">
                {[5000, 10000, 30000, 50000].map(v => (
                    <button key={v} onClick={() => setAmount(v)}
                        className={amount === v ? "bg-green-600 text-white" : "border"}>
                        {v.toLocaleString()}원
                    </button>
                ))}
            </div>

            {/* 직접 입력 */}
            <input type="number" value={amount}
                onChange={e => setAmount(Number(e.target.value))} />

            {/* 리워드 계산 미리보기 */}
            <div className="bg-gray-50 rounded-lg p-4">
                <p>세액공제: {taxDeduction.toLocaleString()}원 (15%)</p>
                <p>지역화폐 포인트: {rewardPoints.toLocaleString()}P</p>
                <p className="font-bold">
                    실질 부담: {(amount - taxDeduction).toLocaleString()}원
                </p>
            </div>

            {/* 결제 버튼 */}
            <button onClick={handleKakaoPay} disabled={isProcessing}
                className="w-full bg-yellow-400 text-black py-4 rounded-lg font-bold">
                카카오페이로 기부하기
            </button>
        </div>
    );
}
```

### 4-3. 카카오맵 연동 (`components/map/DamageMap.tsx`)

```typescript
"use client";
import { useEffect, useRef } from "react";

export function DamageMap({ farms }: { farms: Farm[] }) {
    const mapRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!mapRef.current || !window.kakao) return;

        const map = new kakao.maps.Map(mapRef.current, {
            center: new kakao.maps.LatLng(36.5, 127.5),
            level: 8,
        });

        farms.forEach(farm => {
            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(farm.lat, farm.lng),
                map,
            });

            // 위험도별 마커 색상
            const color = {
                safe: "#22c55e",
                caution: "#eab308",
                danger: "#f97316",
                emergency: "#ef4444",
            }[farm.riskLevel];

            // 커스텀 오버레이 (위험도 표시)
            new kakao.maps.CustomOverlay({
                position: new kakao.maps.LatLng(farm.lat, farm.lng),
                content: `<div style="background:${color};border-radius:50%;width:20px;height:20px;"></div>`,
                map,
            });
        });
    }, [farms]);

    return <div ref={mapRef} className="w-full h-96 rounded-lg" />;
}
```

### 4-4. 개발 체크리스트

- [ ] Next.js 15 프로젝트 생성 (App Router)
- [ ] Tailwind CSS 설정
- [ ] 메인 랜딩 페이지 UI
- [ ] 피해 농가 카드 컴포넌트
- [ ] 카카오맵 SDK 연동 + 마커 표시
- [ ] 기부 폼 (금액 입력·빠른 선택)
- [ ] 리워드 계산 미리보기
- [ ] 카카오페이 연동 (테스트 모드)
- [ ] 기부 완료 페이지 + SNS 공유 버튼
- [ ] Vercel 배포

---

## 5. 관리자 PWA — Next.js (반응형)

### 5-1. 구조 (시민 웹과 모노레포 또는 별도 디렉토리)

```
lifesaver-admin/          # 또는 lifesaver-web/app/admin/ 하위에 구성
├── app/
│   ├── layout.tsx        # 관리자 전용 레이아웃 (사이드바)
│   ├── page.tsx          # 대시보드 메인
│   │
│   ├── farms/
│   │   ├── page.tsx      # 전국 농가 목록 + 위험도 필터
│   │   └── [id]/
│   │       └── page.tsx  # 농가 상세 (이력·기부 현황)
│   │
│   ├── donations/
│   │   └── page.tsx      # 기부 매칭·배송 현황
│   │
│   └── reports/
│       └── page.tsx      # 주간·월간 통계
│
├── components/
│   ├── DashboardStats.tsx      # 요약 수치 카드
│   ├── RiskFarmList.tsx        # 위험 농가 리스트 (모바일 최적화)
│   ├── AdminMap.tsx            # 전국 위험도 지도
│   └── DonationTracker.tsx    # 기부 배송 현황 트래커
│
└── public/
    ├── manifest.json           # PWA 매니페스트
    └── sw.js                   # 서비스워커 (푸시 알림 수신)
```

### 5-2. PWA 설정

#### `public/manifest.json`

```json
{
    "name": "LifeSaver Admin",
    "short_name": "LS Admin",
    "start_url": "/admin",
    "display": "standalone",
    "background_color": "#ffffff",
    "theme_color": "#16a34a",
    "icons": [
        { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
        { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
    ]
}
```

#### `next.config.ts` — PWA 설정

```typescript
import withPWA from "next-pwa";

const nextConfig = withPWA({
    dest: "public",
    register: true,
    skipWaiting: true,
    disable: process.env.NODE_ENV === "development",
})({
    // 기타 Next.js 설정
});

export default nextConfig;
```

### 5-3. 반응형 대시보드 핵심 화면

#### 모바일 (현장 순회용) 레이아웃

```
┌──────────────────────┐
│  LifeSaver Admin  [≡] │
├──────────────────────┤
│ 오늘 위험 23 / 주의 47│
├──────────────────────┤
│ 🔴 전북 정읍 닭 농가  │
│    위험 | 010-xxxx   │
│    [전화] [상세보기]   │
├──────────────────────┤
│ 🟠 경기 안성 돼지 농가 │
│    위험 | 010-xxxx   │
│    [전화] [상세보기]   │
├──────────────────────┤
│ 🟡 충남 홍성 한우 농가 │
│    주의 | 010-xxxx   │
│    [전화] [상세보기]   │
└──────────────────────┘
```

#### RiskFarmList 컴포넌트 (모바일 최적화)

```typescript
export function RiskFarmList({ farms }: { farms: Farm[] }) {
    return (
        <div className="divide-y">
            {farms
                .sort((a, b) => b.riskLevel - a.riskLevel)
                .map(farm => (
                    <div key={farm.id} className="flex items-center justify-between p-4">
                        <div className="flex items-center gap-3">
                            <RiskDot level={farm.riskLevel} />
                            <div>
                                <p className="font-medium text-sm">{farm.name}</p>
                                <p className="text-xs text-gray-500">
                                    {farm.region} · {farm.livestockType}
                                </p>
                            </div>
                        </div>
                        <div className="flex gap-2">
                            {/* 전화 버튼 — 모바일에서 즉시 발신 */}
                            <a href={`tel:${farm.phone}`}
                                className="bg-green-100 text-green-700 px-3 py-1 rounded-lg text-sm">
                                전화
                            </a>
                            <Link href={`/admin/farms/${farm.id}`}
                                className="border px-3 py-1 rounded-lg text-sm">
                                상세
                            </Link>
                        </div>
                    </div>
                ))}
        </div>
    );
}
```

### 5-4. 개발 체크리스트

- [ ] Next.js 프로젝트에 `/admin` 경로 추가 (또는 별도 프로젝트)
- [ ] `next-pwa` 패키지 설정
- [ ] `manifest.json` 작성
- [ ] 반응형 대시보드 레이아웃 (사이드바 PC / 하단 탭바 모바일)
- [ ] 요약 수치 카드 (위험·주의·기부 현황)
- [ ] 위험 농가 리스트 (전화 버튼 포함)
- [ ] 기부 배송 현황 트래커
- [ ] 카카오맵 관리자 지도 (위험도 히트맵)
- [ ] 주간 통계 차트 (Chart.js 또는 Recharts)
- [ ] PWA 홈 화면 추가 안내 (iOS: Safari → 공유 → 홈 화면에 추가)

---

## 6. 공통 인프라

### 6-1. 데이터베이스 (Supabase PostgreSQL)

Supabase 무료 플랜으로 시작 (500MB, 2GB 대역폭). 공모전 MVP에는 충분합니다.

**주요 테이블 요약** (상세는 [DB 스키마](#9-db-스키마) 참고)

```
farms           — 등록 농가 정보
alerts          — 경보 발송 이력
donations       — 기부 내역
rewards         — 리워드 적립 이력
weather_logs    — 기상 수집 이력 (디버깅용)
```

### 6-2. 배포 구성

```
백엔드 (Python FastAPI)
└── Railway.app
    - 무료 플랜 (월 500시간)
    - GitHub push → 자동 배포
    - 환경변수 Railway 대시보드에서 관리

시민 웹 + 관리자 PWA (Next.js)
└── Vercel
    - 무료 플랜 (취미 프로젝트)
    - GitHub push → 자동 배포
    - 도메인: lifesaver.vercel.app (또는 커스텀 도메인)

DB
└── Supabase (무료 플랜)
    - PostgreSQL 호스팅
    - Supabase SDK로 직접 연결 가능 (RLS 활용)

파일 스토리지 (피해 사진 등)
└── Supabase Storage (무료 1GB)
    또는 Cloudflare R2 (무료 10GB/월)
```

### 6-3. Firebase 설정 (FCM)

```
1. Firebase Console → 새 프로젝트 생성
2. iOS 앱 추가 → GoogleService-Info.plist 다운로드
3. 백엔드 서버 → Firebase Admin SDK 서비스 계정 키 발급
4. APNs 인증 키 업로드 (Apple Developer → Keys)
```

### 6-4. 기상청 API 키 발급

```
1. 공공데이터포털 (data.go.kr) 회원가입
2. "기상청 동네예보 조회서비스" 활용 신청 → 자동 승인
3. "기상청 기상특보 조회서비스" 활용 신청
4. 생성된 서비스 키 → .env에 설정
```

---

## 7. 개발 일정 (4주)

### Week 1 — 기반 구축

| 날짜 | macOS 개발자 | 프론트엔드 개발자 |
|---|---|---|
| Day 1 | FastAPI 프로젝트 세팅, Supabase 연결 | Next.js 프로젝트 세팅, Tailwind 설정 |
| Day 2 | 기상청 API 연동 + 파싱 테스트 | 메인 페이지 UI 레이아웃 |
| Day 3 | APScheduler 기상 수집 자동화 | FarmCard 컴포넌트 |
| Day 4 | 룰 엔진 작성 + 단위 테스트 | 카카오맵 연동 (마커 표시) |
| Day 5 | Claude API 연동 + 경보 메시지 생성 테스트 | 기부 폼 UI |

**Week 1 완료 기준**
- [ ] 기상청 API 데이터가 30분마다 DB에 저장됨
- [ ] 임계값 초과 시 위험도 판단 로직 동작
- [ ] Claude API로 경보 메시지 생성 확인
- [ ] 웹 메인 페이지 기본 UI 완성

### Week 2 — 핵심 기능

| 날짜 | macOS 개발자 | 프론트엔드 개발자 |
|---|---|---|
| Day 1 | FCM 서버 연동 + 푸시 발송 테스트 | 기부 완료 페이지 + SNS 공유 |
| Day 2 | iOS Xcode 프로젝트 생성, FCM 수신 설정 | 카카오페이 연동 (테스트 모드) |
| Day 3 | HomeView SwiftUI UI | 관리자 대시보드 기본 레이아웃 |
| Day 4 | 체크리스트 UI + 완료 이력 저장 API | 위험 농가 리스트 (모바일 반응형) |
| Day 5 | 피해 신고 폼 + 스토리 생성 API | 관리자 지도 + 위험도 마커 |

**Week 2 완료 기준**
- [ ] iOS 앱에서 FCM 푸시 알림 실제 수신
- [ ] 농가 앱 홈 화면 동작 (API 연동)
- [ ] 기부 페이지 → 카카오페이 결제 (테스트) 완료
- [ ] 관리자 대시보드 기본 동작

### Week 3 — 통합 및 완성

| 날짜 | macOS 개발자 | 프론트엔드 개발자 |
|---|---|---|
| Day 1~2 | 알림 발송 전체 플로우 E2E 테스트 | 시민 웹 전체 플로우 테스트 |
| Day 3 | 에러 처리, 엣지 케이스 수정 | PWA 설정 (manifest.json, 서비스워커) |
| Day 4 | SMS 알림톡 보조 연동 (선택) | 관리자 전화 버튼·배송 현황 |
| Day 5 | API 문서화 (FastAPI 자동 생성) | 반응형 전체 검증 |

**Week 3 완료 기준**
- [ ] 기상 위험 감지 → 앱 푸시 알림 전체 흐름 동작
- [ ] 기부 → 완료 → 리워드 표시 전체 흐름
- [ ] 관리자 PWA 홈 화면 추가 동작 확인

### Week 4 — 데모 준비

| 날짜 | 공통 |
|---|---|
| Day 1 | 데모 시나리오 구성 + 테스트 데이터 세팅 |
| Day 2 | 발표 자료 초안 (제안서 기반) |
| Day 3 | 데모 리허설 + 버그 수정 |
| Day 4 | 최종 제출 패키지 준비 |
| Day 5 | 제출 |

---

## 8. API 명세

### 8-1. 농가 관련

```
POST   /api/v1/farms                    농가 신규 등록
GET    /api/v1/farms/{farm_id}          농가 정보 조회
PATCH  /api/v1/farms/{farm_id}          농가 정보 수정
DELETE /api/v1/farms/{farm_id}          농가 삭제

POST   /api/v1/farms/{farm_id}/fcm-token   FCM 토큰 등록/갱신
GET    /api/v1/farms/{farm_id}/risk         현재 위험도 조회
GET    /api/v1/farms/{farm_id}/alerts       경보 이력 조회
POST   /api/v1/farms/{farm_id}/checklist    체크리스트 완료 저장
POST   /api/v1/farms/{farm_id}/damage       피해 신고
```

### 8-2. 기부 관련

```
GET    /api/v1/donations/farms          기부 가능 농가 목록
GET    /api/v1/donations/farms/{id}     특정 농가 상세 (스토리 포함)
POST   /api/v1/donations               기부 생성 (결제 전)
POST   /api/v1/donations/{id}/confirm   결제 완료 확인 (카카오페이 콜백)
GET    /api/v1/donations/my             내 기부 이력 조회
```

### 8-3. 관리자 전용

```
GET    /api/v1/admin/dashboard          대시보드 요약 수치
GET    /api/v1/admin/farms              전국 농가 목록 (위험도 필터)
GET    /api/v1/admin/alerts/today       오늘 발송된 경보 전체
PATCH  /api/v1/admin/donations/{id}     배송 현황 업데이트
GET    /api/v1/admin/reports/weekly     주간 통계 리포트
```

### 8-4. 요청/응답 예시

```json
// GET /api/v1/farms/{farm_id}/risk
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

## 9. DB 스키마

```sql
-- 농가 테이블
CREATE TABLE farms (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            TEXT NOT NULL,
    owner_name      TEXT NOT NULL,
    phone           TEXT NOT NULL,
    region          TEXT NOT NULL,          -- "전북 정읍시 감곡면"
    latitude        DECIMAL(10,7) NOT NULL,
    longitude       DECIMAL(10,7) NOT NULL,
    nx              INTEGER NOT NULL,       -- 기상청 격자 X
    ny              INTEGER NOT NULL,       -- 기상청 격자 Y
    livestock_type  TEXT NOT NULL,          -- chicken|pig|cattle|duck
    livestock_count INTEGER NOT NULL,
    device_tokens   TEXT[],                 -- FCM 토큰 (복수 기기)
    kakao_id        TEXT,                   -- 알림톡 수신용
    subscription    TEXT DEFAULT 'basic',   -- basic|pro
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 경보 이력
CREATE TABLE alerts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    farm_id         UUID REFERENCES farms(id),
    risk_level      TEXT NOT NULL,          -- caution|danger|emergency
    temperature     DECIMAL(5,2),
    humidity        DECIMAL(5,2),
    message         TEXT NOT NULL,          -- Claude API 생성 메시지
    sent_via        TEXT[],                 -- ['fcm', 'sms']
    sent_at         TIMESTAMPTZ DEFAULT NOW()
);

-- 체크리스트 완료 이력
CREATE TABLE checklist_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    farm_id         UUID REFERENCES farms(id),
    alert_id        UUID REFERENCES alerts(id),
    item_id         INTEGER NOT NULL,
    item_text       TEXT NOT NULL,
    completed_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 피해 신고
CREATE TABLE damage_reports (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    farm_id         UUID REFERENCES farms(id),
    dead_count      INTEGER NOT NULL,
    cause           TEXT NOT NULL,          -- heatwave|cold_wave|storm
    estimated_loss  BIGINT,                 -- 원 단위
    farmer_note     TEXT,
    story_title     TEXT,                   -- Claude API 생성
    story_content   TEXT,                   -- Claude API 생성
    needs           TEXT[],                 -- 필요 물품 목록
    is_published    BOOLEAN DEFAULT false,  -- 기부 페이지 공개 여부
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 기부 내역
CREATE TABLE donations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    damage_id       UUID REFERENCES damage_reports(id),
    donor_id        UUID,                   -- 익명 허용 (NULL 가능)
    donor_name      TEXT,
    amount          INTEGER NOT NULL,       -- 원 단위
    payment_method  TEXT,                   -- kakaopay|naverpay|card
    payment_status  TEXT DEFAULT 'pending', -- pending|confirmed|failed
    payment_key     TEXT,                   -- PG사 결제 키
    tax_receipt_issued BOOLEAN DEFAULT false,
    reward_points   INTEGER DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    confirmed_at    TIMESTAMPTZ
);

-- 리워드 이력
CREATE TABLE rewards (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    donation_id     UUID REFERENCES donations(id),
    donor_id        UUID NOT NULL,
    points          INTEGER NOT NULL,
    local_currency  TEXT,                   -- "경기지역화폐"
    status          TEXT DEFAULT 'pending', -- pending|issued|used
    issued_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 기상 수집 로그 (디버깅용)
CREATE TABLE weather_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nx              INTEGER,
    ny              INTEGER,
    temperature     DECIMAL(5,2),
    humidity        DECIMAL(5,2),
    heatwave_alert  BOOLEAN DEFAULT false,
    cold_alert      BOOLEAN DEFAULT false,
    collected_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_farms_active ON farms(is_active) WHERE is_active = true;
CREATE INDEX idx_alerts_farm_id ON alerts(farm_id);
CREATE INDEX idx_alerts_sent_at ON alerts(sent_at DESC);
CREATE INDEX idx_donations_damage_id ON donations(damage_id);
CREATE INDEX idx_damage_published ON damage_reports(is_published) WHERE is_published = true;
```

---

## 10. 환경 변수 관리

### `.env.example` (백엔드)

```bash
# 서버
APP_ENV=development          # development | production
APP_HOST=0.0.0.0
APP_PORT=8000
SECRET_KEY=your-secret-key-here

# 데이터베이스 (Supabase)
DATABASE_URL=postgresql+asyncpg://postgres:password@db.xxx.supabase.co:5432/postgres
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...

# AI (Anthropic Claude)
ANTHROPIC_API_KEY=sk-ant-...

# 공공데이터 API
KMA_API_KEY=...              # 기상청 (data.go.kr에서 발급)
AIRKOREA_API_KEY=...         # 에어코리아

# 알림
FIREBASE_CREDENTIALS_PATH=./firebase-adminsdk.json
KAKAO_ALIMTALK_KEY=...       # 카카오 비즈니스 (선택)

# 결제 (테스트)
KAKAOPAY_CID=TC0ONETIME      # 테스트용 고정값
KAKAOPAY_ADMIN_KEY=...
```

### `.env.local` (Next.js 웹)

```bash
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_KAKAO_MAP_KEY=...    # 카카오 개발자센터에서 발급
NEXT_PUBLIC_KAKAOPAY_PG=kakaopay
```

---

## 부록. Claude Code 활용 가이드

이 프로젝트는 두 명이 개발하므로 Claude Code를 적극 활용합니다.

### 백엔드 개발 시 유용한 프롬프트

```
"FastAPI에서 APScheduler로 30분마다 기상청 API를 호출하고
 결과를 PostgreSQL에 저장하는 비동기 스케줄러를 작성해줘.
 환경변수는 pydantic-settings로 로드하고, SQLAlchemy async 사용"

"닭/돼지/한우 축종별로 온도·습도 기반 위험도를 판단하는
 Python 함수를 TDD 방식으로 테스트 코드와 함께 작성해줘"

"Anthropic Claude API를 사용해서 농가 정보와 기상 데이터를
 입력받아 150자 이내 경보 메시지를 생성하는 async 함수 작성해줘"
```

### iOS 개발 시 유용한 프롬프트

```
"SwiftUI로 RiskLevel enum(safe/caution/danger/emergency)에 따라
 색상이 바뀌는 원형 신호등 컴포넌트를 작성해줘"

"Firebase Cloud Messaging을 SwiftUI 앱에 연동하고
 포그라운드에서도 알림 배너가 표시되도록 설정해줘"

"URLSession으로 FastAPI 백엔드 REST API를 호출하는
 generic NetworkClient를 async/await로 작성해줘"
```

### 웹 개발 시 유용한 프롬프트

```
"Next.js 15 App Router에서 서버 컴포넌트로 피해 농가 목록을
 가져오고 클라이언트 컴포넌트로 기부 폼을 구현해줘"

"카카오맵 JavaScript SDK를 Next.js에 연동하고
 위험도별 색상 마커를 표시하는 컴포넌트를 TypeScript로 작성해줘"

"next-pwa로 Next.js 앱을 PWA로 만들고
 manifest.json과 서비스워커 기본 설정을 해줘"
```

---

*이 문서는 지속적으로 업데이트됩니다. 변경 사항은 PR 코멘트로 기록합니다.*
