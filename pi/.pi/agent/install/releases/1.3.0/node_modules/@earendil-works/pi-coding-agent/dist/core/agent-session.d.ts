/**
 * AgentSession - Core abstraction for agent lifecycle and session management.
 *
 * This class is shared between all run modes (interactive, print, rpc).
 * It encapsulates:
 * - Agent state access
 * - Event subscription with automatic session persistence
 * - Model and thinking level management
 * - Compaction (manual and auto)
 * - Bash execution
 * - Session switching and branching
 *
 * Modes use this class and add their own I/O layer on top.
 */
import { type Agent, type AgentEvent, type AgentMessage, type AgentState, type AgentTool, type ThinkingLevel } from "@earendil-works/pi-agent-core";
import type { ImageContent, Model, TextContent } from "@earendil-works/pi-ai/compat";
import { type BashResult } from "./bash-executor.ts";
import type { CacheWarmer, CacheWarmingStatus } from "./cache-warmer.ts";
import { type CompactionResult } from "./compaction/index.ts";
import { type ContextUsage, type ExtensionCommandContextActions, type ExtensionErrorListener, type ExtensionMode, ExtensionRunner, type ExtensionUIContext, type InputSource, type ReplacedSessionContext, type SessionStartEvent, type ShutdownHandler, type ToolDefinition, type ToolInfo } from "./extensions/index.ts";
import { type CustomMessage } from "./messages.ts";
import type { ModelRuntime } from "./model-runtime.ts";
import { type PromptTemplate } from "./prompt-templates.ts";
import type { ResourceLoader } from "./resource-loader.ts";
import { type BranchSummaryEntry, type SessionEntry, SessionManager } from "./session-manager.ts";
import { type CacheWarmingMode, type SettingsManager } from "./settings-manager.ts";
import { type BashOperations } from "./tools/bash.ts";
/** Parsed skill block from a user message */
export interface ParsedSkillBlock {
    name: string;
    location: string;
    content: string;
    userMessage: string | undefined;
}
/**
 * Parse a skill block from message text.
 * Returns null if the text doesn't contain a skill block.
 */
export declare function parseSkillBlock(text: string): ParsedSkillBlock | null;
/** Tool execution events of calls a tool made through `ctx.executeTool()` carry `parentToolCallId`. */
type WithParentToolCallId<E> = E extends {
    type: "tool_execution_start" | "tool_execution_update" | "tool_execution_end";
} ? E & {
    parentToolCallId?: string;
} : E;
/** Session-specific events that extend the core AgentEvent */
export type AgentSessionEvent = WithParentToolCallId<Exclude<AgentEvent, {
    type: "agent_end";
}>> | {
    type: "agent_end";
    messages: AgentMessage[];
    willRetry: boolean;
} | {
    type: "agent_settled";
    aborted: boolean;
} | {
    type: "queue_update";
    steering: readonly string[];
    followUp: readonly string[];
} | {
    type: "compaction_start";
    reason: "manual" | "threshold" | "overflow";
} | {
    type: "entry_appended";
    entry: SessionEntry;
} | {
    type: "session_info_changed";
    name: string | undefined;
} | {
    type: "thinking_level_changed";
    level: ThinkingLevel;
} | {
    type: "compaction_end";
    reason: "manual" | "threshold" | "overflow";
    result: CompactionResult | undefined;
    aborted: boolean;
    willRetry: boolean;
    errorMessage?: string;
} | {
    type: "auto_retry_start";
    attempt: number;
    maxAttempts: number;
    delayMs: number;
    errorMessage: string;
} | {
    type: "auto_retry_end";
    success: boolean;
    attempt: number;
    finalError?: string;
} | {
    type: "summarization_retry_scheduled";
    attempt: number;
    maxAttempts: number;
    delayMs: number;
    errorMessage: string;
} | {
    type: "summarization_retry_attempt_start";
    source: "branchSummary";
} | {
    type: "summarization_retry_attempt_start";
    source: "compaction";
    reason: "manual" | "threshold" | "overflow";
} | {
    type: "summarization_retry_finished";
} | {
    type: "bash_execution_update";
    id?: string;
    delta: string;
};
/** Listener function for agent session events */
export type AgentSessionEventListener = (event: AgentSessionEvent) => void;
export interface AgentSessionConfig {
    agent: Agent;
    sessionManager: SessionManager;
    settingsManager: SettingsManager;
    cwd: string;
    /** Models to cycle through with Ctrl+P (from --models flag) */
    scopedModels?: Array<{
        model: Model<any>;
        thinkingLevel?: ThinkingLevel;
    }>;
    /** Resource loader for extensions, skills, prompts, themes, context files, and system prompt */
    resourceLoader: ResourceLoader;
    /** SDK custom tools registered outside extensions */
    customTools?: ToolDefinition[];
    /** Canonical model/auth runtime used by coding-agent internals. */
    modelRuntime: ModelRuntime;
    /** Keeps the prompt cache entry of the last session request warm. */
    cacheWarmer?: Pick<CacheWarmer, "cancel" | "status" | "onAgentSettled" | "onModeChanged" | "onWarmed">;
    /** Initial active built-in tool names. Default: [read, bash, edit, write] */
    initialActiveToolNames?: string[];
    /**
     * Whether the initial tools come from the `defaultTools` setting. When true, a resumed session
     * replaces them with the loadout its transcript records, with `defaultToolModifiers` applied, and
     * reload activates tools newly added to the setting. Tools removed from it stay active.
     */
    usesDefaultTools?: boolean;
    /**
     * `+name`/`-name` entries applied on top of the `defaultTools` setting, from `--tools`. Reload
     * applies them to the reloaded setting too, so a removed tool stays removed.
     */
    defaultToolModifiers?: string[];
    /**
     * Optional allowlist of tool names or patterns (`*` matches any characters). When provided, only
     * matching tools are exposed. A non-empty list without `mcp__` entries also keeps MCP tools
     * registered for codemode and tool_search; only tool_search can declare them. An empty list
     * exposes no tools.
     */
    allowedToolNames?: string[];
    /** Optional denylist of tool names or patterns. When provided, matching tools are not exposed. */
    excludedToolNames?: string[];
    /**
     * Override base tools (useful for custom runtimes).
     *
     * These are synthesized into minimal ToolDefinitions internally so AgentSession can keep
     * a definition-first registry even when callers provide plain AgentTool instances.
     */
    baseToolsOverride?: Record<string, AgentTool>;
    /** Mutable ref used by Agent to access the current ExtensionRunner */
    extensionRunnerRef?: {
        current?: ExtensionRunner;
    };
    /** Session start event metadata emitted when extensions bind to this runtime. */
    sessionStartEvent?: SessionStartEvent;
}
export interface ExtensionBindings {
    uiContext?: ExtensionUIContext;
    mode?: ExtensionMode;
    commandContextActions?: ExtensionCommandContextActions;
    abortHandler?: () => void;
    shutdownHandler?: ShutdownHandler;
    onError?: ExtensionErrorListener;
}
export type QueuedInputDisposition = "handled" | "queued";
export type PromptDisposition = QueuedInputDisposition | "started";
/** Options for AgentSession.prompt() */
export interface PromptOptions {
    /** Whether to dispatch extension commands and expand skill commands and prompt templates (default: true) */
    expandPromptTemplates?: boolean;
    /** Image attachments */
    images?: ImageContent[];
    /** When streaming, how to queue the message: "steer" (interrupt) or "followUp" (wait). Required if streaming. */
    streamingBehavior?: "steer" | "followUp";
    /** Source of input for extension input event handlers. Defaults to "interactive". */
    source?: InputSource;
    /** Internal hook used by RPC mode to observe how an accepted prompt was dispatched. Not called if the prompt is rejected. */
    preflightResult?: (disposition: PromptDisposition) => void;
}
/** Options for model/thinking mutations. */
export interface ModelMutationOptions {
    /** Persist the new value to global defaults. Defaults to session-only. */
    persist?: boolean;
}
/** Result from cycleModel() */
export interface ModelCycleResult {
    model: Model<any>;
    thinkingLevel: ThinkingLevel;
    /** Whether cycling through scoped models (--models flag) or all available */
    isScoped: boolean;
}
/** Session statistics for /session command */
export interface SessionStats {
    sessionFile: string | undefined;
    sessionId: string;
    userMessages: number;
    assistantMessages: number;
    toolCalls: number;
    toolResults: number;
    totalMessages: number;
    tokens: {
        input: number;
        output: number;
        cacheRead: number;
        cacheWrite: number;
        total: number;
    };
    cost: number;
    contextUsage?: ContextUsage;
}
export declare class AgentSession {
    readonly agent: Agent;
    readonly sessionManager: SessionManager;
    readonly settingsManager: SettingsManager;
    private _scopedModels;
    private _unsubscribeAgent?;
    private _eventListeners;
    private _isAgentRunActive;
    private _agentRunAbortRequested;
    private _idleWaitPromise;
    private _resolveIdleWait;
    /** Tracks pending steering messages for UI display. Removed when delivered. */
    private _steeringMessages;
    /** Tracks pending follow-up messages for UI display. Removed when delivered. */
    private _followUpMessages;
    /** Messages queued to be included with the next user prompt as context ("asides"). */
    private _pendingNextTurnMessages;
    /** Context-only custom messages queued during a run, flushed once the current turn's tool results are in. */
    private _pendingCustomMessages;
    private _compactionAbortController;
    private _autoCompactionAbortController;
    private _overflowRecoveryAttempted;
    private _branchSummaryAbortController;
    private _retryAbortController;
    private _retryAttempt;
    /**
     * Failed response that the next request repeats, set by auto-retry and overflow recovery. The
     * retry is routed with it as `failed`, since the context no longer contains it.
     */
    private _failedResponse;
    private readonly _bashAbortControllers;
    private _pendingBashMessages;
    private _extensionRunner;
    private _turnIndex;
    private readonly _entryIdsByMessage;
    private readonly _boundaryDispatchedMessages;
    private _lastAssistantMessage;
    private _lastAssistantToolResults;
    private _lastActivityOutcome;
    private _isBeforeSettle;
    private _abortDuringBeforeSettle;
    private _isEmittingAgentSettled;
    private readonly _deferredSettledActions;
    private _resourceLoader;
    private _customTools;
    private _baseToolDefinitions;
    private _cwd;
    private _extensionRunnerRef?;
    private _initialActiveToolNames?;
    /**
     * Tools of the restored or reloaded loadout that are not registered yet, such as tools of MCP
     * servers that are still connecting. They are activated when they are registered, and dropped when
     * `setActiveToolsByName()` deactivates a tool or the next agent run starts.
     */
    private _pendingToolNames;
    private _usesDefaultTools;
    private _defaultToolModifiers;
    /** Matches the `--tools` entries: tool names or patterns. */
    private _allowedTools?;
    /**
     * Whether the allowlist filters MCP tools: it is empty (`--no-tools`) or names an MCP tool
     * (`mcp__*`). Otherwise it keeps MCP tools registered for codemode and tool_search.
     */
    private _allowlistFiltersMcp;
    private _excludedTools?;
    private _baseToolsOverride?;
    private _sessionStartEvent;
    private _extensionUIContext?;
    private _extensionMode;
    private _extensionCommandContextActions?;
    private _extensionAbortHandler?;
    private _extensionShutdownHandler?;
    private _extensionErrorListener?;
    private _extensionErrorUnsubscriber?;
    private _modelRuntime;
    private _cacheWarmer?;
    private _toolRegistry;
    /** Created on the first `ctx.executeTool()` call. */
    private _nestedToolCalls;
    /** Declared tools whose declarations requests leave out, from `prepareLoadout` hooks. */
    private _hiddenDeclarations;
    private _toolDefinitions;
    private _toolPromptSnippets;
    private _toolPromptGuidelines;
    private _baseSystemPromptOptions;
    /** Prompt options after before_agent_start mutations for the active run. */
    private _runSystemPromptOptions?;
    constructor(config: AgentSessionConfig);
    get modelRuntime(): ModelRuntime;
    private _getRequiredRequestAuth;
    private _getSummarizationRequestAuth;
    /**
     * The model whose limits apply to `message`, or undefined when the message came from another
     * model. Under a virtual selection, that is the physical model that produced it.
     */
    private _modelForMessage;
    /**
     * Record the selection on the current branch when the branch implies another one, so a resume
     * restores it. Tree navigation can leave the latest `model_change` on another branch; responses
     * cannot record a virtual selection because they name physical models. Responses do record a
     * physical selection unless the branch holds a virtual one; checking a physical selection against
     * responses would record it on every prompt while `prepareRequest` redirects to another model.
     */
    private _recordSelection;
    /** The model whose limits apply to the conversation. */
    private _limitsModel;
    /**
     * Install tool hooks once on the Agent instance.
     *
     * The callbacks read `this._extensionRunner` at execution time, so extension reload swaps in the
     * new runner without reinstalling hooks. Extension-specific tool wrappers are still used to adapt
     * registered tool execution to the extension context. Tool call and tool result interception now
     * happens here instead of in wrappers.
     */
    private _installAgentToolHooks;
    /** `tool_call` handlers. `parentToolCallId` is set for calls another tool made. */
    private _beforeToolCall;
    /** `tool_result` handlers and image normalization. `parentToolCallId` is set for calls another tool made. */
    private _afterToolCall;
    /**
     * Run a call that the tool call `parentToolCallId` made through `ctx.executeTool()`. It goes
     * through the agent's tool pipeline with the session's hooks, against the callable tools.
     */
    private _executeNestedToolCall;
    /** Whether `projection`, the current session projection, exceeds the compaction threshold of `model`. */
    private _exceedsCompactionThreshold;
    private _compactBeforeNextAssistantResponse;
    private _installAgentRequestProjection;
    private _dispatchTurnEndBoundary;
    private _installAgentBoundaryHooks;
    private _installAgentNextTurnRefresh;
    private _refreshFinalizedContext;
    private _applyBoundaryDrafts;
    private _createBoundaryPreviewManager;
    private _getPendingBoundaryMessages;
    private _buildBoundaryContext;
    private _commitBoundaryDrafts;
    private _reportInvalidBoundaryContinuation;
    /** Emit an event to all listeners */
    private _emit;
    private _emitQueueUpdate;
    private _emitSessionCompactFailed;
    private _getIdleWaitPromise;
    private _resolveIdleWaitIfIdle;
    private _emitAgentSettled;
    /** Internal handler for agent events - shared by subscribe and reconnect */
    private _handleAgentEvent;
    private _willRetryAfterAgentEnd;
    private _findPersistedMessageEntryId;
    private _omitRecoveryAttempt;
    /** Find the last assistant message in agent state (including aborted ones) */
    private _findLastAssistantMessage;
    private _replaceMessageInPlace;
    /** Emit extension events based on agent events */
    private _emitExtensionEvent;
    /**
     * Subscribe to agent events.
     * Session persistence is handled internally (saves messages on message_end).
     * Multiple listeners can be added. Returns unsubscribe function for this listener.
     */
    subscribe(listener: AgentSessionEventListener): () => void;
    /** Disconnect from agent events during disposal. */
    private _disconnectFromAgent;
    /**
     * Remove all listeners and disconnect from agent.
     * Call this when completely done with the session.
     */
    dispose(): void;
    /** Refresh the public finalized transcript from the canonical session projection. */
    refreshContext(): void;
    /** Full agent state */
    get state(): AgentState;
    /** Current cache-warming state and the policy inputs that produced it. */
    get cacheWarmingStatus(): CacheWarmingStatus | undefined;
    /** Persist the cache-warming mode and immediately reconcile active warming. */
    setCacheWarmingMode(mode: CacheWarmingMode): void;
    /** Current model (may be undefined if not yet selected) */
    get model(): Model<any> | undefined;
    /** Current thinking level */
    get thinkingLevel(): ThinkingLevel;
    /** Under a virtual selection, the physical model and thinking level of the latest successful response. */
    get routedModel(): {
        model: Model<any>;
        thinkingLevel?: ThinkingLevel;
    } | undefined;
    /** Whether the session is currently processing an agent run or post-run continuation. */
    get isStreaming(): boolean;
    /** Whether the session has no active agent run, compaction, branch summary, retry, or queued continuation. */
    get isIdle(): boolean;
    /** Current effective system prompt, including changes not yet sent to the model. */
    get systemPrompt(): string;
    /** Current retry attempt (0 if not retrying) */
    get retryAttempt(): number;
    /**
     * Get the names of currently active tools, which are the tools declared to the model.
     * Tools with `codemode` or `deferred` exposure are callable from other tools without being active.
     */
    getActiveToolNames(): string[];
    /** Get the names of the tools that tools can call through `ctx.executeTool()`. */
    getCallableToolNames(): string[];
    /**
     * Get all configured tools with name, description, parameter schema, prompt guidelines, and source metadata.
     */
    getAllTools(): ToolInfo[];
    getToolDefinition(name: string): ToolDefinition | undefined;
    /**
     * Set active tools by name.
     * Only tools in the registry can be enabled. Unknown and hidden tool names are ignored.
     * Also rebuilds the system prompt to reflect the new tool set.
     * Changes take effect on the next agent turn.
     */
    setActiveToolsByName(toolNames: string[]): void;
    private _setActiveTools;
    /**
     * Whether `--tools` and `--exclude-tools` keep the tool registered. MCP tools stay registered
     * unless the allowlist filters them (see `_allowlistFiltersMcp`).
     */
    private _isAllowedTool;
    /**
     * Whether the tool may be active, which declares it to the model. MCP tools the allowlist keeps
     * without matching them are only for codemode and tool_search: they may be declared only when
     * tool_search can load them (non-`direct` exposure and tool_search registered). This also applies
     * to tools restored from the transcript or set by extensions.
     */
    private _isActivatable;
    private _getToolExposure;
    /**
     * Tools callable through `ctx.executeTool()`: the active `direct` tools and every registered
     * `codemode` or `deferred` tool.
     */
    private _getCallableTools;
    /**
     * Set the agent's tools for the given active tool names and return them. The active tools are
     * the registered, non-hidden ones; they are declared to the model. Active tools with a
     * `prepareLoadout` hook can change the declared descriptions and hide declarations from
     * requests (see {@link _installHiddenDeclarationsProjection}).
     */
    private _applyToolLoadout;
    /** Whether compaction or branch summarization is currently running */
    get isCompacting(): boolean;
    /** All messages including custom types like BashExecutionMessage */
    get messages(): AgentMessage[];
    /** Current steering mode */
    get steeringMode(): "all" | "one-at-a-time";
    /** Current follow-up mode */
    get followUpMode(): "all" | "one-at-a-time";
    /** Current session file path, or undefined if sessions are disabled */
    get sessionFile(): string | undefined;
    /** Current session ID */
    get sessionId(): string;
    /** Current session display name, if set */
    get sessionName(): string | undefined;
    /** Scoped models for cycling (from --models flag) */
    get scopedModels(): ReadonlyArray<{
        model: Model<any>;
        thinkingLevel?: ThinkingLevel;
    }>;
    /** Update scoped models for cycling */
    setScopedModels(scopedModels: Array<{
        model: Model<any>;
        thinkingLevel?: ThinkingLevel;
    }>): void;
    /** File-based prompt templates */
    get promptTemplates(): ReadonlyArray<PromptTemplate>;
    private _normalizePromptSnippet;
    private _normalizePromptGuidelines;
    private _rebuildSystemPrompt;
    /**
     * Apply a prompt and tool loadout for the next request. Sets the executable tools and
     * returns a system message patching the prompt sections the model currently has (replayed
     * from `messages`), or undefined when the prompt is unchanged. Tool changes are declared by
     * the agent loop before the request.
     *
     * A forced prompt does not affect the transcript: the structured sections are still diffed
     * and persisted, and the forced text is projected onto the request by
     * {@link _installAgentForcedPromptProjection}.
     */
    private _preparePromptAndToolLoadout;
    /**
     * Send a forced prompt as the provider's leading system prompt without recording it.
     *
     * A `before_agent_start` handler that returns `systemPrompt` needs that exact text at the
     * head of the request; a mid-conversation system message would leave the original prompt
     * in place. The forced text is a rendering of the current prompt, so the transcript keeps
     * its structured sections and the request is projected instead: the system messages
     * collapse into one head holding the forced text and the current tools. Runs after the
     * `context` extension handlers.
     */
    /**
     * Remove the declarations that `prepareLoadout` hooks hide from every request. The whole
     * transcript is filtered with the current set, so the projected declarations stay consistent
     * across requests and only change when the loadout does.
     */
    private _installHiddenDeclarationsProjection;
    private _installAgentForcedPromptProjection;
    /**
     * Restore the active tool loadout declared by the session transcript, if it declares one.
     * Tools reachable only from other tools are never declared, but they do not depend on the active
     * set, so the transcript's declarations are the whole loadout.
     * @param modifiers `+name`/`-name` entries applied to the restored loadout.
     */
    private _restoreToolsFromTranscript;
    /**
     * Start a run from a user or custom message. The session counts as busy from here on, so
     * messages sent while before_agent_start handlers run are queued into this run instead of
     * starting another, and an abort requested meanwhile aborts the run as soon as it exists.
     * @param onStarted Called once the run's messages are prepared, before the first request.
     */
    private _startRun;
    /**
     * Prepare a run and return its starting messages: compact first when needed, emit
     * before_agent_start, apply the run's prompt options and tool loadout, and build the starting
     * message followed by pending nextTurn messages (consumed here) and handler messages, with a
     * system patch first when the prompt changed.
     */
    private _prepareRun;
    private _handlePostAgentRun;
    private _runBeforeSettleBoundary;
    private _runInputHandlers;
    private _normalizePromptImages;
    /**
     * Send a prompt to the agent.
     * - Handles extension commands (registered via pi.registerCommand) immediately, even during streaming
     * - Expands file-based prompt templates by default
     * - During streaming, queues via steer() or followUp() based on streamingBehavior option
     * - Validates model and API key before sending (when not streaming)
     * @throws Error if streaming and no streamingBehavior specified
     * @throws Error if no model selected or no API key available (when not streaming)
     */
    prompt(text: string, options?: PromptOptions): Promise<void>;
    /**
     * Try to execute an extension command. Returns true if command was found and executed.
     */
    private _tryExecuteExtensionCommand;
    /**
     * Expand skill commands (/skill:name args) to their full content.
     * Returns the expanded text, or the original text if not a skill command or skill not found.
     * Emits errors via extension runner if file read fails.
     */
    private _expandSkillCommand;
    private _queueUserInput;
    /**
     * Queue a steering message while the agent is running.
     * Delivered after the current assistant turn finishes executing its tool calls,
     * before the next LLM call.
     * Expands skill commands and prompt templates. Errors on extension commands.
     * @param images Optional image attachments to include with the message
     * @param options Input source; defaults to interactive
     * @throws Error if text is an extension command
     */
    steer(text: string, images?: ImageContent[], options?: {
        source?: InputSource;
    }): Promise<QueuedInputDisposition>;
    /**
     * Queue a follow-up message to be processed after the agent finishes.
     * Delivered only when agent has no more tool calls or steering messages.
     * Expands skill commands and prompt templates. Errors on extension commands.
     * @param images Optional image attachments to include with the message
     * @param options Input source; defaults to interactive
     * @throws Error if text is an extension command
     */
    followUp(text: string, images?: ImageContent[], options?: {
        source?: InputSource;
    }): Promise<QueuedInputDisposition>;
    /**
     * Internal: Queue a steering message (already expanded, no extension command check).
     */
    private _queueSteer;
    /**
     * Internal: Queue a follow-up message (already expanded, no extension command check).
     */
    private _queueFollowUp;
    /**
     * Throw an error if the text is an extension command.
     */
    private _throwIfExtensionCommand;
    /**
     * Send a custom message to the session. Creates a CustomMessageEntry.
     *
     * Handles four cases:
     * - Streaming: queues message, processed when loop pulls from queue
     * - Streaming + triggerTurn false: appended to state/session once the current turn ends
     * - Not streaming + triggerTurn: appends to state/session, starts new turn
     * - Not streaming + no trigger: appends to state/session, no turn
     *
     * @param message Custom message with customType, content, display, details
     * @param options.triggerTurn If true and not streaming, triggers a new LLM turn
     * @param options.deliverAs Delivery mode: "steer", "followUp", or "nextTurn"
     */
    sendCustomMessage<T = unknown>(message: Pick<CustomMessage<T>, "customType" | "content" | "display" | "details">, options?: {
        triggerTurn?: boolean;
        deliverAs?: "steer" | "followUp" | "nextTurn";
    }): Promise<void>;
    private _appendCustomMessage;
    /**
     * Append custom messages queued while the agent was running.
     * Called once the current turn's tool results are in agent state and session history.
     */
    private _flushPendingCustomMessages;
    /**
     * Send a user message to the agent. Always triggers a turn.
     * When the agent is streaming, use deliverAs to specify how to queue the message.
     *
     * @param content User message content (string or content array)
     * @param options.deliverAs Delivery mode when streaming: "steer" or "followUp"
     * @param options.expandPromptTemplates Whether to dispatch extension commands and expand skill commands and prompt templates. Default: false.
     */
    sendUserMessage(content: string | (TextContent | ImageContent)[], options?: {
        deliverAs?: "steer" | "followUp";
        expandPromptTemplates?: boolean;
    }): Promise<void>;
    /**
     * Clear all queued messages and return them.
     * Useful for restoring to editor when user aborts.
     * @returns Object with steering and followUp arrays
     */
    clearQueue(): {
        steering: string[];
        followUp: string[];
    };
    /** Number of pending messages (includes both steering and follow-up) */
    get pendingMessageCount(): number;
    /** Get pending steering messages (read-only) */
    getSteeringMessages(): readonly string[];
    /** Get pending follow-up messages (read-only) */
    getFollowUpMessages(): readonly string[];
    get resourceLoader(): ResourceLoader;
    /**
     * Abort current operation and wait for agent to become idle.
     */
    abort(): Promise<void>;
    waitForIdle(): Promise<void>;
    private _emitModelSelect;
    /**
     * Set model directly.
     * Validates that auth is configured and saves to the session transcript.
     * Persists to global defaults only when options.persist is true.
     * @throws Error if no auth is configured for the model
     */
    setModel(model: Model<any>, options?: ModelMutationOptions): Promise<void>;
    private _addPersistedDefaultToNonEmptyScope;
    /**
     * Cycle to next/previous model.
     * Uses scoped models (from --models flag) if available, otherwise all available models.
     * @param direction - "forward" (default) or "backward"
     * @returns The new model info, or undefined if only one model available
     */
    cycleModel(direction?: "forward" | "backward", options?: ModelMutationOptions): Promise<ModelCycleResult | undefined>;
    private _cycleScopedModel;
    private _cycleAvailableModel;
    /**
     * Set thinking level.
     * Clamps to model capabilities based on available thinking levels.
     * Saves the clamped level to the session transcript only if the level actually changes.
     * Persists the requested level to global defaults only when options.persist is true.
     */
    setThinkingLevel(level: ThinkingLevel, options?: ModelMutationOptions): void;
    /**
     * Cycle to next thinking level.
     * @returns New level, or undefined if model doesn't support thinking
     */
    cycleThinkingLevel(options?: ModelMutationOptions): ThinkingLevel | undefined;
    /**
     * Get available thinking levels for current model.
     * The provider will clamp to what the specific model supports internally.
     */
    getAvailableThinkingLevels(): ThinkingLevel[];
    /**
     * Check if current model supports thinking/reasoning.
     */
    supportsThinking(): boolean;
    private _getThinkingLevelForModelSwitch;
    private _clampThinkingLevel;
    private syncQueueModesFromSettings;
    /**
     * Set steering message mode.
     * Saves to settings.
     */
    setSteeringMode(mode: "all" | "one-at-a-time"): void;
    /**
     * Set follow-up message mode.
     * Saves to settings.
     */
    setFollowUpMode(mode: "all" | "one-at-a-time"): void;
    /** Generate Pi's built-in compaction summary for manual and automatic compaction. */
    private _runDefaultCompaction;
    private _clearManualCompactionState;
    /**
     * Manually compact the session context.
     *
     * This is the manual entry point used by `/compact`, RPC, and extensions. It is
     * separate from automatic threshold/overflow compaction, which enters through
     * `_checkCompaction()` and `_runAutoCompaction()`. After preparation and the
     * `session_before_compact` hook, both paths call the lower-level `compact()`
     * function imported from `./compaction/index.ts`, unless the hook cancels or
     * supplies a custom result.
     *
     * Aborts the current agent operation first. Manual compaction never retries or
     * continues the interrupted agent turn.
     *
     * @param customInstructions Optional instructions for the compaction summary
     */
    compact(customInstructions?: string): Promise<CompactionResult>;
    /**
     * Cancel in-progress compaction (manual or auto).
     */
    abortCompaction(): void;
    /**
     * Cancel in-progress branch summarization.
     */
    abortBranchSummary(): void;
    /**
     * Dispatch automatic compaction after `agent_end` or before prompt submission.
     * Manual compaction does not call this method; it enters through `compact()`.
     *
     * Automatic cases:
     * 1. Overflow with retry: a context-overflow error or recoverable length stop;
     *    remove the failed assistant message, compact, and retry the turn once.
     * 2. Overflow without retry: a successful response exceeded the configured
     *    context window; compact but preserve the completed response.
     * 3. Threshold without retry: valid or estimated context usage crossed the
     *    configured threshold; compact without retrying the completed response.
     *
     * Each case calls `_runAutoCompaction()`. After preparation and the
     * `session_before_compact` hook, that method calls the lower-level `compact()`
     * function imported from `./compaction/index.ts`, unless the hook cancels or
     * supplies a custom result.
     *
     * @param assistantMessage The assistant message to check
     * @param skipAbortedCheck If false, include aborted messages (for pre-prompt check). Default: true
     * @returns Whether the post-run loop should call `agent.continue()` for overflow recovery or queued messages
     */
    private _checkCompaction;
    /**
     * Execute threshold or overflow compaction. Manual compaction uses
     * `AgentSession.compact()` instead. Both paths call the lower-level `compact()`
     * function imported from `./compaction/index.ts` after preparation and extension
     * interception.
     *
     * @param reason Automatic trigger selected by `_checkCompaction()`
     * @param willRetry Whether to continue the interrupted turn after overflow compaction
     * @returns Whether the post-run loop should call `agent.continue()`
     */
    private _runAutoCompaction;
    /**
     * Toggle auto-compaction setting.
     */
    setAutoCompactionEnabled(enabled: boolean): void;
    /** Whether auto-compaction is enabled */
    get autoCompactionEnabled(): boolean;
    bindExtensions(bindings: ExtensionBindings): Promise<void>;
    private extendResourcesFromExtensions;
    private buildExtensionResourcePaths;
    private getExtensionSourceLabel;
    private _applyExtensionBindings;
    private _refreshCurrentModelFromRegistry;
    private _bindExtensionCore;
    private _refreshToolRegistry;
    /** Whether activating the tool declares it to the model. */
    private _isDeclarable;
    /** Whether registering the tool activates it, which declares it to the model. */
    private _isActivatedOnRegistration;
    private _buildRuntime;
    reload(options?: {
        beforeSessionStart?: () => void | Promise<void>;
    }): Promise<void>;
    /**
     * Check if an error is retryable (overloaded, rate limit, server errors).
     * Context overflow errors are NOT retryable (handled by compaction instead).
     */
    private _isRetryableError;
    /**
     * Retry policy + callbacks shared by compaction and branch-summary summarization calls.
     * Uses the same `settings.retry` budget/backoff as agent-turn retries so a single transient
     * stream drop no longer fails the whole operation. `source` carries the context
     * the TUI needs to render the retry and recreate the underlying indicator.
     */
    private _summarizationRetryCallbacks;
    private _finishCancelledRetry;
    /**
     * Prepare a retryable error for continuation with exponential backoff.
     * @returns true if the caller should continue the agent, false otherwise
     */
    private _prepareRetry;
    /**
     * Cancel in-progress retry.
     */
    abortRetry(): void;
    /** Whether auto-retry is currently in progress */
    get isRetrying(): boolean;
    /** Whether auto-retry is enabled */
    get autoRetryEnabled(): boolean;
    /**
     * Toggle auto-retry setting.
     */
    setAutoRetryEnabled(enabled: boolean): void;
    /**
     * Execute a bash command.
     * Adds result to agent context and session.
     * @param command The bash command to execute
     * @param onChunk Optional streaming callback for output
     * @param options.excludeFromContext If true, command output won't be sent to LLM (!! prefix)
     * @param options.id Optional identifier included in bash execution update events
     * @param options.operations Custom BashOperations for remote execution
     */
    executeBash(command: string, onChunk?: (chunk: string) => void, options?: {
        excludeFromContext?: boolean;
        id?: string;
        operations?: BashOperations;
    }): Promise<BashResult>;
    /**
     * Record a bash execution result in session history.
     * Used by executeBash and by extensions that handle bash execution themselves.
     */
    recordBashResult(command: string, result: BashResult, options?: {
        excludeFromContext?: boolean;
    }): void;
    /**
     * Cancel running bash command.
     */
    abortBash(): void;
    /** Whether a bash command is currently running */
    get isBashRunning(): boolean;
    /** Whether there are pending bash messages waiting to be flushed */
    get hasPendingBashMessages(): boolean;
    /**
     * Flush pending bash messages to agent state and session.
     * Called after agent turn completes to maintain proper message ordering.
     */
    private _flushPendingBashMessages;
    /**
     * Set a display name for the current session.
     */
    setSessionName(name: string): void;
    /**
     * Navigate to a different node in the session tree.
     * Unlike fork() which creates a new session file, this stays in the same file.
     *
     * @param targetId The entry ID to navigate to
     * @param options.summarize Whether user wants to summarize abandoned branch
     * @param options.customInstructions Custom instructions for summarizer
     * @param options.replaceInstructions If true, customInstructions replaces the default prompt
     * @param options.label Label to attach to the branch summary entry
     * @returns Result with editorText (if user message) and cancelled status
     */
    navigateTree(targetId: string, options?: {
        summarize?: boolean;
        customInstructions?: string;
        replaceInstructions?: boolean;
        label?: string;
    }): Promise<{
        editorText?: string;
        cancelled: boolean;
        aborted?: boolean;
        summaryEntry?: BranchSummaryEntry;
    }>;
    /**
     * Get all user messages from session for fork selector.
     */
    getUserMessagesForForking(): Array<{
        entryId: string;
        text: string;
    }>;
    /**
     * Get session statistics. Aggregates over ALL session entries (including
     * history that was compacted away), so token/cost totals reflect what was
     * actually billed across the session.
     */
    getSessionStats(): SessionStats;
    getContextUsage(): ContextUsage | undefined;
    /**
     * Export session to HTML.
     * @param outputPath Optional output path (defaults to session directory)
     * @param options Optional export presentation settings
     * @returns Path to exported file
     */
    exportToHtml(outputPath?: string, options?: {
        themeName?: string;
    }): Promise<string>;
    /**
     * Export the current session branch to a JSONL file.
     * Writes the session header followed by all entries on the current branch path.
     * @param outputPath Target file path. If omitted, generates a timestamped file in cwd.
     * @returns The resolved output file path.
     */
    exportToJsonl(outputPath?: string): string;
    /**
     * Ask the current model to describe what went wrong in this session for a bug report.
     * Used when the user declines to share the transcript itself.
     */
    summarizeForBugReport(options: {
        hint?: string;
        signal: AbortSignal;
    }): Promise<string>;
    /**
     * Get text content of last assistant message.
     * Useful for /copy command.
     * @returns Text content, or undefined if no assistant message exists
     */
    getLastAssistantText(): string | undefined;
    createReplacedSessionContext(): ReplacedSessionContext;
    /**
     * Check if extensions have handlers for a specific event type.
     */
    hasExtensionHandlers(eventType: string): boolean;
    /**
     * Get the extension runner (for setting UI context and error handlers).
     */
    get extensionRunner(): ExtensionRunner;
}
export {};
//# sourceMappingURL=agent-session.d.ts.map