import { NextResponse } from "next/server";

import { dashboardSummaryFixture } from "@give-on/mocks";

export async function GET() {
  return NextResponse.json(dashboardSummaryFixture);
}

