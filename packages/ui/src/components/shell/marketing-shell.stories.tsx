import type { Meta, StoryObj } from "@storybook/react-vite";

import { MarketingFooterShell, MarketingHeaderShell } from "./marketing-shell";

const meta = {
  title: "Shell/Marketing",
  parameters: {
    layout: "fullscreen"
  }
} satisfies Meta;

export default meta;

type Story = StoryObj<typeof meta>;

export const Header: Story = {
  render: () => (
    <MarketingHeaderShell
      campaignLabel="기후 재난 대응 기부"
      navItems={[
        { href: "/", label: "홈", active: true },
        { href: "/impact", label: "임팩트" },
        { href: "/notifications", label: "알림" }
      ]}
      actionLabel="내 기부 보기"
      actionHref="/impact"
    />
  )
};

export const Footer: Story = {
  render: () => (
    <MarketingFooterShell
      description="기후 재난과 농가를 시민의 행동으로 연결하는 모바일 우선 기부 플랫폼입니다."
      impactLabel="지금까지 0.9톤의 CO₂ 절감과 327건의 농가 지원이 이어졌어요."
      columns={[
        {
          title: "서비스",
          items: ["진행 중인 캠페인", "임팩트 리포트", "알림 센터"]
        },
        {
          title: "농가 파트너",
          items: ["농가 등록", "피해 제보", "못난이 작물 등록"]
        },
        {
          title: "지원",
          items: ["운영팀 문의", "이용 가이드", "개인정보 처리방침"]
        }
      ]}
    />
  )
};
