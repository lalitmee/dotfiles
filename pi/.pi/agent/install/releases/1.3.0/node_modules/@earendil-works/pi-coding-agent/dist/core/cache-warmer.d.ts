import { type Api, type Context, type Model, type ModelsSimpleStreamOptions, type SimpleStreamOptions } from "@earendil-works/pi-ai";
import type { ModelRuntime } from "./model-runtime.ts";
import type { SessionManager, UsageEntry } from "./session-manager.ts";
import type { CacheWarmingMode } from "./settings-manager.ts";
/** Refresh at 90% of the TTL while preserving at least ten seconds of margin. */
export declare function getCacheWarmingDelayMs(ttlMs: number): number | undefined;
/**
 * Lifetime of the prompt cache entry a request writes, from the model's
 * `promptCache` tier for the retention the request used. Undefined when the
 * model has no lifetime for that tier or caching is off.
 */
export declare function getPromptCacheTtlMs(model: Model<Api>, options: SimpleStreamOptions | undefined): number | undefined;
/**
 * Whether replaying the request with a one-token output cap leaves its cache
 * entry untouched. Anthropic's budget-based thinking (Claude models without
 * adaptive thinking) derives `budget_tokens` from `max_tokens`; the replay
 * would get a different budget, which Anthropic keys the message cache on,
 * and the model could still think for thousands of tokens.
 */
export declare function isReplayable(model: Model<Api>, options: SimpleStreamOptions | undefined): boolean;
export type CacheWarmingAction = "warm" | "stop";
/** Inputs and outcome of one warm-or-stop decision, as shown by `/session`. */
export interface CacheWarmingDecision {
    /** "streaming" while the agent run that sent the request is still active. */
    phase: "streaming" | "idle";
    /** Price of this refresh: a cache read of the prompt plus one output token. */
    warmCost: number;
    /** Extra price of the next real request if the cache entry is lost. */
    missCost: number;
    /** Estimated chance that a real request arrives before the entry expires. */
    continuationProbability: number;
    /** `continuationProbability * missCost - warmCost`. */
    expectedSavings: number;
    /** False when the prompt size or the model's prices are unknown. */
    economicsAvailable: boolean;
    /** Pi's decision: "warm" when `expectedSavings` is at least $0.05. */
    action: CacheWarmingAction;
}
/**
 * Fired before each refresh with pi's decision filled in. Everything else an
 * extension might want (model, idle state, context size) is on the context.
 */
export interface CacheWarmingDecisionEvent extends Pick<CacheWarmingDecision, "warmCost" | "missCost" | "continuationProbability" | "action"> {
    type: "cache_warming_decision";
}
export interface CacheWarmingDecisionEventResult {
    /** Override whether this refresh is sent. "stop" ends warming until the next real request. */
    action?: CacheWarmingAction;
}
export interface CacheWarmingStatus {
    /** "scheduled": a refresh timer is armed; "refreshing": a warm request is in flight. */
    state: "inactive" | "scheduled" | "refreshing";
    /** Why nothing is scheduled. */
    reason?: string;
    nextWarmAt?: number;
    /** The pending decision, or the decision that stopped warming. */
    decision?: CacheWarmingDecision;
    /** True when an extension changed `decision.action`. */
    extensionOverride?: boolean;
}
/** The request whose prompt cache entry should be kept warm, exactly as it was sent. */
export interface CacheWarmRequest {
    model: Model<Api>;
    context: Context;
    options: ModelsSimpleStreamOptions;
}
/**
 * Keeps one prompt cache entry alive by re-sending its request with a
 * one-token output cap before the entry expires. `start` replaces any
 * previous run; warm requests never extend the fixed safety windows.
 */
export declare class CacheWarmer {
    private run?;
    private inactive;
    private readonly models;
    private readonly sessionManager;
    private readonly getMode;
    /** Lets extensions override `event.action`; failures fall back to pi's decision. */
    private readonly decide;
    /** Called with the persisted usage entry after each successful refresh. */
    onWarmed?: (entry: UsageEntry) => void;
    constructor(models: Pick<ModelRuntime, "streamSimple">, sessionManager: Pick<SessionManager, "appendUsage" | "getBranch">, getMode: () => CacheWarmingMode, decide?: (event: CacheWarmingDecisionEvent) => Promise<CacheWarmingAction>);
    get status(): CacheWarmingStatus;
    /** Keep the prompt cache entry written by `request` warm while `isCurrent` holds. */
    start(request: CacheWarmRequest, isCurrent: () => boolean): void;
    onAgentSettled(): void;
    /** Reconcile an active run after the persisted warming mode changes. */
    onModeChanged(): void;
    cancel(): void;
    private clearRun;
    private stop;
    private schedule;
    private refresh;
    private refreshDeadlineMissed;
    private validateRun;
    private getModeStopReason;
    private evaluate;
}
/** One-line status for `/session`. */
export declare function formatCacheWarmingStatus(status: CacheWarmingStatus, now?: number): string;
/** One-line transcript text for persisted cache-warming usage. */
export declare function formatCacheWarmingUsage(entry: UsageEntry): string;
//# sourceMappingURL=cache-warmer.d.ts.map