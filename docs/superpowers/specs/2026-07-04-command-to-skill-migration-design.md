# Convert OpenCode Agent Commands to Skills

## Problem

19 out of 47 OpenCode slash commands in `opencode/.config/opencode/command/` use the `agent:` field
(build or plan) with full inline instructions. When invoked via `/command`, OpenCode spawns a sub-agent
and dumps the entire markdown content (~1,310 lines total) as visible prompt text in the conversation.
This creates a poor UX — the user sees raw system prompt content.

The 28 remaining commands use a thin 5-line pattern without `agent:`, delegating to a skill file that
is loaded silently via the skill tool. These work correctly.

## Solution

### Pattern (already validated by 28 existing commands)

Each command file becomes a 5-line thin reference:

```markdown
---
description: <description>
---

Use the skill tool to load the '<name>' skill and follow its workflow.
```

The full workflow instructions move to `.agents/skills/<name>/SKILL.md` with frontmatter:

```markdown
---
name: <name>
description: <description>
---

<full workflow instructions>
```

### Files Changed

- **`.agents/skills/<name>/SKILL.md`** (new) — silent skill file with full instructions
- **`opencode/.config/opencode/command/<name>.md`** (modified) — thin 5-line reference, no agent field
- **`agents/.agents/skills/<name>/SKILL.md`** (new) — mirrored copy for symlink discovery

### Invocation

Instead of `/command`, user says "run <name>" or "use the <name> skill" conversationally.
The AI loads the skill via the skill tool — instructions guide behavior without showing raw text.
The `/command` still works but now injects a single short line instead of dumping the full prompt.

## Prototype: commit

The `commit` command was converted first as a proof of concept:
- `command/commit.md`: 98 lines → 5 lines, `agent: build` removed
- `.agents/skills/commit/SKILL.md`: created with full workflow
- AGENTS.md: updated with the skill-based pattern section

## Batch Conversion (remaining 18)

The remaining prompt-dumping commands to convert:
audit, cleanup, debug, draft, explain, explore, find-docs, gen-docs, gen-gemini,
gen-test, organize, prioritize, rename, report, review-code, review-pr, summarize, whatsnew

Each follows the same pattern: create skill file + thin command file.
