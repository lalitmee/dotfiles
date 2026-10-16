/**
 * Runs the VM in another isolate, reached over an RPC boundary such as a Cloudflare Durable Object
 * stub, while tools keep running in the caller.
 *
 * Problem: a VM on the calling thread blocks that thread while the script computes. In a Durable
 * Object that serves an agent session, a CPU-heavy script would stall every other request to the
 * session (including the user's abort) for seconds. Measured on Cloudflare (October 2026), a
 * script that computed for 10 seconds delayed the session's other requests by 10 seconds when it
 * ran in the session object or in a Dynamic Worker, but by about 50 ms when it ran in a Durable
 * Object of a separately deployed Worker.
 *
 * Solution: the caller keeps the host role (`RemoteCodemodeSandbox`: tools, call records,
 * deadline, abort) and the remote side only runs the VM (`serveCodemodeRemote`, behind
 * `CodemodeSandboxDurableObject` in `@earendil-works/pi-codemode/cloudflare`).
 *
 * Protocol, one RPC call per execution:
 *
 *     client                                     remote
 *     remote.execute(request, exchange) ───────▶ starts the VM (in-thread, with interrupt budget)
 *                                      ◀─────── exchange([...outputs, call])   one call per tool call
 *     runs the tool, replies with result ──────▶ VM continues
 *                                      ◀─────── exchange([...outputs, done])   terminal, reply ignored
 *     execute() resolves ◀────────────────────── VM disposed
 *
 * `exchange` is a function the client passes in; over Workers RPC it becomes a stub that calls back
 * into the client. Output is buffered on the remote side and sent with the next call or the
 * terminal message, so a script that prints in a loop does not make one RPC per line. Each
 * `exchange` carries at most one call, so concurrent tool calls are concurrent RPCs. Calls on one
 * stub are delivered in order, which keeps output ordered before the call or result that follows.
 *
 * Termination: the client cannot interrupt a remote VM that is computing. When the client finishes
 * first (deadline, abort, `close()`), it answers every pending and later `exchange` with
 * `{ type: "stop" }`, and the remote stops the VM at that point. A script that computes without
 * calling a tool runs until its interrupt budget is used up. The remote reports that as a
 * `failure` message, which the client turns into the same `kind: "timeout"` error an in-thread
 * VM produces.
 *
 * Failure: if the RPC call rejects (the remote isolate crashed, hit its CPU limit, or was
 * redeployed) or returns without a terminal message, the execution fails with `kind: "sandbox"`.
 */
import type { CodemodeError, CodemodeSandboxBaseOptions } from "../types.ts";
import type { CodemodeWasmModule } from "../wasm.ts";
import { CodemodeSandboxBase } from "./execution.ts";
import { type HostToWorkerMessage, type VmStartData, type WorkerToHostMessage } from "./protocol.ts";
export interface CodemodeRemoteRequest {
    data: VmStartData;
    /** Requested interrupt budget. The remote may lower it, see {@link CodemodeServeOptions}. */
    interruptBudget?: number;
}
/** What the remote sends to the client: VM messages, or a failure outside the VM bridge. */
export type CodemodeRemoteMessage = WorkerToHostMessage | {
    type: "failure";
    error: CodemodeError;
};
/**
 * The client's answer to an exchange: the result of the call the exchange carried, `null` when it
 * carried no call, or `stop` once the client no longer wants the execution.
 */
export type CodemodeRemoteReply = HostToWorkerMessage | {
    type: "stop";
} | null;
export type CodemodeRemoteExchange = (messages: CodemodeRemoteMessage[]) => Promise<CodemodeRemoteReply>;
/**
 * The remote end, usually a Durable Object stub for `CodemodeSandboxDurableObject`. Anything with
 * this method works, for example an in-process object in tests.
 */
export interface CodemodeRemote {
    execute(request: CodemodeRemoteRequest, exchange: CodemodeRemoteExchange): Promise<void>;
}
export interface RemoteCodemodeSandboxOptions extends CodemodeSandboxBaseOptions {
    /**
     * Returns the remote that runs one execution, called once per `execute()`. For a Durable Object,
     * pick the instance here, for example `() => env.CODEMODE_SANDBOX.getByName(sessionId)`.
     */
    remote: () => CodemodeRemote;
    /** Interrupt budget requested from the remote. Default: the remote's default. */
    interruptBudget?: number;
}
export interface CodemodeServeOptions {
    wasm: CodemodeWasmModule | Promise<CodemodeWasmModule>;
    /** Upper bound for a request's interrupt budget, and the budget when a request names none. */
    maxInterruptBudget?: number;
    /** Upper bound for a request's VM memory, and the limit when a request names none. */
    maxMemoryLimitBytes?: number;
}
/**
 * Remote side of {@link RemoteCodemodeSandbox}: runs one execution's VM on this thread and
 * forwards everything it reports through `exchange`. Resolves once the VM has stopped and the
 * terminal message has been delivered, or the client asked to stop. Never rejects.
 */
export declare function serveCodemodeRemote(request: CodemodeRemoteRequest, exchange: CodemodeRemoteExchange, options: CodemodeServeOptions): Promise<void>;
/**
 * Runs each execution's VM on a remote, usually a Cloudflare Durable Object deployed with
 * `CodemodeSandboxDurableObject`, while tools run here. Same API and results as
 * `CodemodeSandbox`, so it can replace it. Differences: a script that computes without calling a
 * tool is limited by the remote's interrupt budget rather than `timeoutMs`, and after a deadline or
 * abort the remote VM keeps computing until it next calls a tool or uses up that budget.
 */
export declare class RemoteCodemodeSandbox extends CodemodeSandboxBase {
    constructor(options: RemoteCodemodeSandboxOptions);
}
//# sourceMappingURL=remote.d.ts.map