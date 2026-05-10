import { NextResponse } from "next/server";

import { getMockCampaigns } from "@give-on/mocks";

export async function GET() {
  return NextResponse.json(getMockCampaigns());
}

