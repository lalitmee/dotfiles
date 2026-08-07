# Research: OpenCode Config Modes and Agents

Generated: 2026-08-01

## Executive Summary

This research report investigates the configuration modes, custom agents, and plugins that developers in the OpenCode ecosystem are using. By analyzing community practices, official documentation, GitHub repositories, and forum discussions, we identify the trending patterns in terminal-based AI coding setups. OpenCode is built on a highly customizable, multi-agent model that enables developers to define specialized agent profiles with custom prompts, models, and tool access permissions. The report details community best practices, maps popular custom agent roles, lists trending performance and security plugins, and compares these findings against the local dotfiles OpenCode setup.

## Best Practices

- **Principle of Least Privilege**: Restrict agent permissions (`edit: deny`, `bash: deny`) for agents that only perform review, auditing, or planning tasks to prevent accidental changes or execution loops.
- **Model Specialization (The "Stack" Strategy)**: Use fast, cheap models (e.g., Gemini Flash, GPT-3.5) for boilerplate, formatting, and quick lookups, while routing complex tasks (architecture planning, code reviews, deep debugging) to larger reasoning-focused models.
- **Context Optimization**: Keep context windows clean by using dynamic context pruning plugins to prevent performance degradation and save tokens during long-running sessions.
- **Hierarchical Overrides**: Define general-purpose configurations in the global config file (`~/.config/opencode/opencode.json`), and override them with project-specific settings (`./opencode.json` or `.opencode/opencode.json`) to enforce project-specific coding styles and dependencies.

## Trends & Patterns

### 1. Multi-Agent Workflows & Orchestration
The community is shifting from single-agent conversations to multi-agent structures where a primary planning/routing agent orchestrates subagents. Boilerplates like **OpenCode Hive** demonstrate this trend by running a read-only orchestrator that designs plans and dispatches execution tasks to specialized subagents.

### 2. Custom Agent Profiles via Markdown
Instead of massive JSON configurations, developers are using standalone Markdown files with YAML frontmatter in `~/.config/opencode/agents/` to define agents. The frontmatter controls agent metadata:
```yaml
description: Specialized code reviewer agent
mode: subagent
temperature: 0.1
permission:
  edit: deny
  bash: deny
  skill: allow
```

### 3. Read-Only Planning and Safety Gates
Configuring agents with disabled write capabilities has become a standard safety practice. Developers use `@plan` or custom `reviewer` agents to audit code or create design specifications before execution.

## Real-World Examples

### 1. The Git Commit Writer Agent
A highly requested utility agent that automates conventional commits. It is configured as a `subagent` with limited bash permissions (only allowed to run `git diff --cached`) and uses diff content to generate structured commit messages.

### 2. Code Reviewer & Security Auditor Agents
Designed to run in the background to check code changes. They utilize code review skills and security scanners (like `osv-scanner` or custom security MCP servers) to output structured audit reports without modifying the repository's files.

### 3. The OpenCode Hive Framework
A community boilerplate that implements:
- Cost-optimized model routing.
- Parallel worker agents (foragers).
- VS Code integration (vscode-hive) to track feature implementation status.

## Official Documentation

- **Agent Modes**:
  - `primary`: Interactive agents that can be selected to start a session.
  - `subagent`: Specialized assistants invoked programmatically by primary agents using the `Task` tool.
  - `all`: The default mode, allowing an agent to act as both a primary session host and a delegated subagent.

- **Autocomplete Management**:
  - Setting `hidden: true` on subagents hides them from autocomplete menus, keeping UI lists clean while preserving programmatic invocation.

- **Granular Permissions**:
  - OpenCode supports fine-grained rules on tools like `bash`, `edit`, and `read`. Glob patterns can restrict write permissions to specific directories (e.g. allowing edits only in `docs/`).

## Community Discussion

- **Local Inference Support**: On forums like Reddit's `r/LocalLLaMA`, developers prioritize running OpenCode with local models (via Ollama or `llama.cpp`) for privacy, calling out the importance of setting high context windows (`num_ctx`) on local inference servers.
- **Cost Minimization**: Users frequently share setups using auth-routing plugins (like `opencode-gemini-auth`) to redirect API requests to existing personal subscriptions rather than paying per-token API costs.
- **Secure Sandboxing**: Developers leverage Daytona sandbox integrations (`opencode-daytona`) to run commands securely within isolated containers, addressing potential security concerns when running untrusted bash scripts generated by LLMs.

## Recommendations for Local Configuration

The local setup in this dotfiles repository is exceptionally well-configured and aligned with modern community trends:
1. **Theme**: Matches the preferred `cobalt2` style via [cobalt2-custom.json](file:///home/lalitmee/dotfiles/opencode/.config/opencode/themes/cobalt2-custom.json).
2. **Plugins**: Employs top-tier optimization plugins like `superpowers`, `@tarquinen/opencode-dcp` (Dynamic Context Pruning), and `@dietrichgebert/ponytail` (YAGNI enforcement) in [opencode.json](file:///home/lalitmee/dotfiles/opencode/.config/opencode/opencode.json).
3. **Agent Setups**: Fully adopts the YAML frontmatter Markdown format for agent configs. The custom `discover` agent uses [explore-mode.txt](file:///home/lalitmee/dotfiles/opencode/.config/opencode/prompts/explore-mode.txt) to orchestrate research, intent discovery, and alignment phases.

*Suggestions for further optimization:*
- Consider enabling/migrating the disabled git agents in the `not-active-agent` folder (e.g. `git/commit.md` and `git/pr-review.md`) as they align perfectly with popular community commit-writing workflows.
- Explore sandbox integrations like Daytona if security during local command execution is a priority.

## Sources

- [OpenCode Official Documentation](https://opencode.ai/docs/)
- [BSWEN: Creating Custom Agents in OpenCode CLI](https://docs.bswen.com/blog/2026-03-30-opencode-custom-agents/)
- [GitHub: rretsiem/opencode-hive Boilerplate](https://github.com/rretsiem/opencode-hive)
- [OpenCode Cafe: Extension Directory](https://opencode.cafe)
