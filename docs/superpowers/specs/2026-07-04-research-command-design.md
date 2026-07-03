# Spec: Research Command & Agent Skill — Systematic Research for AI Agents

## 1. Problem Statement

When using AI agents (Opencode, Claude Code, Gemini CLI), the user frequently asks them to research best practices, trends, patterns, and concepts across multiple sources (web, GitHub, Reddit, Hacker News, official docs). Currently, this research quality depends entirely on the LLM's training data, with no systematic workflow to find, cross-reference, and synthesize current information. The user needs a repeatable, structured research workflow that any agent can execute, plus a convenient CLI launcher.

## 2. Proposed Solution

A dual-layer system:

- **Agent Skill** (`.agents/skills/research/SKILL.md` + `skills-library/research/SKILL.md`) — defines a 3-phase systematic research workflow that tells any agent exactly how to search, what signals to extract, how to cross-reference, and how to format the output.
- **CLI Launcher** (Zsh `research` function) — a thin wrapper that prints a research prompt and optionally detects the active agent context.

## 3. Components

### 3A. Agent Skill — Workflow (3 Phases)

**Phase 1: Gather & Explore (Systematic Multi-Source)**

The skill instructs the agent to search in this order, using its built-in tools (`websearch`, `webfetch`, `grep`, etc.):

1. **Web Search** — Broad initial query for best practices, trends, patterns related to `<topic>`. Extract: consensus recommendations, common approaches, top tools/libraries.
2. **GitHub** — Search for `github <topic> awesome-list`, `github <topic> best-practices`, `github <topic> style-guide`, `github <topic> vs <alternative>`. Explore the top 2-3 repos. Extract: code patterns, README recommendations, community conventions.
3. **Community Discussions** — `websearch("reddit <topic>")`, `websearch("news.ycombinator.com <topic>")`, `websearch("<topic> discussion 2025 2026")`. Extract: real-world experiences, common pitfalls, debated topics, version migration stories.
4. **Official Documentation** — From gathered URLs, fetch official docs pages for the most relevant tools/libraries. Extract: current API recommendations, deprecation warnings, migration guides.

Configurable via flags: `--sources web,github,community,docs` (default: all).

**Phase 2: Cross-Reference & Synthesize**

The agent must:
- Compare findings across sources — note where they agree and where they diverge
- Tag information quality: `[official]`, `[community consensus]`, `[debated]`, `[version specific]`, `[opinion]`
- Prioritize findings from the last 2 years over older sources
- Identify genuine best practices vs. popular-but-dated approaches

**Phase 3: Output**

- **Terminal summary** (~10 lines): one sentence per key finding, formatted as a compact list
- **Full report** saved to `./research-<topic-slug>.md` (or custom `--output-dir`):

```markdown
# Research: <Topic>
Generated: <date>

## Executive Summary
Brief 3-5 sentence overview.

## Best Practices
- Finding 1 [source type]
- Finding 2 [source type]

## Trends & Patterns
- Trend 1 with evidence

## Real-World Examples
- Example from GitHub repo / Reddit thread

## Official Documentation
- Key docs pages with takeaways

## Community Discussion
- Notable Reddit/HN threads with sentiment

## Recommendations
- Synthesis and actionable guidance

## Sources
- List of all URLs consulted
```

### 3B. CLI — Zsh `research()` Function

- **File:** `zsh/.zsh_functions` (append)
- **Invocation:** `research <topic> [--sources web,github,community,docs] [--output-dir <path>]`
- **Behavior:**
  - Prints a research prompt template the user can paste into any agent
  - Optionally opens the report file when done
  - Falls back to printing usage info

### 3C. Files Modified

| File | Action |
|------|--------|
| `.agents/skills/research/SKILL.md` | **Create** — agent skill definition |
| `skills-library/research/SKILL.md` | **Create** — same skill for the installer |
| `zsh/.zsh_functions` | **Append** — add `research()` CLI function |
| `docs/superpowers/specs/2026-07-04-research-command-design.md` | **Create** — this spec document |

## 4. Verification

1. Syntax check: `zsh -n zsh/.zsh_functions`
2. Load the skill in an agent session and verify the 3-phase workflow renders
3. Run `research "tmux best practices"` and confirm the prompt output
