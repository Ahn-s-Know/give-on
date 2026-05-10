# Storybook 운영 가이드

## 목적

Give On의 Storybook은 앱 전체를 복제하는 도구가 아니라, `공통 디자인 시스템`을 관리하는 카탈로그입니다.
우선순위는 아래와 같습니다.

1. `packages/ui`의 primitive 문서화
2. 사용자/관리자 공통 shell 문서화
3. 토큰 변화가 실제 컴포넌트에 어떻게 반영되는지 빠르게 확인

## 운영 원칙

- Storybook에는 `packages/ui`의 스토리만 등록합니다.
- `apps/*` 내부의 Next.js 라우팅 의존 컴포넌트는 직접 연결하지 않습니다.
- 사용자/관리자 헤더, 푸터, 사이드바, 탑바는 `packages/ui`의 shell 컴포넌트로 끌어올린 뒤 스토리로 관리합니다.
- 앱에서는 이 shell을 얇은 wrapper로 감싸 현재 라우트와 링크만 주입합니다.

## 왜 이렇게 구성했는가

- Next.js App Router 의존 컴포넌트를 그대로 Storybook에 태우면 설정이 빠르게 복잡해집니다.
- 디자인 시스템은 라우팅보다 시각 규칙이 중요하므로, 앱 의존을 걷어낸 shell 형태가 유지보수에 유리합니다.
- 이 구조면 Figma 톤 수정이 `packages/ui`에서 한 번에 반영됩니다.

## 현재 범위

- `Button`, `Badge`, `Card`, `Input`
- `MarketingHeaderShell`, `MarketingFooterShell`
- `AdminSidebarShell`, `AdminTopbarShell`

## 추후 확장 추천

- `CampaignCard`
- `DonationPanel`
- `StatCard`
- `FilterChipGroup`
- `EmptyState`
- `Skeleton`

## 실행

```bash
pnpm storybook
pnpm build-storybook
```
