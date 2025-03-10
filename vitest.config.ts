import path from "path";
import { defineConfig } from "vitest/config";

const base = path.resolve(__dirname, "./src");

export default defineConfig({
  test: {
    globals: true,
    alias: {
      "@": base,
    },
    coverage: {
      enabled: true,
      exclude: ["**/app/*.ts"],
      all: true,
      reporter: ["cobertura", "html-spa", "text-summary"],
    },
  },
});
