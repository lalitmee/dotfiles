# Question gates (mandatory)

Every grilling node and every user decision uses the **question tool** — never bullet lists, lettered options, or open-ended chat questions.

## Hard rules

1. **One question per turn** — one decision tree node at a time.
2. **Minimum 2 options** per question; users can always pick a custom answer for free-text.
3. Put the **Recommended** choice first in the option list; append `(Recommended)` to its label.
4. Use `multiple: true` only when the decision genuinely allows multiple selections (e.g. labels, reviewers).
5. Do **not** treat free-text chat ("yes", "looks good", "use main") as resolving a node unless the user selected that option in a question tool in the same flow.
6. After the user selects an option, log **Resolved:** one-liner, then proceed to the next node.

## Option patterns by node

Map each node from [decision-tree.md](decision-tree.md) to question options. Adapt labels to audit context; keep structure stable.

| Node | Prompt (short) | Options (Recommended first) |
|------|----------------|----------------------------|
| 0 | Which repo for this PR? | `{repo A}` (Recommended) · `{repo B}` · Custom |
| 1 | One PR or split? | Single PR (Recommended) · Split into separate PRs · Custom |
| 2 | Working tree has changes — commit before PR? | Commit staged only (Recommended) · Include unstaged · Skip commit · Cancel |
| 3 | Branch is unpushed — push now? | Push now (Recommended) · Don't push yet · Cancel |
| 4 | Base branch for this PR? | `{inferred}` (Recommended) · `{alt}` · Custom |
| 5 | Draft or ready for review? | Ready for review (Recommended) · Draft PR |
| 6 | Which PR template? | `{resolved}` (Recommended) · `{other template}` · Custom |
| 7 | PR title | `{draft title ≤72 chars}` (Recommended) · Custom |
| 8 | Body section `{name}` | Accept as drafted (Recommended) · Edit this section · Skip unresolved gaps |
| 9 | Link issues? | `{suggested Fixes #N}` (Recommended) · None · Custom |
| 10 | Request reviewers? | `{codeowners}` (Recommended) · None · Custom |
| 11 | Add labels? | `{suggested}` (Recommended) · None · Custom · `multiple: true` when picking labels |
| 12 | Assignee? | None (Recommended) · Assign to me |
| 13 | Create this PR? | Create PR (Recommended) · Request edits · Cancel |

## Free-text via Custom

When the user picks **Custom**, ask for the value in the **next** turn — still via question tool when the answer is a discrete choice (e.g. base branch, title). For long prose (body section rewrite), accept chat input for that edit only, then return to question tool for the next node.

## Node #8 — body sections

Walk template sections in order. One question per section until all are accepted or explicitly skipped.

## Node #13 — final approval

Show title, base, body preview (no AI attribution), draft/reviewers/labels in the message **before** the question. Do not run Phase 5 until user selects **Create PR**.

## Red flags — STOP

- Asking "Which base branch?" in chat prose instead of question tool
- Lettered options (A/B/C) in the assistant message
- Treating "create PR" / "yes" in chat as node #13 approval
- Batching multiple decision-tree nodes in one question
- Skipping question because the answer seems obvious from git audit

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "User already said main in chat" | Still run question unless they picked it in the same question flow |
| "Body edits need conversation" | Custom → accept prose → next section via question |
| "Questions are slow" | Structured gates prevent wrong-repo push and silent PR create |
| "Only discrete choices need questions" | All nodes are decisions — question every time |
| "I'll confirm at the end" | Node #13 is a question; intermediate nodes cannot be skipped |
