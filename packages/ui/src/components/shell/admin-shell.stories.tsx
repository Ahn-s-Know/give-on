import type { Meta, StoryObj } from "@storybook/react-vite";

import { AdminSidebarShell, AdminTopbarShell } from "./admin-shell";

const meta = {
  title: "Shell/Admin",
  parameters: {
    layout: "fullscreen"
  }
} satisfies Meta;

export default meta;

type Story = StoryObj<typeof meta>;

export const Sidebar: Story = {
  render: () => (
    <div className="min-h-screen bg-[var(--background)] p-6">
      <AdminSidebarShell
        subtitle="운영용 웹앱 · 승인과 배송 중심"
        summaryTitle="오늘 운영 포인트"
        summaryBody="긴급 캠페인과 배송 지연 건을 먼저 확인하면 운영 리듬이 훨씬 안정적입니다."
        items={[
          {
            href: "/dashboard",
            label: "대시보드",
            description: "위험 농가와 승인 대기 상태를 빠르게 확인합니다.",
            active: true
          },
          {
            href: "/campaigns",
            label: "캠페인",
            description: "Claude 초안과 공개 상태를 검토합니다."
          },
          {
            href: "/deliveries",
            label: "배송 관리",
            description: "기부 후 물류 진행과 지연 이슈를 추적합니다."
          }
        ]}
        footerTitle="배포 분리 구조"
        footerBody="관리자 앱은 사용자 앱과 독립 배포되지만, 공통 UI와 토큰은 같은 디자인 시스템으로 관리합니다."
        className="flex"
      />
    </div>
  )
};

export const Topbar: Story = {
  render: () => (
    <AdminTopbarShell
      title="운영자 콘솔"
      description="위험 농가, 캠페인, 배송 흐름을 하나의 운영 화면에서 관리합니다."
    />
  )
};
