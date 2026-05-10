import { campaignsFixture } from "./fixtures/campaigns";
import { dashboardSummaryFixture } from "./fixtures/dashboard";

export { campaignsFixture } from "./fixtures/campaigns";
export { dashboardSummaryFixture } from "./fixtures/dashboard";
export { handlers } from "./handlers";

export function getMockCampaigns() {
  return [...campaignsFixture];
}

export function getMockCampaignById(id: string) {
  return campaignsFixture.find((campaign) => campaign.id === id);
}
