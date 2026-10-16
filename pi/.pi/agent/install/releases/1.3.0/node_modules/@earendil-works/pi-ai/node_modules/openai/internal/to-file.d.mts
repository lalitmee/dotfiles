import type { FilePropertyBag } from "./builtin-types.mjs";
/** Text, binary content, or a Blob-compatible value accepted inside a file stream. */
type BlobLikePart = string | ArrayBuffer | ArrayBufferView | BlobLike | DataView;
/**
 * Structural Blob compatibility across DOM, `node-fetch`, and Node.js runtimes.
 *
 * `arrayBuffer()` is intentionally checked separately because some older
 * third-party Blob types do not declare it.
 */
interface BlobLike {
    /** Size of the Blob contents in bytes. */
    readonly size: number;
    /** MIME type associated with the Blob contents, or an empty string. */
    readonly type: string;
    /** Reads the Blob contents as UTF-8 text. */
    text(): Promise<string>;
    /** Returns a Blob-compatible view of the requested byte range. */
    slice(start?: number, end?: number): BlobLike;
}
/**
 * Structural File compatibility across DOM, `node:buffer`, and `undici` runtimes.
 */
interface FileLike extends BlobLike {
    /** Last modification time as milliseconds since the Unix epoch. */
    readonly lastModified: number;
    /** Filename associated with the underlying File-compatible object. */
    readonly name?: string | undefined;
}
/**
 * Structural fetch-response compatibility across browser and server runtimes.
 */
export interface ResponseLike {
    /** Absolute response URL used to infer a filename from its final path segment. */
    url: string;
    /** Reads the response body into a Blob-compatible value. */
    blob(): Promise<BlobLike>;
}
/**
 * File-compatible values that can be buffered into a native `File`.
 *
 * Includes existing files, fetch responses, binary buffers, Blob-compatible
 * values, and async streams of file parts. Top-level strings are intentionally
 * excluded so filesystem paths are not accidentally treated as file contents.
 */
export type ToFileInput = FileLike | ResponseLike | Exclude<BlobLikePart, string> | AsyncIterable<BlobLikePart>;
/**
 * Buffers compatible content into a native {@link File} for an SDK upload.
 *
 * Existing native `File` objects are returned unchanged when their effective
 * filename and metadata are unchanged. Renamed native files reuse the original
 * file contents without buffering and retain their MIME type and modification
 * time unless explicitly overridden. Other filenames are inferred from response
 * URLs or input metadata when omitted or null, falling back to `unknown_file`.
 * An explicit empty filename is preserved. Responses,
 * native or compatible `Blob` values, and compatible non-native files supply
 * their MIME type unless `options.type` provides an explicit override.
 *
 * @param value An existing file, response, binary buffer, Blob-like object, async
 * stream of file parts, or a promise resolving to one of those values.
 * @param name Optional filename overriding inferred metadata or an existing filename.
 * @param options Optional file metadata, including MIME type and modification time.
 * @returns A native `File` containing the complete buffered input.
 * @throws {Error} If the runtime lacks a global `File` constructor or the input
 * cannot be converted into file contents.
 */
export declare function toFile(value: ToFileInput | PromiseLike<ToFileInput>, name?: string | null | undefined, options?: FilePropertyBag | undefined): Promise<File>;
export {};
//# sourceMappingURL=to-file.d.mts.map