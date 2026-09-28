# Add AWS Agent Toolkit

**Status:** Deferred; no installation or configuration changes made.

**Goal:** Add AWS's Agent Toolkit only to the agent CLI(s) used for AWS work.

**Current state:** No AWS Agent Toolkit plugin or MCP server is configured in the tracked Claude Code, Codex, Cursor, Gemini CLI, or OpenCode configs.

## Plan

- [ ] Choose target CLI(s) when ready. AWS provides plugins for Claude Code, Codex, and Cursor; other MCP-capable agents can use the AWS MCP server and Toolkit skills.
- [ ] Start with `aws-core`; add `aws-agents` or `aws-data-analytics` only if those workflows are needed.
- [ ] Follow the current [AWS Agent Toolkit guide](https://docs.aws.amazon.com/agent-toolkit/latest/userguide/) for plugin/MCP setup and AWS identity. Use least-privilege access appropriate to the intended tasks.
- [ ] Update only the selected CLI configuration(s) in this repository.
- [ ] Verify the selected CLI discovers the Toolkit skills and MCP tools; perform a read-only AWS smoke check before enabling write operations.

**Official project:** [aws/agent-toolkit-for-aws](https://github.com/aws/agent-toolkit-for-aws)
