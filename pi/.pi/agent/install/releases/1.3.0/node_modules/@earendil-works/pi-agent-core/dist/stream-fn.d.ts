import type { StreamFn } from "./types.ts";
/**
 * Configure the fallback used by Agent and low-level loops when callers omit streamFn.
 *
 * Hosts that provide a default model runtime can install its stream function here
 * without making pi-agent-core depend on a provider catalog or compatibility layer.
 */
export declare function setDefaultStreamFn(streamFn: StreamFn | undefined): void;
export declare function getDefaultStreamFn(): StreamFn;
//# sourceMappingURL=stream-fn.d.ts.map