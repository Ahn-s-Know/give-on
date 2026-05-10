import { Card, CardContent, CardHeader, CardTitle } from "@give-on/ui";

export default function ImpactPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-4xl flex-col gap-6 px-4 py-10">
      <Card>
        <CardHeader>
          <CardTitle>나의 임팩트</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">
            임팩트 리포트는 추후 Supabase 집계 데이터와 연결됩니다.
          </p>
        </CardContent>
      </Card>
    </main>
  );
}

