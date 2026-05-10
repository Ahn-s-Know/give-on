import { afterAll, afterEach, beforeAll, describe, expect, it } from "vitest";

import { server } from "../server";

describe("campaign handlers", () => {
  beforeAll(() => server.listen());
  afterEach(() => server.resetHandlers());
  afterAll(() => server.close());

  it("returns mock campaign list", async () => {
    const response = await fetch("http://localhost/api/campaigns");
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(Array.isArray(data)).toBe(true);
    expect(data).toHaveLength(2);
  });
});
