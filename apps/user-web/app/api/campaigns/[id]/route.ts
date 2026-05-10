import { NextResponse } from "next/server";

import { getMockCampaignById } from "@give-on/mocks";

type RouteContext = {
  params: Promise<{ id: string }>;
};

export async function GET(_request: Request, context: RouteContext) {
  const { id } = await context.params;
  const campaign = getMockCampaignById(id);

  if (!campaign) {
    return NextResponse.json({ message: "Not found" }, { status: 404 });
  }

  return NextResponse.json(campaign);
}

