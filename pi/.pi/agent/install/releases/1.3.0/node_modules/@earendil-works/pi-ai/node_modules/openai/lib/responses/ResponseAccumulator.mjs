import { accumulateResponseWithContext, createResponseContext, } from "../../internal/responses/response-accumulator.mjs";
/**
 * Applies a streaming event to a response snapshot.
 *
 * Always use the returned snapshot. Incremental events update the supplied snapshot
 * in place, while response lifecycle events return a detached replacement. Event
 * payloads are cloned, so retaining or replaying the raw events is safe.
 */
export function accumulateResponse(event, snapshot) {
    return accumulateResponseWithContext(event, snapshot, createResponseContext());
}
//# sourceMappingURL=ResponseAccumulator.mjs.map