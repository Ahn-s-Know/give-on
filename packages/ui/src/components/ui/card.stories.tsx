import type { Meta, StoryObj } from "@storybook/react-vite";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./card";

const meta = {
  title: "UI/Card",
  component: Card,
  tags: ["autodocs"]
} satisfies Meta<typeof Card>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  render: () => (
    <Card className="w-[360px]">
      <CardHeader>
        <CardTitle>청송 우박 피해 사과</CardTitle>
        <CardDescription>긴급 캠페인 카드의 기본 구조입니다.</CardDescription>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-[var(--muted-foreground)]">
          우박 피해 농가를 돕고 2kg 사과 박스를 받아보세요.
        </p>
      </CardContent>
    </Card>
  )
};
