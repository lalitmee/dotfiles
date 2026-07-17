# Default PR template (fallback)

Use **only** when [template-resolution.md](template-resolution.md) finds no repo template.

## Sources (research)

| Source | Pattern |
|--------|---------|
| [GitHub Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository) | Description, related issues, @mentions |
| [google/nearby](https://github.com/google/nearby/blob/main/.github/PULL_REQUEST_TEMPLATE.md) | Summary + How did you test |
| [android/nowinandroid](https://github.com/android/nowinandroid/blob/main/.github/pull_request_template.md) | What/why + testing instructions |
| Industry consensus | **5 sections max**; short or developers delete the template |

**Maintenance:** Do not web-search per PR. Re-research only when user says `refresh PR template` or during skill updates.

## Template (copy into `--body`)

```markdown
## Summary
<!-- What changed and why (1-3 bullets) -->

## Type of change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactor / chore
- [ ] Docs / tests only

## Test plan
- [ ] <!-- Steps reviewers can replay to verify -->

## Related issues
<!-- Fixes #123, Closes PROJ-456 -->

## Checklist
- [ ] Self-reviewed the diff
- [ ] Tests added or updated (or N/A with reason)
- [ ] Docs updated (or N/A)
```

## Filling rules

- Replace HTML comments with draft content from `git diff [base]...HEAD`.
- Tick checkboxes only when the diff clearly supports it; leave unchecked with `[NEEDS INPUT]` otherwise.
- Pick one **Type of change** checkbox when obvious from diff/commits.
- **Never** append AI attribution lines. Remove if copied from an old PR or tool output.
