## User Story 1: Update Gemini CLI settings to latest schema

**As a** Gemini CLI user,
**I want** my configuration to be minimal and up-to-date with the latest schema
**So that** I avoid using redundant or deprecated settings while keeping my custom preferences and backup configurations.

**Acceptance Criteria:**

1.  Remove `general.enablePromptCompletion` and `general.previewFeatures`.
2.  Remove `tools.shell.enableInteractiveShell`.
3.  Remove the `tools.core` allowlist.
4.  RETAIN `inactiveMcpServers` as a custom backup.
5.  Maintain all other custom preferences.
