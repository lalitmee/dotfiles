/**
 * Model resolution, scoping, and initial selection
 */
import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import { type Api, type AuthOperationOptions, type KnownProvider, type Model } from "@earendil-works/pi-ai";
import type { ModelRuntime } from "./model-runtime.ts";
/** Default chat model IDs for providers with built-in chat models. */
export declare const defaultModelPerProvider: Partial<Record<KnownProvider, string>>;
export interface ScopedModel {
    model: Model<Api>;
    /** Thinking level if explicitly specified in pattern (e.g., "model:high"), undefined otherwise */
    thinkingLevel?: ThinkingLevel;
}
export interface ModelReferenceRequest {
    /** Bare model id or `provider/id`, optionally followed by `:<thinking>`. */
    text: string;
    /** Only consider models from this provider. */
    provider?: string;
    /**
     * A trailing `:<suffix>` is only considered when the full text matches no model, since ids such as
     * OpenRouter's `qwen/qwen3-coder:exacto` contain colons.
     * - `none`: the suffix stays part of the id
     * - `strict`: a valid thinking level is parsed; any other suffix stays part of the id
     * - `lenient`: like `strict`, but an invalid suffix is dropped with a warning
     */
    thinkingSuffix: "none" | "strict" | "lenient";
    /** Match id and name substrings when no exact match exists. */
    fuzzy: boolean;
}
export type ModelReferenceResult = {
    status: "resolved";
    model: Model<Api>;
    thinkingLevel?: ThinkingLevel;
    warning?: string;
} | {
    status: "ambiguous";
    candidates: Model<Api>[];
    usableCount: number;
    thinkingLevel?: ThinkingLevel;
    warning?: string;
} | {
    status: "not-found";
    /** Set when a provider is explicit or named by a `provider/` prefix, for building a custom model id. */
    target?: ModelReferenceTarget;
};
export interface ModelReferenceTarget {
    provider: string;
    providerModels: [Model<Api>, ...Model<Api>[]];
    /** Text after the provider prefix as typed, including any `:<suffix>`. */
    modelText: string;
    /** `modelText` without a valid thinking suffix (unless `thinkingSuffix` is `none`). */
    modelId: string;
    thinkingLevel?: ThinkingLevel;
}
/**
 * `usable` only breaks ties between providers, so a unique match resolves even without credentials
 * (`--api-key` first-time setup).
 */
export declare function resolveModelReference(request: ModelReferenceRequest, models: readonly Model<Api>[], usable: (provider: string) => boolean): ModelReferenceResult;
/** Exact `provider/id` or bare id lookup without thinking suffixes or fuzzy matching. */
export declare function findExactModelReferenceMatch(modelReference: string, models: readonly Model<Api>[]): Model<Api> | undefined;
export interface ModelScopeDiagnostic {
    type: "warning";
    code: "no-match" | "invalid-thinking-level" | "ambiguous";
    message: string;
    pattern: string;
}
export interface ResolveModelScopeResult {
    scopedModels: ScopedModel[];
    diagnostics: ModelScopeDiagnostic[];
}
/**
 * Resolve scope patterns (`--models`, `enabledModels`) to models with optional thinking levels.
 *
 * Every model in `models` is usable, so credentials cannot choose between providers offering the same
 * id. All of them are added, with a warning so the user can pick one with `provider/id`.
 */
export declare function resolveModelScopeFromModels(patterns: string[], models: readonly Model<Api>[]): ResolveModelScopeResult;
export declare function resolveModelScopeWithDiagnostics(patterns: string[], modelRuntime: ModelRuntime, options?: AuthOperationOptions): Promise<ResolveModelScopeResult>;
export declare function resolveModelScope(patterns: string[], modelRuntime: ModelRuntime, options?: AuthOperationOptions): Promise<ScopedModel[]>;
export interface ResolveCliModelResult {
    model: Model<Api> | undefined;
    thinkingLevel?: ThinkingLevel;
    warning: string | undefined;
    /**
     * Error message suitable for CLI display.
     * When set, model will be undefined.
     */
    error: string | undefined;
}
/**
 * Resolve a single model from CLI flags.
 *
 * Supports:
 * - --provider <provider> --model <pattern>
 * - --model <provider>/<pattern>
 * - Fuzzy matching (same rules as model scoping: exact id, then partial id/name)
 *
 * Note: This does not apply the thinking level by itself, but it may *parse* and
 * return a thinking level from "<pattern>:<thinking>" so the caller can apply it.
 */
export declare function resolveCliModel(options: {
    cliProvider?: string;
    cliModel?: string;
    cliThinking?: ThinkingLevel;
    /** `--api-key` was supplied for the selected provider. */
    inlineApiKey?: boolean;
    modelRuntime: ModelRuntime;
}): ResolveCliModelResult;
export interface InitialModelResult {
    model: Model<Api> | undefined;
    thinkingLevel: ThinkingLevel;
    fallbackMessage: string | undefined;
}
/**
 * Find the initial model to use based on priority:
 * 1. First model from scoped models (if not continuing/resuming)
 * 2. Saved default from settings
 * 3. First available model with valid API key
 */
export declare function findInitialModel(options: {
    scopedModels: ScopedModel[];
    isContinuing: boolean;
    defaultProvider?: string;
    defaultModelId?: string;
    defaultThinkingLevel?: ThinkingLevel;
    modelThinkingLevels?: Record<string, ThinkingLevel>;
    modelRuntime: ModelRuntime;
}): Promise<InitialModelResult>;
/**
 * Restore model from session, with fallback to available models
 */
export declare function restoreModelFromSession(savedProvider: string, savedModelId: string, currentModel: Model<Api> | undefined, shouldPrintMessages: boolean, modelRuntime: ModelRuntime): Promise<{
    model: Model<Api> | undefined;
    fallbackMessage: string | undefined;
}>;
//# sourceMappingURL=model-resolver.d.ts.map