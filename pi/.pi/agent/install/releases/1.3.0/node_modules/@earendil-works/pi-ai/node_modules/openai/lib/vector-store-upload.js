"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadAndPollVectorStoreFileBatch = uploadAndPollVectorStoreFileBatch;
const Util_1 = require("./Util.js");
/**
 * Uploads files with a shared iterator, then creates and polls the batch. Every
 * worker settles before upload failures are propagated. Zero concurrency is
 * rejected before any upload or batch-creation request.
 *
 * @internal
 */
async function uploadAndPollVectorStoreFileBatch(resource, client, vectorStoreId, files, fileIds, options) {
    if (files === null || files === undefined || files.length === 0) {
        throw new Error("No `files` provided to process. If you've already uploaded files you should use `.createAndPoll()` instead");
    }
    const configuredConcurrency = options?.maxConcurrency ?? 5;
    const concurrencyLimit = Math.min(configuredConcurrency, files.length);
    if (concurrencyLimit === 0) {
        throw new RangeError('maxConcurrency must be greater than 0');
    }
    const fileIterator = files.values();
    const allFileIds = [...fileIds];
    // This code is based on this design. The libraries don't accommodate our environment limits.
    // https://stackoverflow.com/questions/40639432/what-is-the-best-way-to-limit-concurrency-when-using-es6s-promise-all
    async function processFiles(iterator) {
        for (const item of iterator) {
            // oxlint-disable-next-line no-await-in-loop -- Each worker uploads one file at a time.
            const fileObj = await client.files.create({ file: item, purpose: 'assistants' }, options);
            allFileIds.push(fileObj.id);
        }
    }
    // Assigning length preserves native validation of invalid concurrency values.
    const workers = [];
    workers.length = concurrencyLimit;
    for (let index = 0; index < workers.length; index += 1) {
        workers[index] = processFiles(fileIterator);
    }
    await (0, Util_1.allSettledWithThrow)(workers);
    return await resource.createAndPoll(vectorStoreId, { file_ids: allFileIds }, options);
}
//# sourceMappingURL=vector-store-upload.js.map