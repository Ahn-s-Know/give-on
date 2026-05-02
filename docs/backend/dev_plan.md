# Give On 백엔드 개발 계획서

> 최종 수정: 2026-04-26  
> 대상: `packages/backend` (Python FastAPI)  
> 담당: macOS 개발자 (A)

---

## 목차

1. [아키텍처 개요](#1-아키텍처-개요)
2. [디렉터리 구조](#2-디렉터리-구조)
3. [데이터베이스 설계](#3-데이터베이스-설계)
4. [핵심 모듈 설계](#4-핵심-모듈-설계)
5. [API 엔드포인트 명세](#5-api-엔드포인트-명세)
6. [AI Agent 흐름](#6-ai-agent-흐름)
7. [스케줄러 설계](#7-스케줄러-설계)
8. [알림 발송 설계](#8-알림-발송-설계)
9. [개발 단계 계획](#9-개발-단계-계획)
10. [에러 처리 전략](#10-에러-처리-전략)
11. [로컬 개발 환경](#11-로컬-개발-환경)

---

## 1. 아키텍처 개요

### 전체 시스템 구성

```
                  ┌─────────────────────────────────────────────────┐
                  │                클라이언트                        │
                  │                                                 │
                  │  [Give On Farm - iOS]  [Give On - Web]          │
                  │   FCM 푸시 수신          기부 · 지도 열람         │
                  └────────────────────────┬────────────────────────┘
                                           │ REST API (JSON)
                                           ▼
                  ┌─────────────────────────────────────────────────┐
                  │              Python FastAPI 서버                 │
                  │                                                 │
                  │  ┌──────────────┐    ┌──────────────────────┐  │
                  │  │  APScheduler │    │     AI Agent Core    │  │
                  │  │  30분 주기   │───▶│  risk_engine.py      │  │
                  │  │  매일 07:00  │    │  claude_agent.py     │  │
                  │  └──────────────┘    └──────────────────────┘  │
                  │                               │                 │
                  │  ┌───────────────────────────▼──────────────┐  │
                  │  │              알림 발송 모듈                │  │
                  │  │   FCM (농가 앱)  ·  카카오 알림톡          │  │
                  │  └──────────────────────────────────────────┘  │
                  └──────────────────────┬──────────────────────────┘
                                         │
               ┌─────────────────────────┼──────────────────────────┐
               ▼                         ▼                          ▼
      [SQLite → PostgreSQL]     [기상청 Open API]            [Claude API]
       farms, alerts              단기예보·특보               claude-haiku-4-5
       weather_logs               농업기상 관측               경보 메시지 생성
       donations, rewards
```

### 서비스 제공 방식

| 방식 | 설명 | 구현 모듈 |
|---|---|---|
| **폴링 수집** | 30분마다 기상청 API 호출 → DB 저장 | `scheduler.py` + `kma_client.py` |
| **룰 기반 판단** | 기온·습도 임계값으로 위험도 계산 | `risk_engine.py` |
| **AI 메시지 생성** | Claude API로 맞춤 경보 문구 작성 | `claude_agent.py` |
| **푸시 알림** | FCM으로 농가 앱에 즉시 전송 | `fcm.py` |
| **REST API** | 웹/앱 클라이언트에 데이터 제공 | `api/` 라우터 |

---

## 2. 디렉터리 구조

```
packages/backend/
├── app/
│   ├── main.py                    # FastAPI 앱 진입점, lifespan 설정
│   ├── config.py                  # pydantic-settings 환경변수 관리
│   ├── database.py                # SQLAlchemy async 연결 (Lazy Loading)
│   │
│   ├── api/                       # REST API 라우터
│   │   ├── __init__.py
│   │   ├── farms.py               # GET /farms, POST /farms, GET /farms/{id}
│   │   ├── alerts.py              # GET /alerts, GET /alerts/{farm_id}
│   │   ├── donations.py           # POST /donations, GET /donations
│   │   ├── rewards.py             # GET /rewards/{user_id}
│   │   └── admin.py               # 관리자 전용 (통계, 수동 경보)
│   │
│   ├── agent/                     # AI Agent 핵심
│   │   ├── __init__.py
│   │   ├── risk_engine.py         # 룰 기반 위험도 판단 (TDD)
│   │   ├── claude_agent.py        # Claude API 연동 (haiku)
│   │   └── alert_generator.py    # 경보 생성 오케스트레이터
│   │
│   ├── data/                      # 공공데이터 수집
│   │   ├── __init__.py
│   │   ├── kma_client.py          # 기상청 API (단기예보·특보)
│   │   ├── rda_client.py          # 농촌진흥청 농업기상 (Phase 2)
│   │   └── scheduler.py           # APScheduler 스케줄 정의
│   │
│   ├── models/                    # SQLAlchemy ORM 모델
│   │   ├── __init__.py
│   │   ├── farm.py                # 농가 정보
│   │   ├── weather.py             # 기상 수집 로그
│   │   ├── alert.py               # 경보 발송 로그
│   │   ├── donation.py            # 기부 내역
│   │   └── reward.py              # 리워드 지급 내역
│   │
│   ├── schemas/                   # Pydantic 요청·응답 스키마
│   │   ├── __init__.py
│   │   ├── farm.py
│   │   ├── alert.py
│   │   ├── donation.py
│   │   └── reward.py
│   │
│   └── notifications/             # 알림 발송
│       ├── __init__.py
│       ├── fcm.py                 # Firebase Cloud Messaging
│       └── kakao_alimtalk.py      # 카카오 알림톡 (고령 농가 대비)
│
├── scripts/
│   └── seed_dummy_data.py         # 로컬 더미 데이터 생성
│
├── tests/
│   ├── test_risk_engine.py        # 위험도 엔진 단위 테스트
│   ├── test_kma_client.py         # 기상청 클라이언트 테스트
│   └── test_alert_generator.py   # 경보 생성 통합 테스트
│
├── requirements.txt
├── .env.example
├── setup.sh / setup.bat / setup.py
└── README.md
```

---

## 3. 데이터베이스 설계

### 개발 vs 프로덕션

| 환경 | 엔진 | 드라이버 | 설정 |
|---|---|---|---|
| **로컬 개발** | SQLite | aiosqlite | `sqlite+aiosqlite:///./giveon_dev.db` |
| **프로덕션** | PostgreSQL | asyncpg | `postgresql+asyncpg://...` |

전환 방법: `.env`의 `DATABASE_URL`만 변경, 코드 수정 없음.

---

### 테이블 설계

#### `farms` — 농가 정보

```sql
CREATE TABLE farms (
    id              INTEGER     PRIMARY KEY,
    name            TEXT        NOT NULL,          -- 농장명
    owner_name      TEXT        NOT NULL,          -- 농가주 이름
    livestock_type  TEXT        NOT NULL,          -- chicken | pig | cattle | duck
    livestock_count INTEGER     NOT NULL,          -- 두수
    location        TEXT        NOT NULL,          -- 주소
    latitude        REAL,                          -- 위도 (WGS84)
    longitude       REAL,                          -- 경도 (WGS84)
    phone_number    TEXT,
    device_tokens   TEXT,                          -- FCM 토큰 (JSON 배열)
    is_active       BOOLEAN     DEFAULT TRUE,
    created_at      DATETIME    DEFAULT now(),
    updated_at      DATETIME    DEFAULT now()
);
```

#### `weather_logs` — 기상 수집 로그

```sql
CREATE TABLE weather_logs (
    id                  INTEGER  PRIMARY KEY,
    latitude            REAL     NOT NULL,
    longitude           REAL     NOT NULL,
    temperature         REAL     NOT NULL,   -- °C
    humidity            REAL     NOT NULL,   -- %
    wind_speed          REAL,               -- m/s
    precipitation       REAL,               -- mm
    weather_condition   TEXT,               -- clear | cloudy | rainy | snowy
    forecast_max_temp   REAL,               -- 내일 최고기온
    forecast_min_temp   REAL,               -- 내일 최저기온
    collected_at        DATETIME DEFAULT now()
);
```

#### `alerts` — 경보 발송 로그

```sql
CREATE TABLE alerts (
    id           INTEGER  PRIMARY KEY,
    farm_id      INTEGER  NOT NULL REFERENCES farms(id),
    risk_level   TEXT     NOT NULL,  -- safe | caution | danger | emergency
    temperature  INTEGER,
    humidity     INTEGER,
    message      TEXT     NOT NULL,  -- AI 생성 경보 메시지 (150자 이내)
    is_sent      BOOLEAN  DEFAULT FALSE,
    created_at   DATETIME DEFAULT now()
);
```

#### `donations` — 기부 내역

```sql
CREATE TABLE donations (
    id            INTEGER  PRIMARY KEY,
    farm_id       INTEGER  REFERENCES farms(id),
    donor_name    TEXT,
    amount        INTEGER  NOT NULL,         -- 기부금액 (원)
    message       TEXT,                     -- 응원 메시지
    payment_key   TEXT,                     -- 결제 키 (카카오페이)
    status        TEXT     DEFAULT 'pending', -- pending | completed | failed
    created_at    DATETIME DEFAULT now()
);
```

#### `rewards` — 리워드 지급 내역

```sql
CREATE TABLE rewards (
    id            INTEGER  PRIMARY KEY,
    donation_id   INTEGER  REFERENCES donations(id),
    points        INTEGER  NOT NULL,    -- 지급 포인트 (기부금액 × 5%)
    tax_deduct    INTEGER  NOT NULL,    -- 세액공제 금액 (기부금액 × 15%)
    status        TEXT     DEFAULT 'pending',
    created_at    DATETIME DEFAULT now()
);
```

---

## 4. 핵심 모듈 설계

### 4-1. `app/agent/risk_engine.py` — 위험도 판단 엔진

**설계 원칙**: AI 불필요 — 축산 전문 임계값 룰로 처리, TDD로 개발

```python
# 축종별 위험도 임계값
THRESHOLDS = {
    "chicken": {          # 육계·산란계 (고온에 가장 취약)
        "caution":   {"temp": 30.0},
        "danger":    {"temp": 33.0},
        "emergency": {"temp": 36.0},
    },
    "pig": {              # 돼지 (온도+습도 복합 고려)
        "caution":   {"temp": 28.0, "humidity": 65.0},
        "danger":    {"temp": 30.0, "humidity": 70.0},
        "emergency": {"temp": 33.0},
    },
    "cattle": {           # 한우·젖소 (동절기 한파 기준)
        "caution":   {"temp": -5.0},
        "danger":    {"temp": -10.0},
        "emergency": {"temp": -15.0},
    },
    "duck": {             # 오리
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
    Returns: "safe" | "caution" | "danger" | "emergency"
    """
```

**테스트 케이스** (`tests/test_risk_engine.py`):

| 입력 | 기대 출력 |
|---|---|
| `chicken`, 25°C | `safe` |
| `chicken`, 30°C | `caution` |
| `chicken`, 34°C | `danger` |
| `chicken`, 37°C | `emergency` |
| `pig`, 29°C, 66% | `caution` (온도+습도 복합) |
| `cattle`, -12°C | `danger` |

---

### 4-2. `app/agent/claude_agent.py` — AI 경보 메시지 생성

**설계 원칙**: 비용 최소화 (claude-haiku-4-5 사용), 위험 단계 이상만 호출

```python
import anthropic

async def generate_alert_message(
    farm_info: dict,      # 농장명, 축종, 두수, 위치
    weather_data: dict,   # 현재 기온, 습도, 내일 예보
    risk_level: str       # caution | danger | emergency
) -> str:
    """
    150자 이내 맞춤 경보 메시지 생성
    - caution: 주의 안내
    - danger: 즉각 조치 요청
    - emergency: 긴급 대피·방어 지시
    """
```

**프롬프트 전략**:
- System: 축산 농가 경보 전문가 역할
- User: 농가 정보 + 기상 정보 + 위험 단계
- 응답 제한: 150자 이내, 불필요한 설명 금지
- 비용 절감: `danger` 이상만 Claude API 호출 (`caution`은 템플릿 문구)

**비용 추산**:

| 단계 | 처리 방식 | 예상 비용 |
|---|---|---|
| `safe` | 호출 없음 | $0 |
| `caution` | 고정 템플릿 | $0 |
| `danger` | Claude haiku | ~$0.002/회 |
| `emergency` | Claude haiku | ~$0.002/회 |

---

### 4-3. `app/data/kma_client.py` — 기상청 API 클라이언트 (완료)

| 기능 | 구현 상태 |
|---|---|
| WGS84 → 기상청 격자 좌표 변환 | ✅ 완료 |
| 초단기실황 API 호출 | ✅ 완료 |
| API 키 없을 때 더미 데이터 폴백 | ✅ 완료 |
| 오류 처리 및 로깅 | ✅ 완료 |
| 기상청 특보 연동 | ⏳ 진행 예정 |

---

## 5. API 엔드포인트 명세

모든 API의 prefix: `/api/v1`

### 농가 (Farms)

| Method | 경로 | 설명 | 인증 |
|---|---|---|---|
| `GET` | `/farms` | 전체 농가 목록 (지도용) | 불필요 |
| `GET` | `/farms/{id}` | 농가 상세 정보 | 불필요 |
| `POST` | `/farms` | 농가 등록 (앱 온보딩) | 불필요 |
| `PATCH` | `/farms/{id}` | 농가 정보 수정 | 농가 본인 |
| `POST` | `/farms/{id}/token` | FCM 토큰 등록·갱신 | 농가 본인 |

**`GET /farms` 응답 예시**:
```json
{
  "farms": [
    {
      "id": 1,
      "name": "행복한 닭농장",
      "livestock_type": "chicken",
      "livestock_count": 5000,
      "latitude": 35.9042,
      "longitude": 129.2002,
      "current_risk": "danger",
      "last_alert_at": "2026-04-26T14:30:00"
    }
  ]
}
```

---

### 경보 (Alerts)

| Method | 경로 | 설명 |
|---|---|---|
| `GET` | `/alerts` | 최신 경보 목록 (위험 단계 필터 가능) |
| `GET` | `/alerts/{farm_id}` | 특정 농가 경보 이력 |
| `POST` | `/alerts/manual` | 수동 경보 발송 (관리자 전용) |

---

### 기부 (Donations)

| Method | 경로 | 설명 |
|---|---|---|
| `POST` | `/donations` | 기부 생성 (카카오페이 결제 연동) |
| `GET` | `/donations` | 기부 내역 목록 |
| `GET` | `/donations/{id}` | 기부 상세 |
| `POST` | `/donations/{id}/complete` | 결제 완료 콜백 |

**`POST /donations` 요청 예시**:
```json
{
  "farm_id": 1,
  "donor_name": "홍길동",
  "amount": 10000,
  "message": "힘내세요!"
}
```

**`POST /donations` 응답 예시**:
```json
{
  "donation_id": 42,
  "amount": 10000,
  "tax_deduct": 1500,
  "points": 500,
  "payment_url": "https://online.kakaobank.com/..."
}
```

---

### 리워드 (Rewards)

| Method | 경로 | 설명 |
|---|---|---|
| `GET` | `/rewards/{donor_id}` | 내 리워드 현황 |

---

### 관리자 (Admin)

| Method | 경로 | 설명 |
|---|---|---|
| `GET` | `/admin/stats` | 전체 통계 (농가 수, 기부 총액) |
| `GET` | `/admin/weather` | 현재 전국 기상 현황 |
| `POST` | `/admin/alerts/bulk` | 특정 지역 일괄 경보 발송 |

---

## 6. AI Agent 흐름

```
┌─────────────────────────────────────────────────────────────────┐
│                     30분 주기 자동 실행                           │
│                                                                 │
│  1. 기상청 API 호출                                               │
│     kma_client.get_weather(lat, lon)                            │
│     ↓                                                           │
│  2. 위험도 계산 (룰 기반)                                          │
│     risk_engine.calculate_risk_level(type, temp, humidity)      │
│     → "safe" | "caution" | "danger" | "emergency"               │
│     ↓                                                           │
│  3. 경보 발송 판단                                                 │
│     if risk_level in ["danger", "emergency"]:                   │
│       ↓                                                         │
│  4. Claude API 호출 (danger 이상만)                               │
│     claude_agent.generate_alert_message(farm, weather, risk)    │
│     → "닭 5,000마리 긴급! 오늘 최고 36도 예상..."                   │
│     ↓                                                           │
│  5. FCM 푸시 알림 발송                                             │
│     fcm.send_push(farm.device_tokens, message)                  │
│     ↓                                                           │
│  6. DB 저장 (경보 로그)                                            │
│     alerts 테이블에 저장                                           │
└─────────────────────────────────────────────────────────────────┘
```

### 위험도별 처리 규칙

| 위험도 | Claude 호출 | FCM 발송 | 빈도 |
|---|---|---|---|
| `safe` | ❌ | ❌ | - |
| `caution` | ❌ (템플릿) | ✅ (1일 1회 최대) | 하루 최대 1번 |
| `danger` | ✅ | ✅ | 30분마다 최대 1번 |
| `emergency` | ✅ | ✅ 즉시 | 제한 없음 |

---

## 7. 스케줄러 설계

`app/data/scheduler.py` — APScheduler 기반

```python
# 스케줄 목록

# 1. 30분마다: 기상 수집 + 위험도 판단 + 경보 발송
@scheduler.scheduled_job("interval", minutes=30)
async def collect_weather_and_alert():
    farms = await get_all_active_farms()
    for farm in farms:
        weather = await kma_client.get_weather(farm.latitude, farm.longitude)
        risk = calculate_risk_level(farm.livestock_type, weather.temperature, weather.humidity)
        if risk in ["danger", "emergency"]:
            message = await generate_alert_message(farm, weather, risk)
            await send_fcm_push(farm.device_tokens, message)
            await save_alert_log(farm.id, risk, message)

# 2. 매일 오전 7시: 오늘 날씨 요약 + 위험 예보 선발송
@scheduler.scheduled_job("cron", hour=7, minute=0)
async def send_daily_morning_report():
    # 오늘 최고기온 예보 기반, danger 예상 농가에 선제 경보
    ...

# 3. 매일 자정: 기상 로그 정리 (30일 이상 삭제)
@scheduler.scheduled_job("cron", hour=0, minute=0)
async def cleanup_old_logs():
    ...
```

---

## 8. 알림 발송 설계

### FCM 푸시 알림 (농가 iOS 앱)

**발송 흐름**:
```
FastAPI → Firebase Admin SDK → FCM → iOS 앱
```

**페이로드 구조**:
```json
{
  "notification": {
    "title": "⚠️ 위험 경보",
    "body": "오늘 최고 33도 예상. 닭 5,000마리 긴급 환기 필요."
  },
  "data": {
    "farm_id": "1",
    "risk_level": "danger",
    "alert_id": "42"
  }
}
```

**구현 위치**: `app/notifications/fcm.py`

---

### 카카오 알림톡 (고령 농가 보조)

> 스마트폰을 사용하지 않는 고령 농가를 위해 문자 기반 알림톡 병행

**발송 흐름**:
```
FastAPI → Kakao Bizm API → 카카오 알림톡 → SMS
```

**발송 조건**: `danger` 이상 + 앱 미설치 농가  
**구현 위치**: `app/notifications/kakao_alimtalk.py` (Phase 2)

---

## 9. 개발 단계 계획

### Step 1 — FastAPI 기초 ✅ 완료

| 작업 | 상태 |
|---|---|
| FastAPI 앱 초기 설정 (main.py, config.py) | ✅ |
| SQLAlchemy async + SQLite 연결 | ✅ |
| ORM 모델 (Farm, WeatherLog, Alert) | ✅ |
| 더미 데이터 생성 스크립트 | ✅ |
| 원클릭 시작 스크립트 (setup.sh) | ✅ |

---

### Step 2 — 기상청 API 클라이언트 ✅ 완료

| 작업 | 상태 |
|---|---|
| WGS84 → 격자 좌표 변환 | ✅ |
| 초단기실황 API 호출 (`getUltraSrtNcst`) | ✅ |
| API 키 없을 때 더미 데이터 폴백 | ✅ |
| 단위 테스트 7개 | ✅ |
| **실제 API 키 적용** | ⏳ (별도 신청 필요) |

---

### Step 3 — 위험도 엔진 (TDD)

| 작업 | 예상 시간 | 담당 파일 |
|---|---|---|
| 축종별 임계값 상수 정의 | 30분 | `agent/risk_engine.py` |
| `calculate_risk_level()` 구현 | 1시간 | `agent/risk_engine.py` |
| pytest 단위 테스트 작성 | 1시간 | `tests/test_risk_engine.py` |
| 기상특보 연동 (폭염·한파 자동 상향) | 30분 | `agent/risk_engine.py` |

**완료 기준**: `calculate_risk_level("chicken", 34.0)` → `"danger"` 반환 확인

---

### Step 4 — Claude API 연동

| 작업 | 예상 시간 | 담당 파일 |
|---|---|---|
| `generate_alert_message()` 구현 | 1시간 | `agent/claude_agent.py` |
| 프롬프트 튜닝 (150자 이내, 맞춤형) | 30분 | `agent/claude_agent.py` |
| `caution` 템플릿 메시지 정의 | 30분 | `agent/alert_generator.py` |
| 비용 최적화 (haiku 모델, 캐싱) | 30분 | `agent/claude_agent.py` |

**완료 기준**: Claude 호출 → 150자 이내 한국어 경보 메시지 생성 확인

---

### Step 5 — APScheduler + 전체 흐름 통합

| 작업 | 예상 시간 | 담당 파일 |
|---|---|---|
| 30분 주기 기상 수집 스케줄 | 30분 | `data/scheduler.py` |
| 매일 07:00 일일 리포트 스케줄 | 30분 | `data/scheduler.py` |
| 기상 수집 → 위험도 → 경보 전체 흐름 통합 | 1시간 | `agent/alert_generator.py` |
| FCM 발송 연동 | 1시간 | `notifications/fcm.py` |

**완료 기준**: 서버 실행 → 30분 후 자동 기상 수집 + 경보 로그 DB 저장 확인

---

### Step 6 — REST API 라우터

| 작업 | 예상 시간 | 담당 파일 |
|---|---|---|
| Pydantic 요청·응답 스키마 정의 | 1시간 | `schemas/` |
| 농가 API (`/farms`) | 1시간 | `api/farms.py` |
| 경보 API (`/alerts`) | 30분 | `api/alerts.py` |
| 기부 API (`/donations`) | 1시간 | `api/donations.py` |
| 카카오 역지오코딩 연동 | 30분 | `api/farms.py` |

**완료 기준**: `/docs` Swagger UI에서 모든 엔드포인트 직접 테스트 통과

---

## 10. 에러 처리 전략

### 외부 API 오류

| 상황 | 처리 방식 |
|---|---|
| 기상청 API 타임아웃 | 마지막 정상 수집 데이터 재사용, 경고 로그 |
| 기상청 API 할당량 초과 | 다음 수집 주기까지 스킵, 관리자 알림 |
| Claude API 오류 | 사전 정의 템플릿 메시지로 폴백 |
| FCM 발송 실패 | 3회 재시도 후 DB 실패 기록 |

### HTTP 에러 응답 형식

```json
{
  "error": "FARM_NOT_FOUND",
  "message": "해당 농가를 찾을 수 없습니다.",
  "status_code": 404
}
```

---

## 11. 로컬 개발 환경

### 빠른 시작

```bash
cd packages/backend
bash setup.sh
```

자동으로 다음 처리:
1. Python 가상환경 생성 (`.venv`)
2. 패키지 설치 (`requirements.txt`)
3. SQLite DB 생성 + 더미 데이터 주입
4. FastAPI 서버 시작 (`:8000`)

### API 문서 확인

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

### 테스트 실행

```bash
source .venv/bin/activate

# 전체 테스트
pytest tests/ -v

# 특정 모듈만
pytest tests/test_risk_engine.py -v
pytest tests/test_kma_client.py -v
```

### 더미 데이터 재생성

```bash
# DB 초기화 후 재생성
rm giveon_dev.db
python -m scripts.seed_dummy_data
```

---

## 📎 참고 문서

- [데이터 소스 정의서](./data_sources.md)
- [전체 개발 계획](../drafts/give-on_dev_plan.md)
- [서비스 제안서](../drafts/give-on_proposal.md)
- [개발 일정](../drafts/give-on_schedule.md)
- [백엔드 README](../../packages/backend/README.md)
