import { Card, CardContent, CardHeader, CardTitle } from "@give-on/ui";

export default function AdminCampaignsPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-6xl flex-col gap-6 px-4 py-10">
      <Card>
        <CardHeader>
          <CardTitle>캠페인 승인 관리</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">
            승인 대기, 반려 사유, 긴급도 기준을 여기에 연결합니다.
          </p>
        </CardContent>
      </Card>
    </main>
  );
}

