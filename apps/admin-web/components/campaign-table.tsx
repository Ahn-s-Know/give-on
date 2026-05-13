"use client";

import { useMemo } from "react";
import { createColumnHelper } from "@tanstack/react-table";

import type { CampaignSummary } from "@give-on/schemas";
import { DataTable } from "@give-on/ui";

type CampaignTableProps = {
  data: CampaignSummary[];
};

const columnHelper = createColumnHelper<CampaignSummary>();

export function CampaignTable({ data }: CampaignTableProps) {
  const columns = useMemo(
    () => [
      columnHelper.accessor("title", {
        header: "캠페인명"
      }),
      columnHelper.accessor("region", {
        header: "지역"
      }),
      columnHelper.accessor("urgency", {
        header: "긴급도"
      })
    ],
    []
  );

  return (
    <div className="overflow-hidden rounded-[var(--radius-lg)] border border-[var(--border)] bg-white">
      <DataTable columns={columns} data={data} />
    </div>
  );
}
