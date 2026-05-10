import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "../../lib/cn";

const badgeVariants = cva(
  "inline-flex w-fit items-center rounded-full px-3 py-1 text-xs font-semibold",
  {
    variants: {
      variant: {
        default: "bg-[var(--primary)] text-[var(--primary-foreground)]",
        secondary: "bg-[var(--secondary)] text-[var(--secondary-foreground)]",
        destructive: "bg-[var(--destructive-soft)] text-[var(--destructive)]",
        neutral: "border border-[var(--border)] bg-white text-[var(--secondary-foreground)]",
        warning: "bg-[var(--warning-soft)] text-[var(--warning)]"
      }
    },
    defaultVariants: {
      variant: "default"
    }
  }
);

type BadgeProps = React.HTMLAttributes<HTMLDivElement> &
  VariantProps<typeof badgeVariants>;

export function Badge({ className, variant, ...props }: BadgeProps) {
  return <div className={cn(badgeVariants({ variant }), className)} {...props} />;
}
