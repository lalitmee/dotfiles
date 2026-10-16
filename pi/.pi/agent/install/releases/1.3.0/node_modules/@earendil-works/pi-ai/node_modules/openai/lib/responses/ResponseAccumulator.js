"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.accumulateResponse = accumulateResponse;
const response_accumulator_1 = require("../../internal/responses/response-accumulator.js");
/**
 * Applies a streaming event to a response snapshot.
 *
 * Always use the returned snapshot. Incremental events update the supplied snapshot
 * in place, while response lifecycle events return a detached replacement. Event
 * payloads are cloned, so retaining or replaying the raw events is safe.
 */
function accumulateResponse(event, snapshot) {
    return (0, response_accumulator_1.accumulateResponseWithContext)(event, snapshot, (0, response_accumulator_1.createResponseContext)());
}
//# sourceMappingURL=ResponseAccumulator.js.map