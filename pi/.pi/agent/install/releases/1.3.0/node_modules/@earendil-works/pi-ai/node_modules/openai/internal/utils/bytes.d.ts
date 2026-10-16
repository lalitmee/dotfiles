/** Copies byte arrays into one contiguous `Uint8Array` while preserving their order. */
export declare function concatBytes(buffers: Uint8Array[]): Uint8Array;
/** Encodes text as UTF-8 bytes, reusing the platform encoder after its first call. */
export declare function encodeUTF8(str: string): Uint8Array<ArrayBufferLike>;
/** Decodes UTF-8 bytes as text, reusing the platform decoder after its first call. */
export declare function decodeUTF8(bytes: Uint8Array): string;
//# sourceMappingURL=bytes.d.ts.map