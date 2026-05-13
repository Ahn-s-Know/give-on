import { DashboardOverview } from "@/components/dashboard-overview";

export default function DashboardPage() {
  return (
    <div className="mx-auto flex max-w-7xl flex-col gap-6 px-4 py-10 md:px-6">
      <DashboardOverview />
    </div>
  );
}
