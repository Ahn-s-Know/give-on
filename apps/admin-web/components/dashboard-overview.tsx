"use client";

import { useCampaignsQuery, useDashboardSummaryQuery } from "@give-on/api";
import {
  Badge,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle
} from "@give-on/ui";

import { CampaignTable } from "@/components/campaign-table";

export function DashboardOverview() {
  const summaryQuery = useDashboardSummaryQuery();
  const campaignsQuery = useCampaignsQuery();

  if (summaryQuery.isLoading || campaignsQuery.isLoading) {
    return <p className="text-sm text-muted-foreground">관리자 데이터를 불러오는 중입니다.</p>;
  }

  if (summaryQuery.isError || campaignsQuery.isError || !summaryQuery.data || !campaignsQuery.data) {
    return <p className="text-sm text-[var(--destructive)]">관리자 데이터를 불러오지 못했습니다.</p>;
  }

  const summary = summaryQuery.data;

  return (
    <div className="flex flex-col gap-6">
      <section className="rounded-[var(--radius-xl)] border border-[var(--border)] bg-white p-6 shadow-[var(--shadow-soft)]">
        <div className="flex flex-col gap-4">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="secondary">Give On Admin</Badge>
            <Badge variant="neutral">운영 중심 PWA</Badge>
          </div>
          <div className="space-y-2">
            <h1 className="text-3xl font-semibold tracking-tight text-[var(--foreground)]">
              관리자 대시보드
            </h1>
            <p className="max-w-2xl text-sm leading-7 text-[var(--secondary-foreground)]">
              긴급 농가, 승인 대기 캠페인, 배송 진행 상황을 한 눈에 파악하고 바로
              처리할 수 있는 운영용 시작 화면입니다.
            </p>
          </div>
        </div>
      </section>

      <section className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="gap-2">
            <CardTitle>오늘 위험 농가</CardTitle>
            <CardDescription>기상 위험 신호가 높은 농가 수</CardDescription>
          </CardHeader>
          <CardContent className="text-3xl font-semibold">{summary.atRiskFarms}</CardContent>
        </Card>
        <Card>
          <CardHeader className="gap-2">
            <CardTitle>승인 대기 캠페인</CardTitle>
            <CardDescription>즉시 검토가 필요한 공개 후보</CardDescription>
          </CardHeader>
          <CardContent className="text-3xl font-semibold">{summary.pendingCampaigns}</CardContent>
        </Card>
        <Card>
          <CardHeader className="gap-2">
            <CardTitle>배송 진행 건</CardTitle>
            <CardDescription>답례품 배송이 진행 중인 주문</CardDescription>
          </CardHeader>
          <CardContent className="text-3xl font-semibold">{summary.activeDeliveries}</CardContent>
        </Card>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>캠페인 승인 큐</CardTitle>
        </CardHeader>
        <CardContent>
          <CampaignTable data={campaignsQuery.data} />
        </CardContent>
      </Card>
    </div>
  );
}
