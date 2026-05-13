# Give On — 기후 위기 속 농가를 지키는 기부 플랫폼

기후 위기로부터 농가를 보호하고, 피해 농가를 시민과 연결하는 통합 플랫폼입니다.

**프로젝트 기간:** 2026년 4월 24일 ~ 5월 18일  
**공모전:** 2026 기후부 AX(AI Transformation) 아이디어 경진대회

---

## 프로젝트 구성

### 시스템 아키텍처

```text
[Give On Farm iOS]       [Give On User Web]      [Give On Admin Web]
      │                         │                        │
      └─────────────────────────┼────────────────────────┘
                                │ REST API
                                ▼
                       [FastAPI Backend]
                                │
          ┌─────────────────────┼─────────────────────┬─────────────┐
          ▼                     ▼                     ▼             ▼
      [기상청 API]          [Claude API]         [Supabase]     [Redis]
```

### 디렉터리 구조

```text
give-on/
├── apps/
│   ├── server/                  # FastAPI 백엔드
│   ├── ios/                     # SwiftUI iOS 농가 앱
│   ├── user-web/                # 사용자 웹 (Next.js 15)
│   └── admin-web/               # 관리자 웹 (Next.js 15)
├── packages/
│   ├── ui/                      # shadcn/ui 기반 공통 UI
│   ├── theme/                   # 디자인 토큰
│   ├── api/                     # 공통 fetch / query 로직
│   ├── schemas/                 # zod 스키마
│   ├── mocks/                   # MSW mock handler / fixture
│   ├── store/                   # zustand store
│   ├── forms/                   # RHF 공통 래퍼
│   └── config/                  # 공통 설정
├── docs/
│   ├── adr/                     # Architecture Decision Records
│   ├── api/                     # API 명세, 데이터소스
│   ├── architecture/            # 아키텍처 문서
│   ├── design/                  # 디자인 시스템 문서
│   └── frontend/                # 프론트엔드 플랫폼 가이드
├── .storybook/                  # 디자인 시스템 카탈로그
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
└── tsconfig.base.json
```

---

## 빠른 시작

### 프론트엔드

```bash
pnpm install
pnpm dev:user
# http://localhost:3000

pnpm dev:admin
# http://localhost:3001
```

### 백엔드

```bash
cd apps/server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### iOS 앱

```bash
cd apps/ios
```

---

## 기술 스택

| 레이어 | 기술 |
|---|---|
| iOS App | SwiftUI, FCM |
| User/Admin Web | Next.js 15, Tailwind CSS, shadcn/ui |
| Backend | Python 3.12, FastAPI, APScheduler |
| Database | PostgreSQL (Supabase) |
| Cache | Redis |
| Mock/Test | MSW, Vitest, TanStack Query |
| Deployment | Railway, Vercel |

---

## 프론트엔드 기준 문서

| 문서 | 설명 |
|---|---|
| [docs/frontend/tech-stack.md](./docs/frontend/tech-stack.md) | 프론트엔드 기술 스택 기준 |
| [docs/frontend/style-guide.md](./docs/frontend/style-guide.md) | 코드/디자인 스타일 가이드 |
| [docs/frontend/ai-first-testing.md](./docs/frontend/ai-first-testing.md) | AI-first 테스트 전략 |
| [docs/frontend/storybook.md](./docs/frontend/storybook.md) | Storybook 운영 가이드 |
| [docs/design/give_on_design.md](./docs/design/give_on_design.md) | 디자인 시스템 |

---

## 주요 문서

| 문서 | 설명 |
|---|---|
| [docs/architecture/overview.md](./docs/architecture/overview.md) | 전체 기술 설계 및 API 명세 |
| [docs/architecture/backend.md](./docs/architecture/backend.md) | 백엔드 아키텍처 상세 |
| [docs/api/data-sources.md](./docs/api/data-sources.md) | 공공데이터 API 명세 |
| [CLAUDE.md](./CLAUDE.md) | 협업 가이드 |

---

## 협업 규칙

### 브랜치 전략

```text
main → dev → feature/작업내용
```

### 커밋 메시지

```text
feat: 새로운 기능
fix: 버그 수정
docs: 문서 수정
refactor: 리팩토링
test: 테스트
```
