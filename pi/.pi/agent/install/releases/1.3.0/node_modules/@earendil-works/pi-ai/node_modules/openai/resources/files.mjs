// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../core/resource.mjs";
import { CursorPage } from "../core/pagination.mjs";
import { buildHeaders } from "../internal/headers.mjs";
import { multipartFormRequestOptions } from "../internal/uploads.mjs";
import { waitForFileProcessing } from "../lib/file-processing.mjs";
import { path } from "../internal/utils/path.mjs";
/**
 * Files are used to upload documents that can be used with features like Assistants and Fine-tuning.
 */
export class Files extends APIResource {
    /**
     * Upload a file that can be used across various endpoints. Individual files can be
     * up to 512 MB, and each project can store up to 2.5 TB of files in total. There
     * is no organization-wide storage limit. Uploads to this endpoint are rate-limited
     * to 1,000 requests per minute per authenticated user.
     *
     * - The Assistants API supports files up to 2 million tokens and of specific file
     *   types. See the
     *   [Assistants Tools guide](https://developers.openai.com/api/docs/guides/tools)
     *   for details.
     * - The Fine-tuning API only supports `.jsonl` files. The input also has certain
     *   required formats for fine-tuning
     *   [chat](https://developers.openai.com/api/docs/guides/supervised-fine-tuning#formatting-your-data)
     *   or
     *   [completions](https://developers.openai.com/api/docs/guides/supervised-fine-tuning#formatting-your-data)
     *   models.
     * - The Batch API only supports `.jsonl` files up to 200 MB in size. The input
     *   also has a specific required
     *   [format](https://developers.openai.com/api/docs/guides/batch#1-prepare-your-batch-file).
     * - For Retrieval or `file_search` ingestion, upload files here first. If you need
     *   to attach multiple uploaded files to the same vector store, use
     *   [`/vector_stores/{vector_store_id}/file_batches`](https://developers.openai.com/api/reference/resources/vector_stores/subresources/file_batches/methods/create)
     *   instead of attaching them one by one. Vector store attachment has separate
     *   limits from file upload, including 2,000 attached files per minute per
     *   organization.
     *
     * Please [contact us](https://help.openai.com/) if you need to increase these
     * storage limits.
     */
    create(body, options) {
        return this._client.post('/files', multipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
    /**
     * Returns information about a specific file.
     */
    retrieve(fileID, options) {
        return this._client.get(path `/files/${fileID}`, { ...options, __security: { bearerAuth: true } });
    }
    /**
     * Returns a list of files.
     */
    list(query = {}, options) {
        return this._client.getAPIList('/files', (CursorPage), {
            query,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Delete a file and remove it from all vector stores.
     */
    delete(fileID, options) {
        return this._client.delete(path `/files/${fileID}`, { ...options, __security: { bearerAuth: true } });
    }
    /**
     * Returns a response containing the contents of the specified file.
     */
    content(fileID, options) {
        return this._client.get(path `/files/${fileID}/content`, {
            ...options,
            headers: buildHeaders([{ Accept: 'application/binary' }, options?.headers]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        });
    }
    /**
     * Waits for the given file to be processed, default timeout is 30 mins.
     */
    async waitForProcessing(id, { pollInterval = 5000, maxWait = 30 * 60 * 1000 } = {}) {
        return await waitForFileProcessing(this, id, pollInterval, maxWait);
    }
}
//# sourceMappingURL=files.mjs.map