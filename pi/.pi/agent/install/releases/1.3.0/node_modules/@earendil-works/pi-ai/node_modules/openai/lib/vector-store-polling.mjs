import { pollWithResponse } from "./polling.mjs";
/**
 * Polls an attached file through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
export function pollVectorStoreFile(resource, vectorStoreID, fileID, options) {
    return pollWithResponse((headers) => resource.retrieve(fileID, { vector_store_id: vectorStoreID }, { ...options, headers }), ['in_progress'], ['failed', 'cancelled', 'completed'], options);
}
/**
 * Polls a file batch through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
export function pollVectorStoreFileBatch(resource, vectorStoreID, batchID, options) {
    return pollWithResponse((headers) => resource.retrieve(batchID, { vector_store_id: vectorStoreID }, { ...options, headers }), ['in_progress'], ['failed', 'cancelled', 'completed'], options);
}
//# sourceMappingURL=vector-store-polling.mjs.map