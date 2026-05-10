import { describe, expect, it } from "vitest";

import { useAppUiStore } from "../app-ui/use-app-ui-store";

describe("useAppUiStore", () => {
  it("toggles mobile navigation state", () => {
    useAppUiStore.setState({ mobileNavOpen: false });
    useAppUiStore.getState().toggleMobileNav();

    expect(useAppUiStore.getState().mobileNavOpen).toBe(true);
  });
});

