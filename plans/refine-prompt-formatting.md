# Feature Implementation Plan: Refine Prompt Formatting

## 📋 Todo Checklist
- [x] Conditionally apply formatting change to all relevant `.toml` files.
- [x] Final Review and Testing

## 🔍 Analysis & Investigation

### User Request
The user has requested a formatting change to the `prompt` in the `.toml` files. The `prompt` should start with a newline character after the opening `"""`. The user also specified that I should not add a newline if one already exists.

**Current Format (undesired):**
```toml
prompt="""---
...
"""
```

**Desired Format:**
```toml
prompt="""
---
...
"""
```

### Analysis
This is a straightforward formatting change. To avoid unnecessary file modifications, I will first check if the `prompt` value already starts with a newline. The change will only be applied if the newline is missing.

## 📝 Implementation Plan

### Step 1: Conditionally Apply Formatting Change
I will iterate through all the `.toml` files listed below. For each file, I will read its content and check if the `prompt` string starts with a newline. If it does not, I will add the newline and save the file.

- **Implementation Notes**: Successfully applied the formatting change to all relevant `.toml` files.
- **Status**: ✅ Completed

#### Files to Modify:
- `gemini-cli/.gemini/commands/git/review.toml`
- `gemini-cli/.gemini/commands/git/commit.toml`
- `gemini-cli/.gemini/commands/plan/go.toml`
- `gemini-cli/.gemini/commands/plan/impl.toml`
- `gemini-cli/.gemini/commands/plan/new.toml`
- `gemini-cli/.gemini/commands/plan/refine.toml`
- `gemini-cli/.gemini/commands/plan/cleanup.toml`
- `gemini-cli/.gemini/commands/run/cleanup.toml`
- `gemini-cli/.gemini/commands/run/debug-assistant.toml`
- `gemini-cli/.gemini/commands/run/file-organizer.toml`
- `gemini-cli/.gemini/commands/run/photo-rename.toml`
- `gemini-cli/.gemini/commands/run/report-gen.toml`
- `gemini-cli/.gemini/commands/run/security-audit.toml`
- `gemini-cli/.gemini/commands/run/test-gen.toml`
- `gemini-cli/.gemini/commands/run/task-prioritizer.toml`
- `gemini-cli/.gemini/commands/run/meeting-summary.toml`
- `gemini-cli/.gemini/commands/run/email-draft.toml`
- `gemini-cli/.gemini/commands/find-docs.toml`
- `gemini-cli/.gemini/commands/explain/simple.toml`
- `gemini-cli/.gemini/commands/explain/interactive.toml`
- `gemini-cli/.gemini/commands/code/review.toml`
- `gemini-cli/.gemini/commands/google/whatsnew.toml`
- `gemini-cli/.gemini/commands/react/docs.toml`

### Testing Strategy
To test the implementation, I will read a few of the modified files to ensure the formatting change has been applied correctly, and that no extra newlines were added to files that were already correctly formatted.

## 🎯 Success Criteria
The feature is complete when all the specified `.toml` files have the `prompt` starting with exactly one newline character.
