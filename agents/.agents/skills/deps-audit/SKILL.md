---
name: deps-audit
description: >-
  Systematically compares package.json dependency entries to actual repo usage via
  imports, requires, configs, and scripts. Use when auditing dead dependencies,
  cleaning package.json, answering “is X still used?”, before removing packages,
  or reducing install size and supply-chain surface.
---

# Audit unused `package.json` dependencies

## Core principle

A dependency is **used** if the repo references it in **executable or build-time paths**: JS/TS imports, CSS `@import` where applicable, config that loads the package by name, codegen, or `package.json` `scripts`. A package is **not** unused just because plain text search misses it—check **indirect and non-import** usage first.

## When not to use this alone

- **Peer dependencies** consumers satisfy: absence in your source may still be correct.
- **Optional / platform-specific** deps: may only resolve on certain OS/CI.
- **Meta packages** or **workspace protocol** monorepos: resolve the **logical** package name and search consumers across workspaces.

## Workflow

1. **Inventory**
   - Read `package.json` at the repo root and, for monorepos, each workspace package that has its own `package.json`.
   - Collect keys from `dependencies`, `devDependencies`, and (if present) `optionalDependencies`. Treat `peerDependencies` separately (flag “peer — verify contract”, do not auto-mark unused).

2. **Bucket each package** (determines *where* to look for usage)

   | Bucket | How it usually appears |
   | --- | --- |
   | Runtime JS/TS library | `import`, `require()`, dynamic `import()`, re-export |
   | Types-only | `@types/foo` pairs with imports of `foo`; or `/// <reference types="…" />` |
   | CLI / binary | `scripts` in `package.json`, CI YAML, Docker `RUN`, Makefile |
   | Bundler / transpiler plugin | `webpack.config.*`, `vite.config.*`, `babel.config.*`, `postcss.config.*`, `tailwind.config.*`, `jest.config.*`, `eslint.config.*` |
   | CSS / asset pipeline | `@import "pkg/..."`, `url(...)`, Sass `@use` |
   | Framework convention | e.g. Next.js `next.config`, Storybook main/preview, Cypress plugins |
   | Native / Node addon | `require` from native code, `.node` loads — rare; verify binary |

3. **Search strategy** (prefer ripgrep; respect repo `.gitignore` unless auditing intentionally includes ignored paths)

   For package name `name` from `package.json`:

   - **Primary:** patterns that match module specifiers  
     - Scoped: `@scope/pkg` → search `@scope/pkg`, `@scope/pkg/`, escapes as needed for regex.  
     - Unscoped: `lodash` → `\blodash\b` in import/require strings; include subpaths `lodash/`.
   - **Configs:** search the **string** package name in `*.config.*`, `.babelrc*`, `tsconfig*.json`, `jest.config.*`, `.eslintrc*`, `knip.*`, `turbo.json`, CI workflows.
   - **Scripts:** grep `package.json` `"scripts"` values for the CLI name (often differs from package name — map via `node_modules/.bin` or package `bin` field when unsure).
   - **Types:** for `@types/foo`, search TypeScript usage of `foo` as a module name, not `@types/foo`.

4. **Interpret “no hits”**

   Before marking **unused**, eliminate:

   - **Re-export** through an internal barrel — trace one level.
   - **Dynamic import** with computed specifier — search partial strings / surrounding files.
   - **HTML / templates** (`<script src="…">`) or micro-frontend manifests.
   - **Comments / docs** only — not usage.
   - **Duplicate package** under another name (alias in bundler) — check `resolve.alias`, `paths` in `tsconfig`.

5. **Optional tooling** (run if available; corroborate, don’t blindly trust)

   - `npx depcheck` — fast heuristic scan; false positives on monorepos and tooling.
   - `npx knip` — good for unused deps + exports when configured for the stack.
   - Align tool output with manual grep for anything flagged.

6. **Deliverable**

   - Table: **package**, **section** (`dependencies` / `devDependencies`), **evidence** (file:line or “CLI in script X”), or **suspected unused** with **reason** and **recommended next check** (e.g. “verify Storybook addon”).
   - Never mass-remove without a **build/test** pass the user cares about (`yarn test`, `nx build`, etc.).

## Quick reference — common false “unused”

| Situation | Where to look |
| --- | --- |
| PostCSS / Tailwind preset | `postcss.config.*`, `tailwind.config.*` |
| Babel preset/plugin | `babel.config.*`, `.babelrc` |
| ESLint plugin/parser | `eslint.config.*`, `.eslintrc*` |
| Jest resolver/transform | `jest.config.*` |
| Husky / lint-staged | `.husky/*`, `lint-staged` config |
| Commitlint / semantic-release | Config files at repo root |
| Vitest / Playwright | Dedicated config files |

## Common mistakes

- Labeling **devDependencies** unused because production bundle omits them — they may still be required for **build/CI**.
- Ignoring **workspace** packages: dependency listed in root but only used in `packages/foo`.
- Matching **short names** (`ui`) without word boundaries → false positives; prefer exact specifier patterns.
- Removing **polyfills** or **side-effect** imports that register globally — grep for project-specific entry files.

## Example — minimal manual check

For dependency `react-hook-form`:

```bash
rg 'react-hook-form' --glob '*.ts' --glob '*.tsx' --glob '*.js' --glob '*.jsx' --glob '*.mjs' --glob '*.cjs'
rg 'react-hook-form' --glob '*.json' --glob '*.config.*'
```

Then open `package.json` → `scripts` and CI configs if CLI usage is plausible.
