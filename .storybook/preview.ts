import type { Preview } from "@storybook/react";

import "./preview.css";

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i
      }
    },
    backgrounds: {
      default: "canvas",
      values: [
        { name: "canvas", value: "#f7f8fa" },
        { name: "card", value: "#ffffff" }
      ]
    },
    layout: "centered"
  }
};

export default preview;
