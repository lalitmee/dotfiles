"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.pollVectorStoreFile = pollVectorStoreFile;
exports.pollVectorStoreFileBatch = pollVectorStoreFileBatch;
const polling_1 = require("./polling.js");
/**
 * Polls an attached file through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
function pollVectorStoreFile(resource, vectorStoreID, fileID, options) {
    return (0, polling_1.pollWithResponse)((headers) => resource.retrieve(fileID, { vector_store_id: vectorStoreID }, { ...options, headers }), ['in_progress'], ['failed', 'cancelled', 'completed'], options);
}
/**
 * Polls a file batch through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
function pollVectorStoreFileBatch(resource, vectorStoreID, batchID, options) {
    return (0, polling_1.pollWithResponse)((headers) => resource.retrieve(batchID, { vector_store_id: vectorStoreID }, { ...options, headers }), ['in_progress'], ['failed', 'cancelled', 'completed'], options);
}
//# sourceMappingURL=vector-store-polling.js.map