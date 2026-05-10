import { Badge, Button, Card, CardContent, CardHeader, CardTitle } from "@give-on/ui";

export default function DonationCompletePage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col gap-6 px-4 py-10">
      <Badge>기부 완료</Badge>
      <Card>
        <CardHeader>
          <CardTitle>청송 사과 2kg 박스가 배송될 예정입니다</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm text-muted-foreground">
            완료 화면은 리워드, 배송 상태, 후속 공유 액션의 설계 기준점입니다.
          </p>
          <Button asChild>
            <a href="/">다른 농가 돕기</a>
          </Button>
        </CardContent>
      </Card>
    </main>
  );
}

