import { create } from "zustand";

type CampaignFilterState = {
  urgency: "all" | "긴급" | "진행중";
  setUrgency: (urgency: CampaignFilterState["urgency"]) => void;
};

export const useCampaignFilterStore = create<CampaignFilterState>((set) => ({
  urgency: "all",
  setUrgency: (urgency) => set({ urgency })
}));

