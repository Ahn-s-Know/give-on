import { CampaignDetail } from "@/components/campaign-detail";

type CampaignPageProps = {
  params: Promise<{ id: string }>;
};

export default async function CampaignPage({ params }: CampaignPageProps) {
  const { id } = await params;

  return (
    <div className="mx-auto flex max-w-4xl flex-col gap-6 px-4 py-10 md:px-8">
      <CampaignDetail id={id} />
    </div>
  );
}
