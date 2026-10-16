import type { APIPromise } from "../core/api-promise.js";
import type { NullableHeaders } from "../internal/headers.js";
import type { RequestOptions } from "../internal/request-options.js";
type PollOptions = RequestOptions & {
    pollIntervalMs?: number;
};
/**
 * Repeatedly retrieves a lifecycle resource using the existing polling-helper
 * headers. Intermediate states wait for the explicit interval (including zero),
 * the server interval, or five-second default; terminal states return the same parsed object.
 * The caller's signal interrupts intermediate waits, unknown states retry
 * immediately, and retrieval errors propagate unchanged.
 *
 * @internal
 */
export declare function pollWithResponse<T extends {
    status: string;
}>(retrieve: (headers: NullableHeaders) => APIPromise<T>, intermediateStatuses: readonly T['status'][], terminalStatuses: readonly T['status'][], options?: PollOptions): Promise<T>;
export {};
//# sourceMappingURL=polling.d.ts.map