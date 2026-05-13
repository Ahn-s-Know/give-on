export const queryKeys = {
  campaigns: {
    all: ["campaigns"] as const,
    detail: (id: string) => ["campaigns", id] as const
  },
  dashboard: {
    summary: ["dashboard", "summary"] as const
  }
};

