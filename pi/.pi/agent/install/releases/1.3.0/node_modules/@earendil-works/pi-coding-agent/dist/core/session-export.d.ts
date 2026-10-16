import { type SessionManager } from "./session-manager.ts";
type TrailingEntries = (parentId: string | null, timestamp: string) => readonly object[];
/** Serialize the current branch and optional export-only entries as JSONL. */
export declare function serializeSessionBranch(sessionManager: SessionManager, createTrailingEntries?: TrailingEntries): string;
/** Write the current session branch and optional export-only entries as JSONL. */
export declare function exportSessionToJsonl(sessionManager: SessionManager, outputPath?: string, createTrailingEntries?: TrailingEntries): string;
export {};
//# sourceMappingURL=session-export.d.ts.map