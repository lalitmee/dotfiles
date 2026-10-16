/**
 * Tool discovery: a BM25 ranker over tool metadata, shared by `searchTools()` in codemode scripts and
 * the optional `tool_search` tool.
 *
 * `tool_search` searches tools that are not declared to
 * the model (`codemode` and `deferred` exposure) and loads the matches, so they are declared for the
 * next model call. Loading goes through the active tool set, so it is recorded in the transcript
 * like any other tool change and survives `/tree`, resume, and fork on that branch.
 */
import { type Static, Type } from "typebox";
import type { ExtensionAPI, ToolDefinition, ToolInfo, ToolNamespace } from "../../core/extensions/types.ts";
export declare const TOOL_SEARCH_TOOL_NAME = "tool_search";
export declare const DEFAULT_TOOL_SEARCH_LIMIT = 8;
/** A tool as the ranker sees it: its name and the text built by {@link createToolSearchDocument}. */
export interface ToolSearchDocument {
    name: string;
    text: string;
}
export interface ToolSearchMatch {
    name: string;
    score: number;
}
/** Ranks tools for a query. BM25 today; a hybrid ranker with embeddings can replace it. */
export interface ToolRanker {
    rank(query: string, documents: readonly ToolSearchDocument[], limit: number): ToolSearchMatch[];
}
/** Lowercase terms, split at camelCase boundaries and non-alphanumerics, without stop words. */
export declare function tokenize(text: string): string[];
/**
 * Search text of a tool: the name, the name with `_`
 * as spaces, the description, schema descriptions and property names, and the namespace with its
 * description and instructions.
 */
export declare function createToolSearchDocument(tool: Pick<ToolInfo, "name" | "description" | "parameters">, namespace?: ToolNamespace): ToolSearchDocument;
/** Okapi BM25 with the usual parameters. Ties keep document order. */
export declare class Bm25Ranker implements ToolRanker {
    private readonly k1;
    private readonly b;
    constructor(options?: {
        k1?: number;
        b?: number;
    });
    rank(query: string, documents: readonly ToolSearchDocument[], limit: number): ToolSearchMatch[];
}
export declare const toolSearchSchema: Type.TObject<{
    query: Type.TString;
    limit: Type.TOptional<Type.TNumber>;
}>;
export type ToolSearchInput = Static<typeof toolSearchSchema>;
export interface ToolSearchResultTool {
    name: string;
    description: string;
}
export interface ToolSearchToolDetails {
    /** Tools loaded by this call. */
    loaded: string[];
}
export interface ToolSearchToolOptions {
    /**
     * The session's tools. `tool_search` searches the tools that are not declared to the model and
     * activates the matches. Without it, the tool finds nothing. An `ExtensionAPI` fits.
     */
    tools?: Pick<ExtensionAPI, "getAllTools" | "getActiveTools" | "setActiveTools">;
}
/**
 * The `tool_search` description. It does not list the searchable tools or their namespaces, so it
 * stays the same while tools are registered, for example when MCP servers connect.
 */
export declare const TOOL_SEARCH_DESCRIPTION = "# Tool discovery\n\nSearches over deferred tool metadata with BM25 and exposes matching tools for the next model call.\n\nSome of the tools, such as tools of MCP servers, may not have been provided to you upfront, and you should use this tool (`tool_search`) to search for the required tools. For MCP tool discovery, always use `tool_search`.";
export declare function createToolSearchToolDefinition(options?: ToolSearchToolOptions): ToolDefinition<typeof toolSearchSchema, ToolSearchToolDetails>;
//# sourceMappingURL=tool.d.ts.map