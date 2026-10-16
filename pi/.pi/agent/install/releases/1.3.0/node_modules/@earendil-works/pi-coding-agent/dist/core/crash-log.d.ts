import type { Extension } from "./extensions/types.ts";
export interface CrashRecord {
    timestamp: string;
    version: string;
    kind: "uncaught_exception" | "fatal_error";
    message: string;
    stack: string | null;
    sessionFile: string | null;
    cwd: string;
    notified?: boolean;
}
export declare function readCrashLog(path?: string): CrashRecord[];
type ExtensionStackMetadata = Pick<Extension, "path" | "resolvedPath" | "sourceInfo">;
/** Find loaded extensions with source files in a stack trace. */
export declare function findExtensionStackMatches(stack: string | undefined, extensions: readonly ExtensionStackMetadata[]): string[];
/** Best-effort persistence for callers that are already crashing. */
export declare function recordCrash(crash: {
    kind: CrashRecord["kind"];
    error: unknown;
    sessionFile?: string;
    cwd: string;
}, path?: string): CrashRecord | undefined;
/** Return the newest recent crash, marking pending records as announced. */
export declare function takeUnnotifiedCrash(path?: string, now?: number): CrashRecord | undefined;
export declare function clearCrashLog(path?: string): void;
export {};
//# sourceMappingURL=crash-log.d.ts.map