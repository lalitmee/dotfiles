/**
 * Extension runner - executes extensions and manages their lifecycle.
 */
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import { type ImageContent, type Provider, type ProviderHeaders } from "@earendil-works/pi-ai";
import type { KeyId } from "@earendil-works/pi-tui";
import type { CacheWarmingAction } from "../cache-warmer.ts";
import type { ResourceDiagnostic } from "../diagnostics.ts";
import type { KeybindingsConfig } from "../keybindings.ts";
import type { ModelRegistry } from "../model-registry.ts";
import type { SessionManager } from "../session-manager.ts";
import { type BuildSystemPromptOptions, type NormalizedBuildSystemPromptOptions } from "../system-prompt.ts";
import type { VirtualModelDefinition } from "../virtual-models.ts";
import type { AgentBeforeSettleEvent, BeforeAgentStartCustomEvent, BeforeAgentStartEvent, BeforeAgentStartEventResult, BeforeAgentStartUserEvent, BeforeProviderHeadersEvent, BeforeProviderRequestEvent, BoundaryContextPreview, CacheWarmingDecisionEvent, ContextEvent, ContextWithSystemEvent, EntryRenderer, Extension, ExtensionActions, ExtensionCommandContext, ExtensionCommandContextActions, ExtensionContext, ExtensionContextActions, ExtensionError, ExtensionEvent, ExtensionFlag, ExtensionMode, ExtensionRuntime, ExtensionShortcut, ExtensionToolContext, ExtensionUIContext, InputEvent, InputEventResult, InputSource, LoadExtensionsResult, MarkdownTransformer, MessageEndEvent, MessageRenderer, ProjectTrustContext, ProjectTrustEvent, ProjectTrustEventResult, ProviderConfig, RegisteredTool, ReplacedSessionContext, ResolvedCommand, ResourcesDiscoverEvent, SessionBeforeCompactResult, SessionBeforeForkResult, SessionBeforeSwitchResult, SessionBeforeTreeResult, SessionBoundaryDraft, SessionShutdownEvent, ToolCallEvent, ToolCallEventResult, ToolRenderers, ToolResultEvent, ToolResultEventResult, TurnEndEvent, UserBashEvent, UserBashEventResult } from "./types.ts";
/** The message that starts a run: the before_agent_start event without its prompt fields. */
export type BeforeAgentStartTrigger = Pick<BeforeAgentStartUserEvent, "messageType" | "prompt" | "images"> | Pick<BeforeAgentStartCustomEvent, "messageType" | "message">;
/** Combined result from all before_agent_start handlers. */
interface BeforeAgentStartCombinedResult {
    messages: NonNullable<BeforeAgentStartEventResult["message"]>[];
    systemPromptOptions: NormalizedBuildSystemPromptOptions;
}
/**
 * Events handled by the generic emit() method.
 * Events with dedicated emitXxx() methods are excluded for stronger type safety.
 */
type RunnerEmitEvent = Exclude<ExtensionEvent, ToolCallEvent | ProjectTrustEvent | ToolResultEvent | UserBashEvent | ContextEvent | ContextWithSystemEvent | CacheWarmingDecisionEvent | BeforeProviderRequestEvent | BeforeProviderHeadersEvent | BeforeAgentStartEvent | MessageEndEvent | ResourcesDiscoverEvent | InputEvent | TurnEndEvent | AgentBeforeSettleEvent>;
type RunnerEmitResult<TEvent extends RunnerEmitEvent> = TEvent extends {
    type: "session_before_switch";
} ? SessionBeforeSwitchResult | undefined : TEvent extends {
    type: "session_before_fork";
} ? SessionBeforeForkResult | undefined : TEvent extends {
    type: "session_before_compact";
} ? SessionBeforeCompactResult | undefined : TEvent extends {
    type: "session_before_tree";
} ? SessionBeforeTreeResult | undefined : undefined;
export type ExtensionErrorListener = (error: ExtensionError) => void;
type BoundaryBaseEvent = Omit<TurnEndEvent, "entries" | "continue" | "context"> | Omit<AgentBeforeSettleEvent, "entries" | "continue" | "context">;
interface BoundaryDispatchResult {
    entries: SessionBoundaryDraft[];
    continue: boolean;
    context: BoundaryContextPreview;
    valid: boolean;
}
export type NewSessionHandler = (options?: {
    parentSession?: string;
    setup?: (sessionManager: SessionManager) => Promise<void>;
    withSession?: (ctx: ReplacedSessionContext) => Promise<void>;
}) => Promise<{
    cancelled: boolean;
}>;
export type ForkHandler = (entryId: string, options?: {
    position?: "before" | "at";
    withSession?: (ctx: ReplacedSessionContext) => Promise<void>;
}) => Promise<{
    cancelled: boolean;
}>;
export type NavigateTreeHandler = (targetId: string, options?: {
    summarize?: boolean;
    customInstructions?: string;
    replaceInstructions?: boolean;
    label?: string;
}) => Promise<{
    cancelled: boolean;
}>;
export type SwitchSessionHandler = (sessionPath: string, options?: {
    withSession?: (ctx: ReplacedSessionContext) => Promise<void>;
}) => Promise<{
    cancelled: boolean;
}>;
export type ReloadHandler = () => Promise<void>;
export type ShutdownHandler = () => void;
/**
 * Helper function to emit session_shutdown event to extensions.
 * Returns true if the event was emitted, false if there were no handlers.
 */
export declare function emitSessionShutdownEvent(extensionRunner: ExtensionRunner, event: SessionShutdownEvent): Promise<boolean>;
export declare function emitProjectTrustEvent(extensionsResult: LoadExtensionsResult, event: ProjectTrustEvent, ctx: ProjectTrustContext): Promise<{
    result?: ProjectTrustEventResult;
    errors: ExtensionError[];
}>;
export declare class ExtensionRunner {
    private extensions;
    private runtime;
    private uiContext;
    private mode;
    private cwd;
    private sessionManager;
    private modelRegistry;
    private errorListeners;
    private getModel;
    private getScopedModels;
    private isIdleFn;
    private isProjectTrustedFn;
    private getSignalFn;
    private waitForIdleFn;
    private abortFn;
    private hasPendingMessagesFn;
    private getContextUsageFn;
    private compactFn;
    private getSystemPromptFn;
    private getSystemPromptOptionsFn;
    private executeToolFn;
    private getCallableToolsFn;
    /** Registered MCP servers already reported as unhandled. */
    private readonly reportedMcpServers;
    private newSessionHandler;
    private forkHandler;
    private navigateTreeHandler;
    private switchSessionHandler;
    private reloadHandler;
    private shutdownHandler;
    private shortcutDiagnostics;
    private commandDiagnostics;
    private staleMessage;
    private uiPromptDepth;
    private activeUIPrompt;
    constructor(extensions: Extension[], runtime: ExtensionRuntime, cwd: string, sessionManager: SessionManager, modelRegistry: ModelRegistry);
    bindCore(actions: ExtensionActions, contextActions: ExtensionContextActions, providerActions?: {
        registerProvider?: (name: string, config: ProviderConfig) => void;
        registerNativeProvider?: (provider: Provider) => void;
        unregisterProvider?: (name: string) => void;
        registerVirtualModel?: (definition: VirtualModelDefinition) => void;
        unregisterVirtualModel?: (provider: string, id: string) => void;
    }): void;
    bindCommandContext(actions?: ExtensionCommandContextActions): void;
    setUIContext(uiContext?: ExtensionUIContext, mode?: ExtensionMode): void;
    private wrapUIPromptContext;
    private withUIPrompt;
    private emitUIPromptEvent;
    getUIContext(): ExtensionUIContext;
    hasUI(): boolean;
    getExtensionPaths(): string[];
    /** Get all registered tools from all extensions (first registration per name wins). */
    getAllRegisteredTools(): RegisteredTool[];
    /** Get a tool definition by name. Returns undefined if not found. */
    getToolDefinition(toolName: string): RegisteredTool["definition"] | undefined;
    getFlags(): Map<string, ExtensionFlag>;
    setFlagValue(name: string, value: boolean | string): void;
    getFlagValues(): Map<string, boolean | string>;
    getShortcuts(resolvedKeybindings: KeybindingsConfig): Map<KeyId, ExtensionShortcut>;
    getShortcutDiagnostics(): ResourceDiagnostic[];
    invalidate(message?: string): void;
    private assertActive;
    onError(listener: ExtensionErrorListener): () => void;
    emitError(error: ExtensionError): void;
    /**
     * Report registered MCP servers when no extension handles `mcp_servers_change`, which means
     * nothing connects them (for example when another MCP extension replaced the built-in one).
     */
    reportUnhandledMcpServers(): void;
    hasHandlers(eventType: string): boolean;
    getMessageRenderer(customType: string): MessageRenderer | undefined;
    getMarkdownTransformers(): MarkdownTransformer[];
    /** Renderers of calls to `toolName`: extension resolvers in load order, then `base`. */
    resolveToolRenderers(toolName: string, base: () => ToolRenderers | undefined): ToolRenderers | undefined;
    getEntryRenderer(customType: string): EntryRenderer | undefined;
    private resolveRegisteredCommands;
    getModelRegistry(): ModelRegistry;
    getRegisteredCommands(): ResolvedCommand[];
    getCommandDiagnostics(): ResourceDiagnostic[];
    getCommand(name: string): ResolvedCommand | undefined;
    /**
     * Request a graceful shutdown. Called by extension tools and event handlers.
     * The actual shutdown behavior is provided by the mode via bindExtensions().
     */
    shutdown(): void;
    getActiveTools(): string[];
    /**
     * Create an ExtensionContext for use in event handlers and tool execution.
     * Context values are resolved at call time, so changes via bindCore/bindUI are reflected.
     */
    createContext(): ExtensionContext;
    /**
     * Create the context for executing the tool call `toolCallId`: the extension context plus
     * `tools` and `executeTool()`. `signal` is the default signal of nested calls.
     */
    createToolContext(toolCallId: string, signal: AbortSignal | undefined): ExtensionToolContext;
    createCommandContext(): ExtensionCommandContext;
    emitBoundary(baseEvent: BoundaryBaseEvent, buildContext: (entries: SessionBoundaryDraft[]) => BoundaryContextPreview | Promise<BoundaryContextPreview>): Promise<BoundaryDispatchResult>;
    private isSessionBeforeEvent;
    emit<TEvent extends RunnerEmitEvent>(event: TEvent): Promise<RunnerEmitResult<TEvent>>;
    /** Returns the event's own action unless a handler overrides it; the last override wins. */
    emitCacheWarmingDecision(event: CacheWarmingDecisionEvent): Promise<CacheWarmingAction>;
    emitMessageEnd(event: MessageEndEvent): Promise<AgentMessage | undefined>;
    emitToolResult(event: ToolResultEvent): Promise<ToolResultEventResult | undefined>;
    emitToolCall(event: ToolCallEvent): Promise<ToolCallEventResult | undefined>;
    emitUserBash(event: UserBashEvent): Promise<UserBashEventResult | undefined>;
    /**
     * Run the request-time transforms in two phases. `context` handlers see the conversation
     * only and Pi restores the prompt and tool state after each; `context_with_system`
     * handlers then see the full transcript and their output is used as returned.
     */
    emitContext(messages: AgentMessage[]): Promise<AgentMessage[]>;
    emitBeforeProviderRequest(payload: unknown): Promise<unknown>;
    emitBeforeProviderHeaders(headers: ProviderHeaders): Promise<ProviderHeaders>;
    emitBeforeAgentStart(trigger: BeforeAgentStartTrigger, systemPromptOptions: BuildSystemPromptOptions): Promise<BeforeAgentStartCombinedResult>;
    emitResourcesDiscover(cwd: string, reason: ResourcesDiscoverEvent["reason"]): Promise<{
        skillPaths: Array<{
            path: string;
            extensionPath: string;
        }>;
        promptPaths: Array<{
            path: string;
            extensionPath: string;
        }>;
        themePaths: Array<{
            path: string;
            extensionPath: string;
        }>;
    }>;
    /** Emit input event. Transforms chain, "handled" short-circuits. */
    emitInput(text: string, images: ImageContent[] | undefined, source: InputSource, streamingBehavior?: "steer" | "followUp"): Promise<InputEventResult>;
}
export {};
//# sourceMappingURL=runner.d.ts.map