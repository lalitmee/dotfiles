# Docker-Based Testing for Dotfiles Installation

This directory contains tools for safely testing the dotfiles installation in an isolated Docker environment.

## Quick Start

```bash
# 1. Setup test environment
./docker-test.sh setup

# 2. Test individual phases
./docker-test.sh phase 0    # Base system
./docker-test.sh phase 3    # System foundation
./docker-test.sh phase 7    # Config stowing

# 3. Run full installation
./docker-test.sh full

# 4. Validate results
./docker-test.sh validate

# 5. Manual testing
./docker-test.sh enter

# 6. Cleanup when done
./docker-test.sh cleanup
```

## Available Commands

| Command | Description |
|---------|-------------|
| `setup` | Create and setup test container |
| `phase <num>` | Test specific installation phase (0-8) |
| `full` | Run complete installation |
| `validate` | Check installation results |
| `enter` | Enter container for manual testing |
| `cleanup` | Remove test container |
| `reset` | Reset container to clean state |
| `status` | Show container status |

## Testing Workflow

### Phase-by-Phase Testing
```bash
# Test each phase individually
./docker-test.sh setup
./docker-test.sh phase 0    # Base Ubuntu + Rust/Go
./docker-test.sh phase 1    # i3 Core
./docker-test.sh phase 2    # i3 Enhanced
./docker-test.sh phase 3    # System Foundation (cargo/go tools)
./docker-test.sh phase 4    # Development Core
./docker-test.sh phase 5    # Productivity Layer
./docker-test.sh phase 6    # Desktop Apps
./docker-test.sh phase 7    # Config Stowing
./docker-test.sh phase 8    # Final Setup
```

### Full Installation Testing
```bash
./docker-test.sh setup
./docker-test.sh full
./docker-test.sh validate
```

### Manual Testing
```bash
./docker-test.sh enter
# Now you're inside the container
# Test keybindings, applications, etc.
# Type 'exit' to leave
```

## Container Environment

- **Base Image**: Ubuntu 24.04 LTS
- **User**: testuser (with sudo access)
- **Working Directory**: /home/testuser
- **Dotfiles Location**: /home/testuser/dotfiles
- **Privileged**: Yes (for system-level operations)

## Safety Features

- ✅ **Isolated**: No impact on host system
- ✅ **Disposable**: Easy to reset/recreate
- ✅ **Fast**: Instant setup and cleanup
- ✅ **Controlled**: Exact Ubuntu version matching

## Troubleshooting

### Container Won't Start
```bash
# Check Docker service
sudo systemctl status docker

# Clean up and retry
./docker-test.sh cleanup
./docker-test.sh setup
```

### Installation Fails
```bash
# Enter container and debug
./docker-test.sh enter

# Check logs
docker logs dotfiles-test

# Reset and retry
./docker-test.sh reset
```

### Permission Issues
```bash
# The container runs as 'testuser' with sudo access
# If you need root access inside container:
sudo -i
```

## Validation Checklist

After installation, verify:

- [ ] Tools are installed: `which git zsh tmux nvim i3 cargo go`
- [ ] Configs are linked: `ls -la ~/.zshrc ~/.config/i3/config`
- [ ] Services work: `systemctl status --user *` (if applicable)
- [ ] Keybindings function: Test i3, tmux, sxhkd bindings
- [ ] Applications launch: Try opening terminal, editor, browser

## Performance Metrics

Track these during testing:
- Installation time per phase
- Container resource usage
- Application startup times
- System responsiveness

## Next Steps

1. Run phase-by-phase testing
2. Document any issues found
3. Fix issues in the installation scripts
4. Re-test until all phases pass
5. Run full installation test
6. Validate final results
7. Update documentation with findings