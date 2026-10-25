# Brain Repositories Module

Load this only when deciding whether to save context for future work.

## When to preserve

- Preserve only what materially helps future work: durable constraints,
  consequential decisions and their rationale, recurring pitfalls, reusable
  workflows, or a handoff needed to resume unfinished work.
- Do not preserve routine edits, session narratives, raw command output,
  passing test counts, or facts easily recovered from authoritative project
  sources.
- If nothing qualifies, create no record.

## Which repository

- Personal context: `~/Projects/Personal/Github/ai-brain/`
- Work context: `~/Projects/Work/Github/cursor-brain/`
- Signals: a working directory under `~/Projects/Work` means work; under
  `~/Projects/Personal` means personal. If the signal is missing or mixed, ask.
  Never substitute another repository or create one.
- Keep work information out of the personal brain unless the user explicitly
  authorizes a specific, policy-compliant transfer.
- Resolve paths for the current machine and confirm the repository exists.

## Rules

1. **Instructions first:** Once per session, before the first brain write, read
   the selected repository's root `AGENTS.md` and any directory-level
   instructions covering the target path. Follow them for placement, naming,
   formatting, and references. Do not infer policy from existing files.
2. **Approval:** Every brain write needs explicit approval, separate from
   approval to change a project. Committing or pushing needs its own approval
   (see the Hard Rules). A standing automatic-memory permission only covers
   the scope it names.
3. **Ownership:** Specifications, plans, docs, maintained scripts, and
   verification evidence stay in the owning project. Scratch plans,
   disposable scripts, and raw results stay temporary unless the user approves
   keeping them.
4. **Content:** Explain durable context or give a concise handoff, and
   reference authoritative artifacts instead of copying them. Prefer updating
   an existing relevant record over creating a new one.
5. **Staleness:** Treat status and verification as dated observations and
   re-validate before relying on them.
6. **Reading:** Inspect relevant existing context before resuming work when it
   may affect the task. Do not scan unrelated history.
7. **Secrets:** Never store them (see the Hard Rules).
