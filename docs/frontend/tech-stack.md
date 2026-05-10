# Give On Frontend Platform

## 목적

이 문서는 Give On의 사용자 웹과 관리자 웹을 위한 프론트엔드 플랫폼 기준 문서다. 앱을 새로 만들거나 AI 에이전트가 코드를 생성할 때도 이 문서를 먼저 참고해 구조와 스택 일관성을 유지한다.

## 플랫폼 목표

- 사용자 웹과 관리자 웹을 독립 배포한다.
- 공통 디자인 시스템과 타입, API 계약은 재사용한다.
- 서버리스 환경에 맞는 Next.js 15 App Router 구조를 사용한다.
- AI가 생성한 코드도 테스트 가능한 형태로 강제한다.

## 기준 스택

### 앱 런타임

- `Next.js 15 App Router`
- `React 19`
- `TypeScript strict`

### 스타일링

- `Tailwind CSS`
- `shadcn/ui`
- `@give-on/theme` 토큰 패키지

### 데이터와 인증

- `Supabase Auth`
- `Supabase Postgres`
- `Supabase Storage`

### 상태 관리

- 서버 상태: `TanStack Query v5`
- 클라이언트 UI 상태: `Zustand`

### 폼과 검증

- `React Hook Form`
- `zod`
- `@hookform/resolvers`

### Mock / Test

- `MSW`
- `Vitest`
- `@testing-library/react`
- `Playwright`

### 관리자 UI

- `TanStack Table`

## 모노레포 구조

```text
apps/
  user-web/
  admin-web/
packages/
  ui/
  theme/
  api/
  schemas/
  mocks/
  store/
  forms/
  config/
```

## 책임 분리

- `apps/user-web`: 시민 대상 서비스 UI와 route
- `apps/admin-web`: 운영자 대상 대시보드와 route
- `packages/ui`: 공통 UI primitive와 조합 컴포넌트
- `packages/theme`: 색상, 타이포, radius, shadow, spacing 토큰
- `packages/api`: Supabase client와 공통 fetch 로직
- `packages/schemas`: zod 스키마와 공통 타입
- `packages/mocks`: 개발/테스트용 mock handler와 fixture
- `packages/store`: 앱 전역 UI 상태
- `packages/forms`: RHF 래퍼와 공통 form field

## AI First 원칙

- AI가 생성하는 모든 화면은 기존 패키지 구조 안에만 추가한다.
- 새 API 입력/출력은 먼저 `packages/schemas`에 스키마를 추가한다.
- 클라이언트 상태를 만들기 전에 서버 상태인지 UI 상태인지 구분한다.
- 서버 상태는 Query, UI 상태는 Zustand를 기본으로 삼는다.
- mock 없이 UI를 먼저 만들지 않는다. 최소 하나의 fixture와 handler를 함께 만든다.
- 새 기능은 최소 하나의 검증 코드와 함께 머지 가능해야 한다.

## 배포 전략

- `apps/user-web`: Vercel project 1
- `apps/admin-web`: Vercel project 2
- 둘 다 동일한 공통 패키지를 consume한다.
- MFE는 현재 채택하지 않는다. 배포 분리는 멀티 앱 모노레포로 해결한다.

