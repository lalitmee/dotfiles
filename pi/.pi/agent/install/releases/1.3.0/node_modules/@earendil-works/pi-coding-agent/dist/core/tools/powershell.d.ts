import { type BashOperations, type BashSpawnContext, type BashSpawnHook, type BashToolDetails, type BashToolInput, type BashToolOptions, type createBashTool, createShellToolDefinition } from "./bash.ts";
export declare const powershellToolSystemPromptContribution: {
    readonly snippet: "Execute PowerShell commands";
    readonly guidelines: readonly ["You can inspect PI_* environment variables for current model and session details."];
};
export type PowerShellOperations = BashOperations;
export type PowerShellSpawnContext = BashSpawnContext;
export type PowerShellSpawnHook = BashSpawnHook;
export type PowerShellToolDetails = BashToolDetails;
export type PowerShellToolInput = BashToolInput;
export interface PowerShellToolOptions extends Pick<BashToolOptions, "operations" | "exposeSessionEnvironment" | "spawnHook"> {
}
export declare function createLocalPowerShellOperations(): PowerShellOperations;
export declare function createPowerShellToolDefinition(cwd: string, options?: PowerShellToolOptions): ReturnType<typeof createShellToolDefinition>;
export declare function createPowerShellTool(cwd: string, options?: PowerShellToolOptions): ReturnType<typeof createBashTool>;
//# sourceMappingURL=powershell.d.ts.map