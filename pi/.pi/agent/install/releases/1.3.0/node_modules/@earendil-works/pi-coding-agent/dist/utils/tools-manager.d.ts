export declare function getToolPath(tool: "fd" | "rg"): string | null;
export declare function getLatestVersion(repo: string): Promise<string>;
export interface ToolStatus {
    type: "info" | "warning";
    message: string;
}
/**
 * Ensure a tool is available, downloading if necessary.
 * Reports progress through `onStatus`; status messages are otherwise silent.
 * Returns the tool path, or undefined if unavailable.
 */
export declare function ensureTool(tool: "fd" | "rg", onStatus?: (status: ToolStatus) => void): Promise<string | undefined>;
//# sourceMappingURL=tools-manager.d.ts.map