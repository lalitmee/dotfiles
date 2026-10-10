# Script Test Catalog

Run focused tests from the repository root. These are standalone scripts; there is no shared test runner.

## Focused tests

### Tmux

| Target | Behavior covered | Command |
|---|---|---|
| Global worktree manager | Discovery, actions, and interface (`all` runs all three) | `zsh scripts/test/tmux/worktree/manager.zsh all` |
| Worktree dependencies | Dependency detection and launch behavior | `zsh scripts/test/tmux/worktree/dependencies.zsh` |
| Worktree command flows | Git worktree command flows | `zsh scripts/test/tmux/worktree/flows.zsh` |
| Worktree setup runner | Setup success and failure behavior | `zsh scripts/test/tmux/worktree/setup-runner.zsh` |
| Workmux palette | Palette behavior | `zsh scripts/test/tmux/workmux/palette.zsh` |
| File picker | Tmux file-picker argument handling | `zsh scripts/test/tmux/file-picker.zsh` |
| Tmux installer | Installer behavior | `zsh scripts/test/tmux/install.zsh` |
| Tmux update checker | Update-check behavior | `zsh scripts/test/tmux/update-check.zsh` |

Run an individual manager suite with one of these exact commands:

```bash
zsh scripts/test/tmux/worktree/manager.zsh discovery
zsh scripts/test/tmux/worktree/manager.zsh actions
zsh scripts/test/tmux/worktree/manager.zsh interface
```

### User commands

| Target | Behavior covered | Command |
|---|---|---|
| Bluetooth audio command | Audio sink selection | `zsh scripts/test/bin/bluetooth/audio-selection.zsh` |
| Git email guard | Rejects unexpected author and committer identities | `zsh scripts/test/bin/git/email-guard.zsh` |

## Validators and security checks

| Target | Behavior covered | Command |
|---|---|---|
| Settings | Validate settings configuration | `bash scripts/test/config/settings.sh` |
| Linear MCP | Validate Linear MCP configuration | `bash scripts/test/config/linear-mcp.sh` |
| Gitleaks pre-commit | Exercise secret-blocking hooks in a temporary repository | `python3 scripts/test/security/gitleaks-precommit.py` |
| Installed environment | Verify installation tools and configuration | `bash scripts/test/install/verify.sh` |

## Docker installation harness

The Docker harness tests installation phases in an isolated Ubuntu 24.04 container. From the repository root:

```bash
./scripts/test/install/docker.sh setup
./scripts/test/install/docker.sh phase 0    # Base system
./scripts/test/install/docker.sh phase 1    # i3 core
./scripts/test/install/docker.sh phase 2    # i3 enhanced
./scripts/test/install/docker.sh phase 3    # System foundation
./scripts/test/install/docker.sh phase 4    # Development core
./scripts/test/install/docker.sh phase 5    # Productivity
./scripts/test/install/docker.sh phase 6    # Desktop apps
./scripts/test/install/docker.sh phase 7    # Config stowing
./scripts/test/install/docker.sh phase 8    # Final setup
./scripts/test/install/docker.sh full
./scripts/test/install/docker.sh validate
```

Available commands: `setup`, `phase <0-8>`, `full`, `validate`, `enter`, `cleanup`, `reset`, and `status`. Run `full` only when you intend to test the complete installer inside Docker.

To enter the container for manual checks, run `./scripts/test/install/docker.sh enter`; type `exit` to leave. To clean up, run `./scripts/test/install/docker.sh cleanup`.

Troubleshooting: check the Docker service if the container will not start; use `cleanup` then `setup` to recreate it. If installation fails, enter the container, inspect `docker logs dotfiles-test`, or use `reset` before retrying.

## Support utility

`scripts/test/support/home-env.sh` logs `$HOME` and tilde expansion to `~/dotfiles/scripts/logs/test.log`. It is a probe, not a focused test; running it writes into the current user's home directory.
