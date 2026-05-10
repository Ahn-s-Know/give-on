import { z } from "zod";

export const dashboardSummarySchema = z.object({
  atRiskFarms: z.number().int().nonnegative(),
  pendingCampaigns: z.number().int().nonnegative(),
  activeDeliveries: z.number().int().nonnegative()
});

export type DashboardSummary = z.infer<typeof dashboardSummarySchema>;

