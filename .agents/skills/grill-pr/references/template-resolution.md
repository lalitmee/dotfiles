# PR template resolution

Run during Phase 2, **before** drafting the PR body. Never skip to a hardcoded body.

## Discovery order

Check all GitHub-supported paths in the **target repo** (parallel glob/read):

| Path | Notes |
|------|-------|
| `.github/pull_request_template.md` | Most common |
| `.github/PULL_REQUEST_TEMPLATE.md` | Alternate casing |
| `.github/PULL_REQUEST_TEMPLATE/*.md` | Multiple templates |
| `pull_request_template.md` (repo root) | Legacy |
| `docs/pull_request_template.md` | Docs placement |

### gh API fallback

When local read fails (wrong cwd, sparse checkout):

```bash
gh api "repos/{owner}/{repo}/contents/.github/pull_request_template.md" --jq .content 2>/dev/null | base64 -d
```

Try alternate paths if 404.

## Outcomes

| Result | Action |
|--------|--------|
| **One template** | Use as body scaffold; preserve headings, checklists, HTML comments |
| **Multiple templates** | Grilling — ask which applies; do not mix sections |
| **None found** | Use [default-pr-template.md](default-pr-template.md) |

## Filling repo templates

- Keep section structure intact.
- Replace placeholder prompts with content from full diff analysis.
- UI diffs: populate Screenshots section or state `N/A — no UI change`.

## gh CLI note

`gh pr create` does **not** auto-apply GitHub repo templates. Read the template file and pass `--body` explicitly.

## Report in Preflight summary

```text
Template: .github/pull_request_template.md (repo)
```

or

```text
Template: default fallback (no repo template found)
```
