# Discover Agent Design

**Date:** 2026-07-26
**Status:** Draft

## Overview

A custom primary agent for OpenCode that orchestrates deep exploration of any input (GitHub URL, topic, URL, local path) and aligns with the user on intent and feasibility. Tab-switchable, read-only, delegating to existing `research` and `grill-me` skills.

## Motivation

When given an unknown project, topic, or URL, there was no structured workflow to: (1) deeply understand it, (2) uncover the user's intent behind it, and (3) align on what's feasible. This agent fills that gap by chaining existing skills in a discovery pipeline.

## Architecture

Three-phase orchestration:

```
User input → Phase 1: research skill → Phase 2: intent elicitation → Phase 3: grill-me skill → aligned understanding
```

### Phase 1: Discovery
Loads the existing `research` skill to systematically investigate the target across web, GitHub, community discussions, and official docs. The research skill handles tagging findings with source quality labels.

### Phase 2: Intent Elicitation
Agent presents a digest of findings, then asks the user (via `question` tool):
- What drew you to this?
- What problem are you solving?
- What's your desired outcome?

### Phase 3: Alignment
Loads the existing `grill-me` skill to stress-test the user's desired outcome against research findings, walking decision tree branches until shared understanding.

## Files

| File | Action | Description |
|------|--------|-------------|
| `opencode/.config/opencode/opencode.json` | Add `agent.discover` | Agent definition with permissions |
| `opencode/.config/opencode/prompts/explore-mode.txt` | Create | Agent system prompt |

## Agent Configuration

- **Mode:** primary (Tab-switchable)
- **Temperature:** 0.3 (balanced)
- **Permissions:** read/allow, edit/deny, bash/deny, webfetch/allow, websearch/allow, skill/allow
- **Model:** defaults to globally configured model

## Dependencies

- `.agents/skills/research/SKILL.md` (existing)
- `.agents/skills/grill-me/SKILL.md` (existing)

## Usage

1. `Tab` to "discover" agent
2. `Explore <github.com/org/repo>` or `Research <topic>` or `Look at <url>`
3. Agent runs discovery → asks about intent → grills alignment
4. `Tab` back to "build" to implement, or start new exploration
