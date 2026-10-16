/**
 * Virtual models are catalog entries that route each request to a physical model.
 *
 * The selection (`model_change`, `agent.state.model`, `ctx.model`) may name a virtual model.
 * Everything below the routing step only sees physical models: providers stream them and
 * assistant messages record them. A virtual model never reaches a provider.
 *
 * Virtual models belong to a provider id but are not provider models. `ModelRuntime` keeps them
 * separately and adds them to the provider's catalog with `withVirtualModels()`, so any provider,
 * including one with physical models, can list several virtual models.
 */
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import { type Api, type AssistantMessage, type Message, type Model, type ModelThinkingLevel, type Provider } from "@earendil-works/pi-ai";
import type { SessionEntry } from "./session-manager.ts";
/** API id of virtual catalog entries. Requests for it fail unless routed first. */
export declare const VIRTUAL_MODEL_API = "pi-virtual";
/** Custom entry type that stores router state on the session branch. */
export declare const VIRTUAL_MODEL_STATE_ENTRY = "pi.virtual-model-state";
/** Data of a `pi.virtual-model-state` custom entry. */
export interface VirtualModelStateData<TState = unknown> {
    provider: string;
    modelId: string;
    state: TState;
}
/**
 * Why a request is being routed.
 * - `user`: first request after a message the user wrote (prompt, steering, or follow-up)
 * - `continuation`: any other request in the agent loop, e.g. after tool results or extension messages
 * - `retry`: automatic retry after a failed request, including after compaction for a context overflow
 * - `direct`: a request outside the agent loop, e.g. a compaction summary or an extension call
 */
export type ModelRouteReason = "user" | "continuation" | "retry" | "direct";
export interface ModelRouteRequest<TState = unknown> {
    /** The selected virtual model. */
    model: Model<Api>;
    /** The selected thinking level. Its meaning is up to the router. */
    thinkingLevel: ModelThinkingLevel;
    reason: ModelRouteReason;
    /** Physical model and thinking level of the latest successful response in `messages`. */
    previous?: {
        model: Model<Api>;
        thinkingLevel?: ModelThinkingLevel;
    };
    /**
     * For `retry`: the failed request, which `messages` no longer contains. `message` carries its
     * `stopReason` and `errorMessage`. Absent when the router itself failed.
     */
    failed?: {
        model: Model<Api>;
        thinkingLevel?: ModelThinkingLevel;
        message: AssistantMessage;
    };
    /** Router state last returned on this session branch. Undefined before the first state and for `direct` requests. */
    state?: TState;
    /** Conversation for this request, including system messages. */
    messages: readonly Message[];
    signal?: AbortSignal;
}
/** Physical model and thinking level for one request. */
export interface ModelRoute<TState = unknown> {
    model: Model<Api>;
    thinkingLevel: ModelThinkingLevel;
    /**
     * New router state, stored on the session branch unless it is `request.state` itself. Return
     * `request.state` or undefined to keep the current state. Must be JSON-serializable. Ignored for
     * `direct` requests.
     */
    state?: TState;
}
export interface VirtualModelDefinition<TState = unknown> {
    /** Provider the virtual model is listed under. May be a provider with physical models. */
    provider: string;
    /** Model id. Must not be the id of a physical model of `provider`. */
    id: string;
    name: string;
    /** Thinking levels offered for selection. Defaults to `["off"]`. */
    thinkingLevels?: readonly ModelThinkingLevel[];
    /**
     * Limits shown before the first response. Afterwards, Pi uses the limits of the physical model
     * that answered. Unset limits are unknown (0).
     */
    contextWindow?: number;
    maxTokens?: number;
    /** Input types accepted for selection. Defaults to text and images; routed models without image support get placeholders. */
    input?: ("text" | "image")[];
    /** Pick the physical model, which must have credentials, and thinking level for one request. */
    route(request: ModelRouteRequest<TState>): ModelRoute<TState> | Promise<ModelRoute<TState>>;
}
/** Whether a model or message names a virtual model. Failed routing leaves the virtual model on its message. */
export declare function isVirtualModel(model: {
    api: string;
}): boolean;
/** Latest successful response. Its model is physical: failed or aborted requests, including failed routing, are skipped. */
export declare function findLatestResponse(messages: readonly AgentMessage[]): AssistantMessage | undefined;
/**
 * The model selection a session branch records. A virtual `model_change` holds until the next
 * `model_change`, because responses name the physical models it routed to. Otherwise the latest
 * physical response wins, as in sessions without virtual models. A virtual model that is no longer
 * registered does not hold, so the selection falls back to the physical model that answered last.
 *
 * Only the last `model_change` can hold, so this looks up at most one model in the catalog.
 */
export declare function getBranchSelection(branch: readonly SessionEntry[], getModel: (provider: string, modelId: string) => Model<Api> | undefined): {
    provider: string;
    modelId: string;
} | undefined;
/** Latest router state a session branch stores for a virtual model. */
export declare function getVirtualModelState(branch: readonly SessionEntry[], provider: string, modelId: string): unknown;
/** Build the catalog entry of a virtual model. */
export declare function createVirtualModel(definition: Omit<VirtualModelDefinition, "route">): Model<Api>;
/**
 * Add virtual models to a provider's catalog. Without a provider, the result is a keyless provider
 * that only lists the virtual models. A virtual model hides a physical chat model with the same id,
 * which a catalog refresh can add after registration. Availability follows the provider's auth.
 */
export declare function withVirtualModels(providerId: string, provider: Provider | undefined, virtualModels: readonly Model<Api>[]): Provider;
//# sourceMappingURL=virtual-models.d.ts.map