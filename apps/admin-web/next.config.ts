import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: [
    "@give-on/api",
    "@give-on/forms",
    "@give-on/mocks",
    "@give-on/schemas",
    "@give-on/store",
    "@give-on/theme",
    "@give-on/ui"
  ]
};

export default nextConfig;

