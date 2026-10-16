import { multipartFormRequestOptions } from "./uploads.js";
import type { RequestOptions } from "./request-options.js";
/** Encode explicitly typed fields as single, filename-less multipart parts. */
export declare function encodedMultipartFormRequestOptions(options: RequestOptions, client: Parameters<typeof multipartFormRequestOptions>[1], encodings: Record<string, {
    content_type: string;
    json: boolean;
}>, rawBodyField?: string | null): Promise<RequestOptions>;
//# sourceMappingURL=multipart-encoding.d.ts.map