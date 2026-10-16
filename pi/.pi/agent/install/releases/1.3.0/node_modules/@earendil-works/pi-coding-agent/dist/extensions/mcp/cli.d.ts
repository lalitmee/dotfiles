/**
 * `pi mcp`: add, remove, and check MCP servers and sign in to them outside a session. Agents run it
 * through bash to configure servers, verify an `mcp.json` they wrote, and start an OAuth sign-in;
 * the user only approves access in the browser. Running sessions pick up new credentials on their
 * next turn.
 */
import { McpOAuthCredentialStore } from "./runtime.ts";
export interface McpCommandOptions {
    cwd: string;
    agentDir: string;
    /** Defaults to `mcp-auth.json` in the agent directory. */
    credentials?: McpOAuthCredentialStore;
    /** Defaults to the platform browser. */
    openUrl?: (url: string) => void;
    /** Defaults to console output. */
    log?: (line: string) => void;
    error?: (line: string) => void;
}
/** Run `pi mcp <args>` and return the exit code. */
export declare function runMcpCommand(args: string[], options: McpCommandOptions): Promise<number>;
//# sourceMappingURL=cli.d.ts.map