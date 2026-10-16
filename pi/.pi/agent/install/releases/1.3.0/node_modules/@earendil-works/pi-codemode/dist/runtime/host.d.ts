import type { CodemodeSandboxOptions } from "../types.ts";
import { CodemodeSandboxBase } from "./execution.ts";
/**
 * Runs JavaScript in a QuickJS VM (a separate wasm instance) inside a worker thread. The worker
 * keeps script execution off the host thread: QuickJS runs synchronously, so a spinning script on
 * the host thread would block its event loop. Requires `node:worker_threads` (Node or Bun); see
 * `InlineCodemodeSandbox` and `RemoteCodemodeSandbox` in `@earendil-works/pi-codemode/portable`
 * for other runtimes.
 */
export declare class CodemodeSandbox extends CodemodeSandboxBase {
    constructor(options?: CodemodeSandboxOptions);
}
//# sourceMappingURL=host.d.ts.map