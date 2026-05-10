import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    app: "user-web",
    ok: true
  });
}

