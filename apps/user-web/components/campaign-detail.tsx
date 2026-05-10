"use client";

import { useCampaignDetailQuery } from "@give-on/api";
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

type CampaignDetailProps = {
  id: string;
};

export function CampaignDetail({ id }: CampaignDetailProps) {
  const { data, isLoading, isError } = useCampaignDetailQuery(id);

  if (isLoading) {
    return <p className="text-sm text-muted-foreground">캠페인 정보를 불러오는 중입니다.</p>;
  }

  if (isError || !data) {
    return <p className="text-sm text-[var(--destructive)]">캠페인 정보를 불러오지 못했습니다.</p>;
  }

  return (
    <div className="grid gap-6 lg:grid-cols-[minmax(0,1.3fr)_360px] lg:items-start">
      <div className="flex flex-col gap-6">
        <section className="overflow-hidden rounded-[var(--radius-xl)] border border-[var(--border)] bg-white shadow-[var(--shadow-soft)]">
          <div className="h-64 bg-[linear-gradient(135deg,#eef7f3_0%,#f7f8fa_100%)] md:h-80" />
          <div className="space-y-4 p-6 md:p-8">
            <Badge variant={data.urgency === "긴급" ? "destructive" : "secondary"}>
              {data.urgency}
            </Badge>
            <div className="space-y-2">
              <h1 className="text-3xl font-semibold tracking-tight text-[var(--foreground)] md:text-4xl">
                {data.title}
              </h1>
              <p className="text-sm text-[var(--muted-foreground)]">{data.region}</p>
            </div>
            <p className="max-w-3xl text-base leading-8 text-[var(--secondary-foreground)]">
              {data.summary}
            </p>
          </div>
        </section>

        <Card>
          <CardHeader>
            <CardTitle>기후 신호에서 행동까지</CardTitle>
            <CardDescription>
              재난 정보, 농가 상황, 시민 행동이 하나의 경험으로 이어지도록 설계합니다.
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-3 md:grid-cols-3">
            {[
              ["신호", "재난 위험과 지역 상황을 빠르게 이해합니다."],
              ["행동", "추천 금액으로 망설임 없이 기부를 완료합니다."],
              ["임팩트", "배송과 감사 알림으로 결과를 확인합니다."]
            ].map(([title, body]) => (
              <div
                key={title}
                className="rounded-[var(--radius-lg)] bg-[var(--secondary)] p-4"
              >
                <p className="text-sm font-semibold text-[var(--foreground)]">{title}</p>
                <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">{body}</p>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>

      <Card className="lg:sticky lg:top-28">
        <CardHeader>
          <CardTitle>기부 패널</CardTitle>
          <CardDescription>추천 금액 3만원으로 가장 빠르게 참여할 수 있어요.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-3 gap-2">
            {["1만원", "3만원", "5만원"].map((amount, index) => (
              <Button
                key={amount}
                variant={index === 1 ? "default" : "secondary"}
                className="w-full"
              >
                {amount}
              </Button>
            ))}
          </div>
          <div className="rounded-[var(--radius-lg)] bg-[var(--secondary)] p-4">
            <p className="text-sm font-semibold text-[var(--foreground)]">답례품 안내</p>
            <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">
              못난이 작물 2kg 박스와 농부 감사 사진이 배송됩니다.
            </p>
          </div>
        </CardContent>
        <CardFooter className="flex-col items-stretch">
          <Button size="lg">기부하기</Button>
          <Button variant="ghost">결제 전 안내사항 보기</Button>
        </CardFooter>
      </Card>
    </div>
  );
}
