import { http, HttpResponse } from "msw";

import { campaignsFixture } from "../fixtures/campaigns";

export const campaignHandlers = [
  http.get("http://localhost/api/campaigns", () => {
    return HttpResponse.json(campaignsFixture);
  }),
  http.get("http://localhost/api/campaigns/:id", ({ params }) => {
    const campaign = campaignsFixture.find((item) => item.id === params.id);

    if (!campaign) {
      return HttpResponse.json({ message: "Not found" }, { status: 404 });
    }

    return HttpResponse.json(campaign);
  })
];
