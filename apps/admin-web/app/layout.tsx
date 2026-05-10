import type { Metadata } from "next";
import { ReactNode } from "react";

import { Providers } from "@/app/providers";
import { AdminSidebar } from "@/components/layout/admin-sidebar";
import { AdminTopbar } from "@/components/layout/admin-topbar";

import "./globals.css";

export const metadata: Metadata = {
  title: "Give On Admin",
  description: "Give On 관리자 대시보드"
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <Providers>
          <div className="flex min-h-screen bg-[var(--background)]">
            <AdminSidebar />
            <div className="flex min-h-screen flex-1 flex-col">
              <AdminTopbar />
              <main className="flex-1 px-4 py-6 md:px-6 md:py-8">{children}</main>
            </div>
          </div>
        </Providers>
      </body>
    </html>
  );
}
