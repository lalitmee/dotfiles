import type { PathMetadata } from "./package-manager.ts";
export type SourceScope = "user" | "project" | "temporary";
export type SourceOrigin = "package" | "top-level";
export interface SourceInfo {
    path: string;
    source: string;
    scope: SourceScope;
    origin: SourceOrigin;
    baseDir?: string;
}
/** Prefix of built-in tool and extension paths, such as `builtin:read` or `builtin:mcp`. */
export declare const BUILTIN_PATH_PREFIX = "builtin:";
/**
 * Source of a path that names no file: `builtin` for `builtin:<name>`, or the prefix of an
 * angle-bracket path such as `inline` for `<inline:name>`. Undefined for file paths.
 */
export declare function getSyntheticPathSource(path: string): string | undefined;
export declare function isSyntheticPath(path: string): boolean;
export declare function createSourceInfo(path: string, metadata: PathMetadata): SourceInfo;
export declare function createSyntheticSourceInfo(path: string, options: {
    source: string;
    scope?: SourceScope;
    origin?: SourceOrigin;
    baseDir?: string;
}): SourceInfo;
//# sourceMappingURL=source-info.d.ts.map