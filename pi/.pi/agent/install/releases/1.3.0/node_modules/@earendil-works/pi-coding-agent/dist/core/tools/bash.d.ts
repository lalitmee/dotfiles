import type { AgentTool } from "@earendil-works/pi-agent-core";
import { type Static, Type } from "typebox";
import { type ShellConfig } from "../../utils/shell.ts";
import type { ToolDefinition } from "../extensions/types.ts";
import { type TruncationResult } from "./truncate.ts";
declare const bashSchema: Type.TObject<{
    command: Type.TString;
    timeout: Type.TOptional<Type.TNumber>;
}>;
export declare const bashToolSystemPromptContribution: {
    readonly snippet: "Execute bash commands (ls, grep, find, etc.)";
    readonly guidelines: readonly ["You can inspect PI_* environment variables for current model and session details."];
};
export type BashToolInput = Static<typeof bashSchema>;
/**
 * Result for programmatic callers such as codemode scripts. A non-zero exit code is an error result for the model, but scripts still resolve to this value.
 * `output` is not limited like the model-facing output: callers decide how much of it reaches the model.
 */
declare const bashOutputSchema: Type.TObject<{
    output: Type.TString;
    truncated: Type.TBoolean;
    full_output_path: Type.TOptional<Type.TString>;
    exit_code: Type.TNumber;
    wall_time_seconds: Type.TNumber;
}>;
export type BashToolOutput = Static<typeof bashOutputSchema>;
export interface BashToolDetails {
    truncation?: TruncationResult;
    fullOutputPath?: string;
}
/**
 * Pluggable operations for the bash tool.
 * Override these to delegate command execution to remote systems (for example SSH).
 */
export interface BashOperations {
    /**
     * Execute a command and stream output.
     * @param command The command to execute
     * @param cwd Working directory
     * @param options Execution options
     * @returns Promise resolving to the exit code. Report signal terminations as 128 + signal number;
     * a null exit code is treated as a failed command.
     */
    exec: (command: string, cwd: string, options: {
        onData: (data: Buffer) => void;
        signal?: AbortSignal;
        timeout?: number;
        env?: NodeJS.ProcessEnv;
    }) => Promise<{
        exitCode: number | null;
    }>;
}
/** Shared process execution used by the built-in shell tools. */
export declare function createLocalShellOperations(shellName: string, resolveShellConfig: () => ShellConfig): BashOperations;
/**
 * Create bash operations using pi's built-in local shell execution backend.
 *
 * This is useful for extensions that intercept user_bash and still want pi's
 * standard local shell behavior while wrapping or rewriting commands.
 */
export declare function createLocalBashOperations(options?: {
    shellPath?: string;
}): BashOperations;
export interface BashSpawnContext {
    command: string;
    cwd: string;
    env: NodeJS.ProcessEnv;
}
export type BashSpawnHook = (context: BashSpawnContext) => BashSpawnContext;
export interface BashToolOptions {
    /** Custom operations for command execution. Default: local shell */
    operations?: BashOperations;
    /** Command prefix prepended to every command (for example shell setup commands) */
    commandPrefix?: string;
    /** Optional explicit shell path from settings */
    shellPath?: string;
    /** Expose current Pi session metadata as PI_* environment variables. Default: true */
    exposeSessionEnvironment?: boolean;
    /** Hook to adjust command, cwd, or env before execution */
    spawnHook?: BashSpawnHook;
}
export type BashRenderState = {
    startedAt: number | undefined;
    endedAt: number | undefined;
    interval: NodeJS.Timeout | undefined;
};
export interface ShellToolConfig {
    name: string;
    label: string;
    shellName: string;
    prompt: string;
    promptSnippet: string;
    promptGuidelines?: readonly string[];
    tempFilePrefix: string;
}
export declare function createShellToolDefinition(cwd: string, config: ShellToolConfig, options?: BashToolOptions): ToolDefinition<typeof bashSchema, BashToolDetails | undefined, BashRenderState>;
export declare function createBashToolDefinition(cwd: string, options?: BashToolOptions): ToolDefinition<typeof bashSchema, BashToolDetails | undefined, BashRenderState>;
export declare function createBashTool(cwd: string, options?: BashToolOptions): AgentTool<typeof bashSchema>;
export {};
//# sourceMappingURL=bash.d.ts.map