# Give On Frontend Style Guide

## 기본 원칙

- 제품은 `밝고 정돈된 한국형 모바일 서비스` 감각을 유지한다.
- 색상은 중립 배경 위에 제한된 포인트 컬러만 사용한다.
- 공통 primitive를 우선 사용하고, 앱 안에서 임의 스타일 복제를 금지한다.

## 코드 스타일

### 컴포넌트

- Server Component를 기본값으로 사용한다.
- 상호작용이 필요한 경우에만 `"use client"`를 추가한다.
- 파일 하나에 한 역할만 둔다.

### 네이밍

- route는 도메인 기준으로 나눈다.
- shared component는 `packages/ui`에 둔다.
- 앱 전용 조합 컴포넌트는 각 앱의 `components/`에 둔다.

### 상태

- Query cache를 Zustand에 복제하지 않는다.
- 폼 상태를 Zustand에 넣지 않는다.
- 테이블 정렬/선택 상태는 화면 로컬 상태로 유지한다.

### 스타일

- 색상/spacing/radius/shadow는 토큰에서만 가져온다.
- 임의 hex 값을 JSX에 직접 작성하지 않는다.
- 버튼, 입력, 카드의 변형은 primitive variant로 흡수한다.

## 디자인 시스템 우선순위

1. `@give-on/theme` 토큰
2. `@give-on/ui` primitive
3. 앱 전용 조합 컴포넌트
4. route 단위 화면

## 폼 규칙

- 검증 스키마는 `packages/schemas`에 먼저 작성한다.
- RHF와 zod resolver를 기본 조합으로 사용한다.
- 에러 메시지는 한국어로 통일한다.

## 테이블 규칙

- 관리 화면 테이블은 `TanStack Table + @give-on/ui` 조합으로 구현한다.
- 컬럼 정의와 row type은 분리한다.
- row action은 셀 렌더러 밖으로 빼고 테스트 가능하게 유지한다.

## 문서 유지 규칙

- 새 공통 컴포넌트를 추가하면 문서와 export를 함께 갱신한다.
- 토큰 변경 시 `packages/theme/tokens.css`와 디자인 문서를 같이 수정한다.
- AI가 생성한 코드도 사람이 만든 코드와 같은 기준으로 lint/test/typecheck를 통과해야 한다.

