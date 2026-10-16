/**
 * Log messages MCP servers send with `notifications/message`, appended to `mcp.log` in the agent
 * directory. Several pi processes may write to the same file, so every message is one synchronous
 * append. The file is rotated to `mcp.log.1` once it grows past `MAX_LOG_BYTES`.
 */
/** Format one `notifications/message` from `server` as a log line; continuation lines are indented. */
export declare function formatMcpLogMessage(server: string, params: unknown, now?: Date): string;
/** Appends server log messages to one file. Write errors are ignored: logging must not break tools. */
export declare class McpServerLog {
    readonly path: string;
    private size;
    constructor(path: string);
    write(server: string, params: unknown): void;
    private currentSize;
}
//# sourceMappingURL=log.d.ts.map