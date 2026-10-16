// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../core/resource.mjs";
import { createEmbedding } from "../lib/embeddings.mjs";
/**
 * Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
 */
export class Embeddings extends APIResource {
    create(body, options) {
        return createEmbedding(this._client, body, options);
    }
}
//# sourceMappingURL=embeddings.mjs.map