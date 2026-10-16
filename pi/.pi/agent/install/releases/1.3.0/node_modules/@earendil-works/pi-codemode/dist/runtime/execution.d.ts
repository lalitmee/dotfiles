import type { CodemodeError, CodemodeExecuteOptions, CodemodeResult, CodemodeRun, CodemodeRunOptions, CodemodeSandboxBaseOptions, CodemodeTool } from "../types.ts";
import { type HostToWorkerMessage, type VmStartData } from "./protocol.ts";
/** Callbacks a launcher uses to report what its VM does. */
export interface VmEvents {
    /** A message from the VM. Validated here, so launchers can pass through anything they receive. */
    message(message: unknown): void;
    /** The VM failed or stopped outside the bridge, for example a worker exit or a remote error. */
    failure(error: CodemodeError): void;
}
/** The host's handle on a running VM. */
export interface VmChannel {
    post(message: HostToWorkerMessage): void;
    /** Requests VM shutdown. Called once; may resolve before a worker or remote VM actually exits. */
    stop(): Promise<void>;
}
/**
 * Starts a VM for one execution. Rejections become `sandbox` errors with the rejection's message.
 * The VM may start reporting messages before the returned promise settles.
 */
export type VmLauncher = (data: VmStartData, events: VmEvents) => VmChannel | Promise<VmChannel>;
export declare function errorMessage(error: unknown): string;
/**
 * Tool table, defaults, and in-flight executions; the behavior every sandbox shares. Subclasses
 * only choose where the VM runs by passing a {@link VmLauncher}.
 *
 * The script sees `tools.<name>(args)` for every registered tool, `ALL_TOOLS`, the output helpers
 * `text`, `image`, `exit`, and `console.*`, `store`/`load`, and the configured globals; nothing
 * else (no timers, `fetch`, `process`, `require`, modules). Each `execute()` gets its own VM; the
 * sandbox only holds the tool table and defaults. `close()` aborts in-flight executions.
 */
export declare class CodemodeSandboxBase {
    private readonly toolsByName;
    private readonly globalsByName;
    private readonly timeoutMs;
    private readonly memoryLimitBytes;
    private readonly launch;
    private readonly running;
    private closed;
    constructor(options: CodemodeSandboxBaseOptions, launch: VmLauncher);
    /** Throws if a tool with the same name is already registered. */
    registerTool(tool: CodemodeTool): void;
    unregisterTool(name: string): boolean;
    get tools(): CodemodeTool[];
    get globals(): CodemodeTool[];
    /**
     * `code` is an async function body: `return` and top-level `await` work.
     * Never rejects for script failures; those come back as `{ ok: false }`.
     * The script can use `store(key, value)` and `load(key)` on `options.store`.
     */
    execute(code: string, options?: CodemodeExecuteOptions): Promise<CodemodeResult>;
    /**
     * Run `code` deterministically, with the caller answering its calls: the same script, start time, seed, tools,
     * globals, and store, answered with the same results in the same `seq` order, makes the same calls with the same
     * arguments and produces the same output, on any VM with the same fingerprint. A host can therefore replay it
     * after a restart. The VM runs in UTC, its clock reads `startedAt` and then the `now` of the result being
     * processed, its randomness comes from `seed`, and `WeakRef` and `FinalizationRegistry` do not exist.
     *
     * The sandbox's own tools and globals are not used: the run declares its own, and every call goes to
     * `options.onCall`. Never rejects for script failures; abort through `options.signal` to end the run with an
     * error the script cannot catch.
     */
    start(code: string, options: CodemodeRunOptions): CodemodeRun;
    /** Aborts in-flight executions (they resolve with `kind: "aborted"`) and rejects new ones. */
    close(): Promise<void>;
}
//# sourceMappingURL=execution.d.ts.map