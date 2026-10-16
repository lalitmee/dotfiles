/**
 * Runs the VM on the calling thread, for runtimes without worker threads (Cloudflare Workers and
 * Durable Objects, browsers) and for the server side of `RemoteCodemodeSandbox`.
 *
 * Problem: QuickJS runs synchronously. While a script computes, the host's event loop does not
 * run, so neither the deadline timer nor an abort signal can fire. On Workers even `Date.now()` is
 * frozen during synchronous execution, so the VM cannot check a clock either. Example: with a
 * worker thread, `while (true) {}` is stopped by the host's 200 ms timer; on the calling thread
 * that timer never gets a chance to run.
 *
 * Solution: an interrupt budget. QuickJS polls its interrupt handler periodically while a script
 * runs; this launcher counts the polls across the whole execution and interrupts the script once
 * the count passes the budget. The execution then fails with `kind: "timeout"`. The deadline and
 * abort signal still work whenever the script waits on a tool, since the event loop runs then.
 *
 * The rate of polls depends on the code and the machine. Measured with a tight loop: about 50,000
 * per second of CPU on an Apple M-series laptop and about 10,000 per second on Cloudflare Durable
 * Objects (October 2026). The default of 100,000 allows roughly 2 to 10 seconds of uninterrupted
 * computation; keep it well below the platform's own CPU limit, because hitting that limit resets
 * a Durable Object instead of failing one script.
 *
 * Once the VM reports `done` or `crash`, the result is decided, so the VM is interrupted at the
 * next poll instead of running on until the host stops it. Example: a script that keeps printing in
 * a `for (;;)` loop after its output limit was reached would otherwise run until the budget ran out
 * and be reported as a timeout.
 *
 * Stack: the VM runs on the caller's stack, which is smaller than a worker thread's (about 1 MB
 * on Node's main thread), so QuickJS's stack guard is set to {@link INLINE_MAX_STACK_SIZE}.
 *
 * Reentrancy: VM callbacks run inside QuickJS. Messages from the VM are delivered to the host in
 * a microtask, after the VM has returned, so host code (tool calls, `finish()`, disposal) never
 * runs inside a VM callback and never re-enters the VM.
 */
import type { CodemodeSandboxBaseOptions } from "../types.ts";
import type { CodemodeWasmModule } from "../wasm.ts";
import { CodemodeSandboxBase, type VmLauncher } from "./execution.ts";
export declare const DEFAULT_INTERRUPT_BUDGET = 100000;
/** Allows recursion about 1,000 calls deep and trips well before a 1 MB host stack overflows. */
export declare const INLINE_MAX_STACK_SIZE: number;
export interface InlineCodemodeSandboxOptions extends CodemodeSandboxBaseOptions {
    /**
     * Compiled `quickjs-wasi/quickjs.wasm`. On Cloudflare, import it with Wrangler's `CompiledWasm`
     * rule (`@earendil-works/pi-codemode/cloudflare` does this); on Node, `loadQuickJSWasm()`.
     */
    wasm: CodemodeWasmModule | Promise<CodemodeWasmModule>;
    /**
     * Interrupt polls an execution may use before it fails with `kind: "timeout"`. The only limit on
     * a script that computes without awaiting a tool. Default: {@link DEFAULT_INTERRUPT_BUDGET}.
     */
    interruptBudget?: number;
}
export declare function inlineLauncher(wasm: CodemodeWasmModule | Promise<CodemodeWasmModule>, interruptBudget?: number): VmLauncher;
/**
 * Runs each execution's QuickJS VM on the calling thread. Works in any runtime with WebAssembly
 * and microtasks; needs no worker threads, files, or Node built-ins. A script that computes
 * blocks the caller's thread until it awaits a tool or uses up its interrupt budget, so prefer
 * `CodemodeSandbox` where worker threads exist, and `RemoteCodemodeSandbox` to keep scripts off a
 * thread that must stay responsive (such as a Durable Object that serves a session).
 */
export declare class InlineCodemodeSandbox extends CodemodeSandboxBase {
    constructor(options: InlineCodemodeSandboxOptions);
}
//# sourceMappingURL=inline.d.ts.map