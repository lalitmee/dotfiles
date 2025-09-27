# Feature Implementation Plan: Integrate MCP Tools in Slash Commands (Refined)

## 📋 Todo Checklist
- [x] Add `tool` key to `git/review.toml`
- [x] Add `tool` key to `git/commit.toml`
- [x] Add `tool` key to `plan/go.toml`
- [x] Add `tool` key to `plan/impl.toml`
- [x] Add `tool` key to `plan/new.toml`
- [x] Add `tool` key to `plan/refine.toml`
- [x] Add `tool` key to `plan/cleanup.toml`
- [x] Add `tool` key to `run/cleanup.toml`
- [x] Add `tool` key to `run/debug-assistant.toml`
- [x] Add `tool` key to `run/file-organizer.toml`
- [x] Add `tool` key to `run/photo-rename.toml`
- [x] Add `tool` key to `run/report-gen.toml`
- [x] Add `tool` key to `run/security-audit.toml`
- [x] Add `tool` key to `run/test-gen.toml`
- [x] Add `tool` key to `run/task-prioritizer.toml`
- [x] Add `tool` key to `run/meeting-summary.toml`
- [x] Add `tool` key to `run/email-draft.toml`
- [x] Add `tool` key to `find-docs.toml`
- [x] Add `tool` key to `explain/simple.toml`
- [x] Add `tool` key to `explain/interactive.toml`
- [x] Add `tool` key to `code/review.toml`
- [x] Add `tool` key to `google/whatsnew.toml`
- [x] Add `tool` key to `react/docs.toml`
- [x] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The user wants to integrate a wider range of MCP (Model Context Protocol) server tools into the `gemini-cli` slash commands. The relevant files are:
- `gemini-cli/.gemini/settings.json`: This file contains the configuration for the MCP servers.
- `gemini-cli/.gemini/commands/`: This directory contains the definitions for the slash commands in `.toml` files.

### Global Tool Availability
The user asked if all tools can be made available to all commands. Currently, `gemini-cli` does not support a global "all tools for all commands" setting. However, we can achieve a similar outcome by assigning a comprehensive list of potentially useful tools to each command's configuration. This approach provides broad access to tools for most commands while still allowing for command-specific tool lists where needed. For many commands, we will provide a "kitchen sink" of general-purpose tools.

### Available MCP Tools
Based on `gemini-cli/.gemini/settings.json`, the following tools are available:
- **`time`**: Provides current time.
- **`filesystem`**: Interacts with the local filesystem.
- **`fetch`**: Fetches content from URLs.
- **`memory`**: Provides short-term memory for the assistant.
- **`git`**: Interacts with git repositories.
- **`github`**: Interacts with GitHub.
- **`context7`**: A tool for context-aware responses.
- **`sequential-thinking`**: A tool for step-by-step reasoning.
- **`crash`**: A tool for structured reasoning and problem-solving.
- **`chrome-devtools`**: Interacts with Chrome DevTools.
- **`figma-local-mcp`**: Interacts with a local Figma instance.
- **`figma-remote-mcp`**: Interacts with the remote Figma service.

### Considerations & Challenges
The main challenge is to correctly identify which commands would benefit from which tools. The refined plan will take a more generous approach, providing a wide array of tools to most commands to empower them to handle a broader range of tasks.

## 📝 Implementation Plan

### Prerequisites
- The `gemini-cli` is installed and configured.
- The MCP servers are running and accessible.

### Step-by-Step Implementation
The plan is to add or update the `tool` key in the `.toml` files of the slash commands.

#### General Purpose Toolset
For most commands that involve planning, coding, or complex reasoning, the following "kitchen sink" toolset will be applied:
`["filesystem", "git", "github", "context7", "sequential-thinking", "crash", "fetch"]`

---

1.  **Modify `git` commands**:
    -   Files to modify:
        -   `gemini-cli/.gemini/commands/git/review.toml`
        -   `gemini-cli/.gemini/commands/git/commit.toml`
    -   Changes needed: Add the general-purpose toolset.
        ```toml
        tool = ["filesystem", "git", "github", "context7", "sequential-thinking", "crash", "fetch"]
        ```
    - **Implementation Notes**: Added the tool configuration to both `review.toml` and `commit.toml`.
    - **Status**: ✅ Completed

2.  **Modify `plan` commands**:
    -   Files to modify:
        -   `gemini-cli/.gemini/commands/plan/go.toml`
        -   `gemini-cli/.gemini/commands/plan/impl.toml`
        -   `gemini-cli/.gemini/commands/plan/new.toml`
        -   `gemini-cli/.gemini/commands/plan/refine.toml`
        -   `gemini-cli/.gemini/commands/plan/cleanup.toml`
    -   Changes needed: Add the general-purpose toolset.
        ```toml
        tool = ["filesystem", "git", "github", "context7", "sequential-thinking", "crash", "fetch"]
        ```
    - **Implementation Notes**: Added the tool configuration to all `plan` commands.
    - **Status**: ✅ Completed

3.  **Modify `run` commands**:
    -   Files to modify:
        -   `gemini-cli/.gemini/commands/run/cleanup.toml`
        -   `gemini-cli/.gemini/commands/run/debug-assistant.toml`
        -   `gemini-cli/.gemini/commands/run/report-gen.toml`
        -   `gemini-cli/.gemini/commands/run/security-audit.toml`
        -   `gemini-cli/.gemini/commands/run/test-gen.toml`
    -   Changes needed: Add the general-purpose toolset.
        ```toml
        tool = ["filesystem", "git", "github", "context7", "sequential-thinking", "crash", "fetch"]
        ```
    -   Files to modify (specialized):
        -   `gemini-cli/.gemini/commands/run/file-organizer.toml`
        -   `gemini-cli/.gemini/commands/run/photo-rename.toml`
    -   Changes needed: These are more filesystem-focused.
        ```toml
        tool = ["filesystem", "sequential-thinking", "crash"]
        ```
    -   Files to modify (communication):
        -   `gemini-cli/.gemini/commands/run/task-prioritizer.toml`
        -   `gemini-cli/.gemini/commands/run/meeting-summary.toml`
        -   `gemini-cli/.gemini/commands/run/email-draft.toml`
    -   Changes needed: These are more reasoning and context-focused.
        ```toml
        tool = ["context7", "sequential-thinking", "crash", "memory"]
        ```
    - **Implementation Notes**: Added the tool configuration to all `run` commands.
    - **Status**: ✅ Completed

4.  **Modify `explain` commands**:
    -   Files to modify:
        -   `gemini-cli/.gemini/commands/explain/simple.toml`
        -   `gemini-cli/.gemini/commands/explain/interactive.toml`
    -   Changes needed: These commands are for explaining code.
        ```toml
        tool = ["filesystem", "context7", "sequential-thinking"]
        ```
    - **Implementation Notes**: Added the tool configuration to both `explain` commands.
    - **Status**: ✅ Completed

5.  **Modify `code` commands**:
    -   Files to modify: `gemini-cli/.gemini/commands/code/review.toml`
    -   Changes needed: Add the general-purpose toolset.
        ```toml
        tool = ["filesystem", "git", "github", "context7", "sequential-thinking", "crash", "fetch"]
        ```
    - **Implementation Notes**: Added the tool configuration to the `code/review.toml` command.
    - **Status**: ✅ Completed

6.  **Modify `documentation` commands**:
    -   Files to modify:
        -   `gemini-cli/.gemini/commands/find-docs.toml`
        -   `gemini-cli/.gemini/commands/react/docs.toml`
    -   Changes needed: These are for finding and explaining documentation.
        ```toml
        tool = ["fetch", "context7", "sequential-thinking"]
        ```
    - **Implementation Notes**: Added the tool configuration to both `documentation` commands.
    - **Status**: ✅ Completed

7.  **Modify `google` commands**:
    -   Files to modify: `gemini-cli/.gemini/commands/google/whatsnew.toml`
    -   Changes needed: This command is for fetching information.
        ```toml
        tool = ["fetch", "sequential-thinking"]
        ```
    - **Implementation Notes**: Added the tool configuration to the `google/whatsnew.toml` command.
    - **Status**: ✅ Completed

### Testing Strategy
To test the implementation, the user can run the modified slash commands and verify that the specified tools are available by default. For example, when running `/plan:new`, the user should be able to use the `filesystem`, `git`, `github`, `context7`, `sequential-thinking`, `crash`, and `fetch` tools without explicitly specifying them.

## 🎯 Success Criteria
The feature is complete when the specified slash commands have the default MCP tools available as described in the implementation plan. The user should be able to use the tools without having to specify them in the prompt.
