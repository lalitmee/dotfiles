import type { RequestOptions } from "./request-options.mjs";
import type { FilePropertyBag, Fetch } from "./builtin-types.mjs";
import type { OpenAI } from "../client.mjs";
import type { ReadableStream } from "./shim-types.mjs";
/** Text, binary data, or a blob that can contribute bytes to an uploaded file. */
export type BlobPart = string | ArrayBuffer | ArrayBufferView | Blob | DataView;
/** Node.js-compatible byte stream carrying the source path used to infer a filename. */
type FsReadStream = AsyncIterable<Uint8Array> & {
    /** Source filesystem path, represented as a string or path-like object. */
    path: string | {
        /** Converts the path-like value into its filesystem path. */
        toString(): string;
    };
};
/** Asynchronous chunks consumed lazily while encoding a streaming multipart upload. */
export type StreamingFileInput = AsyncIterable<BlobPart> | ReadableStream<BlobPart>;
declare const brand_privateStreamingFile: unique symbol;
/**
 * A file whose contents are read lazily while the multipart request is sent.
 * Create one with {@link toStreamingFile} when buffering an upload into a `File` is undesirable.
 */
export interface StreamingFile {
    /** Ensures streaming files are created with a filename through {@link toStreamingFile}. */
    readonly [brand_privateStreamingFile]: true;
    /** Source chunks read incrementally as the multipart request body is transmitted. */
    readonly data: StreamingFileInput;
    /**
     * Logical source filename; ordinary uploads send its basename, while Skills can preserve
     * a validated relative directory path.
     */
    readonly name: string;
    /** Optional MIME type; defaults to `application/octet-stream` when omitted. */
    readonly type?: string | undefined;
}
/**
 * Wrap a stream as an uploadable file without reading it into memory.
 *
 * Unlike {@link toFile}, this helper does not create a web `File`, because the `File` constructor
 * must consume all of its contents up front. The stream is instead encoded lazily as multipart
 * form data when the request is sent.
 *
 * @param data Async-iterable or readable-stream chunks containing text, binary data, or blobs.
 * @param name Non-empty logical/source filename. Ordinary uploads send only its basename; Skills
 * uploads may preserve a validated relative path with normalized forward slashes.
 * @param options Optional MIME type for the streaming file.
 * @throws {TypeError} If `name` is empty or the content type contains control characters.
 */
export declare function toStreamingFile(data: StreamingFileInput, name: string, options?: Pick<FilePropertyBag, 'type'>): StreamingFile;
/**
 * Bun file compatibility shape for file objects whose names are optional in their types.
 *
 * @see https://github.com/oven-sh/bun/issues/5980
 */
interface BunFile extends Blob {
    /** Filename exposed by Bun when one is available. */
    readonly name?: string | undefined;
}
/** Blob-compatible upload value that exposes a filename at runtime. */
type NamedBlob = Blob & {
    /** Filename supplied by a native `File` or another named Blob implementation. */
    readonly name?: string | undefined;
};
/**
 * Verifies that the current runtime exposes the global `File` constructor.
 *
 * @throws {Error} If `File` is unavailable; older Node.js runtimes receive an
 * additional upgrade or `node:buffer` compatibility suggestion.
 */
export declare const checkFileSupport: () => void;
/**
 * Values accepted by SDK methods that upload multipart files.
 *
 * Supports native files, fetch responses, blobs, Node.js filesystem read
 * streams, async byte sources, web readable streams, and files created with
 * {@link toStreamingFile}. Use {@link toFile} to materialize compatible content
 * as a native `File` when buffering the complete upload is acceptable.
 */
export type Uploadable = File | Response | FsReadStream | BunFile | NamedBlob | AsyncIterable<BlobPart> | ReadableStream<BlobPart> | StreamingFile;
/**
 * Construct a `File` instance. This is used to ensure a helpful error is thrown
 * for environments that don't define a global `File` yet.
 *
 * A missing filename becomes `unknown_file`.
 */
export declare function makeFile(fileBits: BlobPart[], fileName: string | undefined, options?: FilePropertyBag): File;
/**
 * Infers a filename from an object's `name`, `url`, `filename`, or `path` value.
 *
 * Directory components separated by either `/` or `\\` are discarded unless an
 * explicitly supplied `name` or `filename` opts into preserving its path. Preserved
 * paths must be safe and relative, and use forward slashes. Paths inferred from URLs and filesystem streams
 * discard their directories.
 */
export declare function getName(value: any, options?: {
    stripFilename?: boolean | undefined;
}): string | undefined;
/** Recognizes native ArrayBuffers across realms without trusting their prototype or string tag. */
export declare function isArrayBuffer(value: unknown): value is ArrayBuffer;
/** Identifies objects that expose a callable `Symbol.asyncIterator` method. */
export declare const isAsyncIterable: (value: any) => value is AsyncIterable<any>;
/**
 * Converts a request to multipart form data when its body contains an upload.
 *
 * Uploads include files, blobs, responses, async iterables, readable
 * streams, and {@link StreamingFile} values anywhere in a nested body. Bodies
 * containing streaming values are encoded lazily; other uploads use `FormData`.
 * Requests without uploads are returned unchanged.
 */
export declare const maybeMultipartFormRequestOptions: (opts: RequestOptions, fetch: OpenAI | Fetch, formOptions?: CreateFormOptions) => Promise<RequestOptions>;
/** Request options whose body must be encoded as multipart form data. */
type MultipartFormRequestOptions = Omit<RequestOptions, 'body'> & {
    /** Nested fields and upload values to encode into the multipart request body. */
    body: unknown;
};
/**
 * Encodes a request body as multipart form data even when no file is present.
 *
 * Streaming uploads produce a lazy multipart `ReadableStream` and an explicit
 * boundary header; other values are materialized into platform `FormData`.
 */
export declare const multipartFormRequestOptions: (opts: MultipartFormRequestOptions, fetch: OpenAI | Fetch, formOptions?: CreateFormOptions) => Promise<RequestOptions>;
/** Controls whether explicitly supplied multipart filenames retain directory components. */
export type CreateFormOptions = {
    /** Keep directories in explicit filenames when false; inferred paths remain basename-only. */
    stripFilenames?: boolean;
};
/**
 * Materializes an object into platform `FormData` after verifying fetch support.
 *
 * Strings, numbers, and booleans become text fields; responses, blobs,
 * and async byte sources become file fields. Arrays and nested objects use
 * bracketed field names, while `undefined` values are omitted.
 *
 * @throws {TypeError} If the fetch implementation cannot encode global
 * `FormData`, a field is `null`, or a field has an unsupported value.
 */
export declare const createForm: <T = Record<string, unknown>>(body: T | undefined, fetch: OpenAI | Fetch, options?: CreateFormOptions) => Promise<FormData>;
export {};
//# sourceMappingURL=uploads.d.mts.map