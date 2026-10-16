/**
 * The `codemode` tool: the model writes JavaScript that calls other tools. Scripts use `tools`,
 * `ALL_TOOLS`, `text()`, `image()`, `exit()`, `store()`/`load()`, `console.*`, and `return <value>`,
 * may start with a `// @options:` line, and reach the model catalog, classifiers, and image models
 * through `models.*`. Results start with a "Script completed" or "Script failed" header.
 *
 * Scripts can call the agent loop's nested tools: active `direct` tools and every `codemode` or
 * `deferred` tool. Nested calls run through the agent loop's tool pipeline (`ctx.executeTool`), so
 * validation, `tool_call`/`tool_result` hooks, and permission checks apply exactly as for direct
 * calls. Only the script's output reaches the model; nested results do not.
 *
 * Nested results are handed to the script as follows:
 * - A tool that declares `outputSchema` resolves to its `structuredContent`, also for error
 *   results that carry one.
 * - Any other tool resolves to its text content as one string.
 * - A failed, blocked, or invalid call rejects with an Error carrying the tool's error text.
 *
 * A script that fails returns a normal error result that keeps its partial output, followed by
 * "Script error:" and the error. `store(key, value)` and `load(key)` keep JSON values across
 * calls; successful scripts append their writes to the session as `codemode-store` custom entries,
 * so each branch sees the values written on its own path.
 */
import type { AgentTool } from "@earendil-works/pi-agent-core";
import type { CodemodeTool } from "@earendil-works/pi-codemode";
import { type Static, Type } from "typebox";
import type { ToolDefinition, ToolNamespace } from "../../core/extensions/types.ts";
import type { ModelRegistry } from "../../core/model-registry.ts";
import type { CodemodeMode } from "../../core/settings-manager.ts";
export declare const CODEMODE_TOOL_NAME = "codemode";
/** Custom entry type holding one script's `store()` writes: {@link CodemodeStoreEntryData}. */
export declare const CODEMODE_STORE_ENTRY_TYPE = "codemode-store";
export interface CodemodeStoreEntryData {
    set: Record<string, unknown>;
    delete: string[];
}
/** The part of the model registry that scripts reach through `models`. */
export type CodemodeModelRuntime = Pick<ModelRegistry, "getModelsOfType" | "getAvailableOfType" | "getModelOfType" | "classify" | "generateImages">;
export interface CodemodeToolOptions {
    /** Namespace of a tool, for `searchTools()` ranking and its `namespace` filter. */
    getToolNamespace?: (toolName: string) => ToolNamespace | undefined;
    /** Prompt guidelines of every tool, by tool name, shown with declarations by `describeTool()` and `ALL_TOOLS`. */
    getToolGuidelines?: () => ReadonlyMap<string, readonly string[]>;
    /**
     * Expose the `models` namespace to scripts, backed by the session's model registry
     * (`ctx.modelRegistry`). Without it, `models` is not declared.
     */
    models?: boolean;
    /**
     * Persists `store()` writes as a session custom entry. Without it, writes last only for the
     * current script; `load()` still reads entries already on the branch.
     */
    appendEntry?: (customType: string, data: CodemodeStoreEntryData) => void;
    /** How the tool presents the loadout while active (the `codemode.mode` setting). Default: `on`. */
    getMode?: () => CodemodeMode;
    /** Token budget for tool declarations in the description. Default: {@link DEFAULT_CODEMODE_INLINE_BUDGET}. */
    getInlineBudget?: () => number | undefined;
}
export declare const codemodeSchema: Type.TObject<{
    code: Type.TString;
}>;
export type CodemodeToolInput = Static<typeof codemodeSchema>;
export type CodemodeNestedCallStatus = "running" | "ok" | "error" | "cancelled";
export interface CodemodeNestedCall {
    /** Tool call id of the nested call, `<codemode call id>/<n>`. */
    id: string;
    name: string;
    /** Compact JSON of the arguments, truncated for display. */
    args: string;
    status: CodemodeNestedCallStatus;
    durationMs?: number;
    /** Error text, truncated for display. */
    error?: string;
    /** Cost in USD of a `models.*` call that reported usage. */
    cost?: number;
}
export interface CodemodeToolDetails {
    calls: CodemodeNestedCall[];
    /** Temp file with the full text output, when the output was truncated. */
    fullOutputPath?: string;
}
export declare const codemodeToolSystemPromptContribution: {
    readonly snippet: "Run JavaScript that calls other tools";
    readonly guidelines: readonly ["Use codemode to batch independent tool calls (Promise.allSettled), chain them, or filter large output, instead of many separate calls."];
};
/** The reference for scripts: globals, tool results, `store()`, the `models` API, and limits. */
export declare const CODEMODE_DOCS_PATH: string;
/** Default for {@link CodemodeDescriptionOptions.inlineBudget}, in estimated tokens. */
export declare const DEFAULT_CODEMODE_INLINE_BUDGET: 3000;
/**
 * What a script sees of a tool: its description followed by its prompt guidelines, which the system
 * prompt only has for declared tools. Tools without an output schema resolve to their text output.
 */
export declare function toCodemodeDeclaration(tool: AgentTool<any>, guidelines?: readonly string[]): Omit<CodemodeTool, "execute">;
/** Tools a script may call: every given tool except the codemode tool itself. */
export declare function getCodemodeCallableTools(tools: readonly AgentTool<any>[]): AgentTool<any>[];
export interface CodemodeDescriptionOptions {
    /** Declare the `models` namespace; only for tools created with model access. */
    models?: boolean;
    /** Namespace of each tool, by tool name. Tools of one namespace are listed under one heading. */
    namespaces?: ReadonlyMap<string, ToolNamespace>;
    /** Tools that are callable but never listed with their declaration (`deferred` exposure). */
    deferred?: ReadonlySet<string>;
    /** Prompt guidelines of each tool, by tool name, listed after its description. */
    guidelines?: ReadonlyMap<string, readonly string[]>;
    /**
     * Estimated tokens (characters / 4) the tool sections may use. Tools that do not fit are left
     * out, like deferred tools. Unset lists every tool that is not deferred.
     */
    inlineBudget?: number;
}
/**
 * Model-facing description: the helper list, guidance for finding tools that are not listed, the
 * `models` API, and one section per listed tool, grouped by namespace. Deferred tools are never
 * listed and do not affect the description at all, so it stays the same while tools are registered
 * late (for example by MCP servers that connect). Tool sections are limited to `inlineBudget`.
 */
export declare function createCodemodeDescription(tools: readonly AgentTool<any>[], options?: CodemodeDescriptionOptions): string;
export declare function createCodemodeToolDefinition(options?: CodemodeToolOptions): ToolDefinition<typeof codemodeSchema, CodemodeToolDetails | undefined>;
/**
 * Create the codemode tool as an AgentTool. The description lists the given tools; the script can
 * call whatever tools the agent loop provides at execution time.
 */
export declare function createCodemodeTool(tools?: readonly AgentTool<any>[], options?: CodemodeToolOptions): AgentTool<typeof codemodeSchema>;
//# sourceMappingURL=tool.d.ts.map