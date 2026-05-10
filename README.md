# Give On — 기후 위기 속 축산 농가를 지키는 기부 플랫폼

기후 위기로부터 축산 농가를 보호하고, 피해 농가를 시민과 연결하는 통합 플랫폼입니다.

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
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                 ▼
          [기상청 API]      [Claude API]     [Supabase]
```

### 디렉터리 구조

```text
give-on/
├── apps/
│   ├── user-web/                # 사용자 웹 (Next.js 15)
│   └── admin-web/               # 관리자 웹 (Next.js 15)
├── packages/
│   ├── backend/                 # FastAPI 백엔드
│   ├── ios/                     # SwiftUI iOS 앱
│   ├── ui/                      # shadcn/ui 기반 공통 UI
│   ├── theme/                   # 디자인 토큰
│   ├── api/                     # Supabase / 공통 fetch 로직
│   ├── schemas/                 # zod 스키마
│   ├── mocks/                   # MSW mock handler / fixture
│   ├── store/                   # zustand store
│   └── forms/                   # RHF 공통 래퍼
├── docs/
│   ├── design/                  # 디자인 시스템 문서
│   ├── frontend/                # 프론트엔드 플랫폼 / 스타일 가이드
│   ├── backend/                 # 백엔드 설계
│   └── drafts/                  # 기획 문서
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
cd packages/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### iOS 앱

```bash
cd packages/ios/GiveOnFarm
open GiveOnFarm.xcodeproj
```

---

## 프론트엔드 기준 문서

| 문서 | 설명 |
|---|---|
| [docs/frontend/tech-stack.md](./docs/frontend/tech-stack.md) | 프론트엔드 기술 스택 기준 |
| [docs/frontend/style-guide.md](./docs/frontend/style-guide.md) | 코드/디자인 스타일 가이드 |
| [docs/frontend/ai-first-testing.md](./docs/frontend/ai-first-testing.md) | AI-first 테스트 전략 |
| [docs/design/give_on_design.md](./docs/design/give_on_design.md) | 디자인 시스템 |

---

## 주요 문서

| 문서 | 설명 |
|---|---|
| [docs/drafts/give-on_schedule.md](./docs/drafts/give-on_schedule.md) | 상세 개발 일정 |
| [docs/drafts/give-on_dev_plan.md](./docs/drafts/give-on_dev_plan.md) | 기술 설계 |
| [docs/drafts/give-on_proposal.md](./docs/drafts/give-on_proposal.md) | 공모전 제안서 |
| [CLAUDE.md](./CLAUDE.md) | 협업 가이드 |
