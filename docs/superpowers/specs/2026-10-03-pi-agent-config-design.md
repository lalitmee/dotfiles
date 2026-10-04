# Pi Agent Configuration & Dotfiles Integration Design

**Date**: 2026-10-03  
**Status**: Approved  
**Topic**: Pi Agent Configuration and Parity with OpenCode & Gemini  

---

## 1. Overview & Goals

The user uses multiple agentic coding assistants across their terminal workflows:
- **Gemini / Antigravity CLI** (`gemini-cli/.gemini/`)
- **OpenCode** (`opencode/.config/opencode/`)
- **Pi Agent** (`@earendil-works/pi-coding-agent`, `~/.pi/agent/`)

The goal is to bring **Pi Agent** into the dotfiles management workflow alongside OpenCode and Gemini, ensuring:
1. Dotfiles modularity via GNU Stow (`pi/.pi/agent/`).
2. Unified theming using the user's preferred **Cobalt2** palette.
3. Full access to the existing 58 agent skills in `~/.agents/skills`.
4. Sharing of 30+ slash commands from `~/.config/opencode/command` without duplication.
5. Persistent global directives via `APPEND_SYSTEM.md`.
6. Full tmux modified key compatibility (`extended-keys on`, `extended-keys-format csi-u`).

---

## 2. Directory Layout & Stow Package

A new GNU Stow package `pi` will be introduced at the root of `~/dotfiles`:

```text
dotfiles/
├── pi/
│   └── .pi/
│       └── agent/
│           ├── settings.json
│           ├── APPEND_SYSTEM.md
│           └── themes/
│               └── cobalt2.json
```

### Stowing Strategy
- `~/.pi/agent` holds local runtime and authentication state (`auth.json`, `install/`, `sessions/`, `models-store.json`, `bin/`).
- Existing `~/.pi/agent/settings.json` (auto-generated 4-line stub) will be backed up / replaced by the stowed link.
- GNU Stow (`stow -v pi`) will link:
  - `~/.pi/agent/settings.json` &rarr; `dotfiles/pi/.pi/agent/settings.json`
  - `~/.pi/agent/APPEND_SYSTEM.md` &rarr; `dotfiles/pi/.pi/agent/APPEND_SYSTEM.md`
  - `~/.pi/agent/themes/` &rarr; `dotfiles/pi/.pi/agent/themes/`
- Local credentials (`auth.json`) and session logs remain uncommitted and intact.

---

## 3. Configuration Specification

### `pi/.pi/agent/settings.json`

```json
{
  "theme": "cobalt2",
  "skills": [
    "~/.agents/skills"
  ],
  "prompts": [
    "~/.config/opencode/command"
  ],
  "defaultTools": [
    "read",
    "bash",
    "edit",
    "write"
  ],
  "enableSkillCommands": true,
  "tuiMode": "fullscreen",
  "quietStartup": "header",
  "autocompleteMaxVisible": 8,
  "terminal": {
    "trueColor": true,
    "showImages": true
  },
  "defaultProjectTrust": "ask",
  "retry": {
    "enabled": true,
    "maxRetries": 3
  }
}
```

### Key Field Responsibilities:
- `theme`: Points to the new custom `cobalt2` theme.
- `skills`: Recursively discovers the 58 skills in `~/.agents/skills` per the Agent Skills spec.
- `prompts`: Loads existing Markdown command templates from OpenCode as slash commands.
- `defaultTools`: Standard read, bash, edit, write toolset.
- `tuiMode` & `quietStartup`: Clean fullscreen interface.

---

## 4. Theme Specification (`cobalt2.json`)

File path: `pi/.pi/agent/themes/cobalt2.json`

Conforms to Pi's theme schema (`https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json`), matching the user's `cobalt2-custom.json` from OpenCode:

```json
{
  "$schema": "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
  "name": "cobalt2",
  "appearance": "dark",
  "vars": {
    "cobaltBg": "#193549",
    "cobaltSubtleBg": "#0e4062",
    "cobaltSelectedBg": "#185294",
    "text": "#FFFFFF",
    "muted": "#9E9E9E",
    "dim": "#626262",
    "yellow": "#FFC600",
    "blue": "#00AAFF",
    "lightBlue": "#80FCFF",
    "orange": "#FF9D00",
    "green": "#3AD900",
    "red": "#FF628C",
    "purple": "#967EFB"
  },
  "colors": {
    "accent": "blue",
    "border": "blue",
    "borderAccent": "yellow",
    "borderMuted": "dim",
    "success": "green",
    "error": "red",
    "warning": "yellow",
    "muted": "muted",
    "dim": "dim",
    "text": "text",
    "thinkingText": "muted",
    "selectedBg": "cobaltSelectedBg",
    "scrollbarTrack": "cobaltSubtleBg",
    "scrollbarThumb": "blue",
    "searchMatchBg": "cobaltSelectedBg",
    "searchMatchText": "yellow",
    "userMessageBg": "cobaltSubtleBg",
    "userMessageText": "text",
    "customMessageBg": "cobaltSubtleBg",
    "customMessageText": "muted",
    "customMessageLabel": "purple",
    "toolPendingBg": "cobaltSubtleBg",
    "toolSuccessBg": "#1f553a",
    "toolErrorBg": "#441b2f",
    "toolTitle": "text",
    "toolOutput": "muted",
    "mdHeading": "yellow",
    "mdLink": "lightBlue",
    "mdLinkUrl": "muted",
    "mdCode": "orange",
    "mdCodeBlock": "green",
    "mdCodeBlockBorder": "dim",
    "mdQuote": "muted",
    "mdQuoteBorder": "blue",
    "mdHr": "dim",
    "mdListBullet": "yellow",
    "toolDiffAdded": "green",
    "toolDiffRemoved": "red",
    "toolDiffContext": "muted",
    "syntaxComment": "muted",
    "syntaxKeyword": "blue",
    "syntaxFunction": "yellow",
    "syntaxVariable": "lightBlue",
    "syntaxString": "green",
    "syntaxNumber": "orange",
    "syntaxType": "purple",
    "syntaxOperator": "text",
    "syntaxPunctuation": "text",
    "thinkingOff": "dim",
    "thinkingMinimal": "muted",
    "thinkingLow": "blue",
    "thinkingMedium": "purple",
    "thinkingHigh": "orange",
    "thinkingXhigh": "red",
    "thinkingMax": "red"
  }
}
```

---

## 5. System Instructions (`APPEND_SYSTEM.md`)

File path: `pi/.pi/agent/APPEND_SYSTEM.md`

```markdown
# User Directives & Preferences

## Core Directives
1. **Confirmation Before Changes**: Always explain proposed changes and ask for explicit user confirmation before modifying or creating files in any project.
2. **Never Auto-Commit**: Do not commit or push changes without explicit user approval.
3. **Iterative Problem-Solving**: Prefer an iterative approach—start with the simplest workable solution and refine it, rather than over-engineering upfront.
4. **Syntax Verification**: Always verify code syntax immediately after making changes to prevent regressions.

## Coding & Tooling Preferences
- **Package Management**: Prefer `yarn` over `npm` whenever JavaScript/Node package management is required.
- **Shell Scripts**: Use fold markers for functions in shell scripts (`# {{{ function_name` and `# }}}`).
- **Dotfiles & Symlinks**: The user's dotfiles are managed via GNU Stow. Never execute `./install.sh` without explicit user confirmation.
- **Git Commits**: Follow Conventional Commits format (`type(scope): description` in imperative lowercase).
```

---

## 6. Tmux Optimization

File path: `tmux/.tmux.conf.local`

Under `# -- user customizations`:
```tmux
# enable extended keys (kitty keyboard protocol / modified Enter keys)
set -g extended-keys on
set -g extended-keys-format csi-u
```

---

## 7. Verification & Testing

1. Validate JSON syntax of `settings.json` and `cobalt2.json` with `jq`.
2. Stow `pi` package via `stow -v pi` and verify links with `ls -la ~/.pi/agent/`.
3. Check Pi command and skill discovery (`pi list`).
4. Reload tmux config and verify `tmux show-options -g extended-keys` and `tmux show-options -g extended-keys-format`.
