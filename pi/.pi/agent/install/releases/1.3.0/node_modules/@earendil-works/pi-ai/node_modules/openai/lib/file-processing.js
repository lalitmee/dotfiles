"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.waitForFileProcessing = waitForFileProcessing;
const error_1 = require("../error.js");
const sleep_1 = require("../internal/utils/sleep.js");
/**
 * Waits for file processing through the resource's retrieve method. Elapsed time
 * uses a monotonic clock so system clock changes do not affect the timeout,
 * which is checked after each subsequent retrieval, preserving the existing behavior
 * for an initially terminal file and for a terminal response received too late.
 *
 * @internal
 */
async function waitForFileProcessing(resource, id, pollInterval, maxWait) {
    const terminalStates = new Set(['processed', 'error', 'deleted']);
    const start = performance.now();
    let file = await resource.retrieve(id);
    while (!file.status || !terminalStates.has(file.status)) {
        // oxlint-disable-next-line no-await-in-loop -- Wait before issuing the next processing-status request.
        await (0, sleep_1.sleep)(pollInterval);
        // oxlint-disable-next-line no-await-in-loop -- The timeout and next iteration depend on this response.
        file = await resource.retrieve(id);
        if (performance.now() - start > maxWait) {
            throw new error_1.APIConnectionTimeoutError({
                message: `Giving up on waiting for file ${id} to finish processing after ${maxWait} milliseconds.`,
            });
        }
    }
    return file;
}
//# sourceMappingURL=file-processing.js.map