import type { FileObject, Files } from "../resources/files.mjs";
/**
 * Waits for file processing through the resource's retrieve method. Elapsed time
 * uses a monotonic clock so system clock changes do not affect the timeout,
 * which is checked after each subsequent retrieval, preserving the existing behavior
 * for an initially terminal file and for a terminal response received too late.
 *
 * @internal
 */
export declare function waitForFileProcessing(resource: Pick<Files, 'retrieve'>, id: string, pollInterval: number, maxWait: number): Promise<FileObject>;
//# sourceMappingURL=file-processing.d.mts.map