import type { OpenAI } from "../client.mjs";
import type { APIPromise } from "../core/api-promise.mjs";
import type { RequestOptions } from "../internal/request-options.mjs";
import type { CreateEmbeddingResponse, Embedding, EmbeddingCreateParams } from "../resources/embeddings.mjs";
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
//# sourceMappingURL=embeddings.d.mts.map