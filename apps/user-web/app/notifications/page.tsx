import { Card, CardContent, CardHeader, CardTitle } from "@give-on/ui";

export default function NotificationsPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-4xl flex-col gap-6 px-4 py-10">
      <Card>
        <CardHeader>
          <CardTitle>알림 센터</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">
            감사 사진, 배송 상태, 캠페인 후속 업데이트를 여기에 모읍니다.
          </p>
        </CardContent>
      </Card>
    </main>
  );
}

