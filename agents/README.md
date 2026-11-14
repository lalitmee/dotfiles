# Shared agent skills

Keep custom skills in `agents/.agents/skills/<name>/SKILL.md`.
The `agents` Stow package deploys these globally to `~/.agents/skills`.

Codex skips symlinked `SKILL.md` files, so this package also supplies whole
skill-directory aliases in `agents/.codex/skills`. Each alias points to
`../../.agents/skills/<name>`. When adding a shared skill, add its alias here
as well. Claude uses the aliases in `claude/.claude/skills`.

Deploy from the repository root with `stow --no-folding agents`.
The machine-installed `terminal-browser` skill is excluded; its installer
maintains provider-specific skill links.

For T3 Code, refresh the Codex provider in Settings and use **Restart agent
session** in the command palette after deployment. Skills then appear in the
`$` menu across projects on this machine. Ensure custom skills are enabled in
the machine-local `~/.codex/config.toml` skill configuration.
