import type { Metadata } from "next";
import { ReactNode } from "react";

import { Providers } from "@/app/providers";
import { UserFooter } from "@/components/layout/user-footer";
import { UserHeader } from "@/components/layout/user-header";

import "./globals.css";

export const metadata: Metadata = {
  title: "Give On",
  description: "기후 재난과 농가를 잇는 시민 기부 플랫폼"
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <Providers>
          <div className="flex min-h-screen flex-col bg-[var(--background)]">
            <UserHeader />
            <main className="flex-1">
              <div className="mx-auto flex w-full max-w-6xl flex-1 flex-col px-4 py-6 md:px-8 md:py-8">
                {children}
              </div>
            </main>
            <UserFooter />
          </div>
        </Providers>
      </body>
    </html>
  );
}
