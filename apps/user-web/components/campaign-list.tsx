"use client";

import Link from "next/link";

import { useCampaignsQuery } from "@give-on/api";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from "@give-on/ui";

export function CampaignList() {
  const { data, isLoading, isError } = useCampaignsQuery();

  if (isLoading) {
    return <p className="text-sm text-muted-foreground">캠페인을 불러오는 중입니다.</p>;
  }

  if (isError || !data) {
    return <p className="text-sm text-[var(--destructive)]">캠페인을 불러오지 못했습니다.</p>;
  }

  return (
    <div className="flex flex-col gap-8">
      <section className="rounded-[var(--radius-xl)] border border-[var(--border)] bg-[linear-gradient(135deg,#ffffff_0%,#f4f9f6_100%)] p-6 shadow-[var(--shadow-soft)] md:p-8">
        <div className="flex flex-col gap-5">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="secondary">기후 재난 신호</Badge>
            <Badge variant="neutral">모바일 퍼스트</Badge>
          </div>
          <div className="max-w-2xl space-y-3">
            <h1 className="text-3xl font-semibold tracking-tight text-[var(--foreground)] md:text-4xl">
              기후 재난을 이해하고, 바로 도울 수 있게.
            </h1>
            <p className="text-sm leading-7 text-[var(--secondary-foreground)] md:text-base">
              Give On은 긴급한 농가 상황을 시민의 행동으로 바로 연결하는 데이터 기반
              기부 플랫폼입니다.
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            {["전체", "우박", "폭염", "가뭄", "배송 완료 임박"].map((label, index) => (
              <Badge key={label} variant={index === 0 ? "default" : "secondary"}>
                {label}
              </Badge>
            ))}
          </div>
        </div>
      </section>

      <section className="grid gap-5 md:grid-cols-2">
        {data.map((campaign) => {
          const badgeVariant =
            campaign.urgency === "긴급"
              ? "destructive"
              : campaign.urgency === "주의"
                ? "warning"
                : "secondary";

          return (
            <Card key={campaign.id} className="overflow-hidden">
              <div className="h-48 bg-[linear-gradient(135deg,#e9f5ef_0%,#f6f8fb_100%)]" />
              <CardHeader className="gap-3">
                <div className="flex items-center justify-between gap-3">
                  <Badge variant={badgeVariant}>{campaign.urgency}</Badge>
                  <p className="text-xs font-medium text-[var(--muted-foreground)]">
                    {campaign.region}
                  </p>
                </div>
                <div className="space-y-2">
                  <CardTitle className="text-2xl">{campaign.title}</CardTitle>
                  <CardDescription>{campaign.summary}</CardDescription>
                </div>
              </CardHeader>
              <CardContent className="flex items-center justify-between gap-4">
                <div>
                  <p className="text-sm font-semibold text-[var(--foreground)]">3만원 기부</p>
                  <p className="text-sm text-[var(--muted-foreground)]">
                    농가 지원 + 못난이 작물 직배송
                  </p>
                </div>
                <div className="h-2 w-24 overflow-hidden rounded-full bg-[var(--secondary)]">
                  <div className="h-full w-2/3 rounded-full bg-[var(--primary)]" />
                </div>
              </CardContent>
              <CardFooter>
                <Button asChild>
                  <Link href={`/campaigns/${campaign.id}`}>캠페인 보기</Link>
                </Button>
                <Button asChild variant="ghost">
                  <Link href="/impact">임팩트 보기</Link>
                </Button>
              </CardFooter>
            </Card>
          );
        })}
      </section>
    </div>
  );
}
