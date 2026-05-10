import { http, HttpResponse } from "msw";

import { dashboardSummaryFixture } from "../fixtures/dashboard";

export const dashboardHandlers = [
  http.get("http://localhost/api/dashboard/summary", () => {
    return HttpResponse.json(dashboardSummaryFixture);
  })
];

