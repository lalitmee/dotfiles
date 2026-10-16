import type { RequestOptions } from "../internal/request-options.js";
import type { FileBatches, VectorStoreFileBatch } from "../resources/vector-stores/file-batches.js";
import type { Files, VectorStoreFile } from "../resources/vector-stores/files.js";
type PollOptions = RequestOptions & {
    pollIntervalMs?: number;
};
/**
 * Polls an attached file through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
export declare function pollVectorStoreFile(resource: Pick<Files, 'retrieve'>, vectorStoreID: string, fileID: string, options?: PollOptions): Promise<VectorStoreFile>;
/**
 * Polls a file batch through the resource's retrieve method until it completes,
 * fails, or is cancelled. Retrieval errors are propagated unchanged.
 *
 * @internal
 */
export declare function pollVectorStoreFileBatch(resource: Pick<FileBatches, 'retrieve'>, vectorStoreID: string, batchID: string, options?: PollOptions): Promise<VectorStoreFileBatch>;
export {};
//# sourceMappingURL=vector-store-polling.d.ts.map