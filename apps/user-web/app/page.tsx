import { Badge } from "@give-on/ui";

import { CampaignList } from "@/components/campaign-list";

export default function HomePage() {
  return (
    <div className="mx-auto flex max-w-6xl flex-col gap-8 px-4 py-10 md:px-8">
      <section className="space-y-3">
        <Badge variant="secondary">Give On User Web</Badge>
        <h1 className="text-4xl font-semibold tracking-tight">
          기후 재난을 함께 극복해요
        </h1>
        <p className="max-w-2xl text-base text-muted-foreground">
          사용자 웹은 캠페인 탐색, 기부, 임팩트 확인에 집중합니다. 데이터는 이후
          Supabase와 Route Handler로 연결하고, 현재는 mock contract 기반으로 개발을
          시작합니다.
        </p>
      </section>

      <CampaignList />
    </div>
  );
}
