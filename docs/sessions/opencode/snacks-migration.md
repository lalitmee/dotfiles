# Research OpenCode agents people are using

**Session ID:** ses_041da29fdffeSsbXyt84UaG22S
**Created:** 8/1/2026, 9:56:18 PM
**Updated:** 8/1/2026, 9:59:30 PM

---

## User

lets do some /research for the agents that people are using with opencode

I want to have some agents in my opencode

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 8.5s)

_Thinking:_

The user wants to do some research on agents that people are using with opencode, because they want to have some agents in their opencode. There's a `research` skill available that seems applicable here. Also, we're in plan mode - read-only.

The research skill says: "Systematic multi-source research across web, GitHub, community discussions, and official docs. Use when asked to research best practices, trends, patterns, or find information on any topic. Invoke with a topic to research."

This applies. Let me load the research skill first.

Also since we're in plan mode, I should research and then present a plan. Let me invoke the research skill.

Using the research skill to investigate agents people use with opencode.

**Tool: skill**

**Input:**
```json
{
  "name": "research"
}
```

**Output:**
```
<skill_content name="research">
# Skill: research

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

Base directory for this skill: /home/lalitmee/dotfiles/.agents/skills/research
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 14.1s)

_Thinking:_

The user wants to research agents people use with opencode, and wants to add some agents to their opencode. I'm in plan mode - read only. The research skill is loaded. Let me follow the workflow:

Phase 1: Gather & Explore
- Step 1: Web search for agents used with opencode
- Step 2: GitHub search
- Step 3: Community discussions
- Step 4: Official documentation

The user's dotfiles repo already has `.opencode/` and `.config/opencode/` directories with agents possibly. Let me also check what they already have. Let me run searches in parallel.

Note: since this is about opencode itself (asking what agents people use with opencode), I could also fetch opencode.ai docs. Let me do the web searches first.

Let me batch: websearch + check local opencode config in parallel.

Researching. First, let me check what you already have configured, and search the web in parallel.

**Tool: websearch**

**Input:**
```json
{
  "query": "opencode agents people use custom agents 2026",
  "numResults": 8
}
```

**Output:**
```
Title: How to Create Custom Agents in OpenCode CLI: A Complete Guide | BSWEN
URL: https://docs.bswen.com/blog/2026-03-30-opencode-custom-agents/
Published: 2026-03-30T00:00:00.000Z
Author: Cowrie   Dev @ Bswen
Highlights:
This post shows how to create custom agents and subagents in OpenCode CLI to specialize AI assistants for specific tasks like code review, security audits, or documentation.
...
- Summary
- A code-reviewer agent that focuses on code quality and patterns
- A security-reviewer agent
...
OpenCode CLI supports custom agents through two approaches:
...
1. JSON Configuration in`opencode.json`
2. Markdown Files in agent directories
...
Agents come in two modes:
...
- Primary agents: Main agents you interact with directly
- Subagents: Specialized agents invoked by primary agents for specific tasks
...
Primary agents handle conversations. Subagents handle specialized tasks. This separation keeps each agent focused.
...
The first way to create agents is through the`opencode.json` configuration file.
...
OpenCode looks for configuration in two places:
...
- Global:`~/.config/opencode/opencode.json`(applies to all projects)
- Project:`./opencode.json`(overrides global settings)
...
I created a code-reviewer agent in my project’s`opencode.json`:
...
```
{  "agents": [    {      "name": "code-reviewer",      "mode": "subagent",      "description": "Reviews code for quality, patterns, and best practices",      "model": "claude-sonnet-4-20250514",      "systemPrompt": "You are a code reviewer. Focus on: code quality, design patterns, error handling, and maintainability. Be thorough but concise."    }  ]}
```
...
- name: The identifier used to invoke the agent
- mode: Either`primary` or`subagent`
- description: What the agent does (shown in UI)
- model: Which Claude model to use
- systemPrompt: Instructions that define agent behavior
...
For agents that need specific capabilities, I add permissions:
...
```
{  "agents": [    {      "name": "security-reviewer",      "mode": "subagent",      "description": "Scans code for security vulnerabilities",      "model": "claude-sonnet-4-20250514",      "permissions": {        "read": true,        "write": false,        "execute": false,        "network": false      },      "systemPrompt": "You are a security expert. Identify vulnerabilities including: SQL injection, XSS, CSRF, hardcoded secrets, insecure deserialization. Provide severity ratings and remediation steps."    }  ]}
```
...
### Creating Primary Agents
...
For a custom primary agent, I set mode to`primary`:
...
```
{  "agents": [    {      "name": "yolo",      "mode": "primary",      "description": "Fast agent that bypasses all permission checks",      "model": "claude-sonnet-4-20250514",      "permissions": {        "dangerouslySkipPermissions": true      },      "systemPrompt": "You are a fast development agent. Skip confirmations, make changes directly. Focus on speed over caution."    }  ]}
```
...
## Markdown Agent Configuration
...
The second approach uses Markdown files in agent directories.
...
OpenCode looks for agent definitions in:
...
- Global:`~/.config/opencode/agents/`
- Project:`.opencode/agents/`
...
```
.opencode/└── agents/    ├── code-reviewer.md    ├── security-reviewer.md    └── planner.md
...
Each Markdown file defines one agent:
...
```
---name: plannermode: subagentdescription: Creates detailed implementation plans for complex featuresmodel: claude-sonnet-4-20250514permissions:  read: true  write: false  execute: false---You are a planning expert. When given a feature request:1. Break down the feature into small, implementable tasks2. Identify dependencies between tasks3. Estimate complexity for each task4. Flag potential risks and blockers5. Suggest the order of implementationAlways start with high-level architecture before diving into implementation details.
```
...
## Interactive Creation with opencode agent create
...
OpenCode provides an interactive command to create agents:
...
Global agents go to`~/.config/opencode/agents/`. Project agents go to`.opencode/agents/`.
...
## Invoking Subagents
...
After creating subagents, I invoke them from primary agents or directly.
...
In my primary agent’s system prompt, I reference subagents:
...
```
---name: orchestratormode: primarydescription: Manages workflows of multiple subagentsmodel: claude-sonnet-4-20250514---You are an orchestrator agent. Delegate tasks to specialized subagents:- Use **code-reviewer** when user asks for code review- Use **security-reviewer** when user asks for security audit- Use **planner** when user starts a new feature- Use **tdd-guide** when user writes testsInvoke subagents by name. For example: "Use the code-reviewer agent to analyze the recent changes."
```
...
I can also invoke agents directly via CLI:
...
```
# Invoke a specific agentopencode --agent security-reviewer# Or in conversation"Use security-reviewer to check app.py"
...
```
Me: "I'm starting a new authentication feature"Orchestrator: "I'll use the planner agent to create an implementation plan."[Invokes planner subagent]Planner: "Here's the implementation plan:1. Design database schema for users2. Create password hashing utility3. Implement login endpoint4. Add session management5. Write authentication middleware6. Create tests for each component"Me: "Great, let's start implementing"Orchestrator: "I'll use tdd-guide to ensure we follow TDD practices."[Invokes tdd-guide subagent]TDD-Guide: "Following TDD workflow for authentication:1. RED: Write test for password hashing2. GREEN: Implement password hashing3. REFACTOR: Optimize hashing algorithm"
```
...
```
{  "agents": [    {      "name": "orchestrator",      "mode": "primary",      "description": "Main agent that delegates to subagents",      ...    },    {"name": "frontend", "mode": "subagent", ...},    {"name": "backend", "mode": "subagent", ...},    {"name": "database", "mode": "subagent", ...},    {"name": "testing", "mode": "subagent", ...}  ]}
```
...
### Code Reviewer Agent
...
### Security Reviewer Agent
...
```
---name: security-reviewermode: subagentdescription: Scans code for security vulnerabilitiesmodel: claude-sonnet-4-20250514permissions:  read: true  write: false  execute: false  network: false---Scan for security vulnerabilities:**Injection Attacks**- SQL injection in queries- Command injection in shell calls- XSS in rendered content**Authentication & Authorization**- Hardcoded credentials- Weak password hashing- Missing access controls**Data Protection**- Sensitive data in logs- Unencrypted storage- Insecure transmission**Output Format**
```
...
### TDD Guide Agent
...
```
---name: tdd-guidemode: subagentdescription: Enforces test-driven development workflowmodel: claude-sonnet-4-20250514permissions:  read: true  write: true  execute: true  network: false---Guide developers through TDD workflow:**RED Phase**1. Write test first2. Run test - it MUST FAIL3. Confirm test is valid**GREEN Phase**1. Write minimal implementation2. Run test - it MUST PASS3. Verify test passes**REFACTOR Phase**1. Improve code structure2. Run tests - must still pass3. Check coverage (aim for 80%+)**Rules**- NEVER write implementation before test- NEVER skip running tests- NEVER commit failing tests**Output**After each phase, report:- What was done- Test results- Coverage percentage
...
In this post, I showed how to create custom agents in OpenCode CLI. The key points are:
...
- Use JSON configuration for simple agents in`opencode.json`
- Use Markdown files for complex agents with long system prompts
- Primary agents handle conversations, subagents handle tasks
- Set appropriate permissions for each agent’s role
- Test agents immediately after creation
- Choose models based on task complexity
...
1. Start with one subagent for a task you do frequently
2. Test the agent with real code
3. Iterate on the system prompt based on results
4. Add more subagents as you identify specialized needs
5. Create a primary agent to orchestrate your subagents
...
Custom agents transform OpenCode from a generic assistant into a team of specialized experts. Each agent focuses on what it does best, improving code quality and development efficiency.

---

Title: Shakudo-io/opencode-agents
URL: https://github.com/Shakudo-io/opencode-agents
Published: 2026-01-13T13:56:31.000Z
Author: N/A
Highlights:
A collection of custom agents for OpenCode - the powerful AI coding CLI
...
# OpenCode Agents
...
A collection of custom agents for [OpenCode](https://opencode.ai) - the powerful AI coding CLI.
...
## Available Agents
...
| Agent | Description |
| --- | --- |
| [zellij](./agents/zellij/) | Zellij session controller - navigate tabs, execute commands in other panes, and retrieve information from the current Zellij session |
...
### Zellij Agent
...
The **zellij agent** eliminates this friction. Just tell it to check the tab:
...
### For Humans
...
#### Option 1: Install a Single Agent (Recommended)
...
#### Option 2: Install All Agents
...
#### Option 3: Project-Specific Installation
...
For project-specific agents, copy to your project's `.opencode/agent/` directory:
...
### For AI Agents
...
If you are an AI agent helping a user install these agents, use the following commands:
...
**Note**: After installation, the user must restart OpenCode for the agent to be available.
...
Once installed, agents can be invoked in OpenCode:
...
1. **Via @mention**: `@zellij list all my tabs`
2. **Via agent selection**: Select the agent from the agent picker in the TUI
3. **Via CLI flag**: `opencode --agent zellij`
...
## Agent File Format
...
Each agent is defined as a Markdown file with YAML frontmatter:
...
| Field | Type | Description |
| --- | --- | --- |
| `name` | string | Unique identifier for the agent |
| `description` | string | Brief description shown in agent list |
| `tools` | object | Map of tool names to boolean (enabled/disabled) |
| `model` | string | (Optional) Specific model to use, e.g., `anthropic/claude-sonnet-4-20250514` |
| `mode` | string | (Optional) `primary` or `subagent` |
...
We welcome contributions! To add a new agent:
...
1. Fork this repository
2. Create a new directory under `agents/` with your agent name
3. Add an `agent.md` file following the format above
4. Update this README to include your agent in the table
5. Submit a pull request

---

Title: Agents
URL: https://opencode.ai/docs/agents/
Published: 2026-07-31T17:26:40.101Z
Author: N/A
Highlights:
Configure and use specialized agents.
...
Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.
...
You can switch between agents during a session or invoke them with the`@` mention.
...
There are two types of agents in OpenCode; primary agents and subagents.
...
Primary agents are the main assistants you interact with directly. You can cycle through them using the Tab key, or your configured`switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.
...
OpenCode comes with two built-in primary agents, Build and Plan. We’ll look at these below.
...
Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.

OpenCode comes with three built-in subagents, General, Explore, and Scout. We’ll look at this below.
...
OpenCode comes with two built-in primary agents and three built-in subagents.
...
Build is the default primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.
...
### Use plan
...
A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes. By default, all of the following are set to`ask`:
...
This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.
...
### Use general
...
A general-purpose agent for researching complex questions and executing multi-step tasks. Has full tool access (except todo), so it can make file changes when needed. Use this to run multiple units of work in parallel.
...
### Use explore
...
A fast, read-only agent for exploring codebases. Cannot modify files. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.
...
### Use scout
...
A read-only agent for external docs and dependency research. Use this when you need to clone a dependency repository into OpenCode’s managed cache, inspect library source, or cross-reference local code against upstream implementations without modifying your workspace.
...
For primary agents, use the Tab key to cycle through them during a session. You can also use your configured`switch_agent` keybind.
...
Subagents can be invoked:
...
Manually by @ mentioning a subagent in your message. For example
...
You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:
...
Configure agents in your`opencode.json` config file:
...
```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "build": {      "mode": "primary",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "{file:./prompts/build.txt}",      "permission": {        "edit": "allow",        "bash": "allow"      }    },    "plan": {      "mode
...
"primary",      "
...
claude-haiku-4-20250514",      "permission":
...
edit": "deny",        "
...
": "deny"      }    },    "
...
": {      "
...
": "Reviews code for best practices and potential issues",      "mode": "subagent",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "permission": {        "edit": "deny"      }    }  }}
...
You can also define agents using markdown files. Place them in:
...
- Global:`~/.config/opencode/agents/`
- Per-project:`.opencode/agents/`
...
```
---description: Reviews code for quality and best practicesmode: subagentmodel: anthropic/claude-sonnet-4-20250514temperature: 0.1permission:  edit: deny  bash: deny---You are in code review mode. Focus on:- Code quality and best practices- Potential bugs and edge cases- Performance implications- Security considerationsProvide constructive feedback without making direct changes.
...
The markdown file name becomes the agent name. For example,`review.md` creates a`review` agent.
...
Control the agent’s mode with the`mode` config. The`mode` option is used to determine how the agent can be used.
...
can be set
...
subagent`, or`all`. If no`mode` is specified, it defaults to`
...
Hide a subagent from the`@` autocomplete menu with`hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.
...
### Task permissions
...
Control which sub
...
the Task tool
...
`permission.task
...
for flexible matching.
...
## Create agents
...
You can create new agents using the following command:
...
1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which permissions the agent should be allowed (anything you don’t select is denied).
5. Finally, create a markdown file with the agent configuration.
...
## Use cases
...
- Build agent: Full development work with all tools enabled
- Plan agent: Analysis and planning without making changes
- Review agent: Code review with read-only access plus documentation tools
- Debug agent: Focused on investigation with bash and read tools enabled
- Docs agent: Documentation writing with file operations but no system commands
...
### Documentation agent

---

Title: Build a Local Multi-Agent Coding Workflow in OpenCode - Code Crafter's Den
URL: https://codecraftersden.com/opencode-multi-agent-workflow/
Published: 2026-04-27T22:03:40.000Z
Author: Saeid
Highlights:
A single coding agent is convenient, but it struggles with complex multi-step work. Planning, implementation, review, testing, and commit hygiene all bleed together, and the result is hard to inspect, hard to debug, and hard to reuse. In this post, I’ll show you the local multi-agent workflow I built in OpenCode, and link to the full video tutorial at the bottom.
...
Instead of one big agent doing everything, we split responsibility across seven specialized agents, each with a narrow job:
...
- Planner – asks clarifying questions first, then writes an implementation plan
- Debater – reviews the plan and decides whether a better one exists
- Implementor – applies the approved plan with minimal, targeted code changes
- Reviewer – checks the implementation for correctness and maintainability
- Tester – runs the relevant test suite and records results
- Linter – runs the project lint/check script and reports findings
- Commit-message – reads the final diff and prints a conventional commit message
...
The key improvement over a single agent is shared context. Instead of relying on chat history, every agent reads and writes a file called`WORKFLOW_STATE.md`, making handoffs deterministic and easy to debug.
...
OpenCode supports project-local agents in`.opencode/agents/`, The markdown filename becomes the agent name. Agents can be defined as`primary`(interactive, can invoke subagents) or`subagent`(called by the primary).
...
This file is loaded by OpenCode as project-wide instructions. Every agent inherits these rules:
...
```
# Shared workflow rules

All agents must use WORKFLOW_STATE.md as the shared handoff file.
...
WORKFLOW_STATE.md is the canonical workflow record.
...
Workflow order:
...
1. Planner clarifies the request with the user
2. Planner writes clarified scope and acceptance criteria
3. Debater reviews the plan and decides whether a better plan exists
4. Implementor makes the change
5. Reviewer reviews the result
6. Tester runs relevant tests
7. Linter runs the project lint/check script
8. Commit-message prints the final commit message
...
This file is the live handoff document. Every agent reads it before working and updates only its own section:
...
This captures the whole development lifecycle in one place. If something goes wrong, you inspect the file instead of reconstructing from memory.
...
The most important design decision: the planner must not jump to implementation. It asks clarifying questions, confirms scope and acceptance criteria, then creates a plan and hands off to the debater.
...
---
description
...
, then creates
...
mode: primary
...
model: github
...
permission:
  edit:
    "*": deny
    "WORKFLOW_STATE.
...
": allow
...
: ask
  webfetch: ask
  task:
    "*": deny
    "
...
ater": allow
    "implementor": allow
    "
...
": allow
    "tester": allow
    "
...
inter": allow
    "
...
-message": allow
...
Notice: the planner can only edit`WORKFLOW_STATE.md`. It cannot touch application code. This is enforced by path-based edit permissions.
...
The debater is not a generic critic. Its job is a specific binary decision: is there a meaningfully better plan, or is the current one good enough?
...
Narrow prompts produce better subagents. The debater evaluates for unnecessary complexity, hidden edge cases, backward-compatibility risks, and missing tests, then either proposes an improved plan or explicitly approves the existing one.
...
### Implementor – the only agent that can edit code
...
```
---
description: Implements the approved plan and records what changed in WORKFLOW_STATE.md
mode: subagent
model: github-copilot/gpt-5.3-codex
temperature: 0.15
max_steps: 12
permission:
  edit: allow
  bash: ask
  webfetch: ask
...
This agent gets broad edit access but strict behavioral constraints: smallest useful change, no unrelated refactors, and always write a handoff note.
...
### Reviewer, Tester, Linter, Commit-message
...
All four follow the same pattern: read-only access to application code, write access only to`WORKFLOW_STATE.md`, and narrowly scoped bash commands.
...
The permission model is what makes this workflow trustworthy locally:
...
| Agent | Edit | Bash |
| --- | --- | --- |
| Planner | `WORKFLOW_STATE.md` only | `ask` |
| Debater | `WORKFLOW_STATE.md` only | `ask` |
| Implementor | `allow` | `ask` |
| Reviewer | `WORKFLOW_STATE.md` only | `ask` |
| Tester | `WORKFLOW_STATE.md` only | test commands only |
| Linter | `WORKFLOW_STATE.md` only | lint script only |
| Commit-message | `WORKFLOW_STATE.md` only | `git diff/log/status` only |
...
OpenCode supports path-based edit rules,`"*": deny` followed by`"WORKFLOW_STATE.md": allow` gives write access to exactly one file.
...
Each agent gets a temperature tuned to its job:
...
- Low (0.0–0.1): Planner, Implementor, Reviewer, Tester, Linter, consistency matters
- Slightly higher (0.3): Debater, needs to challenge the plan creatively
- Moderate (0.2): Commit-message, some flexibility is fine
...
You can assign different models per agent using the`model` field. A good starting strategy: stronger reasoning model for the Planner and Implementor, faster/cheaper model for the support roles.
...
Adding Context7 MCP
...
If you’ve connected Context7 through MCP in OpenCode, one line in`AGENTS.md` changes behavior significantly:
...
This makes the workflow docs-aware, not just model-memory-aware. The planner and implementor will consult up-to-date library documentation instead of relying on potentially stale training data.
...
"Add a
...
The planner asks clarifying questions first. Once you answer, it writes the clarified scope into`WORKFLOW_STATE.md`, creates a plan, calls the debater, and, after debate, hands off to the implementor. From there, the rest of the pipeline runs automatically.
...
Three ideas combine to
...
this reliable:
...
1. Role separation, agents with narrow jobs produce more consistent output than one overloaded agent
2. Shared state,`WORKFLOW_STATE.md` makes handoffs deterministic; you can debug by reading a file instead of reconstructing from chat history
3. Scoped permissions, reviewers and testers literally cannot edit code, so mistakes are contained
...
This setup is also extensible. Add a security reviewer, documentation writer, or migration planner later without changing the core workflow.
...
I recorded a 20-minute step-by-step video covering every agent file, the permission model, the Context7 integration, and a live demo of the full workflow running end to end.
...
The GitHub repo with all agent files, AGENTS.md, and WORKFLOW_STATE.md is linked in the video description.

---

Title: Rozariozaro/opencode-subagents
URL: https://github.com/Rozariozaro/opencode-subagents
Published: 2026-05-23T19:11:06.000Z
Author: N/A
Highlights:
Production-grade multi-agent OpenCode system: 6 agents, 6 skills, strict permission isolation, 7-phase workflow
...
A production-grade **multi-agent system** for [OpenCode](https://opencode.ai) that brings structured, deterministic, high-quality AI-assisted software engineering to large-scale codebases.
...
This project implements a **7-agent, 9-skill OpenCode system** with strict separation of concerns, deterministic delegation, and strong quality gates. It is designed for:
...
The system enforces a **read-before-write discipline**, routes all implementations through a dedicated auditor (except documentation-only tasks routed to `@documenter` by `@conductor`), and restricts each agent to only the permissions it needs — preventing hallucination, scope creep, and accidental damage.
...
| Agent | Mode | Model | Temp | Role |
| --- | --- | --- | --- | --- |
| `architect` | primary | `github-copilot/claude-opus-4.6` | 0.1 | Planning + grilling; produces confirmed implementation plans |
| `conductor` | primary | `github-copilot/claude-sonnet-4.6` | 0.1 | Execution coordinator; delegates, escalates, verifies, reports |
| `scout` | subagent | `github-copilot/gpt-5-mini` | 0.0 | Read-only analyst; discovers architecture, traces dependencies, identifies conventions |
| `builder` | subagent | `github-copilot/claude-sonnet-4.6` | 0.2 | Code + docs executor; writes/edits code and directly affected docs, runs builds/tests |
| `auditor` | subagent | `github-copilot/claude-opus-4.6` | 0.1 | Quality gate; validates correctness, consistency, maintainability, safety |
| `documenter` | subagent | `github-copilot/gpt-5-mini` | 0.1 | Single-pass documentation writer; writes README/CHANGELOG/docs, never modifies source code |
| `researcher` | subagent | `github-copilot/gpt-5.4-mini` | 0.1 | Technical research analyst; framework comparisons, OSS discovery, API research |
...
The `description` field in each agent's frontmatter is what OpenCode uses to route tasks. Key routing rules:
...
| If you want to… | Use this agent |
| --- | --- |
| Plan a feature, refactor, or non-trivial task | `@architect` |
| Execute a confirmed plan | `@conductor` |
| Write or edit source code (`.kt`, `.swift`, `.ts`, etc.) | `@builder` |
| Explore the codebase, find files, trace dependencies | `@scout` |
| Research libraries, APIs, or external tools | `@researcher` |
| Audit code for correctness and safety | `@auditor` |
| Write standalone docs (README, CHANGELOG, API docs) | `@documenter` |
...
. Conducts grill-me style interviews, explores the codebase via `@scout`, and produces a confirmed implementation plan. Has **no edit permissions** — job ends at plan confirmation.
...
Primary execution coordinator. Reads the confirmed plan, delegates to `@builder`, manages escalation via `@scout`/`@researcher`, and routes all completed work through `@auditor`. Has **no edit permissions**. For documentation-only tasks (README, CHANGELOG, docs/), conductor delegates directly to `@documenter` and skips the auditor.
...
Executes implementation plans precisely. Has edit + guarded bash permissions. Follows conductor plans — does not make architecture decisions. Owns docs for files directly affected by the current implementation. Owns phases 3–5 of the diagnose debug loop.
...
Single-pass documentation writer. Explores the codebase (using the graphify knowledge graph when available, falling back to direct file reads) and writes documentation files in one pass. Runs on a cheap model for token efficiency. Has edit permissions restricted to `.md`, `.mdx`, `.rst`, `.txt`, `README*`, `CHANGELOG*`, and `docs/**` — **never modifies source code**. Used by conductor for standalone documentation tasks that don't require source code changes.
...
| Skill | Used by | Trigger | Purpose |
| --- | --- | --- | --- |
| `diagnose` | scout, builder | "debug this", "diagnose", bug reports | 5-phase loop: reproduce → minimise → hypothesise → instrument → fix |
| `zoom-out` | scout, auditor, documenter | "zoom out", unfamiliar code section | Architectural mapping; shows broader context, callers, dependencies |
| `graphify` | scout, auditor, documenter | knowledge graph requests | Generates HTML + JSON knowledge graphs with community detection |
| `handoff` | — | session wrap-up, context handoff | Compacts conversation into structured handoff document |
| `grill-with-docs` | — | stress-test a plan, "grill me" | Challenges plans against domain model and existing documentation |
| `supabase` | builder | Supabase DB, Auth, Edge Functions, RLS, Storage | Current Supabase patterns; avoids hallucinating APIs |
| `ui-styling` | builder | UI components, Tailwind, shadcn/ui, design tokens | Component patterns and accessibility guidelines |
| `swiftui-expert-skill` | builder | SwiftUI views, state management, iOS/macOS APIs | SwiftUI best practices, Liquid Glass adoption |
| `grill-me` | — | stress-test a plan, relentless interrogation | Interview-style planning session; resolves decision branches |
...
| Agent | Read | Edit | Bash | Delegate | Web | Skills |
| --- | --- | --- | --- | --- | --- | --- |
| Architect | ✅ | ❌ | ❌ (git read-only) | scout, researcher | ❌ | All |
| Conductor | ✅ | ❌ | ❌ (git read-only) | scout, builder, auditor, researcher, documenter | ❌ | All |
| Scout | ✅ | ❌ | ❌ (git/grep only) | ❌ | ❌ | graphify, zoom-out, diagnose |
| Builder | ✅ | ✅ (all) | ✅ (guarded) | ❌ | ❌ | diagnose, supabase, ui-styling, swiftui-expert-skill |
| Auditor | ✅ | ❌ | ❌ (git/grep/audit only) | ❌ | ❌ | zoom-out, graphify |
| Documenter | ✅ | ✅ (md/docs only) | ✅ (read-only: grep/find/git) | ❌ | ❌ | graphify, zoom-out |
| Researcher | ❌ | ❌ | ❌ | ❌ | ✅ | — |
...
> **Notes:** Bash permissions are restricted per agent — Architect and Conductor allow only read-only git commands (`status`, `diff`, `log`, `branch`). Git write operations (`add`, `commit`, `push`) are exclusively the Builder's job, and only after Auditor approval. Scout and Auditor allow only `git`, `grep`, and `find`. Builder has guarded bash (destructive operations require confirmation). Documenter has read-only bash (grep, rg, find, head, tail, wc, ls, file, git log/diff/show) and can only edit documentation files. Researcher has web-fetch only access.
...
The architect agent will be your primary entry point for planning. Switch to conductor to execute confirmed plans. All other agents are invoked automatically as subagents.
...
Agent models are configured individually in `.opencode/agents/*.md` frontmatter.
...
- [x] 7 agents with full definitions and permission isolation
...
- Architect (planning + grilling)
 - Conductor (execution coordinator)
 - Scout (read-only analyst)
 - Builder (code + directly affected docs executor)
 - Auditor (quality gate, Opus model, CLARIFICATION_NEEDED verdict)
 - Documenter (single-pass documentation writer, cheap model, md/docs only)
 - Researcher (external research)
...
- [x] Strict permission matrix enforced per agent
- [x] Two-stage workflow: planning (architect) + execution (conductor)
- [x] Confirmed plan block format (`---CONFIRMED EXECUTION PLAN---`)
- [x] Parallel delegation rules defined
- [x] Standardized 3-attempt retry model across all agents
- [x] Auditor CLARIFICATION_NEEDED verdict for uncertain analysis
- [x] Builder owns directly affected documentation
- [x] Documenter for standalone documentation tasks (auditor-exempt)
- [x] Benchmark suite (12 test cases T01–T12)
- [x] Empirical validation on real iOS project
...
- [ ] Additional skills: `test-writer`, `migration-helper`, `security-audit`
- [ ] CI/CD integration examples (GitHub Actions, Bitrise)
- [ ] Benchmark results across more project types (KMP, backend, DevOps)
- [ ] Plugin system for custom agent extensions
- [ ] Agent performance dashboard / token usage tracking
- [ ] Pre-built templates for common project types
- [ ] Integration with Supabase MCP for database-aware agents

---

Title: Agents - OpenCode
URL: https://opencode.ai/v2/docs/agents
Published: N/A
Author: N/A
Highlights:
Agents combine a system prompt, model preference, tool permissions, and display metadata into a reusable assistant profile. OpenCode includes agents for common workflows, and you can override them or add your own in configuration or Markdown files.
...
| Agent | Mode | Purpose |
| --- | --- | --- |
| Build (`build`) | `primary` | Default coding agent. Tools are allowed by default, sensitive environment-file reads ask for approval, and access outside the workspace asks for approval. |
| Plan (`plan`) | `primary` | Planning agent. File edits are denied except for OpenCode plan files. Shell commands are not generally denied. |
| General (`general`) | `subagent` | General-purpose research and multi-step work. It has broad tool access but cannot launch more subagents. |
| Explore (`explore`) | `subagent` | Read-only code and web exploration using`read`,`glob`,`grep`,`webfetch`, and`websearch`. |
...
OpenCode also has hidden`compaction`,`title`, and`summary` system agents. They run internal maintenance tasks and are not selectable. There is no built-in`scout` agent in V2.
...
You can override a built-in agent with an entry of the same ID. Set`disabled: true` to remove one.
...
The configured agent must exist, must not have`mode: "subagent"`, and must not be hidden. If it is unavailable, OpenCode falls back to`build`, then to the first visible agent that can run as a primary agent. This selection does not rewrite the agent already stored on an existing session.
...
| Mode | Behavior |
| --- | --- |
| `primary` | Can be selected as the main agent for a session. It cannot be launched as a subagent. |
| `subagent` | Can run in a child session through the`subagent` tool, but cannot be selected as the main agent. |
| `all` | Can be used either way. This is the default for a custom agent when`mode` is omitted. |
...
Subagents run in child sessions with fresh context. A primary agent can invoke one with the`subagent` tool, either in the foreground or in the background. You can also`@` mention a visible subagent to ask the current agent to delegate work to it:
...
The parent agent’s`subagent` permission controls which agents it may launch. The child currently uses its own configured permissions, not a restricted copy of the parent’s permissions.
...
Use the`agents` field in any OpenCode configuration file:
...
```
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "reviewer",
  "agents": {
    "reviewer": {
      "description": "Reviews changes for correctness, security, and missing tests",
      "mode": "all",
      "model": "anthropic/claude-sonnet-4-5#high",
      "system": "Review the current changes. Report findings before any summary.",
      "color": "#ff6b6b",
      "steps": 8,
      "permissions": [
        { "action": "edit", "resource": "*", "effect": "deny" },
        { "action": "shell", "resource": "*", "effect": "deny" }
      ]
    },
    "build": {
      "permissions": [
        { "action": "shell", "resource": "git push *", "effect": "ask" }
      ]
    }
  }
}
...
Agent definitions merge in configuration order. Later scalar fields replace earlier values, request maps merge by key, and permission rules are appended. Global`permissions` are applied to every agent before its agent-specific rules, so a later agent rule can refine a global rule.
...
Explains the agent’s purpose. It is optional, but strongly recommended for subagents because OpenCode includes it in the subagent catalog shown to the model.
...
Accepts`primary`,`subagent`, or`all`. The default is`all`.
...
The TUI uses this as the preferred model when the agent is selected. A child session uses its subagent’s configured model, or inherits the parent session’s model when none is configured. In the API, the session’s selected model is stored separately; creating or switching a primary session with only an agent ID does not itself change that session model.
...
, skills,
...
, and other instruction sources are still added separately.
...
The last matching rule wins. Important V2 action names include`shell` for shell commands,`edit
...
for all edit/write/patch tools, and`subagent` for child agents. Other tools generally use their tool name, such as
...
read`,`glob`,`grep`,`webfetch`,`websearch`, and`skill`.
...
When`true`, removes the agent from normal selectors,`@` autocomplete, and the subagent catalog advertised to models. It is a visibility setting, not a security boundary.
...
When`true`, removes the agent definition at that point in configuration loading. This works for built-in and custom agents.

---

Title: How to create a custom agent in OpenCode — config, system prompt, providers, MCP servers
URL: https://gist.github.com/minzique/e2344d1c3ae94d3b3e446eb099a50cdd
Published: N/A
Author: N/A
Highlights:
# How to create a custom agent in OpenCode — config, system prompt, providers, MCP servers
...
# Creating a Custom Agent in OpenCode
...
> How to define a persistent agent identity that shows up in OpenCode's agent picker — with its own model, system prompt, and personality.
...
- [OpenCode](https://github.com/anomalyco/opencode) installed and working
- At least one LLM provider configured (Anthropic, OpenAI, Google, etc.)
...
OpenCode reads its config from `~/.config/opencode/opencode.json`. This is where agents are defined.
...
— a custom agent called "Lume":**
...
```json
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "lume",
  "agent": {
    "lume": {
      "model": "anthropic/claude-opus-4-6",
      "mode": "primary",
      "color": "#4ade80",
      "description": "Lume — autonomous engineer with persistent memory.",
      "prompt": "You are Lume, a senior software engineer. You are not an assistant — you are an autonomous implementer. Break down tasks, implement them, verify them, and present the result.\n\n**Work Standards:**\n- Verify every change: typecheck, lint, test.\n- One focused commit per logical change.\n- When unsure, read the code — use LSP, grep, glob.\n\n**Autonomy:**\n- When given a task, execute it. Don't ask for permission on implementation details.\n- If blocked on a design decision with real tradeoffs, present options with your recommendation."
    },
    "compaction": {
      "model": "google/gemini-3-flash-preview"
    }
  }
}
...
Save this, restart OpenCode, and "lume" appears in the agent selector.
...
| Field | Required | Description |
|-------|----------|-------------|
| `model` | **Yes** | LLM to use. Format: `provider/model-name` (e.g. `anthropic/claude-sonnet-4-6`, `openai/gpt-5.2-codex`, `google/gemini-3-pro-preview`) |
| `prompt` | No (but you want it) | System prompt. This is what gives your agent its identity, rules, and personality. |
| `mode` | No | Set to `"primary"` for your main agent. |
| `color` | No | Hex color shown in the TUI (e.g. `"#4ade80"`) |
| `description` | No | One-liner shown in the agent picker. |
...
## Special Agents
...
### `compaction`
...
OpenCode uses this agent to summarize the conversation when context gets too long. Point it at something cheap and fast:
...
Don't skip this — without it, OpenCode uses your expensive primary model for compaction, which burns tokens on summaries.
...
```json
"default_agent": "lume"
...
This is the agent that loads when you open OpenCode. Without it, you'll need to select one manually each time.
...
## Adding Providers
...
Agents reference models as `provider/model-name`. The provider must be configured. Most providers just need an API key in environment variables, but you can also configure them explicitly:
...
-google-api-
...
}
    },
...
"
...
": "OpenAI
...
"
...
ingEffort": "medium"
      }
    }
  }
}
...
Standard env vars that OpenCode picks up automatically:
...
- `ANTHROPIC_API_KEY` — for `anthropic/*` models
- `OPENAI_API_KEY` — for `openai/*` models
- `GOOGLE_API_KEY` or `GEMINI_API_KEY` — for `google/*` models
...
## Adding MCP Servers
...
MCP servers give your agent extra tools. Define them in the `mcp` key:
...
"mcp
...
"my-server":
...
"
...
": "local",
      "command": ["node", "/path/to/mcp-server/
...
.js"],
      "
...
": true,
      "environment": {
        "SOME_CONFIG": "value"
      }
    }
  }
}
...
Every MCP server you add here gives all agents access to its tools.

## Plugins (Optional, Advanced)
...
Plugins extend OpenCode's behavior. The `plugin` array loads them by name:
...
- **[oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode)** — Subagent management with per-agent model routing and task categories. Configured via a separate `oh-my-opencode.json`.
- **opencode-rate-limit-fallback** — Automatic fallback to alternative models when you hit rate limits.
...
## Full Example (Production Config)
...
Here's a more complete setup with multiple providers and MCP servers:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "oh-my-opencode",
    "opencode-rate-limit-fallback"
  ],
  "provider": {
    "google": {
      "options": {
        "apiKey": "YOUR_GOOGLE_API_KEY"
      }
    }
  },
  "mcp": {
    "memory": {
      "type": "local",
      "command": ["node", "/path/to/memory-mcp/index.js"],
      "enabled": true,
      "environment": {
        "MEMORY_URL": "http://localhost:4097"
      }
    }
  },
  "default_agent": "myagent",
  "agent": {
    "myagent": {
      "model": "anthropic/claude-opus-4-6",
      "mode": "primary",
      "color": "#4ade80",
      "description": "My custom agent with memory and tools.",
      "prompt": "You are MyAgent, a senior engineer.\n\nYour rules:\n- Always verify changes compile before committing.\n- Use git worktrees for feature branches.\n- Delegate research to explore agents.\n- Own all architectural decisions."
    },
    "compaction": {
      "model": "google/gemini-3-flash-preview"
    }
  }
}
```
...
- **System prompt is everything.** The model is just the engine — the prompt is the personality, rules, and behavior. Spend time on it.
- **Use cheap models for compaction.** Gemini Flash is ideal — fast, cheap, good enough for summarization.
- **Keep secrets out of the config.** Use environment variables for API keys when possible, or ensure the config file isn't committed to git.
- **Restart OpenCode after config changes.** It reads the config on startup.

---

Title: Oh My Opencode — Turn OpenCode into a Multi-Agent System with 7 Specialized Agents - DEV Community
URL: https://dev.to/sarantoon/oh-my-opencode-turn-opencode-into-a-multi-agent-system-with-7-specialized-agents-1flm
Published: 2026-07-25T05:40:56.000Z
Author: N/A
Highlights:
7 Specialized Agents
...
OpenCode คือ open-source coding agent ที่ดังที่สุดในปี 2026 — MIT license — 165,000+ GitHub stars — ใช้แทน Claude Code ได้ฟรี
...
แต่ข้อจำกัดของ OpenCode คือ เป็น single agent — ทำงานทีละอย่าง — ถ้างานใหญ่และซับซ้อน — agent ตัวเดียวอาจหลงทางหรือ context window เต็มก่อนทำงานเสร็จ
...
Oh My Opencode (หรือ`omo`) คือ plugin ที่แก้ปัญหานี้ — เปลี่ยน OpenCode จาก single agent เป็น multi-agent system — มี agent หลายตัว แต่ละตัวเชี่ยวชาญงานต่างกัน — ทำงานพร้อมกันได้ — เหมือนมีทีม dev ทั้งทีมอยู่ใน terminal
...
Oh My Opencode เป็น community plugin สำหรับ OpenCode — สร้างโดย [code-yeongyu](https://github.com/code-yeongyu/oh-my-openagent)— มีเว็บไซต์ official ที่ [ohmyopencode.com](https://ohmyopencode.com/) [8] — และมี QuickStart สอนติดตั้งโดย Rost Glukhov [9]
...
"Oh My Opencode transforms OpenCode into a full multi-agent engineering system. It adds the Sisyphus orchestration system with parallel background execution" [1]
...
หลักการ: แทนที่จะให้ agent ตัวเดียวทำทุกอย่าง — Oh My Opencode แบ่งงานให้ agent เฉพาะทาง — แต่ละตัวใช้โมเดลที่เหมาะสมกับงาน — ทำงานพร้อมกัน — แล้ว Sisyphus (orchestrator) รวบรวมผลลัพธ์
...
## Agent ทั้งหมดใน Oh My Opencode
...
Oh My Opencode มี agent 7 ตัว — แต่ละตัวมีบทบาทชัดเจน:
...
### Sisyphus Junior — Executor 📋
...
งานเดี่ยว
...
ได้รับมอบหมาย
...
### Oracle — ที่ปรึกษา 🔮
...
### Momus — นักวิจารณ์ 👁️
...
### Explorer — นักสำรวจ 🔍
...
โมเดล
...
### Librarian — บรรณารักษ์ 📚
...
### Prometheus — ผู้เฝ้าระวัง 🔥
...
หน้าที่ |
...
### Hyperplan — 5 Agent ถล่มแผนก่อนเขียนโค้ดแม้แต่บรรทัดเดียว
...
### Security Research — 5 Agent ล่า Vulnerability
...
## การตั้งค่าโมเดล — Per-Agent Model Selection
...
Oh My Opencode ไม่ใช้โมเดลเดียวสำหรับทุก agent — แต่ละ agent ใช้โมเดลที่เหมาะสมกับงาน:
...
| Agent | โมเดล | เหตุผล |
| --- | --- | --- |
| Sisyphus | Claude Opus 4.8 | Orchestration ต้องการ reasoning สูงสุด |
| Oracle | Claude Opus 4.8 | คำแนะนำมีผลต่อการตัดสินใจ |
| Momus | Claude Opus 4.8 | วิจารณ์ต้องแม่น |
| Prometheus | Orchestration-class | เฝ้าระวังระบบ |
| Sisyphus Jr | Kimi K2.7 | Execution — ต้องการ stability |
| Explorer | DeepSeek V4 Flash | ถูกสุด — ทำงานซ้ำๆ |
| Librarian | DeepSeek V4 Flash | ถูกสุด — จัดการข้อมูล |
...
Fallback chain: แต่ละ agent มี fallback — ถ้าโมเดลหลักไม่พร้อม — จะใช้ตัวถัดไป — เช่น Sisyphus: Claude Opus 4.8 → Kimi K2.5 → GPT-5.4 → GLM-5
...
Self-hosted: Sisyphus เป็น agent ที่รัน local ยากที่สุด — เพราะ prompt ซับซ้อนและต้องใช้ tool-calling ยาว — Qwen3-Coder หรือ DeepSeek-Coder-V3 อาจพอใช้ได้สำหรับงานง่าย — แต่จะด้อยลงใน multi-agent coordination [1]
...
Sisyphus วาง
...
→ Oracle:
...
→
...
— "JWT
...
?"
  →
...
→
...
→ ทั้ง
...
"I typed`ultrawork` into my terminal and watched as multiple AI agents started executing tasks in parallel. The orchestrator delegated work to specialists, each running on different models" [5]
...
## Oh My Opencode vs Claude Code — เทียบกัน
...
| ความสามารถ | Claude Code | Oh My Opencode |
| --- | --- | --- |
| Single agent | ✅ | ✅ (Sisyphus Jr) |
| Multi-agent parallel | ❌ | ✅ (7 agents พร้อมกัน) |
| Orchestration | ❌ | ✅ (Sisyphus) |
| Per-agent model | ❌ (ใช้โมเดลเดียว) | ✅ (แต่ละ agent ใช้โมเดลต่างกัน) |
| Plan review | ❌ | ✅ (Hyperplan — 5 agent ถล่มแผน) |
| Security audit | ❌ | ✅ (5 agent ล่า vulnerability) |
| Cost optimization | ❌ | ✅ (Explorer/Librarian ใช้โมเดลถูก) |
| Open source | ❌ (Proprietary) | ✅ (MIT) |
| Provider lock-in | ✅ (Anthropic เท่านั้น) | ❌ (ใช้ได้ทุก provider) |
...
1. Cost — Sisyphus, Oracle, Momus ใช้ Claude Opus 4.8 — แพง — แต่ถูกกว่า Claude Code เพราะ Explorer/Librarian ใช้โมเดลถูก
2. Sisyphus รัน local ยาก — ต้องการ reasoning สูง + tool-calling ยาว — Qwen3-Coder พอใช้ได้สำหรับงานง่าย — แต่จะพังใน multi-agent coordination
3. Learning curve — ต้องเข้าใจว่า agent แต่ละตัวทำอะไร — และตั้งค่าโมเดลให้เหมาะสม
4. ยังเป็น community plugin — ไม่ใช่ official — อาจมีบั๊ก — แต่ community active มาก
5. OpenAgentsControl เป็นทางเลือก — ถ้าอยากได้ plan-first + approval gates มากกว่า parallel speed — OpenAgentsControl เน้น control & repeatability — Oh My Opencode เน้น autonomy & speed [7]
...
Oh My Opencode เปลี่ยน OpenCode จาก "coding agent ดีๆ ตัวหนึ่ง" เป็น "ทีม dev ทั้งทีมใน terminal"
...
- 7 specialized agents — แต่ละตัวใช้โมเดลที่เหมาะสม
- ทำงาน parallel ได้ — เร็วกว่า single agent หลายเท่า
- Hyperplan + Security Research — skills ที่ Claude Code ไม่มี
- Open source — MIT — ใช้ฟรี
...
เหมาะกับ:
...
- โปรเจกต์ใหญ่ที่ single agent หลงทาง
- งานที่ต้องการ parallel execution
- ทีมที่อยากได้ code review + security audit อัตโนมัติ
- คนที่อยากทดลอง multi-agent system โดยไม่ต้องเขียนเอง
...
เริ่มจาก`bunx oh-my-openagent install`— แล้วพิมพ์`ultrawork`— แล้วดู agent 7 ตัวทำงานพร้อมกัน
...
หมายเหตุ: จำนวน agent อาจเพิ่มขึ้นจาก 7 ตัวเมื่อระบบ evolve — ตรวจสอบ docs ล่าสุดที่ [ohmyopencode.com](https://ohmyopencode.com/) [8]
```

**Tool: websearch**

**Input:**
```json
{
  "query": "opencode CLI agent configuration opencode.json agent best practices",
  "numResults": 8
}
```

**Output:**
```
Title: Config
URL: https://opencode.ai/docs/config/
Published: N/A
Author: N/A
Highlights:
1. Remote config (from`.well-known/opencode`) - organizational defaults
2. Global config (`~/.config/opencode/opencode.json`) - user preferences
3. Custom config (`OPENCODE_CONFIG` env var) - custom overrides
4. Project config (`opencode.json` in project) - project-specific settings
5. `.opencode` directories - agents, commands, plugins
6. Inline config (`OPENCODE_CONFIG_CONTENT` env var) - runtime overrides
7. Managed config files (`/Library/Application Support/opencode/` on macOS) - admin-controlled
8. macOS managed preferences (`.mobileconfig` via MDM) - highest priority, not user-overridable
...
Place your global OpenCode config in`~/.config/opencode/opencode.json`. Use global config for user-wide server/runtime preferences like providers, models, and permissions.
...
Add`opencode.json` in your project root. Project config has the highest precedence among standard config files - it overrides both global and remote configs.
...
Specify a custom config directory using the`OPENCODE_CONFIG_DIR` environment variable. This directory will be searched for agents, commands, modes, and plugins just like the standard`.opencode` directory, and should follow the same structure.
...
You can configure specialized agents for specific tasks through the`agent` option.
...
```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "code-reviewer": {      "description": "Reviews code for best practices and potential issues",      "model": "anthropic/claude-sonnet-4-5",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "tools": {        // Disable file modification tools for review-only agent        "write": false,        "edit": false,      },    },  },}
```
...
You can also define agents using markdown files in`~/.config/opencode/agents/` or`.opencode/agents/`. Learn more here.
...
### Default agent
...
You can set the default agent using the`default_agent` option. This determines which agent is used when none is explicitly specified.
...
The default agent must be a primary agent (not a subagent). This can be a built-in agent like`"build"` or`"plan"`, or a custom agent you’ve defined. If the specified agent doesn’t exist or is a subagent, OpenCode will fall back to`"build"` with a warning.
...
This setting applies across all interfaces: TUI, CLI (`opencode run`), desktop app, and GitHub Action.

---

Title: Agents
URL: https://opencode.ai/docs/agents/
Published: 2026-07-31T17:26:40.352Z
Author: N/A
Highlights:
Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.
...
Primary agents are the main assistants you interact with directly. You can cycle through them using the Tab key, or your configured`switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.
...
Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.
...
Build is the default primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.
...
A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes. By default, all of the following are set to`ask`:
...
when you want
...
making any actual
...
You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:
...
Configure agents in your`opencode.json` config file:
...
```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "build": {      "mode": "primary",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "{file:./prompts/build.txt}",      "permission": {        "edit": "allow",        "bash": "allow"      }    },    "plan": {      "mode": "primary",      "model": "anthropic/claude-haiku-4-20250514",      "permission": {        "edit": "deny",        "bash": "deny"      }    },    "code-reviewer": {      "description": "Reviews code for best practices and potential issues",      "mode": "subagent",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "permission": {        "edit": "deny"      }    }  }}
...
You can also define agents using markdown files. Place them in:
...
- Global:`~/.config/opencode/agents/`
- Per-project:`.opencode/agents/`
...
```
---description: Reviews code for quality and best practicesmode: subagentmodel: anthropic/claude-sonnet-4-20250514temperature: 0.1permission:  edit: deny  bash: deny---You are in code review mode. Focus on:- Code quality and best practices- Potential bugs and edge cases- Performance implications- Security considerationsProvide constructive feedback without making direct changes.
```
...
The markdown file name becomes the agent name. For example,`review.md` creates a`review` agent.
...
Use the`description` option to provide a brief description of what the agent does and when to use it.
...
This is a
...
config option.
...
Control the randomness and creativity of the LLM’s responses with the`temperature` config.
...
Temperature values typically range from
...
1.0:
...
encode.json
...
is specified, OpenCode uses model-specific defaults; typically 0 for most models, 0.55 for Qwen models.
...
### Max steps
...
Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. This allows users who wish to control costs to set a limit on agentic actions.
...
Set to`true` to disable the agent.
...
Specify a custom system prompt file for this agent with the`prompt` config. The prompt file should contain instructions specific to the agent’s purpose.
...
Use the`model` config to override the model for this agent. Useful for using different models optimized for different tasks. For example, a faster model for planning, a more capable model for implementation.
...
### Tools (deprecated)
...
`tools` is deprecated. Prefer the agent’s`permission` field for new configs, updates and more fine-grained control.
...
Allows you to control which tools are available in this agent. You can enable or disable specific tools by setting them to`true` or`false`. In an agent’s`tools` config,`true` is equivalent to`{"*": "allow"}` permission and`false` is equivalent to`{"*": "deny"}` permission.
...
### Permissions
...
You can configure permissions to manage what actions an agent can take. Each permission key can be set to:
...
- `"ask"`— Prompt for approval before running the tool
- `"allow"`— Allow all operations without approval
- `"deny"`— Disable the tool
...
The available permission keys are:
...
| Key | Tools it gates |
| --- | --- |
| `read` | `read` |
| `edit` | `write`,`edit`,`apply_patch` |
| `glob` | `glob` |
| `grep` | `grep` |
| `list` | `list` |
| `bash` | `bash` |
| `task` | `task` |
| `external_directory` | Any tool that reads or writes files outside the project worktree |
| `todowrite` | `todowrite`,`todoread` |
| `webfetch` | `webfetch` |
| `websearch` | `websearch` |
| `lsp` | `lsp` |
| `skill` | `skill` |
| `question` | `question` |
| `doom_loop` | Recovery prompts when an agent appears stuck |
...
`read`,`edit`,`glob`,`grep`,`list`,`bash`,`task`,`external_directory`,`lsp`, and`skill` accept either a shorthand action (`"allow" | "ask" | "deny"`) or an object of glob/pattern → action for fine-grained control. The remaining keys accept the shorthand action only.
...
You can override these permissions per agent.
...
You can also set permissions in Markdown agents.
...
---description: Code
...
You can set permissions for specific bash commands.
...
And you can also use the`*` wildcard to manage permissions for all commands. Since the last matching rule takes precedence, put the`*` wildcard first and specific rules after.
...
Control the agent’s mode with the`mode` config. The`mode` option is used to determine how the agent can be used.
...
The`mode` option can be set to`primary`,`subagent`, or`all`. If no`mode` is specified, it defaults to`all`.
...
Hide a subagent from the`@` autocomplete menu with`hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.
...
### Task permissions
...
Control which subagents an agent can invoke via the Task tool with`permission.task`. Uses glob patterns for flexible matching.
...
When set to`deny`, the subagent is removed from the Task tool description entirely, so the model won’t attempt to invoke it.
...
Customize the agent’s visual appearance in the UI with the`color` option. This affects how the agent appears in
...
### Top P
...
Control response diversity with the`top_p` option. Alternative to temperature for controlling randomness.
...
Any other options you specify in your agent configuration will be passed through directly to the provider as model options. This allows you to use provider-specific features and parameters.
...
## Create agents
...
You can create new agents using the following command:
...
This interactive command will:
...
1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which permissions the agent should be allowed (anything you don’t select is denied).
5. Finally, create a markdown file with the agent configuration.

---

Title: Agents - OpenCode
URL: https://opencode.ai/v2/docs/agents
Published: N/A
Author: N/A
Highlights:
Agents combine a system prompt, model preference, tool permissions, and display metadata into a reusable assistant profile. OpenCode includes agents for common workflows, and you can override them or add your own in configuration or Markdown files.
...
| Agent | Mode | Purpose |
...
| --- | --- | --- |
...
| Build (`build
...
| `primary` | Default coding agent. Tools are allowed by default, sensitive environment-file reads ask for approval, and access outside the workspace asks
...
approval. |
...
Planning agent. File edits are denied except for Open
...
general`) | `
...
| General-purpose
...
broad tool access but cannot
...
more subagents
...
`, and`
...
search`. |
...
You can override a built-in agent with an entry of the same ID. Set`disabled: true` to remove one.
...
Set the primary agent used when a session has not selected one:
...
```
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "reviewer"
}
...
The configured agent must exist, must not have`mode: "subagent"`, and must not be hidden. If it is unavailable, OpenCode falls back to`build`, then to the first visible agent that can run as a primary agent. This selection does not rewrite the agent already stored on an existing session.
...
An agent’s`mode` controls where it can run:
...
| Mode | Behavior |
| --- | --- |
| `primary` | Can be selected as the main agent for a session. It cannot be launched as a subagent. |
| `subagent` | Can run in a child session through the`subagent` tool, but cannot be selected as the main agent. |
| `all` | Can be used either way. This is the default for a custom agent when`mode` is omitted. |
...
## Configure agents
...
### Markdown files
...
The recommended file locations are:
...
```
~/.config/opencode/agents/<name>.md
.opencode/agents/<name>.md
...
OpenCode discovers project`.opencode` directories from the current directory up to the project root. The path below`agents/` becomes the agent ID, so`.opencode/agents/team/reviewer.md` defines`team/reviewer`.
...
Frontmatter uses the same fields as an entry under`agents`. The Markdown body becomes`system`:
...
```
---
description: Reviews changes without modifying files
mode: subagent
model: anthropic/claude-sonnet-4-5#high
color: "#ff6b6b"
...
steps: 8
permissions:
  - action: edit
    resource: "*"
    effect: deny
  - action: shell
    resource: "*"
    effect: deny
...
correctness, security,
...
### JSON or JSONC
...
Use the`agents` field in any OpenCode configuration file:
...
```
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "reviewer",
  "agents": {
    "reviewer": {
      "description": "Reviews changes for correctness, security, and missing tests",
      "mode": "all",
      "model": "anthropic/claude-sonnet-4-5#high",
      "system": "Review the current changes. Report findings before any summary.",
      "color": "#ff6b6b",
      "steps": 8,
      "permissions": [
        { "action": "edit", "resource": "*", "effect": "deny" },
        { "action": "shell", "resource": "*", "effect": "deny" }
      ]
    },
    "build": {
      "permissions": [
        { "action": "shell", "resource": "git push *", "effect": "ask" }
      ]
    }
  }
}
...
Agent definitions merge in configuration order. Later scalar fields replace earlier values, request maps merge by key, and permission rules are appended. Global`permissions` are applied to every agent before its agent-specific rules, so a later agent rule can refine a global rule.
...
Explains the agent’s purpose. It is optional, but strongly recommended for subagents because OpenCode includes it in the subagent catalog shown to the model.
...
Accepts`primary`,`subagent`, or`all`. The default is`all`.
...
Selects a model using`provider/model` with an optional`#variant`:
...
The TUI uses this as the preferred model when the agent is selected. A child session uses its subagent’s configured model, or inherits the parent session’s model when none is configured. In the API, the session’s selected model is stored separately; creating or switching a primary session with only an agent ID does not itself change that session model.
...
Sets the agent’s system prompt. A non-empty value replaces OpenCode’s provider-specific base prompt for that agent. Project instructions, skills, references, and other instruction sources are still added separately.
...
For a Markdown agent, use the document body instead of a`system` frontmatter field.
...
Permissions are an ordered array of rules:
...
```
{
  "agents": {
    "orchestrator": {
      "permissions": [
        { "action": "subagent", "resource": "*", "effect": "deny" },
        { "action": "subagent", "resource": "explore", "effect": "allow" },
        { "action": "shell", "resource": "git *", "effect": "ask" }
      ]
    }
  }
}
...
Each rule has:
...
| Field | Meaning |
| --- | --- |
| `action` | Tool or permission action, with`*` wildcards supported. |
| `resource` | The path, command, agent ID, or other resource matched by the action. Wildcards are supported. |
| `effect` | `allow`,`ask`, or`deny`. |
...
The last matching rule wins. Important V2 action names include`shell` for shell commands,`edit` for all edit/write/patch tools, and`subagent` for child agents. Other tools generally use their tool name, such as`read`,`glob`,`grep`,`webfetch`,`websearch`, and`skill`.
...
`~` and`$HOME` are expanded in filesystem resources for`read`,`edit`, and`external_directory`. Shell resources are raw command text and are not expanded.
...
Sets a positive maximum number of model steps. On the final allowed step, OpenCode removes tools and asks the model to summarize its work in text. New user input resets the allowance.
...
When`true`, removes the agent from normal selectors,`@` autocomplete, and the subagent catalog advertised to models. It is a visibility setting, not a security boundary.
...
Sets the agent’s UI color. Use a six-digit hex color such as`#ff6b6b`.
...
When`true`, removes the agent definition at that point in configuration loading. This works for built-in and custom agents.
...
The V2 schema accepts per-agent request`headers` and JSON`body` overlays:
...
```
{
  "agents": {
    "reviewer": {
      "request": {
        "headers": { "x-agent": "reviewer" },
        "body": { "temperature": 0.1 }
      }
    }
  }
}

---

Title: CLI | OpenCode
URL: https://opencode.ai/docs/cli/
Published: N/A
Author: N/A
Highlights:
Manage agents for OpenCode.
...
Create a new agent with custom configuration.
...
```
opencode agent create
...
This command will guide you through creating a new agent with a custom system prompt and permission configuration. Anything you don’t allow is denied in the generated agent’s frontmatter.
...
| Flag | Short | Description |
| --- | --- | --- |
| `--path` | | Directory to write the agent file to (defaults to global or`.opencode/agent` based on the prompt) |
| `--description` | | What the agent should do |
| `--mode` | | Agent mode:`all`,`primary`, or`subagent` |
| `--permissions` | | Comma-separated list of permissions to allow (default: all). Available:`bash`,`read`,`edit`,`glob`,`grep`,`webfetch`,`task`,`todowrite`,`websearch`,`lsp`,`skill`. Anything omitted is denied. Alias:`--tools` |
| `--model` | `-m` | Model to use, in`provider/model` format |
...
Passing all of`--path`,`--description`,`--mode`, and`--permissions` runs the command non-interactively.
...
## Environment variables
...
OpenCode can be configured using environment variables.
...
| Variable | Type | Description |
| --- | --- | --- |
| `OPENCODE_AUTO_SHARE` | boolean | Automatically share sessions |
| `OPENCODE_GIT_BASH_PATH` | string | Path to Git Bash executable on Windows |
| `OPENCODE_CONFIG` | string | Path to config file |
| `OPENCODE_TUI_CONFIG` | string | Path to TUI config file |
| `OPENCODE_CONFIG_DIR` | string | Path to config directory |
| `OPENCODE_CONFIG_CONTENT` | string | Inline json config content |
| `OPENCODE_DISABLE_AUTOUPDATE` | boolean | Disable automatic update checks |
| `OPENCODE_DISABLE_PRUNE` | boolean | Disable pruning of old data |
| `OPENCODE_DISABLE_TERMINAL_TITLE` | boolean | Disable automatic terminal title updates |
| `OPENCODE_PERMISSION` | string | Inlined json permissions config |
| `OPENCODE_DISABLE_DEFAULT_PLUGINS` | boolean | Disable default plugins |
| `OPENCODE_DISABLE_LSP_DOWNLOAD` | boolean | Disable automatic LSP server downloads |
...
| `OPENCODE_ENABLE_EXPERIMENTAL_MODELS` | boolean | Enable experimental models |
...
| `OPENCODE_DISABLE_AUTOCOMPACT` | boolean | Disable automatic context compaction |
...
| `OPENCODE_DISABLE_CLAUDE_CODE` | boolean | Disable reading from`.claude`(prompt + skills) |
| `OPENCODE_DISABLE_CLAUDE_CODE_PROMPT` | boolean | Disable reading`~/.claude/CLAUDE.md` |
| `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS` | boolean | Disable loading`.claude/skills` |
...
| `OPENCODE_DISABLE_MODELS_FETCH` | boolean | Disable fetching models from remote sources |
...
| `OPENCODE_DISABLE_MOUSE` | boolean | Disable mouse capture in the TUI |
| `OPENCODE_FAKE_VCS` | string | Fake VCS provider for testing purposes |
| `OPENCODE_CLIENT` | string | Client identifier (defaults to`cli`) |
| `OPENCODE_ENABLE_EXA` | boolean | Enable Exa web search tools |
| `OPENCODE_SERVER_PASSWORD` | string | Enable basic auth for`serve`/`web` |
| `OPENCODE_SERVER_USERNAME` | string | Override basic auth username (default`opencode`) |
| `OPENCODE_MODELS_URL` | string | Custom URL for fetching models configuration |

---

Title: Config | OpenCode
URL: https://dev.opencode.ai/docs/config/
Published: N/A
Author: N/A
Highlights:
1. Remote config (from`.well-known/opencode`) - organizational defaults
2. Global config (`~/.config/opencode/opencode.json`) - user preferences
3. Custom config (`OPENCODE_CONFIG` env var) - custom overrides
4. Project config (`opencode.json` in project) - project-specific settings
5. `.opencode` directories - agents, commands, plugins
6. Inline config (`OPENCODE_CONFIG_CONTENT` env var) - runtime overrides
7. Managed config files (`/Library/Application Support/opencode/` on macOS) - admin-controlled
8. macOS managed preferences (`.mobileconfig` via MDM) - highest priority, not user-overridable
...
Place your global OpenCode config in`~/.config/opencode/opencode.json`. Use global config for user-wide server/runtime preferences like providers, models, and permissions.
...
Add`opencode.json` in your project root. Project config has the highest precedence among standard config files - it overrides both global and remote configs.
...
Specify a custom config directory using the`OPENCODE_CONFIG_DIR` environment variable. This directory will be searched for agents, commands, modes, and plugins just like the standard`.opencode` directory, and should follow the same structure.
...
You can configure specialized agents for specific tasks through the`agent` option.
...
```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "code-reviewer": {      "description": "Reviews code for best practices and potential issues",      "model": "anthropic/claude-sonnet-4-5",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "tools": {        // Disable file modification tools for review-only agent        "write": false,        "edit": false,      },    },  },}
```
...
You can also define agents using markdown files in`~/.config/opencode/agents/` or`.opencode/agents/`. Learn more here.
...
### Default agent
...
You can set the default agent using the`default_agent` option. This determines which agent is used when none is explicitly specified.
...
The default agent must be a primary agent (not a subagent). This can be a built-in agent like`"build"` or`"plan"`, or a custom agent you’ve defined. If the specified agent doesn’t exist or is a subagent, OpenCode will fall back to`"build"` with a warning.
...
This setting applies across all interfaces: TUI, CLI (`opencode run`), desktop app, and GitHub Action.

---

Title: OpenCode Agents & Subagents: Configure AI Workflows - OpenCode Docs
URL: https://open-code.ai/en/docs/agents
Published: N/A
Author: N/A
Highlights:
Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.
...
Primary agents are the main assistants you interact with directly. You can cycle through them using the Tab key, or your configured`switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.
...
Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.
...
the default primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.
...
A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes. By default, all of the following are set to`ask`:
...
This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.
...
You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:
...
Configure agents in your`opencode.json` config file:
...
```
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "permission": {
        "edit": "deny",
        "bash": "deny"
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "permission": {
        "edit": "deny"
      }
    }
  }
}
...
You can also define agents using markdown files. Place them in:
...
- Global:`~/.config/opencode/agents/`
- Per-project:`.opencode/agents/`
...
```
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---

You are in code review mode. Focus on:

- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
...
The markdown file name becomes the agent name. For example,`review.md` creates a`review` agent.
...
Use the`description` option to provide a brief description of what the agent does and when to use it.
...
Control the randomness and creativity of the LLM's responses with the`temperature` config.
...
Temperature values typically range from 0.0 to 1.0:
...
opencode.json
...
### Max steps
...
Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. This allows users who wish to control costs to set a limit on agentic actions.
...
Set to`true` to disable the agent.
...
Specify a custom system prompt file for this agent with the`prompt` config. The prompt file should contain instructions specific to the agent's purpose.
...
Use the`model` config to override the model for this agent. Useful for using different models optimized for different tasks. For example, a faster model for planning, a more capable model for implementation.
...
Tip: If you don't specify a model, primary agents use the model globally configured while subagents will use the model of the primary agent that invoked the subagent.
...
### Tools (deprecated)
...
`tools` is deprecated. Prefer the agent's`permission` field for new configs, updates and more fine-grained control.
...
Allows you to control which tools are available in this agent. You can enable or disable specific tools by setting them to`true` or`false`. In an agent's`tools` config,`true` is equivalent to`{"*": "allow"}` permission and`false` is equivalent to`{"*": "deny"}` permission.
...
opencode.json
...
Note: The agent-specific config overrides the global config.
...
You can configure permissions to manage what actions an agent can take. Each permission key can be set to:
...
- `"ask"`— Prompt for approval before running the tool
- `"allow"`— Allow all operations without approval
- `"deny"`— Disable the tool
...
The available permission keys are:
...
| Key | Tools it gates |
| --- | --- |
| `read` | `read` |
| `edit` | `write`,`edit`,`apply_patch` |
| `glob` | `glob` |
| `grep` | `grep` |
| `list` | `list` |
| `bash` | `bash` |
| `task` | `task` |
| `external_directory` | Any tool that reads or writes files outside the project worktree |
| `todowrite` | `todowrite`,`todoread` |
| `webfetch` | `webfetch` |
| `websearch` | `websearch` |
| `lsp` | `lsp` |
| `skill` | `skill` |
| `question` | `question` |
| `doom_loop` | Recovery prompts when an agent appears stuck |
...
`read`,`edit`,`glob`,`grep`,`list`,`bash`,`task`,`external_directory`,`lsp`, and`skill` accept either a shorthand action (`"allow" | "ask" | "deny"`) or an object of glob/pattern → action for fine-grained control. The remaining keys accept the shorthand action only.
...
Note: Permission keys are matched as wildcard patterns against the underlying tool name, so the same syntax works for built-ins, custom tools, and MCP tools — for example`"mymcp_*": "deny"` denies every tool from an MCP server, and`"mymcp_search": "ask"` targets a single one.
...
opencode.json
...
You can override these permissions per agent.
...
opencode.json
...
You can also set permissions in Markdown agents.
...
You can set permissions for specific bash commands.
...
opencode.json
...
And you can also use the`*` wildcard to manage permissions for all commands. Since the last matching rule takes precedence, put the`*` wildcard first and specific rules after.
...
Control the agent's mode with the`mode` config. The`mode` option is used to determine how the agent can be used.
...
The`mode` option can be set to`primary`,`subagent`, or`all`. If no`mode` is specified, it defaults to`all`.
...
Hide a subagent from the`@` autocomplete menu with`hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.
...
. Hidden agents can still be invoked by the model via the
...
### Task permissions
...
Control which subagents an agent can invoke via the Task tool with`permission.task`. Uses glob patterns for flexible matching.
...
When set to`deny`, the subagent is removed from the Task tool description entirely, so the model won't attempt to invoke it.
...
Tip: Users can always invoke any subagent directly via the`@` autocomplete menu, even if the agent's task permissions would deny it.
...
Customize the agent's visual appearance in the UI with the`color` option. This affects how the agent appears in
...
### Top P
...
option. Alternative to temperature for controlling randomness.
...
Any other options you specify in your agent configuration will be passed through directly to the provider as model options. This allows you to use provider-specific features and parameters.
...
## Create agents
...
You can create new agents using the following command:
...
This interactive command will:
...
1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which permissions the agent should be allowed (anything you don't select is denied).
5. Finally, create a markdown file with the agent configuration.
...
- Plan agent : Analysis and planning without making
...
Code review with read-only

---

Title: OpenCode Multi-Agent Setup: 3 AI Coding Agents | Amir Teymoori
URL: https://amirteymoori.com/opencode-multi-agent-setup-specialized-ai-coding-agents/
Published: 2025-11-30T12:02:53.000Z
Author: Amir Teymoori
Highlights:
I configured OpenCode with 3 specialized agents that work together, and my code quality went up dramatically. The secret? Each agent has a specific role, optimized temperature, and restricted tool access.
...
Here’s the complete OpenCode configuration:

```
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-opus-4-5-20251101",
  "agent": {
    "coder": {
      "description": "Primary coding agent using Claude Opus 4.5",
      "mode": "primary",
      "model": "anthropic/claude-opus-4-5-20251101",
      "temperature": 0.2,
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "researcher": {
      "description": "Research agent using Perplexity Sonar Pro for real-time web search",
      "mode": "subagent",
      "model": "perplexity/sonar-pro",
      "temperature": 0.8,
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "debugger": {
      "description": "Debug and testing agent using GPT-5.1 Codex",
      "mode": "subagent",
      "model": "openai/gpt-5.1-codex",
      "temperature": 0.3,
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    }
  }
}
...
Role: Primary development agent Model:`anthropic/
...
-opus-
...
-202
...
1101
...
Temperature: 0.2
...
Tools: Full access (write, edit, bash
...
```
"coder": {
  "description": "Primary
...
agent using Claude
...
4.5",
  "mode": "primary",
  "model": "anthropic/
...
-5-20251101",
  "temperature": 0.2,
  "tools": {
    "write": true,
    "edit": true,
    "bash": true
  }
}
...
Role: Real-time documentation and API research Model:`perplexity/sonar-pro` Temperature: 0.8 (creative exploration) Tools: None (research only)
...
Security principle: Agents with web access should be read-only on your filesystem.
...
### Researcher Configuration
...
```
"researcher": {
  "description": "Research agent using Perplexity Sonar Pro for real-time web search",
  "mode": "subagent",
  "model": "perplexity/sonar-pro",
  "temperature": 0.8,
  "tools": {
    "write": false,
    "edit": false,
    "bash": false
  }
}
...
## Agent 3: The Debug
...
(GPT-5.1 Codex)
...
Role: Testing, debugging, and validation Model:`openai/gpt-5.1-codex` Temperature: 0.3 (balanced) Tools: Full access (to run tests and apply fixes)
...
- Run tests
...
### Debugger Configuration
...
```
"debugger": {
  "description": "Debug and testing agent using GPT-5.1 Codex",
  "mode": "subagent",
  "model": "openai/gpt-5.1-codex",
  "temperature": 0.3,
  "tools": {
    "write": true,
    "edit": true,
    "bash": true
  }
}
...
## Setting Up OpenCode
...
### Configuration File Location
...
Create your config at one of these locations:
...
```
# Project-specific (recommended)
.opencode/opencode.json

# Global
~/.config/opencode/opencode.json
```
...
### Complete Configuration
...
Here’s the full`opencode.json`:
...
```
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-opus-4-5-20251101",
  "agent": {
    "coder": {
      "description": "Primary coding agent using Claude Opus 4.5",
      "mode": "primary",
      "model": "anthropic/claude-opus-4-5-20251101",
      "temperature": 0.2,
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "researcher": {
      "description": "Research agent using Perplexity Sonar Pro for real-time web search",
      "mode": "subagent",
      "model": "perplexity/sonar-pro",
      "temperature": 0.8,
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "debugger": {
      "description": "Debug and testing agent using GPT-5.1 Codex",
      "mode": "subagent",
      "model": "openai/gpt-5.1-codex",
      "temperature": 0.3,
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    }
  }
}
```
...
### API Keys Setup
...
### Verify Setup
...
```
opencode
...
# Then run
/models    # Should show all configured models
/agents    # Should show coder, researcher, debugger
...
## Alternative Agent Configurations
...
```
{
  "agent": {
    "coder": {
      "model": "anthropic/claude-sonnet-4-20251101",
      "temperature": 0.2,
      "mode": "primary",
      "tools": { "write": true, "edit": true, "bash": true }
    },
    "researcher": {
      "model": "perplexity/sonar",
      "temperature": 0.8,
      "mode": "subagent",
      "tools": { "write": false, "edit": false, "bash": false }
    },
    "debugger": {
      "model": "openai/gpt-4o-mini",
      "temperature": 0.3,
      "mode": "subagent",
      "tools": { "write": true, "edit": true, "bash": true }
    }
  }
}
...
### Local Models Setup
...
```
{
  "agent": {
    "coder": {
      "model": "ollama/deepseek-coder-v2",
      "temperature": 0.2,
      "mode": "primary",
      "tools": { "write": true, "edit": true, "bash": true }
    },
    "reviewer": {
      "model": "ollama/codellama",
      "temperature": 0.1,
      "mode": "subagent",
      "description": "Code review agent",
      "tools": { "write": false, "edit": false, "bash": false }
    }
  }
}
...
## Best Practices
...
### 1. Match Temperature to Task
...
| Task Type | Temperature | Reasoning |
| --- | --- | --- |
| Code generation | 0.1-0.3 | Deterministic, follows patterns |
| Debugging | 0.2-0.4 | Methodical with slight flexibility |
| Research | 0.7-0.9 | Explores diverse options |
| Creative writing | 0.8-1.0 | Maximum diversity |
...
### 2. Restrict Tools by Role
...
Principle of least privilege:
...
- Research agents: No file access
- Review agents: Read-only
- Implementation agents: Full access
...
### 3. Use Descriptive Agent Names
...
```
"security-auditor": { "description": "
...
security vulnerabilities" }
"api-documenter": { "description": "
...
ates OpenAPI specs from code" }
...
### 4. Create Project-Specific Agents
...
Put specialized agents in`.opencode/agent/`:
...
```
.opencode/
├── agent/
│   ├── django-expert.md
│   ├── typescript-migrator.md
│   └── test-writer.md
└── opencode.json
```
...
### 5. Test Agent Collaboration
...
Before relying on auto-invocation, manually test:
...
```
@researcher [your typical research question]
@debugger [your typical debug scenario]
```
...
Ensure each agent returns useful results.
...
## Common Issues
...
### Agent Not Found
...
Problem:`@researcher not recognized`
...
Fix: Check configuration is in correct location:
...
```
# Should be one of:
.opencode/opencode.json
~/.config/opencode/opencode.json
...
### Wrong Model Invoked
...
Problem: Subagent uses wrong model
...
Fix: Ensure`model` field is correct:
...
```
"researcher": {
  "model": "perplexity/sonar-pro",  // Not just "perplexity"
  ...
}
...
### Subagent Can’t Access Files
...
Problem: Debugger says “I don’t have file access”
...
Fix: Check tools configuration:
...
```
"tools": {
  "write": true,   // Must be true
  "edit": true,    // Must be true
  "bash": true     // Must be true
}
```
...
### API Rate Limits
...
Fix: Add delays between heavy operations, or use different providers for different agents to spread load.
...
offs. The plan agent writes a plan; the coder reads it, edits files,
...
signals when done; the debugger agent runs tests. Each agent sees

---

Title: Rules | OpenCode
URL: https://dev.opencode.ai/docs/rules/
Published: N/A
Author: N/A
Highlights:
You can provide custom instructions to opencode by creating an`AGENTS.md` file. This is similar to Cursor’s rules. It contains instructions that will be included in the LLM’s context to customize its behavior for your specific project.
...
To create a new`AGENTS.md` file, you can run the`/init` command in opencode.
...
`/init` scans the important files in your repo, may ask a couple of targeted questions when the codebase cannot answer them, and then creates or updates`AGENTS.md` with concise project-specific guidance.
...
It focuses on the things future agent sessions are most likely to need:
...
- build, lint, and test commands
- command order and focused verification steps when they matter
- architecture and repo structure that are not obvious from filenames alone
- project-specific conventions, setup quirks, and operational gotchas
- references to existing instruction sources like Cursor or Copilot rules
...
If you already have an`AGENTS.md`,`/init` will improve it in place instead of blindly replacing it.
...
opencode also supports reading the`AGENTS.md` file from multiple locations. And this serves different purposes.
...
Place an`AGENTS.md` in your project root for project-specific rules. These only apply when you are working in this directory or its sub-directories.
...
You can also have global rules in a`~/.config/opencode/AGENTS.md` file. This gets applied across all opencode sessions.
...
Since this isn’t committed to Git or shared with your team, we recommend using this to specify any personal rules that the LLM should follow.
...
For users migrating from Claude Code, OpenCode supports Claude Code’s file conventions as fallbacks:
...
- Project rules:`CLAUDE.md` in your project directory (used if no`AGENTS.md` exists)
- Global rules:`~/.claude/CLAUDE.md`(used if no`~/.config/opencode/AGENTS.md` exists)
- Skills:`~/.claude/skills/`— see Agent Skills for details
...
To disable Claude Code compatibility, set one of these environment variables:
...
```
export OPENCODE_DISABLE_CLAUDE_CODE=1        # Disable all .claude supportexport OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=1 # Disable only ~/.claude/CLAUDE.mdexport OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1 # Disable only .claude/skills
```
...
When opencode starts, it looks for rule files in this order:
...
1. Local files by traversing up from the current directory (`AGENTS.md`,`CLAUDE.md`)
2. Global file at`~/.config/opencode/AGENTS.md`
3. Claude Code file at`~/.claude/CLAUDE.md`(unless disabled)
...
The first matching file wins in each category. For example, if you have both`AGENTS.md` and`CLAUDE.md`, only`AGENTS.md` is used. Similarly,`~/.config/opencode/AGENTS.md` takes precedence over`~/.claude/CLAUDE.md`.
...
You can specify custom instruction files in your`opencode.json` or the global`~/.config/opencode/opencode.json`. This allows you and your team to reuse existing rules rather than having to duplicate them to AGENTS.md.
...
encode.json
...
```
{  "$schema": "https://opencode.ai/config.json",  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]}
```
...
You can also use remote URLs to load instructions from the web.
...
{  "$schema": "https://op
...
.json",  "
...
Remote instructions are fetched with a 5 second timeout.
...
All instruction files are combined with your`AGENTS.md` files.
...
While opencode doesn’t automatically parse file references in`AGENTS.md`, you can achieve similar functionality in two ways:
...
### Using opencode.json
...
The recommended approach is to use the`instructions` field in`opencode.json`:
...
encode.json
...
```
{  "$schema": "https://opencode.ai/config.json",  "instructions": ["docs/development-standards.md", "test/testing-guidelines.md", "packages/*/AGENTS.md"]}
```
...
You can teach opencode to read external files by providing explicit instructions in your`AGENTS.md`. Here’s a practical example:
...
```
# TypeScript Project Rules## External File LoadingCRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.Instructions:- Do NOT preemptively load all references - use lazy loading based on actual need- When loaded, treat content as mandatory instructions that override defaults- Follow references recursively when needed## Development GuidelinesFor TypeScript code style and best practices: @docs/typescript-guidelines.mdFor React component architecture and hooks patterns: @docs/react-patterns.mdFor REST API design and error handling: @docs/api-standards.mdFor testing strategies and coverage requirements: @test/testing-guidelines.md## General GuidelinesRead the following file immediately as it's relevant to all workflows: @rules/general-guidelines.md.
...
This approach allows you to:

- Create modular, reusable rule files
- Share rules across projects via symlinks or git submodules
- Keep AGENTS.md concise while referencing detailed guidelines
- Ensure opencode loads files only when needed for the specific task
```

**Tool: bash**

**Input:**
```json
{
  "command": "ls -la ~/.config/opencode/ 2>/dev/null; echo \"---\"; ls -la ~/.config/opencode/agent/ 2>/dev/null; echo \"---\"; ls -la ~/.config/opencode/skills/ 2>/dev/null; echo \"---\"; ls -la .opencode/ 2>/dev/null; echo \"---\"; ls -la opencode/.config/opencode/ 2>/dev/null"
}
```

**Output:**
```
total 52
drwxrwxr-x   5 lalitmee lalitmee  4096 Jul 26 05:07 .
drwx------ 111 lalitmee lalitmee  4096 Aug  1 21:56 ..
-rw-r--r--   1 lalitmee lalitmee   707 May 18 15:43 bun.lock
lrwxrwxrwx   1 lalitmee lalitmee    48 Jul 26 05:07 command -> ../../dotfiles/opencode/.config/opencode/command
-rw-rw-r--   1 lalitmee lalitmee   122 Jul  2 01:22 dcp.jsonc
-rw-rw-r--   1 lalitmee lalitmee    45 Oct 25  2025 .gitignore
drwxr-xr-x  27 lalitmee lalitmee  4096 Jun  4 22:20 node_modules
lrwxrwxrwx   1 lalitmee lalitmee    57 Jul 26 05:07 not-active-agent -> ../../dotfiles/opencode/.config/opencode/not-active-agent
lrwxrwxrwx   1 lalitmee lalitmee    54 Jul 26 05:07 opencode.json -> ../../dotfiles/opencode/.config/opencode/opencode.json
-rw-rw-r--   1 lalitmee lalitmee    65 Jun  4 22:20 package.json
-rw-rw-r--   1 lalitmee lalitmee 13668 Jun  4 22:20 package-lock.json
lrwxrwxrwx   1 lalitmee lalitmee    48 Jul 26 05:07 prompts -> ../../dotfiles/opencode/.config/opencode/prompts
drwxrwxr-x   2 lalitmee lalitmee  4096 Jun 28  2025 providers
drwxrwxr-x   2 lalitmee lalitmee  4096 Jul 26 05:05 skills
lrwxrwxrwx   1 lalitmee lalitmee    47 Jul 26 05:07 themes -> ../../dotfiles/opencode/.config/opencode/themes
lrwxrwxrwx   1 lalitmee lalitmee    49 Jul 26 05:07 tui.json -> ../../dotfiles/opencode/.config/opencode/tui.json
---
---
total 8
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul 26 05:05 .
drwxrwxr-x 5 lalitmee lalitmee 4096 Jul 26 05:07 ..
lrwxrwxrwx 1 lalitmee lalitmee   58 Jul 19 00:48 karpathy-guidelines -> /home/lalitmee/dotfiles/skills-library/karpathy-guidelines
---
---
total 36
drwxr-xr-x 7 lalitmee lalitmee 4096 Jul 29 01:00 .
drwxr-xr-x 3 lalitmee lalitmee 4096 Jul  3  2025 ..
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul 17 19:00 command
drwxrwxr-x 4 lalitmee lalitmee 4096 Nov 22  2025 not-active-agent
-rw-rw-r-- 1 lalitmee lalitmee 1375 Jul 29 01:00 opencode.json
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul 26 05:06 prompts
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul  9 02:33 skills
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul  3 21:40 themes
-rw-rw-r-- 1 lalitmee lalitmee  206 Jul  9 02:26 tui.json

```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 9.9s)

_Thinking:_

Good. Now I have a lot of research already. Let me look at the user's current setup more deeply - their opencode.json, and check what agent directories exist. Also, let me check what GitHub repos/communities recommend. I should look at:

1. User's current `opencode.json`
2. What's in `~/.config/opencode/not-active-agent` (maybe their old agents?)
3. GitHub awesome lists for opencode agents

Let me also search GitHub for awesome-opencode agent collections and check community discussions (reddit/HN).

Let me read the config files and search GitHub in parallel.

Good data. Let me dig into your current config and check GitHub/community for agent collections.

**Tool: read**

**Input:**
```json
{
  "filePath": "/home/lalitmee/dotfiles/opencode/.config/opencode/opencode.json"
}
```

**Output:**
```
<path>/home/lalitmee/dotfiles/opencode/.config/opencode/opencode.json</path>
<type>file</type>
<content>
1: {
2:   "$schema": "https://opencode.ai/config.json",
3:   "autoshare": false,
4:   "autoupdate": true,
5:   "plugin": [
6:     "superpowers@git+https://github.com/obra/superpowers.git",
7:     "@tarquinen/opencode-dcp@latest",
8:     "@dietrichgebert/ponytail"
9:   ],
10:   "agent": {
11:     "plan": {
12:       "color": "accent"
13:     },
14:     "build": {
15:       "color": "primary"
16:     },
17:     "discover": {
18:       "description": "Discover mode — research GitHub repos, topics, or URLs and align on intent",
19:       "mode": "primary",
20:       "temperature": 0.3,
21:       "color": "success",
22:       "prompt": "{file:./prompts/explore-mode.txt}",
23:       "permission": {
24:         "read": "allow",
25:         "edit": "deny",
26:         "bash": "deny",
27:         "grep": "allow",
28:         "glob": "allow",
29:         "webfetch": "allow",
30:         "websearch": "allow",
31:         "skill": "allow",
32:         "todowrite": "allow"
33:       }
34:     },
35:     "explore": {
36:       "color": "secondary"
37:     },
38:     "general": {
39:       "color": "warning"
40:     }
41:   },
42:   "mcp": {
43:     "context7": {
44:       "type": "local",
45:       "command": ["npx", "-y", "@upstash/context7-mcp"],
46:       "environment": {
47:         "DEFAULT_MINIMUM_TOKENS": "6000"
48:       }
49:     },
50:     "crash": {
51:       "type": "local",
52:       "command": ["npx", "-y", "crash-mcp"]
53:     },
54:     "chrome-devtools": {
55:       "command": ["npx", "-y", "chrome-devtools-mcp@latest"],
56:       "type": "local"
57:     }
58:   }
59: }

(End of file - total 59 lines)
</content>
```

**Tool: bash**

**Input:**
```json
{
  "command": "ls -la ~/.config/opencode/not-active-agent/ 2>/dev/null; echo \"---\"; ls -la ~/.config/opencode/skills/ 2>/dev/null; echo \"---\"; ls ~/.config/opencode/agent 2>/dev/null; echo \"---\"; ls ~/.config/opencode/agents 2>/dev/null"
}
```

**Output:**
```
total 16
drwxrwxr-x 4 lalitmee lalitmee 4096 Nov 22  2025 .
drwxr-xr-x 7 lalitmee lalitmee 4096 Jul 29 01:00 ..
drwxrwxr-x 2 lalitmee lalitmee 4096 Nov 22  2025 dev
drwxrwxr-x 2 lalitmee lalitmee 4096 Dec  3  2025 git
---
total 8
drwxrwxr-x 2 lalitmee lalitmee 4096 Jul 26 05:05 .
drwxrwxr-x 5 lalitmee lalitmee 4096 Jul 26 05:07 ..
lrwxrwxrwx 1 lalitmee lalitmee   58 Jul 19 00:48 karpathy-guidelines -> /home/lalitmee/dotfiles/skills-library/karpathy-guidelines
---
---

```

**Tool: websearch**

**Input:**
```json
{
  "numResults": 6,
  "query": "github awesome opencode agents collection .opencode/agents community"
}
```

**Output:**
```
Title: mouyox21/opencode-agents
URL: https://github.com/mouyox21/opencode-agents
Published: N/A
Author: N/A
Highlights:
A collection of 258 sub-agents + 1 orchestrator specialized OpenCode agents for software development workflows — architecture, testing, security, devops, and more
...
CLI + npm library + registry for 259 specialized OpenCode agents (258 sub-agents + 1 orchestrator).
...
- **🔍 Search & Discover** — Find agents by name, description, or category
- **📦 Install / Update / Remove** — Manage agents like npm packages
- **🌐 Global or Per-Project** — Install system-wide or in `.opencode/agents/`
- **📋 Registry** — Built-in registry of all 259 agents with version info
- **💻 CLI** — Full-featured command-line interface
- **📚 Library** — Programmatic API for Node.js (ESM + CJS)
...
**259 agents** across **11 categories**:
...
```bash
mkdir -p .opencode/agents/
...
# Copy agent files from node_modules or repository
```
...
```bash
mkdir -p ~/.config/opencode/agents/

---

Title: ankitmundada/awesome-opencode-subagents
URL: https://github.com/ankitmundada/awesome-opencode-subagents
Published: 2026-02-03T08:57:37.000Z
Author: N/A
Highlights:
100+ subagents for opencode
...
---


 🤖 Awesome OpenCode CLI Subagents
 A curated collection of specialized AI assistants for OpenCode CLI





[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
...
![Subagent
...
This repository serves as the definitive collection of OpenCode CLI subagents, specialized AI assistants designed for specific development tasks.
...
Clone this repository
...
. Copy desired agent files to:
...
- `~/.config/opencode/agents/` for global access
 - `.opencode/agents/` for project-specific use
...
Check the [categories/](categories/) directory for the full list of available subagents.
...
### Subagent Storage Locations
...
| Type | Path | Availability | Precedence |
| --- | --- | --- | --- |
| Project Subagents | `.opencode/agents/` | Current project only | Higher |
| Global Subagents | `~/.config/opencode/agents/` | All projects | Lower |

---

Title: awesome-opencode/awesome-opencode: A curated list of awesome ...
URL: https://github.com/awesome-opencode/awesome-opencode
Published: N/A
Author: N/A
Highlights:
A curated list of awesome plugins, themes, agents, projects, and resources for https://opencode.ai
...
## README










 Awesome Opencode




  






 A curated list of plugins, themes, agents, and resources for Opencode.
 The AI coding agent for the terminal, built by the team at Anomaly.



[**OFFICIAL**](#official) • [**PLUGINS**](#plugins) • [**THEMES**](#themes) • [**AGENTS**](#agents) • [**PROJECTS**](#projects) • [**RESOURCES**](#resources)










 ⭐️ Official Repositories

| Project | Stars | Description |
| :--- | :--- | :--- |
| **[opencode](https://github.com/anomalyco/opencode)** | ![Stars](https://badgen.net/github/stars/anomalyco/opencode) | The official opencode AI coding agent. |
...
. |






 🧩 PLUGINS



 @bluelovers/opencode-arise - 「⚔️ ARISE!」　A Solo Leveling themed orchestrator harness for OpenCode

 A lightweight, token-efficient orchestrator layer. Enables parallel background task execution in OpenCode. Launch AI agents to work simultaneously on exploration and research while continuing with other tasks. Allows specifying custom models for each_agent via configuration.

 🔗 View Repository




 aerovato/opencode-quotes-plugin - Display inspirational quotes instead of tips

 Replaces the default home-page tips with inspirational quotes for a more motivating OpenCode experience.

 🔗 View Repository




 Agent Identity - Agent self-identity and per-message attribution for multi-agent sessions

 Two plugins that improve agent identity awareness. AgentSelfIdentityPlugin injects a one
...
.

 🔗 View Repository




 Agent Memory - Letta
...
Oh My Opencode - Agents & Pre-built tools

 Background agents, pre-built tools (LSP/AST/MCP), curated agents, and a Claude Code compatible layer.

 🔗 View Repository




 Oh My Opencode Slim - Lightweight agent orchestration with reduced token usage

 Slimmed-down fork of oh-my-opencode focused on core agent
...
port setups, and cleans up when sessions finish.

 🔗 View Repository




 Opencode Agents Sidebar - Browse configured OhMyOpenAgent agents in the TUI

 OpenCode sidebar plugin that displays configured OhMyOpenAgent agents with lifecycle-based categories, collapsible sections, descriptions, and model information.

 🔗 View Repository




 Opencode Canvas - Interactive terminal canvases in tmux splits

 Interactive terminal canvases (calendars, documents, flight booking) in tmux splits. Port of claude-canvas for OpenCode.

 🔗 View Repository
...
.

 🔗 View Repository




 ➕ Add a Theme via PR







 🤖 AGENTS



 Agentic - Modular AI agents

 Modular AI agents and commands for structured software development with opencode.

 🔗 View Repository




 Claude Subagents - Claude Code subagents

 Comprehensive reference repository for production-ready Claude Code subagents.

 🔗 View Repository




 deliberation - Ask GPT, Gemini, Grok, or OpenRouter for a second opinion or a fix, as expert subagents over MCP

 Get a delegated second opinion or an actual fix from GPT (Codex), Gemini, Grok (xAI), or OpenRouter
...
plus the ask-gpt, ask-gemini, ask-grok, ask-openrouter, ask-all, and consensus commands. Each one can advise (read-only) or implement. ask-all asks every model at once and compares
...
answers; consensus runs an arbiter loop until the models agree.

 🔗 View Repository
...
🔗 View Repository




 NERV - Invisible engineering infrastructure for AI agents

 Spec-Driven Development pipeline, A2A task delegation hub, persistent semantic memory (MAGI), and 9 specialized subagents for OpenCode. Scaffolds 45+ files via `nerv init` including SDD skills, slash commands, MCP servers, and lifecycle plugins.

 🔗 View Repository




 Opencode Agents - Enhanced workflows

 A set of opencode configurations, prompts, agents, and plugins for enhanced development workflows.

 🔗 View Repository




 Python Expert Agent for OpenCode - Python Expert Agent toolkit for OpenCode with subagents and skills

 A custom configurable agent toolkit includes 1 Primary Custom Agent python-expert with intelligent skill loading, Predefined Specialized Subagents for Code generation, review, testing, and exploration, On-Demand Skills for Python development projects, Context Files for Standards, patterns, and security guidelines.

 🔗 View Repository




 Redstone - AI-built Minecraft plugins

 an Opencode agent that simplifies Minecraft plugin development and deployment.

 🔗 View Repository




 server-manager - Non-blocking background server management — start, track, and stop local dev servers without blocking your AI session.

 Start, track, and stop local dev servers in the background — without blocking your AI conversation. Supports Node.js, Python, Go, .NET, Java, Rust, PHP and any framework that runs a dev server. JSON state persistence, per-project log files, HTTP health checks, and log tail/grep for debugging.

 🔗 View Repository




 ➕ Add an Agent via PR







 🛠 PROJECTS



 Agent of Empires - Multi-session TUI for OpenCode

 A terminal UI for managing multiple OpenCode sessions in tmux with git worktree integration and Docker sandboxing.

 🔗 View Repository




 agent-dotfiles - Write AI coding rules once, sync to every agent

 Write AI coding rules once, sync to every agent. Supports Command Code, Claude Code, Cursor, Copilot, Codex, and OpenCode.

 🔗 View Repository




 agent-harness - Reusable agent asset lifecycle for OpenCode workspaces

 A Node.js CLI for discovering, curating, staging, activating, and wiring reusable AI-agent assets into developer workspaces, including OpenCode.

 🔗 View Repository




 AgentDeals - MCP server aggregating free tiers, credits, and referral codes across 1,500+ developer tools

 Remote MCP server that surfaces free tiers, credits, trials, and referral codes for developer infrastructure — Railway, Vercel, Fly, OpenAI, Anthropic, and 1,500+ other vendors. Exposes four tools (search_deals, plan_stack, compare_vendors, track_changes) so an agent can find the cheapest way to ship a given stack. Works with opencode via remote URL (https://agent
...
-production.up.railway.app/mcp). Also tracks pricing changes over time.

 🔗 View Repository




 agenttrace - Local TUI for Open
...
View Repository




 Beads
...
).

 🔗 View Repository




 Universal LLM API Proxy - Universal multi-model proxy and library - made with Opencode community

 Universal LLM Gateway: One API, every LLM. OpenAI/Anthropic-compatible endpoints with multi-provider translation and intelligent load-balancing. Works with any application that supports custom OpenAI/Anthropic base URLs—no code changes required in your existing tools. Best support for Antigravity/Gemini CLI out of the competition. Deploy anywhere. Opencode Discord discussion

 🔗 View Repository




 Unship
...
agents in parallel.

 🔗 View Repository




 ➕ Add a Project via PR







 📚 RESOURCES



 Akephalos - Local-first markdown passport for portable agent context and memory

 A local-first, markdown-first `.akephalos` passport for portable agent preferences, tool notes, rules, project context, and durable memories. It uses plain files and Git so MCP-capable coding-agent workflows can inspect and carry context across tools and machines without hosted sync
...
🔗 View Repository




 Coding Agent Orchestration - OpenCode Setup Guide / Orchestration

 An opinionated but practical handbook that argues for treating AI coding tools as a composable, multi-agent system rather than a single assistant, and then walks through how to implement that mindset using OpenCode's CLI, configuration system, and ecosystem (agents, tools, skills, and plugins).

 🔗 View Repository

---

Title: humanuoid/opencode-agents-hub
URL: https://github.com/humanuoid/opencode-agents-hub
Published: 2026-01-10T14:06:53.000Z
Author: N/A
Highlights:
# Repository: humanuoid/opencode-agents-hub
...
🤖 Ready-to-use AI agents & skills for OpenCode — plan, code, review, commit, release. Generic, multilingual, stack-agnostic.
...
# OpenCode Agents Hub
...
A collection of ready-to-use agents and skills for [OpenCode](https://opencode.ai) to assist developers in their daily tasks.
...
- **Generic** — Works with any language, framework, or stack
- **Context-aware** — Relies on your project's `AGENTS.md` for specific conventions
- **No vendor lock-in** — Uses your configured model/provider
- **Multilingual** — Responds in your language
...
## 📦 Agents
...
| Agent | Description |
| --- | --- |
| `dev-architect` | Design implementation plans before coding. Think before you build. |
| `debugger` | Analyze errors and bugs. Diagnose without modifying code. |
...
### Subagents (@ mention)
...
| Agent | Description |
| --- | --- |
| `commit-writer` | Generate commit messages following Conventional Commits. |
| `code-review` | Review code for bugs, security, performance, and best practices. |
| `task-writer` | Draft tasks/tickets from ideas or bugs. Concise and actionable. |
| `pr-writer` | Create pull requests on GitHub/GitLab with structured descriptions. |
| `release-notes` | Generate and publish release notes matching your project's style. |
...
| Skill | Description |
| --- | --- |
| `git-conventions` | Conventional Commits, branch naming, PR standards, SemVer, changelog format. |
| `context7-lookup` | How to use Context7 MCP for up-to-date library documentation. |
...
# Create symlinks to your global OpenCode config
ln -s $(pwd)/agent ~/.config/opencode/agent
ln -s $(pwd)/skill ~/.config/opencode/skill
```
...
Or manually copy the `agent/` and `skill/` folders to `~/.config/opencode/`.
...
### Alternative: Per-Project (Git Submodule)
...
```bash
# Add as submodule in your project
git submodule add https://github.com/humanuoid/opencode-agents-hub.git .opencode
...
# The agents and skills will be available only in this project
```
...
For best results, create an `AGENTS.md` file at the root of your project describing:
...
Create a file with the same name in your project's `.opencode/agent/` to override:
...
```markdown
<!-- .opencode/agent/commit-writer.md -->
---
description: Custom commit writer for this project
mode: subagent
---
...
- [OpenCode Docs](https://opencode.ai/docs/)
- [Agents Documentation](https://opencode.ai/docs/agents/)
- [Skills Documentation](https://opencode.ai/docs/skills/)
- [Model Recommendations](docs/models-recommendation.md)
- [AGENTS.md Template](docs/AGENTS.template.md)

---

Title: weisser-dev/awesome-opencode
URL: https://github.com/weisser-dev/awesome-opencode
Published: 2026-03-27T06:38:11.000Z
Author: N/A
Highlights:
108 agents, 15 skills, smart model config, and interactive CLI for OpenCode — npx @weisser-dev/awesome-opencode
...
The most comprehensive collection of agents, skills, and tooling for [OpenCode](https://opencode.ai) -- the open-source AI coding agent.
...
**108 agents** | **15 skills** | **18 curated MCP servers** | **Live MCP registry search** | **Smart model detection**
...
> Inspired by [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents), fully adapted for OpenCode with permissions, skills, and markdown agent format.
...
✔ No AGENTS.md found. Generate one with project-specific rules? Yes

  Generated:
    .opencode/agents/ (5 agents)
    .opencode/skills/ (3 skills)
    opencode.json (updated)
    .opencode/advanced.json (state)
    AGENTS.md (generated)

  Setup complete!
...
```bash
# 1. Copy agents
mkdir -p .opencode/agents
cp templates/agents/code-reviewer.md .opencode/agents/
cp templates/agents/typescript-pro.md .opencode/agents/
...
# 2. Copy skills
mkdir -p .opencode/skills/git-release
cp templates/skills/git-release/SKILL.md .opencode/skills/git-release/
...
/cost-
...
# then /
...
in the TUI
...
This project builds on the work of several open-source communities:
...
- **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** -- The agent collection (127+ subagents) served as the primary inspiration. All agents were adapted for OpenCode with permissions, skill integration, and markdown format.
...
- **[darrenhinde/OpenAgentsControl](https://github.com/darrenhinde/OpenAgentsControl)** -- Agent configuration patterns and workflows.
...
](https://
...
ystem/)
...
[MCP Server Directory
...
so)
...
benchmarks
- [
...
](https://

---

Title: heads/main/README.md
URL: https://github.com/ampedweb/awesome-subagents/blob/refs/heads/main/README.md
Published: N/A
Author: N/A
Highlights:
- Repository: ampedweb/awesome-subagents | A collection of 100+ specialized subagents covering a wide range of development use cases, originally just for Claude Code, but now with a script to convert them to Cursor and Opencode compatible syntax. | 3 stars | Shell
- Branch: refs
...
**A curated collection of AI coding agent definitions for Claude Code, OpenCode, and Cursor.**
...
This repository contains 131+ specialised AI agent definitions organised into 10 categories. The definitions in `categories/` use the Claude Code format as the canonical source. The `generate.sh` script produces equivalent definitions for OpenCode and Cursor.
...
Cursor also reads `.claude/agents/` and `~/.claude/agents/` natively for compatibility, but the generated Cursor definitions in `agent-specific/cursor/` add `readonly: true` support for agents that have no write, edit, or bash tools.
...
| Tool | Global | Project |
|------|--------|---------|
| Claude Code | `~/.claude/agents/` | `.claude/agents/` |
| OpenCode | `~/.config/opencode/agents/` | `.opencode/agents/` |
| Cursor | `~/.cursor/agents/` | `.cursor/agents/` |
...
### OpenCode
...
OpenCode requires generated definitions. Run `generate.sh` first, then `setup.sh`.
...
```bash
git clone https://github.com/ampedweb/awesome-subagents.git
cd awesome-subagents
./generate.sh                            # generates agent-specific/opencode/ and agent-specific/cursor/
./setup.sh global                        # symlinks OpenCode into ~/.config/opencode/agents/
./setup.sh project /path/to/your-project # symlinks OpenCode into the project
```
...
| Type | Path | Availability | Precedence |
|------|------|--------------|------------|
| Project Subagents | `.claude/agents/` | Current project only | Higher |
| Global Subagents | `~/.claude/agents/` | All projects | Lower |
```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 7.5s)

_Thinking:_

I have a lot of info now. The user's dotfiles repo structure: agents would live in `opencode/.config/opencode/agents/` (stowed). Let me check what's in `not-active-agent` (dev, git) — that's their old/retired agents. Let me peek at them to understand what they already tried, and check their prompts dir too. Also let me check community discussions (reddit/HN) quickly for real-world sentiment.

Actually, I have quite a lot already. Let me do one more round: check not-active-agent contents + a quick reddit search. Then synthesize into a plan.

Let me check your retired agents and community sentiment.

**Tool: bash**

**Input:**
```json
{
  "command": "ls -la ~/.config/opencode/not-active-agent/dev/ ~/.config/opencode/not-active-agent/git/ 2>/dev/null; echo \"---\"; ls ~/dotfiles/opencode/.config/opencode/prompts/ 2>/dev/null"
}
```

**Output:**
```
/home/lalitmee/.config/opencode/not-active-agent/dev/:
total 12
drwxrwxr-x 2 lalitmee lalitmee 4096 Nov 22  2025 .
drwxrwxr-x 4 lalitmee lalitmee 4096 Nov 22  2025 ..
-rw-rw-r-- 1 lalitmee lalitmee  743 Nov 22  2025 review.md

/home/lalitmee/.config/opencode/not-active-agent/git/:
total 16
drwxrwxr-x 2 lalitmee lalitmee 4096 Dec  3  2025 .
drwxrwxr-x 4 lalitmee lalitmee 4096 Nov 22  2025 ..
-rw-rw-r-- 1 lalitmee lalitmee  737 Nov 22  2025 commit.md
-rw-rw-r-- 1 lalitmee lalitmee  678 Nov 22  2025 pr-review.md
---
explore-mode.txt

```

**Tool: websearch**

**Input:**
```json
{
  "numResults": 5,
  "query": "reddit opencode custom agents worth it subagent recommendations"
}
```

**Output:**
```
Title: What’s the best practice to define multi (sub-)agent workflow
URL: https://www.reddit.com/r/opencodeCLI/comments/1r0d34g/whats_the_best_practice_to_define_multi_subagent.json
Published: N/A
Author: t2_lghd0q2r
Highlights:
I want to create a really simple workflow to optimize context usage and therefore save tokens and increase efficiency. Therefore I want to create something like a plan, build, review workflow, where planning an and review are done by dedicated subagents (with specific models, prompt, temperature, …). I created the subagents according to the documentation https://opencode.ai/docs/agents/ in the agents folder of the projects and placed the desired workflow in the AGENTS.md file. But somehow it is kind of random if it is picked up by the main agent. Do I have to write my own orchestrator agent to make it work? I don’t want to write the system prompt for the main agent.

---

Title: Agents
URL: https://opencode.ai/docs/agents/
Published: 2026-07-31T17:26:58.009Z
Author: N/A
Highlights:
Configure and use specialized agents.
...
Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.
...
There are two types of agents in OpenCode; primary agents and subagents.
...
### Subagents
...
Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.

OpenCode comes with three built-in subagents, General, Explore, and Scout. We’ll look at this below.
...
OpenCode comes with two built-in primary agents and three built-in subagents.
...
Build is the default primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.
...
A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes. By default, all of the following are set to`ask`:
...
This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.
...
### Use general
...
Mode:`subagent`
...
A general-purpose agent for researching complex questions and executing multi-step tasks. Has full tool access (except todo), so it can make file changes when needed. Use this to run multiple units of work in parallel.
...
### Use explore
...
Mode:`subagent`
...
A fast, read-only agent for exploring codebases. Cannot modify files. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.
...
### Use scout
...
Mode:`subagent`
...
A read-only agent for external docs and dependency research. Use this when you need to clone a dependency repository into OpenCode’s managed cache, inspect library source, or cross-reference local code against upstream implementations without modifying your workspace.
...
the Tab key to cycle through them during a session
...
Subagents can be invoked:
...
Automatically by primary agents for specialized tasks based on their descriptions.
...
Manually by @ mentioning a subagent in your message. For example.
...
You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:
...
Configure agents in your`opencode.json` config file:
...
```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "build": {      "mode": "primary",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "{file:./prompts/build.txt}",      "permission": {        "edit": "allow",        "bash": "allow"      }    },    "plan": {      "mode": "primary",      "model": "anthropic/claude-haiku-4-20250514",      "permission": {        "edit": "deny",        "bash": "deny"      }    },    "code-reviewer": {      "description": "Reviews code for best practices and potential issues",      "mode": "subagent",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "permission": {        "edit": "deny"      }    }  }}
...
You can also define agents using markdown files. Place them in:
...
```
---description: Reviews code for quality and best practicesmode: subagentmodel: anthropic/claude-sonnet-4-20250514temperature: 0.1permission:  edit: deny  bash: deny---You are in code review mode. Focus on:- Code quality and best practices- Potential bugs and edge cases- Performance implications- Security considerationsProvide constructive feedback without making direct changes.
...
The markdown file name becomes the agent name. For example,`review.md` creates a`review` agent.
...
Control the agent’s mode with the`mode` config. The`mode` option is used to determine how the agent can be used.
...
` option can be set to`
...
`. If no
...
is specified, it defaults
...
Hide a subagent from the`@` autocomplete menu with`hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.
...
### Task permissions
...
Control which subagents an agent can invoke via the Task tool with`permission.task`. Uses glob patterns for flexible matching.
...
When set to`deny`, the subagent is removed from the Task tool description entirely, so the model won’t attempt to invoke it.
...
## Create agents
...
1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which permissions the agent should be allowed (anything you don’t select is denied).
5. Finally, create a markdown file with the agent configuration.
...
## Use cases
...
Here are some common use cases for different agents.
...
- Build agent: Full development work with all tools enabled
- Plan agent: Analysis and planning without making changes
- Review agent: Code review with read-only access plus documentation tools
- Debug agent: Focused on investigation with bash and read tools enabled
- Docs agent: Documentation writing with file operations but no system commands
...
### Documentation agent
...
```
---description: Writes and maintains project documentationmode: subagentpermission:  bash: deny---You are a technical writer. Create clear, comprehensive documentation.Focus on:- Clear explanations- Proper structure- Code examples- User-friendly language
...
```
---description: Performs security audits and identifies vulnerabilitiesmode: subagentpermission:  edit: deny---You are a security expert. Focus on identifying potential security issues.Look for:- Input validation vulnerabilities- Authentication and authorization flaws- Data exposure risks- Dependency vulnerabilities- Configuration security issues

---

Title: How have you set up your sub agents to keep costs down? : r/opencode
URL: https://www.reddit.com/r/opencode/comments/1rvvel1/how_have_you_set_up_your_sub_agents_to_keep_costs/
Published: N/A
Author: N/A
Highlights:
set up your sub agents to keep costs down? : r/opencode Skip to main content How have you set up your sub agents to keep
...
down? :
...
set up your sub agents to keep
...
I've been using OpenCode for about a month now. It's helped me make a ton of progress on some tricky projects that I've been working on. But Anthropic costs are getting sort of insane, and I definitely don't need Opus 4.6 doing greps and directory listings, and probably almost anything else, besides just talking with me, reasoning through problems, and making plans. Maybe writing the code.
...
Anyway, I know that we can customize this in the opencode.json, but it's a little bewildering trying to figure out what the right constellation of models might look like for this.
...
How have you configured OpenCode to make sure expensive models are doing challenging things, and cheap models are doing grunt work?
...
The pattern that usually works best is expensive planner, cheap worker. I keep the main model on stronger

---

Title: OpenCode Subagents: Workflows & Superpowers - ArceApps Blog
URL: https://arceapps.com/blog/opencode-subagents/
Published: 2026-05-20T00:00:00.000Z
Author: N/A
Highlights:
OpenCode solves this with a system of agents that includes two fundamental roles: primary agents and subagents. Primary agents are the main assistants you interact with directly. Subagents are specialized assistants that can be invoked for specific tasks, work in parallel, or help you — and the primary agent — with research, exploration, or analysis without interrupting the main workflow.
...
In this article we’ll dive deep into subagents: what they are, how the built-in ones work in OpenCode, how to invoke them, how to configure them, and how to create your own custom subagents to adapt OpenCode to your indie developer workflow.
...
Subagents are specialized assistants running in child sessions linked to the main session. A primary agent may decide to invoke them automatically when it needs to perform a task that better fits a subagent’s capabilities. You can also invoke them manually by mentioning them with `@` in your message: for example, `@explore analyze the project structure`.
...
The General subagent is a general-purpose agent capable of executing complex multi-step tasks. It has full access to all tools except `todo` (the task management tool), which means it can read files, modify them, run terminal commands, and conduct research without restrictions. The difference with the primary Build agent is that General runs in a separate session and its work is presented as a sub-task within the main conversation.
...
The Explore subagent is a read-only agent designed for quickly exploring codebases. It cannot modify files. Its specialty is finding files by patterns, searching code for keywords, or answering questions about a project’s structure.
...
Use Explore when you need to understand an unfamiliar codebase without any risk of modifying it. It’s perfect for answering questions like «where is the User class defined?» or «which files would this database migration touch?». Since it has no write permissions, you can use it with complete peace of mind — it won’t alter your code.
...
The Scout subagent is a read-only agent specialized in external documentation and dependency research. Unlike Explore, which works only with your local codebase, Scout can clone dependency repositories into OpenCode’s managed cache, inspect library source code, and cross-reference your local code against upstream implementations without modifying your workspace.
...
Use Scout when you need to understand how a library you’re using works, verify changes between dependency versions, or investigate a specific implementation in an npm package or Python module’s source code. It’s especially useful in indie projects where you don’t have a dedicated platform engineer but still need to deeply understand the tools you use.
...
The underlying idea: `@general` is the exception, not the rule. By default I prefer `@explore` (fast, local, cheap on tokens) or `@scout` (when the code I care about lives in another repository). I only escalate to `@general` when the task requires modifying files or running commands, and even then I make sure its permissions are scoped to the minimum necessary.
...
Primary agents can decide on their own to invoke a subagent when they detect that a task fits better with a specialized agent’s capabilities. For instance, if the Build agent needs to investigate how an external library works to complete your request, it might automatically invoke the Scout subagent for that research.
...
Automatic invocation depends on each subagent’s description and the underlying language model. OpenCode doesn’t force automatic invocation — it’s a model decision based on conversation context.
...
OpenCode lets you customize the built-in subagents or create your own. Configuration can be done in two formats: JSON in your `opencode.json` file, or Markdown files placed in an agents directory.
...
The file name becomes the agent name. In this case, `review.md` creates an agent called `review` that you can invoke with `@review`.
...
When `hidden` is `true`, the agent doesn’t appear in the agent selection list. Hidden agents are useful for system agents like Compaction, Title, and Summary that need to exist but don’t need to be selected manually.
...
Use the right agent for the right task. Don’t use Build for everything. If you only need to explore code, use Explore. If you only need to plan, use Plan. This reduces noise in your main session and keeps context cleaner.
...
Configure restrictive permissions by default. Subagents you create for specific tasks don’t need all permissions. A research agent doesn’t need `edit: allow`. A review agent doesn’t need `bash`. Restrictive permissions are guardrails that prevent costly mistakes.
...
Use low temperature for technical tasks. For code analysis, planning, and review, use low temperature (0.0 – 0.2). Responses will be more predictable and focused. Save high temperature for brainstorming and idea generation.
...
Use Markdown files for complex agents. If an agent has a very long prompt or you want to version its configuration alongside the project, use the Markdown format in `.opencode/agents/`. It’s more readable and keeps configuration close to code.
...
Subagents are not completely isolated processes. They share the parent session context in a limited way: the parent knows the result of the child’s work, but the child doesn’t necessarily know all the parent’s context. This can lead to duplicated effort if you’re not explicit in your prompts.
...
Another point to consider: subagents consume resources from the model you’re using. Each subagent runs in its own session and generates its own input and output tokens. In large projects with many subagents, token costs can grow significantly. Use `maxSteps` to set limits.
...
Finally, automatic subagent invocation depends on the language model. Not all models decide to invoke subagents the same way. More recent and capable models tend to use subagents more intelligently.
...
`, or `Completable`”. The agent reads the code and generates a `migration_plan.md`.
...
2. Implementation Phase (`@general` in parallel): For each isolated component (e.g., a `Repository` and its `ViewModel`), I launch a `@general` to perform the specific migration based on the plan. By doing this in separate sessions, context errors are minimized.
...
3. Review Phase (`@review`): Once `@general` finishes, I use my custom `@review` subagent to audit the changes. “Review the migration diff in `UserRepository.kt`. Ensure the Coroutines exception handling is equivalent to the RxJava implementation and check for potential memory leaks”.
...
I can invoke it with `@security-audit review the latest commits in the auth module`. Because it has `edit: deny`, I know it won’t break anything. Its only job is to generate a critical report.
...
Using subagents isn’t free. Every subagent session consumes input tokens (the shared context) and output tokens. Here are my golden rules for keeping costs under control:
...
1. Limit initial context: Don’t invoke a subagent from a primary session that already has 150 conversation turns. The subagent will inherit that massive context. It’s better to start a fresh, clean session for heavy tasks.
2. Use the right model: Not everything needs `claude-4.8-sonnet`. For formatting tasks, simple parsing, or light exploration, Haiku models or even mid-sized local models (if you have the hardware) are more than capable.
3. Watch the `maxSteps`: A subagent that enters an error-correction loop (tries to compile -> fails -> tries to fix -> fails) can drain your API balance in minutes. Keep `maxSteps` low (between 5 and 10) to force the agent to stop and ask for your input.
...
Integrating subagents into your OpenCode workflow isn’t about working less, it’s about working better. By separating responsibilities (exploration, code writing, security review), you reduce the cognitive load for both yourself and the underlying LLM.

---

Title: OpenCode Subagents: Workflows, Use Cases, and Superpowers - ArceApps Blog
URL: https://arceapps.com/blog/opencode-subagents-workflows/
Published: 2026-06-26T00:00:00.000Z
Author: N/A
Highlights:
# OpenCode Subagents: Workflows, Use Cases, and Superpowers

 calendar_today Friday, June 26, 2026



A while ago, I wrote about the fundamentals of subagents in OpenCode, explaining how to configure the `agents.json` file and the different modes of operation. Since then, my way of using them has evolved radically. I no longer see them simply as a shortcut to avoid typing long prompts, but as architectural components to automate entire workflows.
...
Today, we are going to dive much deeper. We’ll look at how to design workflows by combining “cheap” agents (SLMs or fast models) for routine tasks with frontier agents (like Claude 3.5 Sonnet or GPT-4o) for deep reasoning. And most importantly: how to use this architecture to autonomously implement rigorous methodologies like Superpowers.
...
When you start building multi-agent workflows, cost (both in tokens and latency) quickly becomes a bottleneck. You can’t pass every minor decision to a heavy reasoning model.
...
The secret to efficient
...
user’s prompt and decides which specialized
...
agent to call.
...
enses the context of
...
before passing it to the
...
, saving thousands of
...
tokens.
3
...
obvious syntax or style errors before
...
resources on a full testing cycle.
...
The practical conclusion: the router analyzes four signals —task complexity, estimated cost, context size, and criticality— and fires each call at the cheapest model that can solve it. 80% of calls go to cheap agents; the remaining 20% to frontier agents. When a cheap call isn’t enough, you escalate. This is very clear in the Superpowers case coming up next.
...
If you’ve read my analysis of Superpowers, you’ll know that it’s a fantastic framework because it forces agents to apply rigorous Test-Driven Development (TDD). But running Superpowers manually requires a lot of oversight. This is where subagents shine.
...
We can create a workflow in OpenCode that automates the Superpowers cycle:
...
In our `.opencode/agents.json`, we define three specific agents:
...
```
{
  "agent": {
    "super-plan": {
      "description": "Creates the technical plan and test cases.",
      "mode": "subagent",
      "model": "anthropic/claude-3-5-sonnet",
      "temperature": 0.1,
      "permission": {
        "edit": "deny",
        "bash": "deny"
      }
    },
    "super-test": {
      "description": "Writes unit tests based on the plan.",
      "mode": "subagent",
      "model": "anthropic/claude-3-5-sonnet",
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    },
    "super-code": {
      "description": "Implements the code to make the tests pass.",
      "mode": "subagent",
      "model": "anthropic/claude-3-5-sonnet",
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    }
  }
}
```
...
Instead of doing everything at once, the flow works like this:

1. We call `@super-plan` to analyze the requirement and generate a design document with the expected test cases.
2. Once approved, we call `@super-test`. This agent is only allowed to write test files and run `pnpm test`. Obviously, the tests will fail because there is no code yet. This is the expected behavior in TDD.
3. Finally, we invoke `@super-code`. Its only directive is: “Read the output of the failing tests and write the minimum code necessary to make them pass”.
...
By splitting the problem, we avoid the classic issue of the agent writing the code and tests at the same time, creating “happy path tests” that always pass but don’t verify anything real.
...
The key idea visible in the infographic: each subagent has explicitly different permissions. `@super-plan` cannot write files or run commands — it only plans. `@super-test` can, but its output is by design tests that must fail before the implementation. `@super-code` receives the red tests’ output and writes the minimum code. The loop only closes when the tests pass, and only then do you commit.
...
Another incredibly useful workflow for legacy projects or large codebases is automatic triage.
...
Often, we face a bug reported by a user: “The login button doesn’t work when I’m on Safari”. Instead of opening the project and starting to search with `grep`, I use a cheap explorer agent.
...
```
<!-- ~/.config/opencode/agents/triage.md -->
---
description: Analyzes a bug report and finds the problematic files
mode: subagent
model: google/gemini-1.5-flash
permission:
  edit: deny
  bash: allow
---
...
You are a triage agent. Your goal is not to fix the bug, but to find where it is.
Use bash commands like `find`, `grep`, and `cat` to search the codebase.
When you find the relevant files, provide a 3-line summary explaining
which component might be failing and which files the developer should look at.
...
This agent uses an ultra-fast and cheap model. Its job is to do the code “archaeology.” Once `@triage` tells me the problem is in `src/components/Auth/LoginButton.tsx`, I can invoke my main agent (the expensive model) passing that file directly, saving time and context.
...
Paranoid
...
AI-generated code tends to be functional, but not always secure. Blindly trusting a single model to write and review its own code is an anti-pattern.
...
For this, I configure a strict security review subagent:
...
```
{
  "agent": {
    "paranoia-review": {
      "description": "Reviews code for vulnerabilities before commit.",
      "mode": "subagent",
      "model": "anthropic/claude-3-5-sonnet",
      "prompt": "You are an extremely strict security auditor. Look for SQL injections, XSS, exposed tokens, and business logic vulnerabilities. DO NOT suggest style improvements, ONLY serious security issues.",
      "temperature": 0.0
    }
  }
}
...
The key here is the prompt and the temperature of `0.0`. We want this agent to be deterministic and focus exclusively on one domain: security. Before pushing to production, I run `@paranoia-review review recent changes` as the final step in my workflow.
...
The true power of OpenCode does not lie in having a chat integrated into your terminal, but in its ability to act as an orchestrator.
...
By starting to treat subagents as specialized atomic functions—some cheap and fast for exploration, others heavy and methodical for implementation—you transform your development environment from a simple code generator into a genuine software assembly line.
...
The next time you face a complex task, don’t ask your main agent to do it all. Ask yourself: How would a real engineering team divide this? And then, create the subagents to replicate that team.
```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 5.8s)

_Thinking:_

I have comprehensive research now. Let me also quickly check what the user's retired agents looked like (review.md, commit.md, pr-review.md) to understand what they already tried and might want to revive. Actually, those are in not-active-agent. Let me quickly read them to inform recommendations.

Actually, let me look at them quickly, then synthesize the plan. In plan mode, I should present a plan. Let me read the 3 retired agents.

**Tool: bash**

**Input:**
```json
{
  "command": "head -20 ~/.config/opencode/not-active-agent/dev/review.md; echo \"===COMMIT===\"; head -20 ~/.config/opencode/not-active-agent/git/commit.md; echo \"===PR===\"; head -20 ~/.config/opencode/not-active-agent/git/pr-review.md"
}
```

**Output:**
```
---
description: Review code changes
agent: review
---

## Mission: Code Review

Your task is to review code changes for quality, security, and style.

### Workflow:

1.  **Analyze Diff**:

    - Read the provided diff or file content.
    - Identify the language and context.

2.  **Check Criteria**:

    - **Correctness**: Does the code do what it claims?
    - **Security**: Are there any vulnerabilities (SQL injection, XSS, etc.)?
===COMMIT===
---
description: Generate git commit messages
agent: git
---

## Mission: Git Commit

Your task is to generate a conventional commit message based on the staged changes.

### Workflow:

1.  **Analyze Changes**:

    - Run `git diff --cached` to see staged changes.
    - If no changes are staged, ask the user to stage changes first.

2.  **Generate Message**:

    - Create a commit message following the Conventional Commits specification (e.g., `feat:`, `fix:`, `chore:`).
    - Keep the subject line under 50 characters.
===PR===
---
description: Review Pull Requests
agent: review
---

## Mission: PR Review

Your task is to review a Pull Request or a specific branch against the main branch.

### Workflow:

1.  **Fetch Context**:

    - If a PR URL is provided, try to use `gh pr view` or similar tools if available.
    - If not, assume the current branch is the feature branch and compare it with `main` (or `master`).
    - Run `git diff main...HEAD` to get the changes.

2.  **Review**:

    - Analyze the diff for bugs, style issues, and logic errors.

```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 83.5s)

_Thinking:_

I now have a full picture:

**User's current setup:**
- Global opencode config at `~/.config/opencode/opencode.json` (stowed from `dotfiles/opencode/.config/opencode/`)
- Has: plugins (superpowers, opencode-dcp, ponytail), agents `plan`, `build`, `discover` (custom primary), `explore`, `general` (colored), MCP servers (context7, crash, chrome-devtools)
- Has retired agents in `not-active-agent/`: `dev/review.md`, `git/commit.md`, `git/pr-review.md` (old format, no `mode` field, deprecated format `agent:` key)
- Has skills (karpathy-guidelines), commands, prompts
- No `agents/` directory currently active

**Research findings (what people use):**

1. **Community consensus patterns:**
   - Planner/Architect → Implementor/Builder → Reviewer/Auditor → Tester → Linter → Commit-message pipeline (Code Crafter's Den, Rozariozaro, Amir Teymoori)
   - "Expensive planner, cheap worker" pattern (reddit)
   - Least-privilege permissions: research agents read-only, review agents no edit/bash, implementors full access
   - Low temperature (0.0-0.2) for technical tasks
   - Path-based edit permissions for trust (WORKFLOW_STATE.md pattern)
   - Per-agent model assignment (cheap models for exploration/research, strong for planning/implementation)

2. **Ready-made collections:**
   - `mouyox21/opencode-agents` — 258 subagents + orchestrator, CLI/npm registry
   - `ankitmundada/awesome-opencode-subagents` — 100+ subagents
   - `weisser-dev/awesome-opencode` — 108 agents, 15 skills, `npx @weisser-dev/awesome-opencode`
   - `humanuoid/opencode-agents-hub` — dev-architect, debugger, commit-writer, code-review, task-writer, pr-writer, release-notes
   - `Shakudo-io/opencode-agents` — zellij agent
   - `ampedweb/awesome-subagents` — 131+ agents, Claude→opencode conversion
   - oh-my-opencode plugin (7 agents, Sisyphus orchestration)
   - VoltAgent/awesome-claude-code-subagents (original inspiration)

3. **Official docs facts:**
   - Agent locations: global `~/.config/opencode/agents/`, project `.opencode/agents/` (or `.opencode/agent/` in older docs)
   - Markdown frontmatter: description, mode (primary/subagent/all), model, temperature, permission, tools (deprecated), max_steps, color, hidden
   - `opencode agent create` interactive command with `--path`, `--description`, `--mode`, `--permissions`, `--model`
   - Permission keys: read, edit, glob, grep, list, bash, task, external_directory, todowrite, webfetch, websearch, lsp, skill, question, doom_loop
   - Built-ins: build, plan (primary); general, explore, scout (subagent)

4. **User's context:**
   - dotfiles repo, stowed: `opencode/.config/opencode/` → `~/.config/opencode/`
   - Already has discover primary agent, prompts/explore-mode.txt
   - Retired agents used old format (frontmatter `agent: review`, no mode) — likely outdated format that didn't work well, hence deactivated
   - AGENTS.md says config filenames kebab-case, skills snake_case, etc.

Now, in plan mode, I should present a plan. The user asked to "do some research for the agents that people are using with opencode. I want to have some agents in my opencode."

So the plan should propose:
1. Which agents to add (based on research — the most popular/useful ones)
2. Where they go (dotfiles/opencode/.config/opencode/agents/, stowed)
3. What each agent's config looks like (markdown format with frontmatter)
4. Reload after stow

Per the research skill, I should also produce a research report file... but we're in plan mode (read-only), so I can't write the file yet. I'll present the terminal summary + plan, and offer to write the report + agents during implementation.

The user's model situation: they use deepseek-v4-flash-free (the current model). Their config doesn't specify a global model. Models for agents should probably not be hardcoded unless they want — subagents inherit parent's model if not specified. Good default: don't pin models, or pin cheap ones.

Let me design the proposed agent set based on consensus (keep it lean per ponytail — don't build 10 agents; user already has superpowers skills doing some of this):

Popular consensus set (from multiple sources):
1. **code-reviewer** (subagent, read-only, edit:deny, bash:deny, temp 0.1) — most common agent across ALL sources
2. **commit-writer** (subagent, git diff only) — user already has a retired one, revive it
3. **debugger** (subagent, bash+read, no edit... actually debuggers need edit sometimes; consensus: investigate only, diagnose)
4. **researcher** (subagent, webfetch/websearch only, no file writes)
5. **security-reviewer** (subagent, read-only) — user has an `audit` skill already though
6. **docs-writer** (subagent, edit only .md, bash deny)

But wait — ponytail mode: user already has skills for many of these (audit, review-code, commit via conventional-commit skill, debug, diagnose, gen-test). Skills and agents overlap. The user has superpowers plugin which has skills for brainstorming, TDD, etc.

Hmm, but the user explicitly wants agents. The lean approach: add a small set of subagents that map to tasks where dedicated agents pay off per community consensus:
- code-reviewer (read-only review)
- commit-writer (conventional commits)
- debugger
- researcher (web research, read-only)
- Maybe a plan/architect? They already have `plan` primary + `discover`.

Also offer: install a ready-made collection (weisser-dev/awesome-opencode or humanuoid hub) vs. hand-written minimal set. That's a decision point for the user.

Per ponytail + plan mode, I should ask the user which direction: minimal hand-written set vs curated collection install.

Let me also give the ~10-line research summary per the skill. Since plan mode forbids writing the report file, I'll note that in implementation I can save `research-opencode-agents.md`.

Also important detail for their dotfiles: agents dir would be `dotfiles/opencode/.config/opencode/agents/` and stow will link it. The old not-active-agent had a different layout (`dev/`, `git/` subdirs with old-format files — `agent:` frontmatter key is deprecated).

Key format facts for the plan:
- Current docs (2026): `~/.config/opencode/agents/*.md` (note: `agents` plural now, older docs said `agent` singular — the Shakudo repo uses `.opencode/agent/` singular... official docs say `~/.config/opencode/agents/` plural. The not-active-agent dir is at `~/.config/opencode/not-active-agent/` — irrelevant). Hmm, wait — both the official docs and the awesome repos say `~/.config/opencode/agents/`. The bswen article says `agent` singular but that's third-party. Official: `agents/` plural. Go with `agents/`.

- Frontmatter fields: description, mode, model, temperature, permissions (V2: array of {action, resource, effect}) or permission map (V1), max_steps/steps, color, hidden, system prompt = body.

Note the version discrepancy: opencode.ai/docs/agents (V1 style `permission: {edit: deny}`) vs opencode.ai/v2/docs/agents (`permissions: [{action, resource, effect}]`). The user's config uses V1 style (`permission` map with allow/deny/ask keys). Their installed opencode version — the AGENTS.md says "opencode/.config/opencode/command/" and opencode.json uses "agent" key with permission maps, which is V1 format. The v2 docs appear to be for a newer opencode version (maybe v2). I should match the user's existing config style (V1) since that's what their installed version supports, but verify at implementation time with `opencode --version` and `opencode agent create`.

Let me now ask the user the key decision questions:
1. Minimal hand-written set (5 agents) vs install curated collection (108 agents from weisser-dev) vs hybrid
2. Which agents matter most to them (code review, commit, debug, research, security, docs)

Actually per plan mode guidance, I should present the plan with a recommendation and ask. Let me use the question tool for the key decisions.

Actually, let me keep it simple: present the research summary + proposed plan, and ask 1-2 questions (which agents, and collection vs handwritten).

Let me formulate the plan concisely. Ponytail: keep it lean.

Proposed plan:

**Where**: `dotfiles/opencode/.config/opencode/agents/` (new dir, stowed → `~/.config/opencode/agents/`). Also consider reviving/porting the 3 retired agents from `not-active-agent/` with modern format.

**Agents (recommended set based on community consensus)**:
1. `code-reviewer.md` — subagent, read-only (edit:deny, bash:deny), temp 0.1 — reviews diffs for bugs/security/quality
2. `commit-writer.md` — subagent, bash limited to git diff/log/status — conventional commits
3. `debugger.md` — subagent, read+bash (no edit) — diagnose root cause of bugs/errors
4. `researcher.md` — subagent, webfetch/websearch only — external docs/API research
5. `security-reviewer.md` — subagent, read-only — vuln scan (they already have audit skill — optional, maybe skip)
6. `docs-writer.md` — subagent, edit limited to *.md, bash deny — optional

That's maybe 4-6 agents. Keep models unpinned (inherit) unless user wants cheap models for some.

Also optionally: `opencode agent create` non-interactive flags for scaffolding.

Options to present:
- A: Minimal handwritten set (recommended — matches their dotfiles setup, tailored to their existing skills/plugins)
- B: Install curated collection (weisser-dev/awesome-opencode via npx, or humanuoid/opencode-agents-hub via symlink) — 100+ agents, more bloat
- C: Hybrid

Also ask about which roles they actually want.

Let me ask via question tool, then finalize plan. Actually the flow: present findings briefly, then ask. I'll ask two questions:
1. Handwritten vs collection vs hybrid
2. Which agents to include (multiple)

Then in the next turn (after answers), I'll present the final plan. Actually I can present the full plan now and ask at the end. Plan mode says: present a well-researched plan, tie loose ends before implementation. Asking now is right.

Research complete. Here's the summary, then a couple of decisions before I finalize the plan.

## Research: Agents for OpenCode

- **The consensus pattern** (all sources agree): specialized subagents — planner/architect → implementor → reviewer → tester — with strict least-privilege permissions. "Expensive planner, cheap worker" for cost. [community consensus]
- **Most commonly used agents**: code-reviewer (read-only, `edit: deny`), commit-writer, debugger/triage, researcher (web-only, no file access), security-auditor, docs-writer. Low temperature (0.0–0.2) for all. [community consensus]
- **Ready-made collections**: `weisser-dev/awesome-opencode` (108 agents, install via `npx`), `mouyox21/opencode-agents` (259 agents + CLI registry), `humanuoid/opencode-agents-hub` (7 focused agents, symlink-friendly), `ankitmundada/awesome-opencode-subagents` (100+). [github]
- **Format**: Markdown files in `~/.config/opencode/agents/*.md` (global) or `.opencode/agents/` (per-project). Frontmatter: `description`, `mode: subagent`, `model`, `temperature`, `permission` map. Filename = agent name. Or `opencode agent create --description ... --mode subagent --permissions ...`. [official]
- **Your setup**: config lives in `dotfiles/opencode/.config/opencode/`, stowed globally. You already have `discover` (primary), plugins (superpowers, ponytail, dcp), skills (audit, debug, commit, review-code...). You have 3 **retired** agents (`not-active-agent/`: review, commit, pr-review) in an outdated format (`agent:` frontmatter key, no `mode`).
- **Pitfall**: subagents cost tokens; auto-invocation is model-dependent and unreliable — @-mention explicitly, cap `max_steps`. [community + reddit]

**Key overlap note**: you already have skills covering several of these roles (audit, debug, commit, review-code). Agents make sense where you want a *different model + locked permissions* — review, research, triage — rather than duplicating skills.

**Tool: question**

**Input:**
```json
{
  "questions": [
    {
      "question": "How do you want to get the agents?",
      "header": "Source",
      "options": [
        {
          "label": "Handwritten minimal set (Recommended)",
          "description": "5-6 curated agents matching your workflow, in your dotfiles repo. No bloat, easy to maintain."
        },
        {
          "label": "Install a curated collection",
          "description": "e.g. weisser-dev/awesome-opencode (108 agents) or humanuoid/opencode-agents-hub. More agents, more noise."
        },
        {
          "label": "Hybrid",
          "description": "Handwritten core set + cherry-pick a few agents from a collection."
        }
      ]
    },
    {
      "question": "Which agent roles do you actually want? (pick any)",
      "header": "Agent roles",
      "multiple": true,
      "options": [
        {
          "label": "Code reviewer",
          "description": "Read-only diff review for bugs, security, quality. The single most-used agent in every collection."
        },
        {
          "label": "Commit writer",
          "description": "Conventional commit messages from git diff. You have a retired one already."
        },
        {
          "label": "Debugger / triage",
          "description": "Root-cause analysis of errors with bash+read, no edits. Cheap model fits."
        },
        {
          "label": "Researcher",
          "description": "Web search/fetch only — external docs, APIs, dependency research. No file access."
        },
        {
          "label": "Security auditor",
          "description": "Vulnerability scan, read-only. Overlaps with your audit skill."
        },
        {
          "label": "Docs writer",
          "description": "Writes/updates .md files only, bash denied."
        }
      ]
    },
    {
      "question": "Should agents pin specific models or inherit your default?",
      "header": "Models",
      "options": [
        {
          "label": "Inherit default (Recommended)",
          "description": "No model field — subagents use your session model. Simplest, works with whatever provider you're on."
        },
        {
          "label": "Pin cheap models for grunt work",
          "description": "e.g. deepseek-flash for triage/research, strong model only for review. More config, saves tokens."
        }
      ]
    }
  ]
}
```

**Output:**
```
User has answered your questions: "How do you want to get the agents?"="Handwritten minimal set (Recommended)", "Which agent roles do you actually want? (pick any)"="Code reviewer, Commit writer, Debugger / triage, Researcher, Security auditor, Docs writer", "Should agents pin specific models or inherit your default?"="Inherit default (Recommended)". You can now continue with the user's answers in mind.
```

---

## Assistant (Plan · DeepSeek V4 Flash Free (New) · 45.0s)

---

## User

continue

---

## Assistant (Plan · Nemotron 3 Ultra Free · 9.9s)

---
