import { defineConfig } from "eslint/config";
import { FlatCompat } from "@eslint/eslintrc";
import js from "@eslint/js";
import globals from "globals";
import jsoncParser from "jsonc-eslint-parser";

const compat = new FlatCompat();

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

  ...compat.extends("plugin:jsonc/recommended-with-jsonc"),
  {
    files: ["**/*.json"],
    languageOptions: {
      parser: jsoncParser,
      parserOptions: { jsonSyntax: "JSONC" },
    },
  },
]);
