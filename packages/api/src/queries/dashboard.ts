import { queryOptions } from "@tanstack/react-query";

import { dashboardSummarySchema, type DashboardSummary } from "@give-on/schemas";

import { fetchJson } from "../http/fetch-json";
import { queryKeys } from "../query-keys";

export async function fetchDashboardSummary(): Promise<DashboardSummary> {
  const json = await fetchJson<unknown>("/api/dashboard/summary");
  return dashboardSummarySchema.parse(json);
}

export function getDashboardSummaryQueryOptions() {
  return queryOptions({
    queryKey: queryKeys.dashboard.summary,
    queryFn: fetchDashboardSummary
  });
}

