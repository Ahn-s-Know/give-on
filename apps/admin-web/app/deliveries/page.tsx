import { Card, CardContent, CardHeader, CardTitle } from "@give-on/ui";

export default function AdminDeliveriesPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-6xl flex-col gap-6 px-4 py-10">
      <Card>
        <CardHeader>
          <CardTitle>배송 관리</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">
            배송 상태 파이프라인과 배송 예외 처리를 여기에 연결합니다.
          </p>
        </CardContent>
      </Card>
    </main>
  );
}

