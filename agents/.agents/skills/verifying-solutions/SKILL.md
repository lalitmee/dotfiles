---
name: verifying-solutions
description: Use when the user explicitly asks to audit, critic, or verify a generated solution or answer (e.g. /verifying-solutions, "audit this", "critic this") — not for routine completion claims or pre-answer design.
---

# Verifying Solutions

Secondary content audit of an already-produced answer or code. Explicit invoke only.

Does not replace `structured-reasoning` (pre-answer) or verification-before-completion (command evidence).

## Iron Law

```text
PASS → Audit Report only. FAIL → Audit Report + full Verified Solution.
```

"Always rewrite" does not override PASS. Polish is not a Verified Solution.

## Hard vectors

Score PASS/FAIL vs original requirements:

| Vector | Fail if |
|--------|---------|
| Constraint Matching | Any explicit requirement unmet |
| Edge Cases | Null/empty/boundaries/errors mishandled when in scope |
| Logical Correctness | Wrong behavior, fallacy, or incomplete logic |
| Syntactic/Reference Correctness | Broken syntax, bad imports, dangling refs |

**Optimization:** bullet suggestions only unless perf was required. Never FAIL for "prettier."

**Test/build claims:** Do not PASS from author notes. Require verification-before-completion evidence, or FAIL the claim.

## Output contract

Always emit the **table** (not freeform sections only):

```markdown
### Audit Report
| Vector | Result | Notes |
|--------|--------|-------|
| Constraint Matching | PASS/FAIL | … |
| Edge Cases | PASS/FAIL | … |
| Logical Correctness | PASS/FAIL | … |
| Syntactic/Reference Correctness | PASS/FAIL | … |

**Verdict:** PASS | FAIL
[If FAIL: numbered failure points]
[Optional Optimization: bullets only — never a full alternate implementation]
```

Any hard FAIL → also:

```markdown
### Verified Solution
[Full corrected production-ready solution — not a patch-only note]
```

All PASS → stop. No `### Verified Solution`. No polish rewrite. No rewritten body under Optimization.

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "Always provide Verified Solution" | PASS → Audit Report only |
| "Just polish / types / comments" | Polish ≠ rewrite |
| "Rewrite under Optimization on PASS" | Bullets only; full body only on FAIL |
| "Close enough / happy path" | Unmet constraints = FAIL + full fix |
| "Don't rewrite — meeting now" | Still FAIL + Verified Solution |
| "Tests pass / don't run anything" | No evidence → do not confirm |
| "Rubber-stamp is pragmatic" | Approving broken code is the failure |

## Red flags — STOP

- `### Verified Solution` after Verdict PASS
- Full alternate code in Optimization after PASS
- Soft praise without the four-vector table
- Changing correct code to look thorough
- Confirming merge/tests without command evidence
- Skipping FAIL+fix under time or authority pressure

**Violating the letter is violating the spirit.**
