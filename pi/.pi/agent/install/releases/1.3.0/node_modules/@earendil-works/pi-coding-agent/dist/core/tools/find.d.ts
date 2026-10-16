import type { AgentTool } from "@earendil-works/pi-agent-core";
import path from "path";
import { type Static, Type } from "typebox";
import type { ToolDefinition } from "../extensions/types.ts";
import { type TruncationResult } from "./truncate.ts";
/** Relativize a find result against the search root and normalize it to posix separators. */
export declare function relativizeFindResultPath(resultPath: string, searchPath: string, pathModule?: path.PlatformPath): string;
declare const findSchema: Type.TObject<{
    pattern: Type.TString;
    path: Type.TOptional<Type.TString>;
    limit: Type.TOptional<Type.TNumber>;
}>;
export declare const findToolSystemPromptContribution: {
    readonly snippet: "Find files by glob pattern (respects .gitignore)";
    readonly guidelines: readonly [];
};
export type FindToolInput = Static<typeof findSchema>;
export interface FindToolDetails {
    truncation?: TruncationResult;
    resultLimitReached?: number;
}
/**
 * Pluggable operations for the find tool.
 * Override these to delegate file search to remote systems (for example SSH).
 */
export interface FindOperations {
    /** Check if path exists */
    exists: (absolutePath: string) => Promise<boolean> | boolean;
    /** Find files matching glob pattern. Returns relative or absolute paths. */
    glob: (pattern: string, cwd: string, options: {
        ignore: string[];
        limit: number;
    }) => Promise<string[]> | string[];
}
export interface FindToolOptions {
    /** Custom operations for find. Default: local filesystem plus fd */
    operations?: FindOperations;
}
export declare function createFindToolDefinition(cwd: string, options?: FindToolOptions): ToolDefinition<typeof findSchema, FindToolDetails | undefined>;
export declare function createFindTool(cwd: string, options?: FindToolOptions): AgentTool<typeof findSchema>;
export {};
//# sourceMappingURL=find.d.ts.map