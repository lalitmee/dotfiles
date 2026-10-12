# Global Agent Instructions Design

## Goal

Maintain one portable source of shared agent instructions in dotfiles and make it available to Codex, Cursor, OpenCode, Gemini CLI, and Claude Code. Keep repository-specific guidance and personal/work knowledge separate from those global rules.

## Current context

- The dotfiles repository already has a root `AGENTS.md` for this repository's conventions.
- It has separate configuration packages for Codex, Cursor, OpenCode, Gemini CLI, and Claude Code, plus shared agent tooling.
- The user maintains `ai-brain` for personal context and `cursor-brain` for work context.

## Source of truth and boundaries

- Add the canonical tool-neutral instructions at `agents/instructions/global.md`.
- Put only durable cross-agent defaults there: intellectual honesty and uncertainty, investigation before project claims, secret handling, and preference for simple solutions.
- Do not impose brittle universal response behavior such as confidence tags on every factual statement or always challenging the user first.
- Keep tool-specific routing and configuration in thin adapters, not in the canonical file.
- Keep the repository root `AGENTS.md` scoped to dotfiles development and usage.
- Keep personal and work context, records, plans, and specs in their respective brain repositories. Brain logging instructions belong in relevant work/Cursor-specific guidance, not the global file.
- Avoid machine-specific paths and personal/work assumptions in the canonical instructions.

## Distribution

Maintain adapters in the existing dotfiles packages for Codex, Cursor, OpenCode, Gemini CLI, and Claude Code. Each adapter should load or refer to the canonical file when the tool supports that mechanism. If a tool requires a standalone file, keep its shared content generated or copied from the canonical source; do not maintain divergent shared rules by hand.

Before selecting exact adapter paths or mechanisms, verify each tool's current global-instruction support. Do not assume all tools discover the same filenames or support includes.

## Validation

- Verify each of the five tools receives the shared instructions through its supported global mechanism.
- Verify adapters do not become competing sources of shared policy.
- Verify the canonical file is portable and contains no machine-specific paths or brain-repository work rules.
- Verify the root `AGENTS.md` remains dotfiles-specific.

## Scope exclusions

- No new brain repository or migration of existing brain content.
- No broad agent policy rewrite beyond the shared portable defaults.
- No speculative adapters or automation beyond what the five named tools require.
