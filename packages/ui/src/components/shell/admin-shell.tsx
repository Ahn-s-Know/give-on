import * as React from "react";

import { cn } from "../../lib/cn";
import { Badge } from "../ui/badge";

type AdminNavItem = {
  href: string;
  label: string;
  description?: string;
  active?: boolean;
};

type AdminSidebarShellProps = {
  brandHref?: string;
  brandLabel?: string;
  subtitle?: string;
  summaryTitle?: string;
  summaryBody?: string;
  items: AdminNavItem[];
  footerTitle?: string;
  footerBody?: string;
  className?: string;
};

type AdminTopbarShellProps = {
  eyebrow?: string;
  title: string;
  description: string;
  badgeLabel?: string;
  className?: string;
};

export function AdminSidebarShell({
  brandHref = "/dashboard",
  brandLabel = "Give On Admin",
  subtitle,
  summaryTitle,
  summaryBody,
  items,
  footerTitle,
  footerBody,
  className
}: AdminSidebarShellProps) {
  return (
    <aside
      className={cn(
        "hidden w-80 shrink-0 border-r border-[var(--border)] bg-[linear-gradient(180deg,#ffffff_0%,#fbfcfd_100%)] xl:block",
        className
      )}
    >
      <div className="flex h-full flex-col gap-8 px-6 py-6">
        <div className="space-y-1">
          <a href={brandHref} className="text-lg font-semibold tracking-tight text-[var(--foreground)]">
            {brandLabel}
          </a>
          {subtitle ? (
            <p className="text-sm leading-6 text-[var(--muted-foreground)]">{subtitle}</p>
          ) : null}
        </div>

        {summaryTitle || summaryBody ? (
          <div className="rounded-[var(--radius-xl)] border border-[var(--border)] bg-[var(--secondary)] p-4">
            {summaryTitle ? (
              <p className="text-sm font-semibold text-[var(--foreground)]">{summaryTitle}</p>
            ) : null}
            {summaryBody ? (
              <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">{summaryBody}</p>
            ) : null}
          </div>
        ) : null}

        <nav className="flex flex-col gap-2">
          {items.map((item) => (
            <a
              key={item.href}
              href={item.href}
              aria-current={item.active ? "page" : undefined}
              className={cn(
                "rounded-[var(--radius-lg)] border px-4 py-3 transition",
                item.active
                  ? "border-[var(--primary)] bg-[var(--primary-soft)]"
                  : "border-transparent hover:border-[var(--border)] hover:bg-white"
              )}
            >
              <div className="flex items-center justify-between gap-3">
                <span
                  className={cn(
                    "text-sm font-semibold",
                    item.active ? "text-[var(--foreground)]" : "text-[var(--secondary-foreground)]"
                  )}
                >
                  {item.label}
                </span>
                {item.active ? <Badge variant="default">현재</Badge> : null}
              </div>
              {item.description ? (
                <p className="mt-1 text-xs leading-5 text-[var(--muted-foreground)]">
                  {item.description}
                </p>
              ) : null}
            </a>
          ))}
        </nav>

        {(footerTitle || footerBody) && (
          <div className="mt-auto rounded-[var(--radius-xl)] border border-[var(--border)] bg-white p-4 shadow-[var(--shadow-soft)]">
            {footerTitle ? (
              <p className="text-sm font-semibold text-[var(--foreground)]">{footerTitle}</p>
            ) : null}
            {footerBody ? (
              <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">{footerBody}</p>
            ) : null}
          </div>
        )}
      </div>
    </aside>
  );
}

export function AdminTopbarShell({
  eyebrow = "운영자 콘솔",
  title,
  description,
  badgeLabel = "Admin PWA",
  className
}: AdminTopbarShellProps) {
  return (
    <header
      className={cn(
        "sticky top-0 z-20 border-b border-[var(--border)] bg-white/88 backdrop-blur supports-[backdrop-filter]:bg-white/72",
        className
      )}
    >
      <div className="flex items-center justify-between gap-4 px-4 py-4 md:px-6">
        <div className="min-w-0">
          <p className="text-xs font-semibold uppercase tracking-[0.08em] text-[var(--muted-foreground)]">
            {eyebrow}
          </p>
          <div className="mt-1 flex items-center gap-3">
            <p className="text-lg font-semibold tracking-tight text-[var(--foreground)]">{title}</p>
            <Badge variant="neutral" className="hidden md:inline-flex">
              실시간 운영
            </Badge>
          </div>
          <p className="mt-1 text-sm text-[var(--muted-foreground)]">{description}</p>
        </div>
        <Badge variant="secondary" className="shrink-0">
          {badgeLabel}
        </Badge>
      </div>
    </header>
  );
}
