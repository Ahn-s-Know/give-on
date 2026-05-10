import { queryOptions } from "@tanstack/react-query";

import { campaignSummarySchema, type CampaignSummary } from "@give-on/schemas";

import { fetchJson } from "../http/fetch-json";
import { queryKeys } from "../query-keys";

export async function fetchCampaigns(): Promise<CampaignSummary[]> {
  const json = await fetchJson<unknown>("/api/campaigns");
  return campaignSummarySchema.array().parse(json);
}

export async function fetchCampaignById(id: string): Promise<CampaignSummary> {
  const json = await fetchJson<unknown>(`/api/campaigns/${id}`);
  return campaignSummarySchema.parse(json);
}

export function getCampaignsQueryOptions() {
  return queryOptions({
    queryKey: queryKeys.campaigns.all,
    queryFn: fetchCampaigns
  });
}

export function getCampaignByIdQueryOptions(id: string) {
  return queryOptions({
    queryKey: queryKeys.campaigns.detail(id),
    queryFn: () => fetchCampaignById(id),
    enabled: Boolean(id)
  });
}

