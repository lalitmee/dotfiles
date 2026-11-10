#!/usr/bin/env python3
"""Check selective agent deployment without changing the real home directory."""

import json
import os
from pathlib import Path
import subprocess
import tempfile


repo = Path(__file__).resolve().parents[3]
with tempfile.TemporaryDirectory(prefix="agent-configs-", dir="/tmp/opencode") as tmp:
    home = Path(tmp)
    system_skill = home / "system-skill"
    system_skill.mkdir()
    (system_skill / "SKILL.md").write_text("System-owned skill\n")
    protected_links = []
    for directory in [".agents/skills", ".claude/skills", ".codex/skills", ".pi/agent/skills", ".gemini/config/skills"]:
        root = home / directory
        root.mkdir(parents=True)
        for name in ["omarchy", "omarchy-app", "diagnose-crash", "superwhisper"]:
            link = root / name
            link.symlink_to(system_skill, target_is_directory=True)
            protected_links.append(link)

    protected_files = {
        ".codex/config.toml": "# desktop-managed local settings\n",
        ".claude/themes/omarchy.json": '{"name":"Omarchy"}\n',
        ".pi/agent/themes/omarchy-system.json": '{"name":"Omarchy"}\n',
    }
    for name, content in protected_files.items():
        path = home / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    command = [
        "stow", "--no-folding", f"--dir={repo}", f"--target={home}",
        "agents", "claude", "codex", "pi", "gemini-cli", "opencode",
    ]
    for _ in range(2):
        subprocess.run(command, check=True)

    for link in protected_links:
        assert link.is_symlink() and link.readlink() == system_skill, link
    for name, content in protected_files.items():
        assert (home / name).read_text() == content, name
    for name in [".claude/CLAUDE.md", ".pi/agent/AGENTS.md", ".gemini/GEMINI.md", ".gemini/antigravity-cli/settings.json"]:
        assert (home / name).is_file(), name
    assert not (home / ".claude/settings.json.bak").exists()
    assert not (home / ".gemini/settings.json").exists()
    assert not (home / ".gemini/policies").exists()
    assert not (home / ".gemini/config/skills.json").exists()
    assert not (home / ".gemini/config/hooks.json.bak").exists()
    assert not (home / ".codex/AGENTS.md").exists()

    for skill in (repo / "agents/.agents/skills").iterdir():
        source = skill / "SKILL.md"
        if source.is_file():
            deployed = home / ".claude/skills" / skill.name / "SKILL.md"
            assert deployed.resolve() == source.resolve(), skill.name
            antigravity_skill = home / ".gemini/skills" / skill.name / "SKILL.md"
            assert antigravity_skill.resolve() == source.resolve(), skill.name

    claude = json.loads((home / ".claude/settings.json").read_text())
    pi = json.loads((home / ".pi/agent/settings.json").read_text())
    mcp = json.loads((home / ".pi/agent/mcp.json").read_text())
    assert claude["theme"] == "custom:cobalt2"
    assert (home / ".claude/themes/cobalt2.json").is_file()
    assert all(claude["enabledPlugins"].values())
    assert "statusLine" not in claude
    assert pi["theme"] == "cobalt2"
    assert (home / ".pi/agent/themes/cobalt2.json").is_file()
    cli = json.loads((home / ".config/opencode/cli.json").read_text())
    assert cli["theme"]["name"] == "cobalt2-custom"
    assert (home / ".config/opencode/themes/cobalt2-custom.json").is_file()
    # Removing optional machine themes must not affect portable selection.
    for name in [".claude/themes/omarchy.json", ".pi/agent/themes/omarchy-system.json"]:
        (home / name).unlink()
    subprocess.run(command, check=True)
    assert not (home / ".claude/themes/omarchy.json").exists()
    assert not (home / ".pi/agent/themes/omarchy-system.json").exists()
    assert "deviceId" not in pi and "lastChangelogVersion" not in pi
    assert all(server["enabled"] is True for server in mcp["mcpServers"].values())
    opencode = json.loads((home / ".config/opencode/opencode.json").read_text())
    assert all(server.get("disabled", False) is False for server in opencode["mcp"]["servers"].values())
    antigravity = json.loads((home / ".gemini/antigravity-cli/settings.json").read_text())
    antigravity_mcp = json.loads((home / ".gemini/config/mcp_config.json").read_text())["mcpServers"]
    json.loads((home / ".gemini/config/hooks.json").read_text())
    json.loads((home / ".gemini/antigravity-cli/keybindings.json").read_text())
    assert antigravity["agentMode"] == "accept-edits"
    assert antigravity["allowNonWorkspaceAccess"] is True
    assert antigravity["trustedWorkspaces"]
    assert set(antigravity_mcp) == {
        "chrome-devtools", "context7", "crash", "fetch", "google-drive",
        "linear", "next-devtools", "playwright",
    }
    assert antigravity_mcp["google-drive"]["disabled"] is True
    assert antigravity_mcp["playwright"]["disabled"] is True
    assert antigravity_mcp["linear"]["serverUrl"] == "https://mcp.linear.app/mcp"
    assert {name for name, server in antigravity_mcp.items() if not server.get("disabled", False)} == {
        "chrome-devtools", "context7", "crash", "fetch", "linear", "next-devtools",
    }
    assert all(link.is_symlink() and link.readlink() == system_skill for link in protected_links)

    bin_dir = home / "bin"
    bin_dir.mkdir()
    workmux = bin_dir / "workmux"
    workmux.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$HOOK_LOG"\n')
    workmux.chmod(0o755)
    env = os.environ | {
        "HOME": str(home), "PATH": f"{bin_dir}:/usr/bin:/bin",
        "HOOK_LOG": str(home / "hook.log"),
    }
    codex = json.loads((repo / "codex/.codex/hooks.json").read_text())
    antigravity_hooks = json.loads((home / ".gemini/config/hooks.json").read_text())
    for definition in antigravity_hooks.values():
        for event, groups in definition.items():
            for group in groups:
                for hook in group.get("hooks", [group]):
                    subprocess.run(["/bin/bash", "-n", "-c", hook["command"]], check=True)
    for config in [claude, codex]:
        for groups in config["hooks"].values():
            commands = [hook["command"] for group in groups for hook in group["hooks"]]
            assert len(commands) == len(set(commands)), commands
            for hook in commands:
                assert ".orca/" not in hook and "rex __internal" not in hook, hook
                subprocess.run(["/bin/bash", "-n", "-c", hook], check=True)
                subprocess.run(["/bin/bash", "-c", hook], env=env, check=True)
    assert "register-agent" in (home / "hook.log").read_text()

print("PASS: idempotent Stow, system links/themes, local Codex state, shared skills, safe hooks, and enabled integrations")
