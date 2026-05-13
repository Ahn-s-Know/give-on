import type { Meta, StoryObj } from "@storybook/react-vite";

import { Badge } from "./badge";

const meta = {
  title: "UI/Badge",
  component: Badge,
  tags: ["autodocs"]
} satisfies Meta<typeof Badge>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Statuses: Story = {
  render: () => (
    <div className="flex gap-2">
      <Badge>진행중</Badge>
      <Badge variant="secondary">주의</Badge>
      <Badge variant="destructive">긴급</Badge>
      <Badge variant="warning">마감 임박</Badge>
      <Badge variant="neutral">모바일 우선</Badge>
    </div>
  )
};
