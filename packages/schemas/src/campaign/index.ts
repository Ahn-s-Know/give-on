import { z } from "zod";

export const campaignSummarySchema = z.object({
  id: z.string().min(1),
  title: z.string().min(1),
  region: z.string().min(1),
  urgency: z.enum(["진행중", "주의", "위험", "긴급"]),
  summary: z.string().min(1)
});

export type CampaignSummary = z.infer<typeof campaignSummarySchema>;

