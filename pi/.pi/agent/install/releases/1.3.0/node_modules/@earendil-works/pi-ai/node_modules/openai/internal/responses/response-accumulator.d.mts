import type { Response, ResponseStreamEvent } from "../../resources/responses/responses.mjs";
import type { ResponseAccumulatorContext } from "./canonical-output-text.mjs";
interface ResponseKeepAliveEvent {
    type: 'keepalive';
    sequence_number: number;
}
type ResponseAccumulatorEvent = ResponseStreamEvent | ResponseKeepAliveEvent;
export declare function createResponseContext(): ResponseAccumulatorContext;
export declare function accumulateResponseWithContext(event: ResponseAccumulatorEvent, snapshot: Response | undefined, context: ResponseAccumulatorContext, rejectInvalidShellTargets?: boolean, onSanitizedEvent?: (event: ResponseStreamEvent) => void): Response;
export {};
//# sourceMappingURL=response-accumulator.d.mts.map