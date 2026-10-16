"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createForm = exports.multipartFormRequestOptions = exports.maybeMultipartFormRequestOptions = exports.isAsyncIterable = exports.checkFileSupport = void 0;
exports.toStreamingFile = toStreamingFile;
exports.makeFile = makeFile;
exports.getName = getName;
exports.isArrayBuffer = isArrayBuffer;
const headers_1 = require("./headers.js");
const shims_1 = require("./shims.js");
const bytes_1 = require("./utils/bytes.js");
const brand_privateStreamingFile = /* @__PURE__ */ Symbol('brand.privateStreamingFile');
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
function toStreamingFile(data, name, options) {
    if (typeof name !== 'string' || !name) {
        throw new TypeError('toStreamingFile requires a non-empty file name');
    }
    const type = options?.type;
    if (type) {
        validateStreamingFileType(type);
    }
    return {
        [brand_privateStreamingFile]: true,
        data,
        name,
        ...(type ? { type } : {}),
    };
}
/**
 * Verifies that the current runtime exposes the global `File` constructor.
 *
 * @throws {Error} If `File` is unavailable; older Node.js runtimes receive an
 * additional upgrade or `node:buffer` compatibility suggestion.
 */
const checkFileSupport = () => {
    if (typeof File === 'undefined') {
        // SAFETY: This optional Node global is inspected only to improve the missing-File diagnostic in runtimes without process.
        const { process } = globalThis;
        const isOldNode = typeof process?.versions?.node === 'string' &&
            Number.parseInt(process.versions.node.split('.'), 10) < 20;
        throw new Error('`File` is not defined as a global, which is required for file uploads.' +
            (isOldNode
                ? " Update to a supported Node.js LTS release, or set `globalThis.File` to `import('node:buffer').File`."
                : ''));
    }
};
exports.checkFileSupport = checkFileSupport;
/**
 * Construct a `File` instance. This is used to ensure a helpful error is thrown
 * for environments that don't define a global `File` yet.
 *
 * A missing filename becomes `unknown_file`.
 */
function makeFile(fileBits, fileName, options) {
    (0, exports.checkFileSupport)();
    // SAFETY: The SDK BlobPart union supports Node and web binary inputs; the native File constructor handles those parts across their differing ambient types.
    return new File(fileBits, fileName ?? 'unknown_file', options);
}
/**
 * Infers a filename from an object's `name`, `url`, `filename`, or `path` value.
 *
 * Directory components separated by either `/` or `\\` are discarded unless an
 * explicitly supplied `name` or `filename` opts into preserving its path. Preserved
 * paths must be safe and relative, and use forward slashes. Paths inferred from URLs and filesystem streams
 * discard their directories.
 */
function getName(value, options) {
    if (typeof value !== 'object' || value === null) {
        return undefined;
    }
    const name = 'name' in value ? value.name : undefined;
    const explicitName = (name && String(name)) || ('filename' in value && value.filename && String(value.filename));
    if (explicitName) {
        return options?.stripFilename === false ? normalizeFilenamePath(explicitName) : basename(explicitName);
    }
    const url = 'url' in value && value.url && String(value.url);
    if (url) {
        try {
            return basename(new URL(url).pathname);
        }
        catch {
            return basename(url);
        }
    }
    const path = 'path' in value && value.path && String(value.path);
    return path ? basename(path) : undefined;
}
function basename(value) {
    return value.split(/[\\/]/).pop() || undefined;
}
function normalizeFilenamePath(value) {
    const normalized = value.replace(/\\/g, '/');
    if (normalized.startsWith('/') || /^[A-Za-z]:/.test(normalized) || normalized.split('/').includes('..')) {
        throw new TypeError('Upload file name must be a safe relative path without parent directory segments');
    }
    return normalized;
}
const arrayBufferByteLengthGetter = Object.getOwnPropertyDescriptor(ArrayBuffer.prototype, 'byteLength')?.get;
/** Recognizes native ArrayBuffers across realms without trusting their prototype or string tag. */
function isArrayBuffer(value) {
    try {
        return arrayBufferByteLengthGetter?.call(value) !== undefined;
    }
    catch {
        return false;
    }
}
/** Identifies objects that expose a callable `Symbol.asyncIterator` method. */
const isAsyncIterable = (value) => value != null && typeof value === 'object' && typeof value[Symbol.asyncIterator] === 'function';
exports.isAsyncIterable = isAsyncIterable;
/**
 * Converts a request to multipart form data when its body contains an upload.
 *
 * Uploads include files, blobs, responses, async iterables, readable
 * streams, and {@link StreamingFile} values anywhere in a nested body. Bodies
 * containing streaming values are encoded lazily; other uploads use `FormData`.
 * Requests without uploads are returned unchanged.
 */
const maybeMultipartFormRequestOptions = async (opts, fetch, formOptions) => {
    if (!hasUploadableValue(opts.body)) {
        return opts;
    }
    if (hasStreamingUploadableValue(opts.body)) {
        return createStreamingFormRequestOptions(opts, formOptions);
    }
    return { ...opts, body: await (0, exports.createForm)(opts.body, fetch, formOptions) };
};
exports.maybeMultipartFormRequestOptions = maybeMultipartFormRequestOptions;
/**
 * Encodes a request body as multipart form data even when no file is present.
 *
 * Streaming uploads produce a lazy multipart `ReadableStream` and an explicit
 * boundary header; other values are materialized into platform `FormData`.
 */
const multipartFormRequestOptions = async (opts, fetch, formOptions) => {
    if (hasStreamingUploadableValue(opts.body)) {
        return createStreamingFormRequestOptions(opts, formOptions);
    }
    return { ...opts, body: await (0, exports.createForm)(opts.body, fetch, formOptions) };
};
exports.multipartFormRequestOptions = multipartFormRequestOptions;
const supportsFormDataMap = /* @__PURE__ */ new WeakMap();
/**
 * node-fetch doesn't support the global FormData object in recent node versions. Instead of sending
 * properly-encoded form data, it just stringifies the object, resulting in a request body of "[object FormData]".
 * This function detects if the fetch function provided supports the global FormData object to avoid
 * confusing error messages later on.
 */
function supportsFormData(fetchObject) {
    // SAFETY: The union has already excluded callable fetch values; the remaining OpenAI client owns the fetch implementation used by this probe.
    const fetch = typeof fetchObject === 'function' ? fetchObject : fetchObject.fetch;
    const cached = supportsFormDataMap.get(fetch);
    if (cached) {
        return cached;
    }
    const promise = (async () => {
        try {
            let FetchResponse;
            if ('Response' in fetch) {
                // SAFETY: Custom fetch implementations may expose their matching Response constructor; the enclosing probe catches incompatible constructors.
                FetchResponse = fetch.Response;
            }
            else {
                const response = await fetch('data:,');
                await response.arrayBuffer();
                // SAFETY: The successful fetch response supplies the constructor used to test its own FormData support; failures remain inside the probe's catch.
                FetchResponse = response.constructor;
            }
            const data = new FormData();
            if (data.toString() === (await new FetchResponse(data).text())) {
                return false;
            }
            return true;
        }
        catch {
            // avoid false negatives
            return true;
        }
    })();
    supportsFormDataMap.set(fetch, promise);
    return promise;
}
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
const createForm = async (body, fetch, options = {}) => {
    if (!(await supportsFormData(fetch))) {
        throw new TypeError('The provided fetch function does not support file uploads with the current global FormData class.');
    }
    const form = new FormData();
    await Promise.all(Object.entries(body || {}).map(([key, value]) => addFormValue(form, key, value, options)));
    return form;
};
exports.createForm = createForm;
// Native files, Bun files, and unnamed upload values all inherit from Blob.
const isBlob = (value) => value instanceof Blob;
const isReadableStream = (value) => typeof value === 'object' &&
    value !== null &&
    'getReader' in value &&
    typeof value.getReader === 'function';
const isStreamingFile = (value) => typeof value === 'object' && value !== null && brand_privateStreamingFile in value;
const isUploadable = (value) => typeof value === 'object' &&
    value !== null &&
    (value instanceof Response ||
        (0, exports.isAsyncIterable)(value) ||
        isReadableStream(value) ||
        isStreamingFile(value) ||
        isBlob(value));
// SAFETY: The enclosing object guard and own-key enumeration allow reading these property values without assigning them a trusted value type.
const hasStreamingUploadableValue = (value) => {
    if (isStreamingFile(value) || (0, exports.isAsyncIterable)(value) || isReadableStream(value)) {
        return true;
    }
    if (Array.isArray(value)) {
        return value.some(hasStreamingUploadableValue);
    }
    if (value && typeof value === 'object' && !isBlob(value) && !(value instanceof Response)) {
        // Own properties only, matching what form encoding serializes; inherited values are never encoded.
        for (const k of Object.keys(value)) {
            if (hasStreamingUploadableValue(value[k])) {
                return true;
            }
        }
    }
    return false;
};
// SAFETY: The enclosing object guard and own-key enumeration allow reading these property values without assigning them a trusted value type.
const hasUploadableValue = (value) => {
    if (isUploadable(value)) {
        return true;
    }
    if (Array.isArray(value)) {
        return value.some(hasUploadableValue);
    }
    if (value && typeof value === 'object') {
        // Own properties only, matching what form encoding serializes; inherited values are never encoded.
        for (const k of Object.keys(value)) {
            if (hasUploadableValue(value[k])) {
                return true;
            }
        }
    }
    return false;
};
const snapshotPreservedUploadEntries = (entries, filenames) => {
    const snapshot = [];
    for (const entry of entries) {
        if (isUploadable(entry.value) && !filenames.has(entry.value)) {
            filenames.set(entry.value, getStreamingFileName(entry.value, { stripFilenames: false }));
        }
        snapshot.push(entry);
    }
    return snapshot;
};
const createStreamingFormRequestOptions = (opts, options = {}) => {
    const entries = iterateFormEntries(opts.body);
    const preservedFilenames = options.stripFilenames === false ? new WeakMap() : undefined;
    const multipartEntries = preservedFilenames
        ? snapshotPreservedUploadEntries(entries, preservedFilenames)
        : entries;
    const boundary = `openai-${Math.random().toString(36).slice(2)}`;
    const body = (0, shims_1.ReadableStreamFrom)(iterateMultipartBody(multipartEntries, boundary, options, preservedFilenames));
    return {
        ...opts,
        body,
        headers: (0, headers_1.buildHeaders)([{ 'content-type': `multipart/form-data; boundary=${boundary}` }, opts.headers]),
    };
};
async function* iterateMultipartBody(entries, boundary, options, preservedFilenames) {
    for await (const { key, value } of entries) {
        if (isUploadable(value)) {
            const filename = preservedFilenames?.get(value) ?? getStreamingFileName(value, options);
            const type = getStreamingFileType(value);
            yield (0, bytes_1.encodeUTF8)(`--${boundary}\r\n`);
            yield (0, bytes_1.encodeUTF8)(`Content-Disposition: form-data; name="${escapeHeaderValue(key)}"; filename="${escapeHeaderValue(filename)}"\r\nContent-Type: ${type}\r\n\r\n`);
            yield* iterateBytes(getStreamingFileData(value));
        }
        else {
            yield (0, bytes_1.encodeUTF8)(`--${boundary}\r\n`);
            yield (0, bytes_1.encodeUTF8)(`Content-Disposition: form-data; name="${escapeHeaderValue(key)}"\r\n\r\n${String(value)}`);
        }
        yield (0, bytes_1.encodeUTF8)('\r\n');
    }
    yield (0, bytes_1.encodeUTF8)(`--${boundary}--\r\n`);
}
function* iterateFormEntries(body) {
    if (!body || typeof body !== 'object') {
        return;
    }
    for (const [key, value] of Object.entries(body)) {
        yield* iterateFormValue(key, value);
    }
}
function* iterateFormValue(key, value) {
    if (value === undefined) {
        return;
    }
    if (value == null) {
        throw new TypeError(`Received null for "${key}"; to pass null in FormData, you must use the string 'null'`);
    }
    if (typeof value === 'string' ||
        typeof value === 'number' ||
        typeof value === 'boolean' ||
        isUploadable(value)) {
        yield { key, value };
    }
    else if (Array.isArray(value)) {
        for (const entry of value) {
            yield* iterateFormValue(key + '[]', entry);
        }
    }
    else if (typeof value === 'object') {
        for (const [name, prop] of Object.entries(value)) {
            yield* iterateFormValue(`${key}[${name}]`, prop);
        }
    }
    else {
        throw new TypeError(`Invalid value given to form, expected a string, number, boolean, object, Array, File or Blob but got ${value} instead`);
    }
}
function getStreamingFileName(value, options) {
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The runtime guard validates JavaScript and custom upload values before trusting the StreamingFile brand.
    if (isStreamingFile(value)) {
        const { name } = value;
        if (typeof name !== 'string' || !name) {
            throw new TypeError('Streaming upload file name must be a non-empty string');
        }
        return options.stripFilenames === false
            ? normalizeFilenamePath(name)
            : (basename(name) ?? 'unknown_file');
    }
    return getName(value, { stripFilename: options.stripFilenames }) ?? 'unknown_file';
}
function getStreamingFileType(value) {
    let type;
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- Runtime upload-brand checks intentionally accept unknown inputs despite the static Uploadable annotation.
    if (isStreamingFile(value) || isBlob(value)) {
        ({ type } = value);
    }
    else if (value instanceof Response) {
        type = value.headers.get('content-type') ?? undefined;
    }
    return validateStreamingFileType(type || 'application/octet-stream');
}
function validateStreamingFileType(type) {
    if (typeof type !== 'string') {
        throw new TypeError('Streaming upload content type must be a string');
    }
    for (let index = 0; index < type.length; index += 1) {
        const character = type.codePointAt(index) ?? 0;
        if (character <= 0x1f || character === 0x7f) {
            throw new TypeError('Streaming upload content type must not contain control characters');
        }
    }
    return type;
}
function getStreamingFileData(value) {
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The runtime guard validates the streaming wrapper before accessing its potentially custom data.
    if (isStreamingFile(value)) {
        return value.data;
    }
    return value;
}
async function* iterateBytes(value) {
    if (typeof value === 'string') {
        yield (0, bytes_1.encodeUTF8)(value);
    }
    else if (ArrayBuffer.isView(value)) {
        yield new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
    }
    else if (isArrayBuffer(value)) {
        yield new Uint8Array(value);
    }
    else if (value instanceof Response) {
        yield* iterateBytes(value.body || (await value.blob()));
    }
    else if (value instanceof Blob) {
        if (typeof value.stream === 'function') {
            yield* iterateBytes(value.stream());
        }
        else {
            yield new Uint8Array(await value.arrayBuffer());
        }
    }
    else if (isReadableStream(value)) {
        for await (const chunk of (0, shims_1.ReadableStreamToAsyncIterable)(value)) {
            yield* iterateBytes(chunk);
        }
    }
    else if ((0, exports.isAsyncIterable)(value)) {
        for await (const chunk of value) {
            yield* iterateBytes(chunk);
        }
    }
    else {
        throw new TypeError(`Invalid streaming file chunk: ${String(value)}`);
    }
}
function escapeHeaderValue(value) {
    return Array.from(value, (character) => {
        const codePoint = character.codePointAt(0) ?? 0;
        return codePoint <= 0x1f || codePoint === 0x7f || character === '"' || character === '\\'
            ? encodeURIComponent(character)
            : character;
    }).join('');
}
const addFormValue = async (form, key, value, options) => {
    if (value === undefined) {
        return;
    }
    if (value == null) {
        throw new TypeError(`Received null for "${key}"; to pass null in FormData, you must use the string 'null'`);
    }
    // Nested form keys use the current bracketed encoding.
    if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
        form.append(key, String(value));
    }
    else if (value instanceof Response) {
        const blob = await value.blob();
        form.append(key, makeFile([blob], getName(value, { stripFilename: options.stripFilenames }), { type: blob.type }));
    }
    else if ((0, exports.isAsyncIterable)(value)) {
        form.append(key, makeFile([await new Response((0, shims_1.ReadableStreamFrom)(value)).blob()], getName(value, { stripFilename: options.stripFilenames })));
    }
    else if (isBlob(value)) {
        const filename = getName(value, { stripFilename: options.stripFilenames });
        if (filename === undefined) {
            form.append(key, value);
        }
        else {
            form.append(key, value, filename);
        }
    }
    else if (Array.isArray(value)) {
        // Prepare array elements concurrently, then preserve their repeated-field order.
        const entries = await Promise.all(value.map(async (entry) => {
            const entryForm = new FormData();
            await addFormValue(entryForm, key + '[]', entry, options);
            return entryForm;
        }));
        for (const entryForm of entries) {
            if (!entryForm) {
                continue;
            }
            for (const [entryKey, entryValue] of entryForm.entries()) {
                form.append(entryKey, entryValue);
            }
        }
    }
    else if (typeof value === 'object') {
        await Promise.all(Object.entries(value).map(([name, prop]) => addFormValue(form, `${key}[${name}]`, prop, options)));
    }
    else {
        throw new TypeError(`Invalid value given to form, expected a string, number, boolean, object, Array, File or Blob but got ${value} instead`);
    }
};
//# sourceMappingURL=uploads.js.map