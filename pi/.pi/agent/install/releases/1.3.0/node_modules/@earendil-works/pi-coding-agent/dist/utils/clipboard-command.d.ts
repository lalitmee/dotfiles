/** Undefined means the command failed; an empty buffer is a successful result. */
export declare function runClipboardCommand(command: string, args: readonly string[], options?: {
    input?: string;
    timeoutMs?: number;
    maxBufferBytes?: number;
}): Promise<Buffer | undefined>;
//# sourceMappingURL=clipboard-command.d.ts.map