import { defineConfig } from "eslint/config";
import js from "@eslint/js";
import globals from "globals";
import jsoncPlugin from "eslint-plugin-jsonc";

export default defineConfig([
  js.configs.recommended,

  {
    files: ["**/*.js", "**/*.cjs"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "script",
      globals: {
        ...globals.node,
      },
    },
    rules: {
      "no-undef": "error",
    },
  },

  {
    files: ["build/src/prep.js"],
    languageOptions: {
      globals: { scriptLibraryPathInRepo: "readonly" },
    },          
  },

  {
    files: ["build/src/push.js"],
    rules: {
      "no-useless-escape": "off",
    },
  },

  {
    files: ["build/src/utils/async.js"],
    rules: {
      "no-redeclare": ["error", { builtinGlobals: false }],
    },
  },

  ...jsoncPlugin.configs["flat/recommended-with-jsonc"],
]);