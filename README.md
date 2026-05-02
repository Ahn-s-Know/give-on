# Give On — 기후 위기 속 축산 농가를 지키는 기부 플랫폼

기후 위기로부터 축산 농가를 보호하고, 피해 농가를 시민과 연결하는 통합 플랫폼입니다.

**프로젝트 기간:** 2026년 4월 24일 ~ 5월 18일 (4주 MVP 개발)  
**팀 구성:** macOS/iOS 개발자 1명 + 프론트엔드 개발자 1명  
**공모전:** 2026 기후부 AX(AI Transformation) 아이디어 경진대회

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
                    (Python + Claude AI)
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
          [기상청 API]  [Claude API]    [Supabase DB]
```

### 디렉터리 구조

```
give-on/
├── packages/
│   ├── backend/                 # FastAPI 백엔드 (macOS 개발자)
│   │   ├── app/
│   │   │   ├── main.py
│   │   │   ├── config.py
│   │   │   ├── database.py
│   │   │   ├── api/             # 라우터
│   │   │   ├── agent/           # AI Agent (위험도 판단, Claude 연동)
│   │   │   ├── data/            # 공공데이터 클라이언트
│   │   │   ├── models/          # SQLAlchemy ORM
│   │   │   ├── schemas/         # Pydantic 스키마
│   │   │   └── notifications/   # FCM, 알림톡
│   │   ├── tests/
│   │   ├── migrations/          # DB 마이그레이션
│   │   ├── requirements.txt
│   │   ├── .env.example
│   │   └── Dockerfile
│   │
│   ├── ios/                     # SwiftUI iOS 앱 (macOS 개발자)
│   │   ├── GiveOnFarm/
│   │   │   ├── Core/            # 네트워크, 알림, 저장소
│   │   │   ├── Features/        # 온보딩, 홈, 경보, 설정
│   │   │   ├── DesignSystem/    # 컬러, 타이포그래피, 컴포넌트
│   │   │   └── Resources/       # 에셋, plist
│   │   └── GiveOnFarm.xcodeproj
│   │
│   └── web/                     # Next.js 웹 (프론트엔드 개발자)
│       ├── app/                 # App Router
│       │   ├── layout.tsx
│       │   ├── page.tsx         # 메인 랜딩
│       │   ├── donate/          # 기부 플로우
│       │   ├── admin/           # 관리자 PWA
│       │   └── map/             # 피해 현황 지도
│       ├── components/          # UI 컴포넌트
│       ├── lib/                 # API 클라이언트, 유틸
│       ├── types/               # TypeScript 타입
│       ├── public/              # 정적 파일 및 PWA manifest
│       ├── package.json
│       └── next.config.ts
│
├── docs/
│   ├── drafts/                  # 기획 문서
│   ├── architecture/            # 아키텍처 다이어그램
│   ├── api/                     # API 명세
│   └── deployment/              # 배포 가이드
│
├── .github/
│   └── workflows/               # CI/CD 파이프라인
│
├── infra/
│   ├── docker/                  # Docker Compose
│   └── terraform/               # IaC (선택)
│
├── .gitignore
├── .env.example
├── README.md
├── CLAUDE.md                    # Claude 협업 가이드
└── package.json                 # 모노레포 관리
```

---

## 🚀 빠른 시작

### 백엔드 시작
```bash
cd packages/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload --port 8000
```

### 웹 개발 시작
```bash
cd packages/web
npm install
npm run dev
# http://localhost:3000
```

### iOS 앱 개발 시작
```bash
cd packages/ios/GiveOnFarm
open GiveOnFarm.xcodeproj
```

---

## 📅 개발 일정

| Phase | 기간 | 목표 |
|---|---|---|
| **Phase 0** | 4/24-4/27 | 개발 환경 세팅, API 키 발급 |
| **Phase 1** | 4/27-5/4 | 핵심 기능 개발 |
| **Phase 2** | 5/6-5/10 | 통합 테스트 및 E2E 검증 |
| **Phase 3** | 5/11-5/18 | 제출 서류 및 최종 마무리 |

자세한 일정은 [docs/drafts/give-on_schedule.md](./docs/drafts/give-on_schedule.md) 참고

---

## 🛠 기술 스택

| 레이어 | 기술 | 담당자 |
|---|---|---|
| **Frontend (Web)** | Next.js 15, Tailwind CSS | 프론트엔드 개발자 |
| **iOS App** | Swift 6, SwiftUI, FCM | macOS 개발자 |
| **Backend** | Python FastAPI, Claude API | macOS 개발자 |
| **Database** | PostgreSQL (Supabase) | 공통 |
| **Deployment** | Railway, Vercel | 공통 |

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
```

### 데일리 싱크업
- **시간:** 매일 22:00 (퇴근 후)
- **채널:** Slack/카카오톡
- **내용:** 진행 상황 / 블로커 공유

---

## 📚 주요 문서

| 문서 | 설명 |
|---|---|
| [give-on_schedule.md](./docs/drafts/give-on_schedule.md) | 상세 개발 일정 |
| [give-on_dev_plan.md](./docs/drafts/give-on_dev_plan.md) | 기술 설계 |
| [give-on_proposal.md](./docs/drafts/give-on_proposal.md) | 공모전 제안서 |
| [CLAUDE.md](./CLAUDE.md) | Claude Code 가이드 |

---

**마지막 업데이트:** 2026-04-26  
**공모전 제출 마감:** 2026-05-18
