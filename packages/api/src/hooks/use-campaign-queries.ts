"use client";

import { useQuery } from "@tanstack/react-query";

import {
  getCampaignByIdQueryOptions,
  getCampaignsQueryOptions
} from "../queries/campaigns";

export function useCampaignsQuery() {
  return useQuery(getCampaignsQueryOptions());
}

export function useCampaignDetailQuery(id: string) {
  return useQuery(getCampaignByIdQueryOptions(id));
}

