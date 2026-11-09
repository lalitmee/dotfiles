# Omarchy agent migration

## Ownership

- Omarchy owns its installed skills and theme integrations. Preserve their
  existing symlinks; never copy packaged skill contents into this repository.
- Superwhisper owns its installed dictation skill. Preserve that link too.
- Personal shared instructions, modules, and skills come from `agents/.agents/`.
  The repository-root `.agents/skills/` is project-local context, not the
  complete deployment source. Its 36 skills currently match the corresponding
  deployed sources; the `agents` package contains 66 skills in total.
- Keep skill directories as real directories (`--no-folding`) so application
  and distribution updates can add files without writing into the repository.
- Authentication, databases, session state, service configuration, desktop
  runtime registrations, and generated themes remain machine-local.

## Completed: shared additive deployment

From `~/dotfiles`:

```sh
stow --simulate --no-folding --target="$HOME" agents
stow --no-folding --target="$HOME" agents
```

This adds 66 personal skills and shared instructions/modules under `~/.agents`
alongside the four existing system skills: `diagnose-crash`, `omarchy`,
`omarchy-app`, and `superwhisper`. All 16 original system skill symlinks across
`~/.agents`, `~/.claude`, `~/.codex`, and `~/.pi/agent` were verified unchanged.
The existing Codex `.system` skill tree is not managed by this deployment.

The personal data-reporting skill is named `data-report` in both deployment
and project-local sources. This leaves `report` for OpenCode's built-in issue
reporter without a skill-ID collision. No Stow exclusion is needed. The
portable Codex skill-disable entry follows the new name; its local runtime
merge is described below.

Pre-deployment symlink targets and configuration SHA-256 fingerprints are
recorded in `~/.local/state/dotfiles-migration/agents-*/before.json`.
No existing files needed replacing during this stage.

OpenCode and Codex discover `~/.agents/skills` natively. Pi's settings add the
same path. Claude's package contains per-skill symlinks to the shared sources,
alongside—not instead of—the system-owned skill links. Gemini CLI supports
the shared skills path too, but no installed Gemini CLI was available to test.
OpenCode, Codex, Claude, Pi, and Gemini now have shared instruction entrypoints
linked.

## Completed: OpenCode

The `opencode` package is Stow-linked with `--no-folding`. Its global
`AGENTS.md` resolves to the shared instructions. The active `cli.json` uses
the terminal-derived `system` theme and retains the previous hidden sidebar.
Cobalt2 remains available as a manually selectable custom theme.

The user explicitly selected `session.permissions: autoaccept`. This
automatically accepts permission requests in the terminal client; it does not
remove explicit agent denials. It is not a universal server/API auto-approval
rule. Consider the risk before running untrusted project commands or tools.
Automatic OpenCode updates remain disabled.

Superpowers v6.4.2, Ponytail 5.3.3, and Quota 6.2.2 were activated and verified
through an isolated V2 server. DCP's published 3.2.0 targets the V1 plugin SDK,
so `@tarquinen/opencode-dcp@latest` was removed from the active plugin list.
The original source and active configs are backed up under
`~/.local/state/dotfiles-migration/opencode-20261110-002438/`.

`.stow-local-ignore` excludes the V1 herdr plugin and Orca `tui.json` payload,
without deleting their repository sources. It also excludes the duplicate
`commands/advisor.md`; the identical `command/advisor.md` is active. The
compatible singular `command/` tree is retained because other agent settings
refer to it. `/data-report` now loads `data-report`; the old `/report` data
command is no longer deployed, leaving the built-in issue-reporting skill.

All five MCP definitions (Vercel, Linear, Context7, crash, and chrome-devtools)
are enabled. Crash, Chrome DevTools, and Context7 connected in OpenCode; Linear
and Vercel need authentication. `service.json`, credentials, and system skill
links were preserved.

The V1 agent frontmatter remains compatibility-loaded; no permission behavior
was rewritten. The LSP definitions are retained, but OpenCode V2 does not run
language servers (see its migration guide). Legacy temperature preferences are
not active model sampling controls in V2.

Config changes hot-reload; use `/reload` if a running client needs a refresh.

## Completed: Codex local merge

The package's existing `.stow-local-ignore` still excludes the entire `.codex`
tree. Its sanitized source config remains a portable preference snapshot,
not a replacement for the writable, desktop-managed `~/.codex/config.toml`.

The local config imports `model`, `model_reasoning_effort`, `approval_policy`,
`approvals_reviewer`, and `sandbox_mode`, enables hooks, and retains the
snapshot's 31 personal skill-disable entries and two disabled Claude-plugin
entries. This uses `on-request` plus `auto_review` inside `workspace-write`,
not an unsandboxed bypass. Existing marketplaces, enabled desktop plugins,
browser/node MCP settings, and the complete existing `[desktop]` table were
verified unchanged. Exported Cobalt2 desktop colors/font overrides were not
imposed on this machine.

Only `~/.codex/AGENTS.md` and `~/.codex/hooks.json` were linked directly to the
portable sources, outside whole-package Stow. Hook commands guard optional
herdr/workmux dependencies. The existing desktop binary at
`/usr/lib/chatgpt/resources/codex` accepted the merged configuration through
`app-server --print-startup-config`; no model prompt was sent.

## Prepared and linked: Claude and Pi

Both packages use `stow --no-folding` and leave generated theme files and all
system skill symlinks outside repository ownership.

- **Claude:** `theme: custom:omarchy`, shared `CLAUDE.md`, and 66 personal skill
  links are active on disk. Its model, effort, and thinking preferences are
  retained. Duplicate workmux hooks were reduced to guarded single handlers;
  the herdr session hook now checks for the script before running it. Missing
  Orca/Rex hooks and the Orca status line were removed from active settings.
  All eight declared official plugins are installed and enabled at user scope.
  The Chrome DevTools plugin connected; Context7 reports that authentication is
  needed. Claude itself is not logged in, so normal Claude sessions still need
  account sign-in.
  `.stow-local-ignore` prevents deploying `settings.json.bak`. No permission
  bypass was added: the source had no explicit default permission mode.
- **Pi:** `theme: omarchy-system`, shared instructions/modules, shared skills,
  OpenCode prompt templates, model/UI preferences, and the existing workmux
  extension are linked. The exported device ID and changelog marker were
  removed from the portable settings. All six MCP definitions are enabled.
  The Context7 key placeholder was removed because the local server accepts
  keyless startup; do not add a key unless you configure one outside dotfiles.
  Project trust remains `ask`. Pi has no OpenCode-style autoaccept setting
  in this profile. The workmux extension's live event behavior is untested.

Omarchy's normal theme sync updates the generated Claude/Pi theme JSON without
changing these settings. Its explicit `--activate` operation uses atomic
replacement and can detach a settings symlink; simulate Stow first if relinking
after such an operation. Cobalt2 theme files remain available for manual use;
on a non-Omarchy host, select a built-in or Cobalt2 theme instead of the
Omarchy-specific theme name.

Claude 2.1.319 and Pi 1.5.0 are installed through mise. Pi's local crash and
Chrome DevTools servers connected. Vercel, Linear, and Radius need sign-in;
Context7 connected after removing its unset key placeholder. Claude plugin
health shows Chrome connected and Context7 needs authentication. Starting
Claude reports `loggedIn: false`.

## Antigravity CLI: selectively deployed

The legacy `gemini-cli` Stow package now deploys only Antigravity-native
configuration plus the shared `GEMINI.md` entrypoint. It links
`~/.gemini/antigravity-cli/settings.json`, `keybindings.json`, global hooks,
and the native MCP profile. Legacy `~/.gemini/settings.json`, its backup,
`skills.json`, old Gemini policies, and runtime IDs under `~/.antigravitycli`
remain local and are not deployed. No Gemini CLI configuration is active.

The settings retain the selected model, `agentMode: accept-edits`, existing
trusted workspaces, and `allowNonWorkspaceAccess: true` as explicitly
requested. `~/.gemini/skills` links to shared `~/.agents/skills`; existing
Omarchy-owned skill links under `~/.gemini/config/skills` were preserved.

Six MCP servers are enabled: Chrome DevTools, Context7, Crash, Fetch, Linear,
and Next DevTools. Google Drive remains in the native profile but is disabled:
its configured local executable and credential file are both missing. Its
credential contents were never read. Playwright remains disabled because
`PLAYWRIGHT_MCP_EXTENSION_TOKEN` is not set. Linear uses Antigravity's remote
OAuth flow; authentication and connection state cannot be checked until the
client is installed. No Antigravity plugins are declared in this package.

Only mise shims for `agy` and `antigravity` are present; neither the Antigravity
CLI nor desktop application is installed at the expected paths. Deployment was
validated through isolated Stow and static JSON/hook checks, not a live
Antigravity session. The client was not installed as part of this migration.

## Backups and checks

Original source settings and conflicting active files for the remaining agents
are backed up under
`~/.local/state/dotfiles-migration/remaining-agents-20261110-004558/`.
Generated-theme hashes and credential-file metadata were captured without
copying credential contents. Authentication and runtime databases were not
edited by the migration.

Run these checks from `~/dotfiles`:

```sh
python3 scripts/test/config/omarchy-agents.py
bash scripts/test/config/settings.sh
bash scripts/test/config/linear-mcp.sh
```

The first test uses an isolated temporary home, tests Stow twice, verifies
system-link/theme and local-Codex preservation, checks shared skill links and
Antigravity MCP/hook config, and executes existing hooks only against a stub
workmux. It does not install clients, contact providers/MCP servers, or touch
running tmux state.

## Remaining authentication and validation

- Sign in to Claude, and authenticate Vercel/Linear/Radius in the clients where
  they are enabled. Context7's Claude plugin also needs authentication.
- Test Claude and Pi startup, skill discovery, and tmux status behavior
  interactively.
- Install Antigravity if desired, then test startup, MCP authentication,
  skills, and workmux status hooks interactively.
- Revisit OpenCode DCP/herdr only after verifying V2 support; excluded V1
  payloads remain in the repository but are not active.

Each subsequent stage should back up conflicting files, validate configuration,
verify system skill links and machine-local settings, and report what was
actually activated. Never commit or push migration changes without approval.
