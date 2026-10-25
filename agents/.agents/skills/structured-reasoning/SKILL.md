---
name: structured-reasoning
description: Use when the task is multi-constraint, ambiguous, architectural, or needs a design/algorithm choice before answering. Skip for trivial lookups and one-line edits.
---

# Structured Reasoning

Reason in four steps before answering. Precedence: user constraints > correctness > clarity > optimization.

Does not replace **diagnose** (bugs) or **karpathy-guidelines** (coding discipline).

## When / When NOT

**Use:** multi-constraint design, ambiguous requirements, architecture/algorithm choice, /structured-reasoning / "use structured reasoning", or show work / think out loud.

**Skip:** trivial lookups, renames, one-line edits, or "be thorough" on a tiny change.

## Core recipe (before every answer this skill covers)

1. **Analyze** — requirements + hidden constraints
2. **Deconstruct** — isolated sub-tasks
3. **Hypothesize** — method, algorithm, or structure
4. **Draft** — sequential build steps

Time pressure does not excuse skipping a step. Recommendation-first then backfill is not this recipe.

## Visibility

| Condition | Output |
|-----------|--------|
| Show work / reasoning / think out loud | `### Thought Process` (all 4 labeled steps) then `### Solution` |
| Explicit invoke (/structured-reasoning or clear ask) | Same visible template (invoke = show structure) |
| Auto on complex task | Run steps internally; concise answer only — no Task / Thought Process / Solution headings |

"Keep it short" after invoke shortens Solution, not the template.

## Visible template

```markdown
### Task
[Problem]

### Thought Process
1. Analyze: ...
2. Deconstruct: ...
3. Hypothesize: ...
4. Draft: ...

### Solution
[Answer matching the thought process]
```

## Common mistakes

| Excuse | Reality |
|--------|---------|
| "Just pick something — meeting started" | Run all 4 steps; shorten Solution |
| "Thinking out loud" without labels | Show-work / invoke needs the template |
| "Be thorough" on a rename | Skip skill; ship the one-liner |
| "Keep it short" after invoke | Short Solution; still emit template |
| Recommendation then rationale | Recipe first, then Solution |
