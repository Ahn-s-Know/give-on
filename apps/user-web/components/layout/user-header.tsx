"use client";

import { usePathname } from "next/navigation";

import { MarketingHeaderShell } from "@give-on/ui";

const items = [
  { href: "/", label: "홈" },
  { href: "/impact", label: "임팩트" },
  { href: "/notifications", label: "알림" }
] as const;

export function UserHeader() {
  const pathname = usePathname();

  return (
    <MarketingHeaderShell
      campaignLabel="기후 재난 대응 기부"
      navItems={items.map((item) => ({
        ...item,
        active: item.href === "/" ? pathname === item.href : pathname?.startsWith(item.href)
      }))}
      actionHref="/impact"
      actionLabel="내 기부 보기"
    />
  );
}
