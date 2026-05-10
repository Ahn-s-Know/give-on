# AI First Testing Guide

## 목표

AI가 생성한 코드도 바로 검증 가능한 구조를 만든다. 테스트는 품질 보증뿐 아니라 AI 코드 생성의 guardrail 역할을 한다.

## 테스트 레이어

### 1. Schema test

- 위치: `packages/schemas`
- 목적: 입력/출력 계약이 깨지지 않는지 확인

### 2. Store test

- 위치: `packages/store`
- 목적: UI 상태 전이 검증

### 3. Mock contract test

- 위치: `packages/mocks`
- 목적: fixture와 handler가 프론트 기대 응답과 일치하는지 확인

### 4. Component test

- 위치: 각 앱 또는 `packages/ui`
- 목적: 사용자 상호작용과 렌더링 검증

### 5. E2E

- 위치: 각 앱
- 목적: 주요 사용자 흐름 검증

## 개발 규칙

- 새 화면은 mock handler 없이 시작하지 않는다.
- 새 폼은 schema + form test 최소 1개를 둔다.
- 새 전역 상태는 store test를 둔다.
- 관리자 테이블은 row selection, sorting, empty state 중 최소 1개를 검증한다.

## AI 작업 체크리스트

- 타입 생성만 하고 런타임 검증을 생략하지 않았는가
- 서버 상태와 클라이언트 상태가 혼합되지 않았는가
- mock fixture가 실제 UI 요구 shape를 반영하는가
- optimistic UI가 있다면 rollback 시나리오가 있는가
- 테스트 이름만 있고 내용이 비어 있지 않은가

## CI 제안

```text
1. pnpm lint
2. pnpm typecheck
3. pnpm test
4. pnpm --filter @give-on/user-web build
5. pnpm --filter @give-on/admin-web build
```

## 검증 우선순위

- 지금 단계 MVP: schema, store, mock contract
- 화면 확장 단계: component test
- 배포 직전: Playwright E2E

