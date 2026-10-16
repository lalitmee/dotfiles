/** Copies byte arrays into one contiguous `Uint8Array` while preserving their order. */
export function concatBytes(buffers) {
    let length = 0;
    for (const buffer of buffers) {
        length += buffer.length;
    }
    const output = new Uint8Array(length);
    let index = 0;
    for (const buffer of buffers) {
        output.set(buffer, index);
        index += buffer.length;
    }
    return output;
}
let encodeUTF8_;
/** Encodes text as UTF-8 bytes, reusing the platform encoder after its first call. */
export function encodeUTF8(str) {
    let encoder;
    // SAFETY: Supported runtimes provide the standard TextEncoder/TextDecoder globals; the cast keeps their ambient DOM declarations optional.
    return (encodeUTF8_ ??
        ((encoder = new globalThis.TextEncoder()), (encodeUTF8_ = encoder.encode.bind(encoder))))(str);
}
let decodeUTF8_;
/** Decodes UTF-8 bytes as text, reusing the platform decoder after its first call. */
export function decodeUTF8(bytes) {
    let decoder;
    // SAFETY: Supported runtimes provide the standard TextEncoder/TextDecoder globals; the cast keeps their ambient DOM declarations optional.
    return (decodeUTF8_ ??
        ((decoder = new globalThis.TextDecoder()), (decodeUTF8_ = decoder.decode.bind(decoder))))(bytes);
}
//# sourceMappingURL=bytes.mjs.map