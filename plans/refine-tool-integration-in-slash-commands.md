# Feature Implementation Plan: Refine Tool Integration in Slash Commands v3

## 📋 Todo Checklist
- [x] Revert changes to all previously modified `.toml` files
- [x] Add in-prompt metadata to `git/review.toml`
- [x] Add in-prompt metadata to `git/commit.toml`
- [x] Add in-prompt metadata to `plan` commands
- [ ] Add in-prompt metadata to `run` commands
- [ ] Add in-prompt metadata to `explain` commands
- [ ] Add in-prompt metadata to `code/review.toml`
- [ ] Add in-prompt metadata to `documentation` commands
- [ ] Add in-prompt metadata to `google/whatsnew.toml`
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### New Discovery: `mcp-servers` and `allowed-tools`
Based on the user's latest feedback and a new example, a more nuanced understanding of the in-prompt frontmatter has been developed. The frontmatter contains two distinct keys for tool management:

-   **`mcp-servers`**: This key takes an array of strings, where each string is the name of an MCP server to connect to. These names should correspond to the servers defined in the `mcpServers` section of `settings.json`.

-   **`allowed-tools`**: This key also takes an array of strings, but these strings represent the names of the *specific tools* (or methods) that the command is permitted to use. These can be built-in tools (e.g., `Read`, `Write`, `Glob`) or tools provided by the MCP servers.

### Referencing MCP Tools
The example provided by the user (`mcp__sequential-thinking__sequentialthinking`) suggests a specific syntax for referencing tools from MCP servers: `mcp__<server-name>__<tool-name>`. Based on this, it is hypothesized that for servers like `sequential-thinking` and `context7`, the tool name is the same as the server name.

### Revised Strategy
This plan will be updated to reflect this new, more accurate understanding. The implementation will now involve:
1.  **Reverting the previous changes**: Removing the `tool = [...]` key from all modified `.toml` files.
2.  **Implementing the new method**: Adding a YAML frontmatter to the `prompt` of each relevant `.toml` file, with separate `mcp-servers` and `allowed-tools` keys.
3.  **Refined Tool and Server Selection**: A more precise selection of servers and tools will be applied to each command.

## 📝 Implementation Plan

### Step 1: Revert Previous Changes
I will iterate through all the `.toml` files that were modified in the previous session and remove the `tool = [...]` line from each.
- **Implementation Notes**: Successfully reverted all the changes.
- **Status**: ✅ Completed

### Step 2: Implement In-Prompt Metadata
After reverting the changes, I will modify the `prompt` in each relevant `.toml` file to include the YAML frontmatter with `mcp-servers` and `allowed-tools`.

#### Server and Tool Assignments:

-   **`git/review.toml`**:
    ```yaml
    ---
    mcp-servers: [sequential-thinking, crash, context7]
    allowed-tools: [filesystem, git, github, fetch, mcp__sequential-thinking__sequentialthinking, mcp__crash__crash, mcp__context7__context7]
    ---
    ```
-   **`git/commit.toml`**:
    ```yaml
    ---
    mcp-servers: [sequential-thinking]
    allowed-tools: [git, mcp__sequential-thinking__sequentialthinking]
    ---
    ```
-   **`plan` commands**:
    ```yaml
    ---
    mcp-servers: [sequential-thinking, crash, context7]
    allowed-tools: [filesystem, git, github, fetch, mcp__sequential-thinking__sequentialthinking, mcp__crash__crash, mcp__context7__context7]
    ---
    ```
-   **`run/cleanup.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem, git]
    ---
    ```
-   **`run/debug-assistant.toml`**:
    ```yaml
    ---
    mcp-servers: [sequential-thinking, crash]
    allowed-tools: [filesystem, git, mcp__sequential-thinking__sequentialthinking, mcp__crash__crash]
    ---
    ```
-   **`run/file-organizer.toml`**, **`run/photo-rename.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem]
    ---
    ```
-   **`run/report-gen.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem]
    ---
    ```
-   **`run/security-audit.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem, git, fetch]
    ---
    ```
-   **`run/test-gen.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem]
    ---
    ```
-   **`run/task-prioritizer.toml`**, **`run/meeting-summary.toml`**, **`run/email-draft.toml`**:
    ```yaml
    ---
    mcp-servers: [sequential-thinking, memory]
    allowed-tools: [mcp__sequential-thinking__sequentialthinking, mcp__memory__memory]
    ---
    ```
-   **`find-docs.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [fetch, git, github, filesystem]
    ---
    ```
-   **`explain/simple.toml`**, **`explain/interactive.toml`**:
    ```yaml
    ---
    mcp-servers: [context7, sequential-thinking]
    allowed-tools: [filesystem, mcp__context7__context7, mcp__sequential-thinking__sequentialthinking]
    ---
    ```
-   **`code/review.toml`**:
    ```yaml
    ---
    mcp-servers: [context7, sequential-thinking]
    allowed-tools: [filesystem, git, mcp__context7__context7, mcp__sequential-thinking__sequentialthinking]
    ---
    ```
-   **`google/whatsnew.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [fetch]
    ---
    ```
-   **`react/docs.toml`**:
    ```yaml
    ---
    mcp-servers: []
    allowed-tools: [filesystem]
    ---
    ```

### Testing Strategy
To test the implementation, the user can run the modified slash commands and verify that the specified tools are available by default. The user should also verify that commands with no `mcp-servers` assigned do not have any MCP tools available.

## 🎯 Success Criteria
The feature is complete when the specified slash commands have the correct MCP servers and tools available as described in the implementation plan, using the in-prompt frontmatter method.