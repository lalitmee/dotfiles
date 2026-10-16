"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toFile = toFile;
const uploads_1 = require("./uploads.js");
/**
 * This check adds the arrayBuffer() method type because it is available and used at runtime
 */
const isBlobLike = (value) => value != null &&
    typeof value === 'object' &&
    typeof value.size === 'number' &&
    typeof value.type === 'string' &&
    typeof value.text === 'function' &&
    typeof value.slice === 'function' &&
    typeof value.arrayBuffer === 'function';
/**
 * This check adds the arrayBuffer() method type because it is available and used at runtime
 */
const isFileLike = (value) => value != null &&
    typeof value === 'object' &&
    typeof value.name === 'string' &&
    typeof value.lastModified === 'number' &&
    isBlobLike(value);
const isResponseLike = (value) => value != null &&
    typeof value === 'object' &&
    typeof value.url === 'string' &&
    typeof value.blob === 'function';
const hasFilePropertyOverrides = (value, options) => (options?.type != null && options.type !== value.type) ||
    (options?.lastModified != null && options.lastModified !== value.lastModified) ||
    options?.endings != null;
const canReuseNativeFile = (value, name, options) => (name == null || name === value.name) && !hasFilePropertyOverrides(value, options);
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
async function toFile(value, name, options) {
    (0, uploads_1.checkFileSupport)();
    // If it's a promise, resolve it.
    value = await value;
    if (isFileLike(value)) {
        const fileOptions = {
            ...options,
            type: options?.type ?? value.type,
            lastModified: options?.lastModified ?? value.lastModified,
        };
        if (value instanceof File) {
            if (canReuseNativeFile(value, name, options)) {
                return value;
            }
            return (0, uploads_1.makeFile)([value], name ?? value.name, fileOptions);
        }
        return (0, uploads_1.makeFile)([await value.arrayBuffer()], name ?? value.name, fileOptions);
    }
    if (isResponseLike(value)) {
        const blob = await value.blob();
        name ?? (name = (0, uploads_1.getName)(value));
        const responseOptions = options?.type === undefined && blob.type ? { ...options, type: blob.type } : options;
        return (0, uploads_1.makeFile)(await getBytes(blob), name, responseOptions);
    }
    const parts = await getBytes(value);
    name ?? (name = (0, uploads_1.getName)(value));
    if (options?.type === undefined) {
        const typedPart = parts.find((part) => typeof part === 'object' && 'type' in part && !!part.type);
        if (typedPart) {
            options = { ...options, type: typedPart.type };
        }
    }
    return (0, uploads_1.makeFile)(parts, name, options);
}
async function getBytes(value) {
    const parts = [];
    if (typeof value === 'string' ||
        ArrayBuffer.isView(value) || // includes Uint8Array, Buffer, etc.
        (0, uploads_1.isArrayBuffer)(value)) {
        parts.push(value);
    }
    else if (isBlobLike(value)) {
        parts.push(value instanceof Blob ? value : new Blob([await value.arrayBuffer()], { type: value.type }));
    }
    else if ((0, uploads_1.isAsyncIterable)(value) // includes Readable, ReadableStream, etc.
    ) {
        for await (const chunk of value) {
            parts.push(...(await getBytes(chunk)));
        }
    }
    else {
        const constructor = value?.constructor?.name;
        throw new Error(`Unexpected data type: ${typeof value}${constructor ? `; constructor: ${constructor}` : ''}${propsForError(value)}`);
    }
    return parts;
}
function propsForError(value) {
    if (typeof value !== 'object' || value === null) {
        return '';
    }
    const props = Object.getOwnPropertyNames(value);
    return `; props: [${props.map((p) => `"${p}"`).join(', ')}]`;
}
//# sourceMappingURL=to-file.js.map