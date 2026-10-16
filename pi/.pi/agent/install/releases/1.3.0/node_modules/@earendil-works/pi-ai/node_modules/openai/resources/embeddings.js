"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Embeddings = void 0;
const resource_1 = require("../core/resource.js");
const embeddings_1 = require("../lib/embeddings.js");
/**
 * Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
 */
class Embeddings extends resource_1.APIResource {
    create(body, options) {
        return (0, embeddings_1.createEmbedding)(this._client, body, options);
    }
}
exports.Embeddings = Embeddings;
//# sourceMappingURL=embeddings.js.map