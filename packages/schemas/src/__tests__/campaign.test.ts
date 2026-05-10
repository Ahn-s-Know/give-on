import { describe, expect, it } from "vitest";

import { campaignSummarySchema } from "../campaign";

describe("campaignSummarySchema", () => {
  it("accepts a valid campaign summary", () => {
    const result = campaignSummarySchema.safeParse({
      id: "apple-001",
      title: "청송 우박 피해 사과",
      region: "경북 청송",
      urgency: "긴급",
      summary: "2kg 사과 박스로 연결되는 긴급 지원 캠페인"
    });

    expect(result.success).toBe(true);
  });

  it("rejects unknown urgency labels", () => {
    const result = campaignSummarySchema.safeParse({
      id: "apple-001",
      title: "청송 우박 피해 사과",
      region: "경북 청송",
      urgency: "보통",
      summary: "요약"
    });

    expect(result.success).toBe(false);
  });
});

