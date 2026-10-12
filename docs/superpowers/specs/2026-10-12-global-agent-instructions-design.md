# Global Agent Instructions Design

## Goal

Maintain one portable source of shared agent instructions in dotfiles and make it available to Codex, Cursor, OpenCode, Gemini CLI, and Claude Code. Keep repository-specific guidance and personal/work knowledge separate from those global rules.

## Current context

- The dotfiles repository already has a root `AGENTS.md` for this repository's conventions.
- It has separate configuration packages for Codex, Cursor, OpenCode, Gemini CLI, and Claude Code, plus shared agent tooling.
- The user maintains `ai-brain` for personal context and `cursor-brain` for work context.

## Source of truth and boundaries

- Add the canonical tool-neutral instructions at `agents/instructions/global.md`.
- Preserve the user's complete `AGENT DIRECTIVE: ADVISOR PERSONA & OPERATIONAL RULES` verbatim in the canonical file, including first-sentence behavior, confidence tags, phrase bans, disagreement and pushback rules, tool routing, worktree conventions, and Cursor Brain work logging.
- Keep tool-specific routing and configuration in thin adapters, not in the canonical file.
- Keep the repository root `AGENTS.md` scoped to dotfiles development and usage.
- Preserve the brain logging rules as written; the canonical directive intentionally gives tools this context-preservation behavior.

## Distribution

Maintain adapters in the existing dotfiles packages for Codex, Cursor, OpenCode, Gemini CLI, and Claude Code. Each adapter should load or refer to the canonical file when the tool supports that mechanism. If a tool requires a standalone file, keep its shared content generated or copied from the canonical source; do not maintain divergent shared rules by hand.

Before selecting exact adapter paths or mechanisms, verify each tool's current global-instruction support. Do not assume all tools discover the same filenames or support includes.

## Validation

- Verify each of the five tools receives the shared instructions through its supported global mechanism.
- Verify adapters do not become competing sources of shared policy.
- Verify the canonical file matches the user's supplied directive and contains no machine-specific absolute paths.
- Verify the root `AGENTS.md` remains dotfiles-specific.

## Scope exclusions

- No new brain repository or migration of existing brain content.
- No paraphrasing or narrowing of the supplied agent directive.
- No speculative adapters or automation beyond what the five named tools require.
