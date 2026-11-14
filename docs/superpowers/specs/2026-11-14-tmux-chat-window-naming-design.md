# tmux Chat Window Naming

## Goal

Rename a tmux window on demand using the first user prompt of the chat running in its active pane. Support OpenCode, Codex, Pi, Claude Code, and AGY without scraping terminal output or guessing which session is active.

## Interaction

Add `n` to the existing `ai-tools` key table, entered with `Ctrl-a Ctrl-i`. The binding passes the originating pane ID and working directory to a popup; it updates the corresponding AI-tools help.

Detect the agent from the pane's process where reliable. Otherwise, ask the user to choose the agent. For OpenCode, Codex, Pi, and Claude Code, use the agent's session interface to find sessions for the relevant project and display a searchable picker with titles or short previews. Only skip the picker if the active session can be identified reliably. A session selected for a pane may be reused only if its identity can be verified against the currently running agent; otherwise, show the picker again. In particular, changing sessions inside an agent must not silently reuse a stale selection.

For AGY, ask for a short task description instead. Do not use its undocumented session store or scrape its terminal. This fallback does not claim to retrieve AGY's conversation automatically.

Read the selected session's first user-authored text prompt. Pass only that prompt, or the AGY description, to a naming CLI. Request a lowercase, hyphenated two- or three-word name and validate it before renaming the original window. The naming operation runs only when explicitly triggered; it does not change chat-launch behavior or automatically rename windows.

## Provider boundaries

Keep provider-specific session listing and prompt retrieval separate from the shared picker, naming, and tmux operations. Use documented interfaces and installed tooling where available; avoid adding dependencies unless necessary and separately approved.

- **OpenCode:** use its session listing and export or session API. Verify the installed version's output and whether any active-session interface identifies the selected TUI session rather than merely running work.
- **Codex:** use the app-server thread listing and history interfaces, verifying the installed protocol version and the available preview or user-message fields.
- **Pi:** use its documented session format or session interfaces to list sessions and retrieve the first user message. RPC describes its own process and must not be assumed to attach to an existing interactive Pi process.
- **Claude Code:** use a documented session-reading interface if available without a new dependency; validate any alternative before relying on it. Hooks may identify sessions only if configured and must not be assumed present for existing chats.
- **AGY:** manual description only, until a supported session-reading interface is available.

Provider APIs and local installations differ. If an adapter cannot safely list or read sessions using a verified interface, report the limitation rather than choosing another conversation, scraping the pane, or silently reading undocumented data. Any additional dependencies or agent configuration require separate approval.

## Safety and failure behavior

The selected prompt can contain sensitive information and may be transmitted to the naming CLI's configured model provider. The picker and shortcut are explicit user actions; never submit all session histories or tool output. Treat prompt content as untrusted data, not instructions to execute. Do not invoke tools or change the original conversation to generate a name.

Capture the pane and window identity at invocation so switching windows while naming runs cannot rename a different window. If the pane or window disappears, the user cancels, no suitable session or first prompt exists, a provider fails, or the naming output is invalid, leave the window name unchanged and show a useful tmux message. Do not expose prompts in status messages or logs.

## Verification

Use isolated fixtures and fake provider and naming commands, not real private conversations or model requests. Cover agent detection and manual selection, session filtering and picker cancellation, selection ambiguity and stale mappings, first-user-prompt extraction, AGY's manual fallback, invalid or empty names, provider and naming failures, and targeting the original window after focus changes.

Run the focused tests and shell syntax checks, update `scripts/test/README.md` for any new focused tests, and verify the new binding and help entry in an isolated tmux server. Reload and inspect the live tmux keymap when practical, without altering unrelated user changes.

## Out of scope

Automatic background renaming, full-conversation summarization, session mutation, undocumented AGY integration, and support for agents beyond the five named above.
