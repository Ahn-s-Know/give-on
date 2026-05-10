import { z } from "zod";

export const donationAmountSchema = z.object({
  amount: z.number().int().positive()
});

export type DonationAmount = z.infer<typeof donationAmountSchema>;

