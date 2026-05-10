import * as React from "react";

import { cn } from "../../lib/cn";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";

type MarketingNavItem = {
  href: string;
  label: string;
  active?: boolean;
};

type MarketingHeaderShellProps = {
  brandHref?: string;
  brandLabel?: string;
  campaignLabel?: string;
  navItems: MarketingNavItem[];
  actionHref?: string;
  actionLabel?: string;
  className?: string;
};

type MarketingFooterColumn = {
  title: string;
  items: string[];
};

type MarketingFooterShellProps = {
  brandLabel?: string;
  description: string;
  impactLabel?: string;
  columns: MarketingFooterColumn[];
  className?: string;
};

export function MarketingHeaderShell({
  brandHref = "/",
  brandLabel = "Give On",
  campaignLabel,
  navItems,
  actionHref = "/impact",
  actionLabel = "내 기부 보기",
  className
}: MarketingHeaderShellProps) {
  return (
    <header
      className={cn(
        "sticky top-0 z-20 border-b border-[var(--border)] bg-white/88 backdrop-blur supports-[backdrop-filter]:bg-white/72",
        className
      )}
    >
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3 md:px-8">
        <div className="flex min-w-0 items-center gap-3 md:gap-8">
          <a href={brandHref} className="shrink-0 text-lg font-semibold tracking-tight text-[var(--foreground)]">
            {brandLabel}
          </a>
          {campaignLabel ? (
            <Badge variant="neutral" className="hidden md:inline-flex">
              {campaignLabel}
            </Badge>
          ) : null}
          <nav className="hidden items-center gap-2 md:flex">
            {navItems.map((item) => (
              <a
                key={item.href}
                href={item.href}
                aria-current={item.active ? "page" : undefined}
                className={cn(
                  "rounded-full px-3 py-2 text-sm transition",
                  item.active
                    ? "bg-[var(--secondary)] font-medium text-[var(--foreground)]"
                    : "text-[var(--secondary-foreground)] hover:bg-[var(--secondary)] hover:text-[var(--foreground)]"
                )}
              >
                {item.label}
              </a>
            ))}
          </nav>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant="secondary" className="md:hidden">
            모바일 우선
          </Badge>
          <Button asChild size="sm" className="rounded-full">
            <a href={actionHref}>{actionLabel}</a>
          </Button>
        </div>
      </div>
    </header>
  );
}

export function MarketingFooterShell({
  brandLabel = "Give On",
  description,
  impactLabel,
  columns,
  className
}: MarketingFooterShellProps) {
  return (
    <footer
      className={cn(
        "border-t border-[var(--border)] bg-[linear-gradient(180deg,#ffffff_0%,#f7f8fa_100%)]",
        className
      )}
    >
      <div className="mx-auto grid max-w-6xl gap-8 px-4 py-10 md:grid-cols-[1.4fr_1fr_1fr_1fr] md:px-8">
        <div className="space-y-4">
          <div className="space-y-2">
            <p className="text-lg font-semibold tracking-tight text-[var(--foreground)]">
              {brandLabel}
            </p>
            <p className="max-w-sm text-sm leading-6 text-[var(--muted-foreground)]">
              {description}
            </p>
          </div>
          {impactLabel ? (
            <div className="rounded-[var(--radius-lg)] border border-[var(--border)] bg-white px-4 py-3 shadow-[var(--shadow-soft)]">
              <p className="text-xs font-medium uppercase tracking-[0.08em] text-[var(--muted-foreground)]">
                Climate Impact
              </p>
              <p className="mt-2 text-sm font-medium text-[var(--foreground)]">{impactLabel}</p>
            </div>
          ) : null}
        </div>
        {columns.map((column) => (
          <div key={column.title} className="space-y-3">
            <p className="text-sm font-semibold text-[var(--foreground)]">{column.title}</p>
            <div className="flex flex-col gap-2 text-sm text-[var(--muted-foreground)]">
              {column.items.map((item) => (
                <p key={item}>{item}</p>
              ))}
            </div>
          </div>
        ))}
      </div>
    </footer>
  );
}
