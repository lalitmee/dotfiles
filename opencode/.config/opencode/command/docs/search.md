---
description: Enhanced documentation search agent
agent: plan
---

## Mission: Documentation Search

Your task is to find and summarize documentation relevant to the user's query.

### Workflow:

1.  **Identify Scope**:

    - Determine if the query is about a specific tool (e.g., "git", "docker", "python") or the current project.

2.  **Search**:

    - **Project Docs**: Search `docs/`, `README.md`, and code comments.
    - **External Docs**: If configured, search external documentation sources.

3.  **Synthesize**:
    - Provide a clear answer based on the found documentation.
    - Cite sources with file paths or URLs.

### QUESTION:

$ARGUMENTS
