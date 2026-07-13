# Ponytail Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track ponytail's `full` mode config in dotfiles via stow.

**Architecture:** Single JSON config file under a stow-managed directory, matching every other tool config in this repo.

**Tech Stack:** JSON, stow

## Global Constraints

- Config file: `ponytail/.config/ponytail/config.json` containing `{"defaultMode": "full"}`
- Stow command: `stow ponytail` from repo root

---

### Task 1: Create and stow ponytail config

**Files:**
- Create: `ponytail/.config/ponytail/config.json` ✓ already exists
- Test: n/a — manual verification via file existence + stow

- [ ] **Step 1: Verify the config file exists**

```bash
cat /home/lalitmee/dotfiles/ponytail/.config/ponytail/config.json
```
Expected: `{"defaultMode": "full"}`

- [ ] **Step 2: Stow the ponytail directory**

```bash
cd /home/lalitmee/dotfiles && stow ponytail
```
Expected: no errors, creates `~/.config/ponytail/config.json` → `../dotfiles/ponytail/.config/ponytail/config.json`

- [ ] **Step 3: Verify the stow link**

```bash
ls -la ~/.config/ponytail/config.json
```
Expected: shows a symlink to `.../dotfiles/ponytail/.config/ponytail/config.json`

- [ ] **Step 4: Verify ponytail picks it up**

```bash
cat ~/.config/ponytail/config.json
```
Expected: `{"defaultMode": "full"}`

- [ ] **Step 5: Commit**

```bash
git add ponytail/.config/ponytail/config.json docs/superpowers/specs/2026-07-13-ponytail-config-design.md docs/superpowers/plans/2026-07-13-ponytail-config.md
git commit -m "feat(ponytail): track config in dotfiles with full mode"
```
