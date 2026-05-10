"use client";

import { usePathname } from "next/navigation";

import { AdminSidebarShell } from "@give-on/ui";

const items = [
  {
    href: "/dashboard",
    label: "대시보드",
    description: "위험 농가와 승인 대기 상태를 빠르게 확인합니다."
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
];

export function AdminSidebar() {
  const pathname = usePathname();

  return (
    <AdminSidebarShell
      subtitle="운영용 웹앱 · 승인과 배송 중심"
      summaryTitle="오늘 운영 포인트"
      summaryBody="긴급 캠페인과 배송 지연 건을 먼저 확인하면 운영 리듬이 훨씬 안정적입니다."
      items={items.map((item) => ({
        ...item,
        active: pathname?.startsWith(item.href)
      }))}
      footerTitle="배포 분리 구조"
      footerBody="관리자 앱은 사용자 앱과 독립 배포되지만, 공통 UI와 토큰은 같은 디자인 시스템으로 관리합니다."
    />
  );
}
