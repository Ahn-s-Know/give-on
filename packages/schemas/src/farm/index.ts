import { z } from "zod";

export const farmTypeSchema = z.enum(["chicken", "pig", "cattle", "duck", "crop"]);
export type FarmType = z.infer<typeof farmTypeSchema>;

