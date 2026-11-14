# tmux Chat Window Naming Implementation Plan

> **For agentic workers:** Use the executing-plans skill for native execution, or subagent-driven-development only if the user explicitly chooses delegation. Steps use checkbox syntax.

**Goal:** Rename a tmux window on demand using a selected agent session's first user prompt.

**Architecture:** A popup orchestrates provider detection, session selection, first-prompt retrieval and title generation. Separate provider adapters supply structured session candidates and prompt text; ambiguous or unsupported cases fail safely rather than guessing.

**Tech Stack:** Zsh, Python 3 standard library, tmux, gum, installed agent CLIs.

**Spec:** `docs/superpowers/specs/2026-11-14-tmux-chat-window-naming-design.md`

## Global Constraints

- Support OpenCode, Codex, Pi, Claude Code, and AGY's manual-description fallback.
- No pane scraping, undocumented AGY store, agent-session mutation, or automatic background renaming.
- Send only the selected first user prompt or AGY description to the naming CLI; never log prompt content.
- No new dependencies or agent-configuration changes without separate approval.
- Do not commit without separate explicit approval.
- Provider features not demonstrably available through supported interfaces must produce a clear limitation, not an unsafe guess.

## Review Focus

- Two sessions in one project: picker selects the requested one, never the newest implicitly.
- Session switched inside an agent: a subsequent invocation does not reuse a stale association.
- Prompt includes instructions or shell metacharacters: it remains data and is never executed.
- Naming finishes after focus changes: only the original window is affected.
- Missing provider, empty prompt, malformed response, or vanished target: no window is renamed.

## File structure

- Create `tmux/.config/tmux/scripts/popup/ai/rename-chat.sh`: popup orchestration, provider choice, naming and tmux targeting.
- Create `tmux/.config/tmux/scripts/popup/ai/chat-sessions.py`: provider-specific listing and first-prompt retrieval; Python standard library only.
- Create `scripts/test/tmux/ai/chat-sessions.py`: fixture-based adapter tests.
- Create `scripts/test/tmux/ai/rename-chat.zsh`: mocked UI/backend and private-tmux integration tests.
- Modify `tmux/.config/tmux/tmux.conf.local`, `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt`, and `results/tmux-native-config-baseline.md`: bind and document the shortcut, updating its tracked keymap baseline.
- Modify `scripts/test/tmux/config.zsh`: assert the new key binding and help row on an isolated tmux server.
- Modify `scripts/test/README.md`: add both focused test commands.

### Task 1: Session adapters

**Interfaces:** `python3 chat-sessions.py list PROVIDER DIRECTORY` emits a JSON array of `{id, title}` records; `python3 chat-sessions.py prompt PROVIDER DIRECTORY SESSION_ID` emits a JSON string containing only the first user text prompt. Errors go to stderr without conversation content and return nonzero. Supported provider names are `opencode`, `codex`, `pi`, and `claude`; AGY is handled by the popup.

- [ ] Write fixture-based tests in `scripts/test/tmux/ai/chat-sessions.py` for each verified adapter: two same-directory sessions with explicit ID selection, first user text rather than assistant/tool/system content, empty or missing prompt, malformed provider response, unavailable command, and paths containing spaces. Test that errors contain no transcript content.
- [ ] Run `python3 scripts/test/tmux/ai/chat-sessions.py`; expect failures because the adapter does not exist.
- [ ] Implement the adapter CLI in `tmux/.config/tmux/scripts/popup/ai/chat-sessions.py`. Verify the installed provider's documented interface and response schema before implementing each adapter: OpenCode `session list --format json` and `session export`; Codex app-server JSON-RPC; Pi's documented JSONL session format; Claude's documented SDK/session-reading interface if available without installation. Use fixture data reflecting verified schemas, not private session data. If a supported interface is unavailable, return an explicit provider-specific limitation; do not substitute undocumented data. Keep candidate IDs and titles separate from prompt text.
- [ ] Run `python3 scripts/test/tmux/ai/chat-sessions.py`; expect all tests to pass. Run `python3 -m py_compile tmux/.config/tmux/scripts/popup/ai/chat-sessions.py`.

### Task 2: Manual rename flow

**Interfaces:** `zsh rename-chat.sh PANE_ID` targets the pane's original window and directory; it calls the Task 1 adapter, uses gum for selection/input, and reports status via tmux. `agy` always uses manual input.

- [ ] Write `scripts/test/tmux/ai/rename-chat.zsh` using fake agent, adapter, gum, and naming commands plus an isolated tmux socket. Assert explicit session selection when two candidates exist, fresh selection after a simulated in-agent session switch, AGY manual input, provider-selection fallback, cancellation, no sessions, empty prompt, unavailable naming backend, timeout, malformed name, and original-window targeting after switching focus. Include a prompt with shell metacharacters and an instruction to run a command; assert it is passed as data and no marker command runs. Assert status output omits prompt content.
- [ ] Run `zsh scripts/test/tmux/ai/rename-chat.zsh`; expect failure because the script does not exist.
- [ ] Implement `tmux/.config/tmux/scripts/popup/ai/rename-chat.sh`: resolve and retain the original window ID and project path; detect a supported pane process only when unambiguous, otherwise offer a provider picker. Always show the session picker for supported session adapters in this version, avoiding stale mappings. For AGY request a description. Invoke the existing launcher’s naming backends and timeout conventions without using tools or changing the selected session; validate 2–3 lowercase alphanumeric hyphen-separated words, maximum 48 characters. Recheck the original target before renaming and report errors without the prompt. Treat all prompt text as data and do not evaluate it as shell code.
- [ ] Run `zsh -n tmux/.config/tmux/scripts/popup/ai/rename-chat.sh` and `zsh scripts/test/tmux/ai/rename-chat.zsh`; expect success.

### Task 3: Binding, help, and end-to-end verification

**Interfaces:** `Ctrl-a Ctrl-i n` starts the Task 2 script for `#{pane_id}` in a popup; existing AI-tool bindings remain unchanged.

- [ ] Extend `scripts/test/tmux/ai/rename-chat.zsh` to load the configuration on a private tmux socket and assert the `ai-tools` table binds `n` to the new script with the originating pane ID. Assert the AI-tools help table includes the shortcut.
- [ ] Run `zsh scripts/test/tmux/ai/rename-chat.zsh`; expect the new binding/help assertions to fail.
- [ ] Add the binding to `tmux/.config/tmux/tmux.conf.local`, add its help row to `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt`, and document both focused tests in `scripts/test/README.md`.
- [ ] Run `python3 scripts/test/tmux/ai/chat-sessions.py`, `zsh scripts/test/tmux/ai/rename-chat.zsh`, and `zsh scripts/test/tmux/ai/launcher.zsh`; expect all to pass. Run `zsh -n` on the popup script and `python3 -m py_compile` on the adapter. Check `git diff --check`.
- [ ] If a live tmux server is available and reloading is practical, source `~/.config/tmux/tmux.conf` and inspect `tmux list-keys -T ai-tools`; otherwise record why live reload was skipped. Do not run the installer or alter unrelated changes.
