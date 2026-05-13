import { describe, expect, it } from "vitest";

import { GET } from "./route";

describe("user-web health route", () => {
  it("returns ok response", async () => {
    const response = await GET();
    const json = await response.json();

    expect(response.status).toBe(200);
    expect(json).toEqual({
      app: "user-web",
      ok: true
    });
  });
});

