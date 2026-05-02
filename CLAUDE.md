# Claude Code 협업 가이드

Give On 프로젝트에서 Claude Code를 활용하기 위한 실용 가이드입니다.

---

## 🎯 프로젝트 개요

**Give On**는 기후 위기로부터 축산 농가를 보호하는 AI 플랫폼입니다.

- **기간:** 2026-04-24 ~ 2026-05-18 (4주)
- **팀:** macOS 개발자(A) + 프론트엔드 개발자(B)
- **기술:** FastAPI + Next.js + SwiftUI + Claude API + 공공데이터 + Redis

---

## 📦 프로젝트 구조 (모노레포)

```
give-on/
├── apps/
│   ├── server/                          # FastAPI 백엔드
│   │   ├── app/
│   │   │   ├── main.py
│   │   │   ├── config.py                # pydantic-settings
│   │   │   ├── database.py              # Supabase + asyncpg
│   │   │   │
│   │   │   ├── api/                     # [Layer 1] API — 라우팅만
│   │   │   │   ├── v1/
│   │   │   │   │   ├── farms.py
│   │   │   │   │   ├── alerts.py
│   │   │   │   │   ├── donations.py
│   │   │   │   │   └── admin.py
│   │   │   │   └── deps.py              # 공통 의존성 (auth, db session)
│   │   │   │
│   │   │   ├── services/                # [Layer 2] 비즈니스 로직
│   │   │   │   ├── farm_service.py
│   │   │   │   ├── alert_service.py
│   │   │   │   ├── donation_service.py
│   │   │   │   └── risk_service.py
│   │   │   │
│   │   │   ├── repositories/            # [Layer 3] DB 접근
│   │   │   │   ├── farm_repo.py
│   │   │   │   ├── alert_repo.py
│   │   │   │   └── donation_repo.py
│   │   │   │
│   │   │   ├── agent/                   # AI Agent
│   │   │   │   ├── risk_engine.py       # 룰 기반 위험도 판정
│   │   │   │   ├── claude_agent.py      # Claude API
│   │   │   │   └── story_generator.py
│   │   │   │
│   │   │   ├── scheduler/               # 스케줄러
│   │   │   │   ├── jobs.py
│   │   │   │   └── runner.py
│   │   │   │
│   │   │   ├── integrations/            # 외부 API 클라이언트
│   │   │   │   ├── kma_client.py
│   │   │   │   ├── fcm_client.py
│   │   │   │   └── kakao_client.py
│   │   │   │
│   │   │   └── models/                  # SQLAlchemy ORM + Pydantic schemas
│   │   │       ├── farm.py
│   │   │       ├── alert.py
│   │   │       └── donation.py
│   │   │
│   │   ├── tests/
│   │   │   ├── unit/
│   │   │   │   ├── test_risk_engine.py
│   │   │   │   └── test_claude_agent.py
│   │   │   └── integration/
│   │   │       └── test_farm_api.py
│   │   │
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   │
│   ├── web/                             # Next.js (Give + Admin 통합)
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── (give)/              # Route Group — 시민 기부
│   │   │   │   │   ├── page.tsx
│   │   │   │   │   └── [id]/page.tsx
│   │   │   │   ├── (admin)/             # Route Group — 관리자
│   │   │   │   │   ├── layout.tsx       # 관리자 전용 인증 레이아웃
│   │   │   │   │   └── dashboard/
│   │   │   │   └── layout.tsx
│   │   │   │
│   │   │   ├── components/
│   │   │   │   ├── ui/                  # shadcn/ui 기반 공통 컴포넌트
│   │   │   │   ├── give/                # 기부 도메인 컴포넌트
│   │   │   │   └── admin/               # 관리자 도메인 컴포넌트
│   │   │   │
│   │   │   ├── lib/
│   │   │   │   ├── api/                 # API 클라이언트 (fetch wrapper)
│   │   │   │   └── utils/
│   │   │   │
│   │   │   └── types/                   # TypeScript 타입 (openapi 자동생성)
│   │   │
│   │   ├── public/
│   │   │   └── manifest.json            # PWA
│   │   └── next.config.ts
│   │
│   └── ios/                             # SwiftUI iOS 앱
│       └── GiveOnFarm/
│           ├── App/
│           │   ├── GiveOnFarmApp.swift
│           │   └── AppDelegate.swift     # FCM 설정
│           │
│           ├── Core/                     # 앱 전역 인프라
│           │   ├── Network/
│           │   │   ├── APIClient.swift   # URLSession async/await
│           │   │   └── Endpoints.swift
│           │   ├── Push/
│           │   │   └── PushManager.swift # FCM 토큰 관리
│           │   └── Storage/
│           │       └── UserDefaultsManager.swift
│           │
│           ├── Features/                 # 기능별 MVVM 모듈
│           │   ├── Onboarding/
│           │   ├── Home/
│           │   ├── Alert/
│           │   └── DamageReport/
│           │
│           ├── DesignSystem/
│           │   ├── Colors.swift
│           │   ├── Typography.swift
│           │   └── Components/
│           │       ├── RiskLevelBadge.swift
│           │       └── ChecklistRow.swift
│           │
│           └── Resources/
│
├── docs/
│   ├── adr/                             # Architecture Decision Records
│   ├── api/                             # openapi.json + 데이터소스 명세
│   └── architecture/                    # 아키텍처·개발계획·제안서·일정
│
├── .github/
│   └── workflows/
│       ├── server-deploy.yml            # Railway 배포
│       └── web-deploy.yml               # Vercel 배포
│
├── CLAUDE.md
└── README.md
```

---

## 🏗️ 시스템 아키텍처

```
[Give On iOS App]          [Give On Web]         [Give On Admin PWA]
  (농가 앱 · SwiftUI)      (시민 기부 · Next.js)  (관리자 · Next.js)
        │                        │                       │
        └────────────────────────┼───────────────────────┘
                                 │ HTTPS / REST API
                                 ▼
                       ┌─────────────────────┐
                       │   FastAPI Backend    │
                       │  ┌───────────────┐  │
                       │  │  API Layer    │  │
                       │  │  (Routers)    │  │
                       │  └──────┬────────┘  │
                       │  ┌──────▼────────┐  │
                       │  │ Service Layer │  │
                       │  └──────┬────────┘  │
                       │  ┌──────▼────────┐  │
                       │  │   Repository  │  │
                       │  └──────┬────────┘  │
                       │  ┌──────▼────────┐  │
                       │  │  Scheduler    │  │  ← APScheduler (30분 주기)
                       │  │  AI Agent     │  │  ← Claude API
                       │  └───────────────┘  │
                       └──────────┬──────────┘
                                  │
              ┌───────────────────┼───────────────────┐
              ▼                   ▼                   ▼
        [Supabase]          [기상청 API]          [Claude API]
        PostgreSQL          공공데이터             claude-haiku
              │
              ▼
          [Redis]   ← 선택: 위험도 캐시, 중복 알림 방지
```

### 레이어 설명

| 레이어 | 역할 |
|---|---|
| API Layer (Routers) | HTTP 요청 수신, 입력 유효성 검사, 응답 반환 |
| Service Layer | 비즈니스 로직 처리, 트랜잭션 조율 |
| Repository | DB 접근 추상화 (Supabase/PostgreSQL) |
| Scheduler | APScheduler로 30분 주기 기상 데이터 수집 |
| AI Agent | Claude API 호출, 경보 메시지 생성 |

### 외부 의존성

| 서비스 | 용도 |
|---|---|
| Supabase / PostgreSQL | 농가·기상·기부 데이터 영구 저장 |
| 기상청 API (공공데이터) | 동네예보 데이터 30분 주기 수집 |
| Claude API (claude-haiku) | AI 기반 맞춤 경보 메시지 생성 |
| Redis (선택) | 위험도 캐시, 중복 알림 방지 |

---

## 💬 Claude Code 활용 시나리오

### 백엔드 개발 (담당: A)

#### 시나리오 1: 기상청 API 클라이언트 작성

```
프롬프트:
"FastAPI에서 APScheduler로 30분마다 기상청 동네예보 API를 호출하고
결과를 PostgreSQL에 저장하는 비동기 함수를 작성해줘.
pydantic-settings로 환경변수를 로드하고, SQLAlchemy async 사용.
error handling도 포함해주고."

예상 결과:
- apps/server/app/integrations/kma_client.py (기상청 API 클라이언트)
- apps/server/app/scheduler/jobs.py (APScheduler 스케줄 정의)
- 로그 레벨 설정 포함
```

#### 시나리오 2: 위험도 판단 엔진 (룰 기반)

```
프롬프트:
"축종별(chicken, pig, cattle, duck) 온도·습도 임계값을 기반으로
위험도를 판단하는 Python 함수를 TDD 방식으로 작성해줘.
반환값은 'safe', 'caution', 'danger', 'emergency' 중 하나.
테스트 코드도 함께 포함."

예상 결과:
- apps/server/app/agent/risk_engine.py
- apps/server/tests/unit/test_risk_engine.py (pytest)
```

#### 시나리오 3: Claude API 연동 경보 메시지

```
프롬프트:
"Claude API(claude-haiku-4-5)를 사용해서
농가 정보(축종, 두수, 위치)와 현재 기상(온도, 습도, 내일 예보)를
입력받아 150자 이내의 맞춤 경보 메시지를 생성하는 async 함수를 작성해줘.
Anthropic SDK 사용, 오류 처리 포함."

예상 결과:
- apps/server/app/agent/claude_agent.py (Claude API 호출 함수)
- 비용 최적화 (haiku 모델 사용)
- 응답 시간 < 2초 보장
```

### iOS 앱 개발 (담당: A)

#### 시나리오 1: FCM 푸시 알림 설정

```
프롬프트:
"Firebase Cloud Messaging을 SwiftUI 앱에 연동하는 코드를 작성해줘.
요구사항:
- AppDelegate에서 FCM 토큰 등록
- 백엔드 서버로 토큰 전송
- 포그라운드에서도 배너로 알림 표시
- NotificationManager 싱글톤 패턴 사용"

예상 결과:
- apps/ios/GiveOnFarm/Core/Push/PushManager.swift
- apps/ios/GiveOnFarm/App/AppDelegate.swift (FCM 초기화)
```

#### 시나리오 2: 위험도 신호등 UI 컴포넌트

```
프롬프트:
"SwiftUI로 위험도 신호등 컴포넌트를 만들어줘.
enum RiskLevel {
  case safe, caution, danger, emergency
}
- 원형 디자인, 그림자 효과
- 색상: green/yellow/orange/red
- 텍스트: 안전/주의/위험/긴급"

예상 결과:
- apps/ios/GiveOnFarm/DesignSystem/Components/RiskLevelBadge.swift
```

#### 시나리오 3: REST API 네트워크 클라이언트

```
프롬프트:
"URLSession으로 FastAPI 백엔드를 호출하는
generic NetworkClient를 async/await로 작성해줘.
요구사항:
- Codable 응답 모델
- 에러 처리 (네트워크 에러, 서버 에러)
- Authorization 헤더 지원
- 기본 timeout 15초"

예상 결과:
- apps/ios/GiveOnFarm/Core/Network/APIClient.swift
```

### 웹 개발 — 시민 기부 (담당: B)

#### 시나리오 1: 피해 농가 기부 카드 컴포넌트

```
프롬프트:
"Next.js 15에서 피해 농가 정보를 표시하는
FarmCard 컴포넌트를 TypeScript + Tailwind로 작성해줘.
표시할 정보:
- 농가명 / 위치 / 축종 / 폐사 수
- 위험도 배지 (색상: red/orange/yellow/green)
- 기부하기 버튼
모바일 반응형 필수"

예상 결과:
- components/donate/FarmCard.tsx
```

#### 시나리오 2: 카카오맵 피해 현황 지도

```
프롬프트:
"카카오맵 JavaScript SDK를 Next.js에서 사용해서
피해 농가를 위험도별 색상 마커로 표시하는 컴포넌트를
TypeScript로 작성해줘.
- 초기 중심: 전국 중심 (36.5, 127.5)
- 마커 색상: green(안전)/yellow(주의)/orange(위험)/red(긴급)
- 클릭 시 상세 정보 팝업"

예상 결과:
- components/map/DamageMap.tsx
```

#### 시나리오 3: 기부 폼 및 리워드 계산

```
프롬프트:
"Next.js에서 기부 금액을 입력받고
실시간으로 세액공제(15%)와 포인트(5%)를 계산해서
표시하는 DonationForm을 만들어줘.
- 빠른 선택: 5,000원 / 10,000원 / 30,000원 / 50,000원
- 직접 입력도 가능
- 결제 버튼 (카카오페이)
Tailwind CSS로 스타일링"

예상 결과:
- components/donate/DonationForm.tsx
```

### 웹 개발 — Admin PWA (담당: B)

#### 시나리오 1: 농가 관리 대시보드

```
프롬프트:
"Next.js App Router + Tailwind로 관리자용 농가 목록 대시보드를 작성해줘.
요구사항:
- 농가 목록 테이블 (농가명, 축종, 위치, 현재 위험도)
- 위험도 기준 필터 (safe/caution/danger/emergency)
- 행 클릭 시 상세 페이지 이동
- PWA manifest 포함 (standalone 모드)"

예상 결과:
- app/(admin)/farms/page.tsx
- app/(admin)/farms/[id]/page.tsx
- public/manifest.json
```

#### 시나리오 2: 경보 이력 조회

```
프롬프트:
"관리자 페이지에서 발송된 경보 메시지 이력을 조회하는
AlertHistoryTable 컴포넌트를 TypeScript + Tailwind로 작성해줘.
- 날짜·축종·위험도 기준 필터
- 페이지네이션 (20개씩)
- CSV 내보내기 버튼"

예상 결과:
- components/admin/AlertHistoryTable.tsx
```

---

## 🚀 Claude Code 사용 팁

### 1. 명확한 요구사항 제시

❌ **나쁜 예:**
```
"API 클라이언트 코드 작성해줘"
```

✅ **좋은 예:**
```
"FastAPI에서 기상청 API를 호출하는 비동기 함수를 작성해줘.
요구사항:
- httpx 라이브러리 사용
- 환경변수 SETTINGS.KMA_API_KEY 사용
- 동네예보 API (YYYYMMDD, HH00 형식)
- 응답: {temperature, humidity, forecast_data}
- 에러 시 log + None 반환"
```

### 2. 파일 경로 정확히 지정

```
"apps/server/app/integrations/kma_client.py 파일을 생성해줘"
```

### 3. 기술 스택 명시

```
"Python 3.12, FastAPI 0.115, SQLAlchemy 2.0, asyncpg 사용"
"Swift 6, SwiftUI, iOS 17+ 타겟"
"Next.js 15 App Router, Tailwind CSS 4"
```

### 4. 기존 코드 참고 지시

```
"docs/architecture/overview.md의
API 명세를 참고해서 구현해줘"
```

---

## 📋 일반적인 작업 패턴

### Backend 개발 (A)

| 작업 | 예상 시간 | Claude 활용 |
|---|---|---|
| 기상청 API 클라이언트 | 1~2시간 | ⭐⭐⭐⭐⭐ 매우 유용 |
| 위험도 엔진 (TDD) | 1~2시간 | ⭐⭐⭐⭐ 테스트 코드 생성 |
| Claude API 연동 | 1시간 | ⭐⭐⭐⭐⭐ 프롬프트 작성 등 |
| 라우터/엔드포인트 | 30분~1시간 | ⭐⭐⭐⭐ 보일러플레이트 |
| DB 마이그레이션 | 30분 | ⭐⭐⭐ SQL 쿼리 생성 |

### iOS 개발 (A)

| 작업 | 예상 시간 | Claude 활용 |
|---|---|---|
| FCM 설정 | 1시간 | ⭐⭐⭐⭐ 보일러플레이트 |
| SwiftUI 화면 | 1~2시간 | ⭐⭐⭐⭐ 컴포넌트 생성 |
| 네트워크 클라이언트 | 1시간 | ⭐⭐⭐⭐⭐ 매우 유용 |
| 상태 관리 | 1시간 | ⭐⭐⭐⭐ ViewModel 생성 |

### 웹 개발 — 시민 기부 (B)

| 작업 | 예상 시간 | Claude 활용 |
|---|---|---|
| 컴포넌트 (UI) | 30분~1시간 | ⭐⭐⭐⭐⭐ 매우 유용 |
| 카카오맵 연동 | 1시간 | ⭐⭐⭐⭐ 예제 코드 생성 |
| API 클라이언트 (ts) | 30분 | ⭐⭐⭐⭐ 타입 정의 자동화 |

### 웹 개발 — Admin PWA (B)

| 작업 | 예상 시간 | Claude 활용 |
|---|---|---|
| 농가 관리 대시보드 | 1~2시간 | ⭐⭐⭐⭐⭐ 매우 유용 |
| 경보 이력 조회 | 1시간 | ⭐⭐⭐⭐ 테이블·필터 생성 |
| PWA 설정 | 30분 | ⭐⭐⭐ manifest.json, sw.js |
| API 클라이언트 (ts) | 30분 | ⭐⭐⭐⭐ 타입 정의 자동화 |

---

## 🔗 참고 문서 (Claude에 전달 가능)

작업 시작 전에 다음 문서를 Claude와 공유하면 유용합니다:

1. **기술 스택:** docs/architecture/overview.md
   - API 명세 (섹션 8)
   - DB 스키마 (섹션 9)
   - 환경변수 (섹션 10)

2. **개발 일정:** docs/architecture/schedule.md
   - Phase별 마일스톤
   - 일일 작업 내용

3. **제안서:** docs/architecture/proposal.md
   - 서비스 흐름
   - AI Agent 구조
   - 공공데이터 활용 계획

4. **데이터 소스:** docs/api/data-sources.md
   - 기상청 API 명세
   - 공공데이터 포털 키 설정

---

## ✅ 코드 리뷰 체크리스트

Claude와 협업한 코드를 커밋 전에 확인:

- [ ] 에러 처리 (try-except, Optional 타입)
- [ ] 환경변수 사용 (하드코딩 금지)
- [ ] 타입 힌팅 (Python, TypeScript)
- [ ] 필요시 테스트 코드 포함
- [ ] 주석/docstring (비명백한 부분만)
- [ ] 보안 (API 키, 암호 미노출)
- [ ] 성능 (비동기 처리, 캐싱)

---

## 🚨 주의사항

1. **API 키 보호**
   - .env에만 저장, 코드에 하드코딩 금지
   - Claude에 민감한 정보 전달 금지

2. **비용 최적화** (Claude API)
   - claude-haiku-4-5 사용 (저비용)
   - 호출 최소화 (배치 처리)
   - Token 사용량 모니터링

3. **일정 준수**
   - 완벽함보다 완성을 우선
   - MVP 기능만 구현 (Nice to Have 제외)
   - 4주 기한 엄수

---

## 📞 Claude와의 대화 팁

### 효과적인 질문

```
"FastAPI에서 에러 처리를 어떻게 해야 해?"
→ "FastAPI 프로젝트에서 HTTPException을 사용해서
   일관된 에러 응답을 반환하도록 구조를 짜줄 수 있어?
   예시로 404, 400, 500 케이스를 모두 처리하는 엔드포인트 만들어줘"
```

### 코드 개선 요청

```
"이 코드 좋게 만들어줘"
→ "이 함수를 async/await로 리팩토링하고,
   타입 힌팅을 추가해줄 수 있어?
   
def fetch_weather(location):
    response = requests.get(...)
    return response.json()
   
파일: apps/server/app/integrations/kma_client.py"
```

---

## 🎉 결론

Claude Code는 Give On 프로젝트의 **개발 속도를 2배 이상 높일 수 있습니다.**

특히:
- ✅ 보일러플레이트 코드 자동 생성
- ✅ 복잡한 로직 구현 (AI Agent, API 통합)
- ✅ 테스트 코드 작성
- ✅ 문서 생성 및 정리

**핵심:** 명확한 요구사항 + 기술 스택 명시 = 높은 품질의 코드

---

**문서 버전:** 1.2  
**마지막 업데이트:** 2026-05-02