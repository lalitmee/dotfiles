---
name: research
description: >
  Systematic multi-source research across web, GitHub, community
  discussions, and official docs. Use when asked to research best
  practices, trends, patterns, or find information on any topic.
  Invoke with a topic to research.
---

# Research Skill

Systematic multi-source research workflow that produces structured, actionable reports. Use when the user asks you to research best practices, trends, patterns, find information about a tool/concept, or needs up-to-date knowledge beyond your training data.

## Workflow

### Phase 1: Gather & Explore

Search across these sources **in order**, using your available search tools. Do not skip sources unless instructed.

**Step 1 — Web Search:**
- Search for `best practices for <topic>`, `<topic> trends 2025 2026`, `<topic> patterns`, `<topic> guide`
- Extract: consensus recommendations, common approaches, top tools/libraries, current state of the art

**Step 2 — GitHub:**
- Search for `github <topic> awesome-list`, `github <topic> best-practices`, `github <topic> style-guide`, `github <topic>`
- Open and read the top 2-3 most starred/active repositories' READMEs
- Also search `<topic> vs <alternative>` to understand ecosystem choices
- Extract: code patterns, README recommendations, community conventions, real project examples

**Step 3 — Community Discussions:**
- Search for `reddit <topic>`, `site:news.ycombinator.com <topic>`
- Also search `<topic> discussion`, `<topic> experience`, `<topic> review`
- Extract: real-world experiences, common pitfalls, debated topics, version migration stories, hot takes with evidence

**Step 4 — Official Documentation:**
- From gathered URLs, fetch official docs pages for the most relevant tools/libraries
- Look for: getting started guides, API references, migration guides, deprecation notes
- Extract: current recommendations, version requirements, configuration details

**Configuration:**
- Default sources: `web,github,community,docs`
- Can be filtered: `--sources web,docs` to skip community/GitHub
- User may specify `--output-dir` for the report file

### Phase 2: Cross-Reference & Synthesize

After gathering, analyze the collected information:

1. **Compare findings** across sources — note where they agree and where they diverge
2. **Tag information quality** using these labels:
   - `[official]` — from official documentation
   - `[community consensus]` — widely agreed upon across multiple sources
   - `[debated]` — conflicting opinions or approaches
   - `[version specific]` — tied to a particular version or release
   - `[opinion]` — individual or minority perspective
3. **Prioritize recency** — prefer information from the last 2 years
4. **Identify genuine best practices** vs. popular-but-dated approaches
5. **Note any deprecation warnings or security concerns** explicitly

### Phase 3: Output

**Terminal Summary** — Print a compact ~10-line summary first:

```
Research: <Topic>

• <key finding 1> [source type]
• <key finding 2> [source type]
• ...

Full report saved to: ./research-<topic-slug>.md
```

**Full Report** — Save to `./research-<topic-slug>.md` (or custom path):

```markdown
# Research: <Topic>
Generated: <date>

## Executive Summary
Brief 3-5 sentence overview synthesizing the most important findings.

## Best Practices
- <Finding with context and source tag>
- <Finding with context and source tag>

## Trends & Patterns
- <Trend description with evidence>
- <Trend description with evidence>

## Real-World Examples
- <Example from GitHub repo / Reddit thread / article>
- <Example from GitHub repo / Reddit thread / article>

## Official Documentation
- <Key docs page> — <takeaway>
- <Key docs page> — <takeaway>

## Community Discussion
- <Notable Reddit/HN thread> — <key sentiment or debate>
- <Notable Reddit/HN thread> — <key sentiment or debate>

## Recommendations
- <Actionable synthesis and guidance>

## Sources
- <URL 1>
- <URL 2>
```

## Usage Examples

**Research a topic with all sources:**
> Research best practices for structuring tmux configurations

**Research with limited sources:**
> Research neovim lua plugin patterns using only web and github sources

**Research with custom output dir:**
> Research rust async patterns, output to ./research-output/

## Triggering

This skill activates when the user:
- Asks to "research" something
- Asks to "find best practices for" something
- Asks to "look into" a topic deeply
- Says "research <topic>"
- Asks about current trends, patterns, or state of the art for a topic
