# OpenCode V2 Plugin Migration Design

## Goal

Port Ponytail and Workmux's OpenCode plugins to OpenCode V2 and keep the fixed
versions in personal forks under the `lalitmee` GitHub account for the user's
own use. Upstream pull requests are out of scope. Update this dotfiles
repository's global OpenCode configuration to use V2 plugin configuration and
keep the Herdr integration disabled without modifying its installer-managed
plugin file.

## Current context

- OpenCode is running V2 (currently observed as v2.0.18).
- The dotfiles config is `opencode/.config/opencode/opencode.json`, currently
  using the V1 `plugin` property and listing Superpowers, DCP, and Ponytail.
- Workmux's local plugin is `opencode/.config/opencode/plugins/workmux-status.ts`.
- Herdr's local integration is
  `opencode/.config/opencode/plugins/herdr-agent-state.js`. Its header states
  that Herdr manages and overwrites it during installation; it must not be
  edited or removed as part of this work.
- The current Ponytail release and Workmux's upstream OpenCode plugin still use
  the V1 plugin API. They need V2 ports rather than configuration-only changes.
- Herdr is excluded from the porting/forking scope. Its V2 plugin identity must
  be verified before adding a disable rule to the configuration.

## Design

### Repositories and delivery

Maintain personal forks of the Ponytail and Workmux repositories under
`lalitmee`, cloned under `~/Projects/Personal/Github/`. Keep each port on its
own dedicated branch in its respective fork. Each branch should contain only
the changes needed to make that plugin work on V2 while preserving its existing
behavior. These fixes are for the user's own use; do not prepare or submit
upstream pull requests. Ask before pushing local branch changes to GitHub.
Do not commit unrelated changes or combine the two ports into one branch.

### V2 plugin ports

- **Ponytail:** migrate its OpenCode entrypoint and hooks from the V1 plugin API
  to the V2 plugin API. Preserve Ponytail's existing supported behavior and
  keep changes within the OpenCode integration.
- **Workmux:** migrate the upstream OpenCode status plugin from the V1 factory
  and returned event hook to the V2 plugin API. Preserve status aggregation,
  waiting/working/done behavior, session handling, and best-effort Workmux CLI
  integration.
- Verify each port against the V2 plugin documentation and the actual current
  upstream source before implementation. Keep plugin-specific tests and
  validation in the corresponding fork.

### Dotfiles configuration and Herdr

Convert the existing OpenCode configuration's plugin-list field to the V2
`plugins` field while preserving all currently configured plugins and unrelated
settings. Add a V2 disable rule for the verified Herdr plugin ID. Do not change
the Herdr-managed JavaScript file or uninstall Herdr. Determine and validate
the actual plugin ID from V2 plugin discovery/identity before writing the
disable rule; the filename alone is not authoritative.

The local Workmux plugin should track the V2-compatible upstream implementation
in a way consistent with the existing dotfiles layout. This design does not
authorize running `./install.sh`; repository guidance forbids that without
explicit confirmation. Any required live-runtime reload or test should use the
normal OpenCode V2 mechanism and avoid changing unrelated machine state.

## Validation and acceptance criteria

1. Ponytail's V2 plugin loads and retains the behavior covered by its existing
   tests or documented integration behavior.
2. Workmux's V2 plugin loads, registers its agent when possible, and reports
   aggregate status correctly across parent/child sessions, waiting states,
   stale busy events, and deleted sessions.
3. The dotfiles OpenCode config is valid V2 configuration, preserves unrelated
   settings and configured plugins, and does not load Herdr.
4. The Herdr installer-managed file remains unchanged.
5. Each personal fork has an isolated V2 port branch with changes suitable for
   the user's own use.
6. No upstream PR is prepared or opened. Do not push or commit without the
   user's explicit authorization, consistent with repository guidance.

## Out of scope

- Porting Herdr's plugin to V2.
- Editing, deleting, or replacing the Herdr installer-managed plugin file.
- Reworking unrelated OpenCode configuration, agents, MCP servers, or dotfiles.
- Installing or updating unrelated dependencies, running the dotfiles
  installer, or making unrequested upstream changes.

## References

- OpenCode V2 migration guide: <https://opencode.ai/v2/docs/migrate-v1>
- OpenCode V2 plugin migration: <https://opencode.ai/v2/docs/build/plugins/migrate-v1>
- OpenCode V2 plugin guide: <https://opencode.ai/v2/docs/build/plugins>
- OpenCode V2 plugin configuration: <https://opencode.ai/v2/docs/plugins>
- Ponytail plugin source:
  <https://raw.githubusercontent.com/DietrichGebert/ponytail/main/.opencode/plugins/ponytail.mjs>
- Workmux plugin source:
  <https://raw.githubusercontent.com/raine/workmux/main/resources/opencode/plugins/workmux-status.ts>
- Herdr integration documentation:
  <https://github.com/herdrdev/herdr/blob/master/docs/versions/0.8.0/website/src/content/docs/integrations.mdx>
