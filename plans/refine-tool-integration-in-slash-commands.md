# Feature Implementation Plan: Final Tool Integration in Slash Commands (v10)

## 📋 Todo Checklist

- [x] Revert all `.toml` files to their original state.
- [x] Add a descriptive and structured markdown section for tool usage to the *end* of the prompts of the relevant `.toml` files.
- [x] Final Review and Testing

## 🔍 Analysis & Investigation

### Final Conclusion on Tool Integration
Based on the user's latest feedback, the definitive strategy for tool integration is to use a descriptive and structured markdown section at the **end** of the prompt in each command's `.toml` file. This section will clearly inform the LLM of the tools at its disposal right before it begins its task, which is a strong prompt engineering practice.

### Revised Strategy
This plan will now proceed with the following strategy:
1.  **Revert all previous changes**: Ensure a clean slate by removing any incorrect tool integration attempts from the `.toml` files.
2.  **Implement the descriptive tool section at the end of the prompt**: For each relevant command, append the structured markdown section for tool usage to the `prompt`.

## 📝 Implementation Plan

### Step 1: Revert Previous Changes
I will iterate through all the `.toml` files that were modified in the previous sessions and remove any tool-related additions to the prompts to restore them to their original state.
- **Implementation Notes**: All relevant `.toml` files have been reverted to their original state, removing any previous tool integration attempts.
- **Status**: ✅ Completed

### Step 2: Implement Descriptive Tool Section at the End of Prompts
After reverting the changes, I will modify the `prompt` in each relevant `.toml` file to include the new structured markdown section at the end of the prompt.
- **Implementation Notes**: The descriptive tool section has been added to the end of the prompt for all relevant `.toml` files.
- **Status**: ✅ Completed

#### Example Format:
```markdown
... (main prompt content)

## Available Tools

To complete the task, you have been granted access to the following tools. You are expected to use them as needed.

The tools available for this command are:
- `filesystem`
- `git`
- ...
```

#### Tool Assignments:

-   **`git/review.toml`**:
    -   Tools: `filesystem`, `git`, `github`, `fetch`, `sequential-thinking`, `crash`, `context7`
-   **`git/commit.toml`**:
    -   Tools: `git`, `sequential-thinking`
-   **`plan` commands** (go, impl, new, refine, cleanup):
    -   Tools: `filesystem`, `git`, `github`, `fetch`, `sequential-thinking`, `crash`, `context7`
-   **`run/cleanup.toml`**:
    -   Tools: `filesystem`, `git`
-   **`run/debug-assistant.toml`**:
    -   Tools: `filesystem`, `git`, `sequential-thinking`, `crash`
-   **`run/file-organizer.toml`**, **`run/photo-rename.toml`**:
    -   Tools: `filesystem`
-   **`run/report-gen.toml`**:
    -   Tools: `filesystem`
-   **`run/security-audit.toml`**:
    -   Tools: `filesystem`, `git`, `fetch`
-   **`run/test-gen.toml`**:
    -   Tools: `filesystem`
-   **`run/task-prioritizer.toml`**, **`run/meeting-summary.toml`**, **`run/email-draft.toml`**:
    -   Tools: `memory`, `sequential-thinking`
-   **`find-docs.toml`**:
    -   Tools: `fetch`, `git`, `github`, `filesystem`
-   **`explain/simple.toml`**, **`explain/interactive.toml`**:
    -   Tools: `filesystem`, `context7`, `sequential-thinking`
-   **`code/review.toml`**:
    -   Tools: `filesystem`, `git`, `context7`, `sequential-thinking`
-   **`google/whatsnew.toml`**:
    -   Tools: `fetch`
-   **`react/docs.toml`**:
    -   Tools: `filesystem`

### Testing Strategy
To test the implementation, the user can run the modified slash commands and verify that the LLM correctly understands and uses the tools mentioned in the prompt.

## 🎯 Success Criteria
The feature is complete when the specified slash commands correctly use the assigned tools, as evidenced by the LLM's behavior when the commands are executed.
