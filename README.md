# Give On — 기후 위기 속 축산 농가를 지키는 기부 플랫폼

기후 위기로부터 축산 농가를 보호하고, 피해 농가를 시민과 연결하는 통합 플랫폼입니다.

---

## 📋 프로젝트 구성

### 시스템 아키텍처

```
[Give On Farm iOS]       [Give On Web]            [Give On Admin PWA]
(농가 앱)               (기부 웹)               (관리자 대시보드)
      │                       │                        │
      └───────────────────────┼────────────────────────┘
                              │ REST API
                              ▼
                    [FastAPI Backend]
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
          [기상청 API]    [Supabase DB]    [Redis]
```

### 디렉터리 구조

```
give-on/
├── apps/
│   ├── server/                  # FastAPI 백엔드
│   │   ├── app/
│   │   │   ├── api/             # 라우터 (v1)
│   │   │   ├── services/        # 비즈니스 로직
│   │   │   ├── repositories/    # DB 접근
│   │   │   ├── agent/           # 위험도 판단, 메시지 생성
│   │   │   ├── scheduler/       # APScheduler
│   │   │   ├── integrations/    # 외부 API 클라이언트
│   │   │   └── models/          # ORM + 스키마
│   │   ├── tests/
│   │   └── requirements.txt
│   │
│   ├── web/                     # Next.js (기부 웹 + 관리자 PWA)
│   │   └── src/
│   │       ├── app/
│   │       │   ├── (give)/      # 시민 기부 Route Group
│   │       │   └── (admin)/     # 관리자 Route Group
│   │       └── components/
│   │
│   └── ios/                     # SwiftUI iOS 농가 앱
│       └── GiveOnFarm/
│           ├── Core/
│           ├── Features/
│           └── DesignSystem/
│
├── docs/
│   ├── adr/                     # Architecture Decision Records
│   ├── api/                     # API 명세, 데이터소스
│   └── architecture/            # 아키텍처, 백엔드 설계
│
└── .github/
    └── workflows/               # CI/CD (Railway, Vercel)
```

---

## 🚀 빠른 시작

### 백엔드

```bash
cd apps/server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp ../../.env.example .env
uvicorn app.main:app --reload --port 8000
```

### 웹

```bash
cd apps/web
npm install
npm run dev
# http://localhost:3000
```

### iOS 앱

```bash
cd apps/ios/GiveOnFarm
open GiveOnFarm.xcodeproj
```

---

## 🛠 기술 스택

| 레이어 | 기술 |
|---|---|
| **iOS App** | Swift 6, SwiftUI, FCM |
| **Web** | Next.js 15, Tailwind CSS, shadcn/ui |
| **Backend** | Python 3.12, FastAPI, APScheduler |
| **Database** | PostgreSQL (Supabase) |
| **Cache** | Redis |
| **Deployment** | Railway (server), Vercel (web) |

---

## 📚 문서

| 문서 | 설명 |
|---|---|
| [architecture/overview.md](./docs/architecture/overview.md) | 전체 기술 설계 및 API 명세 |
| [architecture/backend.md](./docs/architecture/backend.md) | 백엔드 아키텍처 상세 |
| [api/data-sources.md](./docs/api/data-sources.md) | 공공데이터 API 명세 |

---

## 🤝 협업 규칙

### 브랜치 전략

```
main → dev → feature/작업내용
```

### 커밋 메시지

```
feat: 새로운 기능
fix: 버그 수정
docs: 문서 수정
refactor: 리팩토링
test: 테스트
```
