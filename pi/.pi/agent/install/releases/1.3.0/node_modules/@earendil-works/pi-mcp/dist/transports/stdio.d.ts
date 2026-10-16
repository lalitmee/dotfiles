import { type JsonRpcMessage } from "../protocol/jsonrpc.ts";
import { type McpTransport, TransportEvents } from "./transport.ts";
export interface StdioTransportOptions {
    command: string;
    args?: readonly string[];
    cwd?: string;
    env?: Record<string, string>;
    inheritEnv?: boolean;
    stderr?: "pipe" | "inherit";
    onStderr?: (chunk: string) => void;
    maxMessageBytes?: number;
    maxStderrBytes?: number;
    /** Time to wait for the server to exit after SIGTERM before sending SIGKILL. Default: 2000. */
    closeTimeoutMs?: number;
}
export declare class StdioTransport extends TransportEvents implements McpTransport {
    readonly options: Readonly<StdioTransportOptions>;
    private child;
    private stdoutBuffer;
    private stderrBuffer;
    private started;
    private closed;
    constructor(options: StdioTransportOptions);
    get pid(): number | undefined;
    get stderr(): string;
    start(): Promise<void>;
    send(message: JsonRpcMessage): Promise<void>;
    close(): Promise<void>;
    private handleStdout;
    private handleStderr;
}
//# sourceMappingURL=stdio.d.ts.map