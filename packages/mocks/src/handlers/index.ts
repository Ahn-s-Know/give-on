import { campaignHandlers } from "./campaigns";
import { dashboardHandlers } from "./dashboard";

export const handlers = [...campaignHandlers, ...dashboardHandlers];
