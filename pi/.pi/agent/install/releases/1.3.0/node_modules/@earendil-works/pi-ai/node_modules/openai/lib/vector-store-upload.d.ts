import type { OpenAI } from "../client.js";
import type { RequestOptions } from "../internal/request-options.js";
import type { FileBatches, VectorStoreFileBatch } from "../resources/vector-stores/file-batches.js";
import type { Uploadable } from "../uploads.js";
type UploadOptions = RequestOptions & {
    pollIntervalMs?: number;
    maxConcurrency?: number;
};
/**
 * Uploads files with a shared iterator, then creates and polls the batch. Every
 * worker settles before upload failures are propagated. Zero concurrency is
 * rejected before any upload or batch-creation request.
 *
 * @internal
 */
export declare function uploadAndPollVectorStoreFileBatch(resource: Pick<FileBatches, 'createAndPoll'>, client: Pick<OpenAI, 'files'>, vectorStoreId: string, files: Uploadable[], fileIds: string[], options?: UploadOptions): Promise<VectorStoreFileBatch>;
export {};
//# sourceMappingURL=vector-store-upload.d.ts.map