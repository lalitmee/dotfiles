/**
 * Sandboxes that need no Node built-ins: `InlineCodemodeSandbox` runs the VM on the calling thread
 * and `RemoteCodemodeSandbox` runs it in another isolate. Neither imports `node:*` modules, so this
 * entry works in Cloudflare Workers, Durable Objects, and browsers. `CodemodeSandbox`, which uses
 * worker threads, stays in the main entry.
 */
export { toCodemodeIdentifier } from "./identifier.js";
export { CodemodeSandboxBase } from "./runtime/execution.js";
export { DEFAULT_INTERRUPT_BUDGET, InlineCodemodeSandbox, } from "./runtime/inline.js";
export { MAX_OUTPUT_CHARS, MAX_OUTPUT_ITEMS, MAX_STORE_TOTAL_CHARS, MAX_STORE_VALUE_CHARS, } from "./runtime/prelude-source.js";
export { RemoteCodemodeSandbox, serveCodemodeRemote, } from "./runtime/remote.js";
//# sourceMappingURL=portable.js.map