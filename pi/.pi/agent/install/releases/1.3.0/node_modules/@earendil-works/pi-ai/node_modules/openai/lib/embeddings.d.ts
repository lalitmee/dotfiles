import type { OpenAI } from "../client.js";
import type { APIPromise } from "../core/api-promise.js";
import type { RequestOptions } from "../internal/request-options.js";
import type { CreateEmbeddingResponse, Embedding, EmbeddingCreateParams } from "../resources/embeddings.js";
type Base64EmbeddingResponse = Omit<CreateEmbeddingResponse, 'data'> & {
    data: (Omit<Embedding, 'embedding'> & {
        embedding: string;
    })[];
};
/**
 * Sends the optimized embeddings request while preserving explicit encodings and
 * the original APIPromise response accessors.
 *
 * @internal
 */
export declare function createEmbedding(client: OpenAI, body: EmbeddingCreateParams, options?: RequestOptions): APIPromise<CreateEmbeddingResponse | Base64EmbeddingResponse>;
export {};
//# sourceMappingURL=embeddings.d.ts.map