# Excalidraw diagrams

Project-neutral Excalidraw design and review skill for personal and work diagrams. It covers a shared visual system, state machines, flowcharts, architecture, sequence diagrams, persistent arrow attachment, and migration of existing scenes.

## Prerequisites

- An agent that supports `SKILL.md` and an Excalidraw MCP or editor.
- Python 3 for the bundled structural validator and pilot builder.
- An interactive Excalidraw editor for drag/resize/reopen verification.

No production domain behavior is encoded in the pilot examples.

## Installation

Use one installed copy per agent. The personal source is `~/dotfiles/skills/excalidraw-diagrams`; `nes-cursor-brain/skills/excalidraw-diagrams` is a distributable mirror. When changing either copy, deliberately synchronize the entire folder and compare it; neither repository auto-updates the other.

For this machine, directory links in `~/.codex/skills/excalidraw-diagrams` and `~/.cursor/skills/excalidraw-diagrams` point to the dotfiles source. Codex's cross-runtime alias `~/.agents/skills/excalidraw-diagrams` points to the same folder. Keep `SKILL.md` a regular file inside the linked directory. The dotfiles `agents` package carries skill-directory aliases and the `cursor` package carries its skill/rule aliases. Do not run the interactive dotfiles installer for this skill.

For an independent installation from either repository:

```zsh
mkdir -p ~/.codex/skills ~/.cursor/skills
cp -R skills/excalidraw-diagrams ~/.codex/skills/excalidraw-diagrams
cp -R skills/excalidraw-diagrams ~/.cursor/skills/excalidraw-diagrams
```

Use `~/.agents/skills/` instead of a second Codex copy when that is the configured skills home. Optional Claude Code target: `~/.claude/skills/excalidraw-diagrams/`.

The bundled `excalidraw-diagrams.mdc` is an intent-based Cursor routing rule. Copy it to `~/.cursor/rules/` or a project's `.cursor/rules/`; it loads the skill rather than duplicating the design system. Codex uses skill description discovery or an explicit `$excalidraw-diagrams` invocation. Reload the agent session if a newly installed skill does not appear.

## Usage

```text
Use $excalidraw-diagrams to create an illustrative payment state machine.
Restyle this .excalidraw file, preserving its logic and repairing detached arrows.
Review this diagram's decisions, readability, and persistent arrow bindings.
```

Start with [SKILL.md](SKILL.md). The [review checklist](references/review-checklist.md) separates model correctness, static bindings, visual inspection, and actual movement verification.

## Pilots and components

Each pilot has an editable native `.excalidraw` file and a simplified `.mcp.json` array for `create_view`. The `.svg` previews are deterministic schematics; `.rendered.svg` and `.rendered.png` are exports from the installed Excalidraw renderer. The native file owns editable bindings. Rebuilding pilots does not refresh renderer exports: regenerate those in the target editor after changing scene geometry.

- [Payment state machine](examples/payment-state-machine.excalidraw)
- [Approval flow](examples/approval-flow.excalidraw)
- [Service architecture](examples/service-architecture.excalidraw)
- [Component library](assets/components.excalidrawlib)

```zsh
python3 scripts/validate_scene.py --self-test
python3 scripts/validate_scene.py examples/*.excalidraw
python3 scripts/build_pilots.py
```

Run from this skill directory. The builder regenerates illustrative pilots; it does not modify unrelated diagrams. Static validation does not establish drag behavior. See [binding guidance](references/mcp-bindings.md) for adapter limits and [sources](references/libraries.md#sources) for design references.
