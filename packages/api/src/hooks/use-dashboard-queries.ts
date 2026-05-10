"use client";

import { useQuery } from "@tanstack/react-query";

import { getDashboardSummaryQueryOptions } from "../queries/dashboard";

export function useDashboardSummaryQuery() {
  return useQuery(getDashboardSummaryQueryOptions());
}

