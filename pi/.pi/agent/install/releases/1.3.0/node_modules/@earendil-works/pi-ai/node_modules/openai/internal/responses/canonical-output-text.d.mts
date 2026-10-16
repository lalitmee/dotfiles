import type { Response } from "../../resources/responses/responses.mjs";
import { OutputTextIndex } from "./output-text-index.mjs";
type ResponseOutput = Response['output'][number];
export interface ResponseAccumulatorContext {
    canonicalSnapshot: Response | undefined;
    outputTextLengths: WeakMap<ResponseOutput, number>;
    outputTextIndex: OutputTextIndex;
}
export declare function createCanonicalResponseContext(): ResponseAccumulatorContext;
export declare function getOutputText(context: ResponseAccumulatorContext, output: ResponseOutput): string;
export declare function ensureCanonicalOutputText(context: ResponseAccumulatorContext, snapshot: Response): void;
export declare function cloneResponse(context: ResponseAccumulatorContext, response: Response): Response;
export declare function updateCachedOutputTextLength(context: ResponseAccumulatorContext, output: ResponseOutput, outputIndex: number, previousText: string, nextText: string): void;
export declare function updateOutputText(context: ResponseAccumulatorContext, snapshot: Response, outputIndex: number, previousText: string, nextText: string, contentIndex?: number): void;
export {};
//# sourceMappingURL=canonical-output-text.d.mts.map