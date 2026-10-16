var _LineDecoder_instances, _LineDecoder_buffer, _LineDecoder_start, _LineDecoder_end, _LineDecoder_searchIndex, _LineDecoder_skipLeadingLF, _LineDecoder_append;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../tslib.mjs";
import { decodeUTF8, encodeUTF8 } from "../utils/bytes.mjs";
/** Maximum backing-buffer capacity retained when completed lines leave little active data. */
const MAX_RETAINED_BUFFER_BYTES = 64 * 1024;
/**
 * Incrementally decodes UTF-8 text into lines without losing partial characters
 * or newline sequences that span multiple chunks.
 *
 * Supports `\n`, `\r`, and `\r\n` line endings. Call {@link flush} after the
 * final chunk to emit a trailing line that does not end with a newline.
 *
 * Based on the line decoder used by the Python `httpx` project:
 * https://github.com/encode/httpx/blob/920333ea98118e9cf617f246905d7b202510941c/httpx/_decoders.py#L258
 */
export class LineDecoder {
    /** Creates a decoder with no buffered bytes or pending newline continuation. */
    constructor() {
        _LineDecoder_instances.add(this);
        _LineDecoder_buffer.set(this, void 0);
        _LineDecoder_start.set(this, void 0);
        _LineDecoder_end.set(this, void 0);
        _LineDecoder_searchIndex.set(this, void 0);
        _LineDecoder_skipLeadingLF.set(this, void 0);
        __classPrivateFieldSet(this, _LineDecoder_buffer, new Uint8Array(), "f");
        __classPrivateFieldSet(this, _LineDecoder_start, 0, "f");
        __classPrivateFieldSet(this, _LineDecoder_end, 0, "f");
        __classPrivateFieldSet(this, _LineDecoder_searchIndex, 0, "f");
        __classPrivateFieldSet(this, _LineDecoder_skipLeadingLF, false, "f");
    }
    /**
     * Appends a text or UTF-8 byte chunk and returns every newly completed line.
     *
     * Incomplete lines remain buffered for the next call. A trailing `\r`
     * completes its line immediately, and a following `\n` is consumed as its
     * continuation. `null` and `undefined` are ignored and do not flush buffered
     * content.
     */
    decode(chunk) {
        if (chunk == null) {
            return [];
        }
        let binaryChunk;
        if (chunk instanceof ArrayBuffer) {
            binaryChunk = new Uint8Array(chunk);
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- The line decoder accepts both text and binary chunks and must select the matching decoding path.
        }
        else if (typeof chunk === 'string') {
            binaryChunk = encodeUTF8(chunk);
        }
        else {
            binaryChunk = chunk;
        }
        if (binaryChunk.length === 0) {
            return [];
        }
        if (__classPrivateFieldGet(this, _LineDecoder_skipLeadingLF, "f")) {
            __classPrivateFieldSet(this, _LineDecoder_skipLeadingLF, false, "f");
            if (binaryChunk[0] === 0x0a) {
                binaryChunk = binaryChunk.subarray(1);
            }
            if (binaryChunk.length === 0) {
                return [];
            }
        }
        __classPrivateFieldGet(this, _LineDecoder_instances, "m", _LineDecoder_append).call(this, binaryChunk);
        const lines = [];
        let patternIndex;
        while ((patternIndex = findNewlineIndex(__classPrivateFieldGet(this, _LineDecoder_buffer, "f"), __classPrivateFieldGet(this, _LineDecoder_searchIndex, "f"), __classPrivateFieldGet(this, _LineDecoder_end, "f"))) != null) {
            const line = decodeUTF8(__classPrivateFieldGet(this, _LineDecoder_buffer, "f").subarray(__classPrivateFieldGet(this, _LineDecoder_start, "f"), patternIndex.preceding));
            lines.push(line);
            __classPrivateFieldSet(this, _LineDecoder_start, patternIndex.index, "f");
            if (patternIndex.carriage) {
                if (__classPrivateFieldGet(this, _LineDecoder_start, "f") < __classPrivateFieldGet(this, _LineDecoder_end, "f") && __classPrivateFieldGet(this, _LineDecoder_buffer, "f")[__classPrivateFieldGet(this, _LineDecoder_start, "f")] === 0x0a) {
                    __classPrivateFieldSet(this, _LineDecoder_start, __classPrivateFieldGet(this, _LineDecoder_start, "f") + 1, "f");
                }
                else if (__classPrivateFieldGet(this, _LineDecoder_start, "f") === __classPrivateFieldGet(this, _LineDecoder_end, "f")) {
                    __classPrivateFieldSet(this, _LineDecoder_skipLeadingLF, true, "f");
                }
            }
            __classPrivateFieldSet(this, _LineDecoder_searchIndex, __classPrivateFieldGet(this, _LineDecoder_start, "f"), "f");
        }
        __classPrivateFieldSet(this, _LineDecoder_searchIndex, __classPrivateFieldGet(this, _LineDecoder_end, "f"), "f");
        if (__classPrivateFieldGet(this, _LineDecoder_start, "f") === __classPrivateFieldGet(this, _LineDecoder_end, "f")) {
            __classPrivateFieldSet(this, _LineDecoder_start, 0, "f");
            __classPrivateFieldSet(this, _LineDecoder_end, 0, "f");
            __classPrivateFieldSet(this, _LineDecoder_searchIndex, 0, "f");
            if (__classPrivateFieldGet(this, _LineDecoder_buffer, "f").length > MAX_RETAINED_BUFFER_BYTES) {
                __classPrivateFieldSet(this, _LineDecoder_buffer, new Uint8Array(), "f");
            }
        }
        else if (lines.length > 0 && __classPrivateFieldGet(this, _LineDecoder_buffer, "f").length > MAX_RETAINED_BUFFER_BYTES) {
            const length = __classPrivateFieldGet(this, _LineDecoder_end, "f") - __classPrivateFieldGet(this, _LineDecoder_start, "f");
            if (length <= MAX_RETAINED_BUFFER_BYTES || __classPrivateFieldGet(this, _LineDecoder_buffer, "f").length > length * 4) {
                const capacity = length <= MAX_RETAINED_BUFFER_BYTES
                    ? Math.min(Math.max(length * 2, 256), MAX_RETAINED_BUFFER_BYTES)
                    : length * 2;
                const buffer = new Uint8Array(capacity);
                buffer.set(__classPrivateFieldGet(this, _LineDecoder_buffer, "f").subarray(__classPrivateFieldGet(this, _LineDecoder_start, "f"), __classPrivateFieldGet(this, _LineDecoder_end, "f")));
                __classPrivateFieldSet(this, _LineDecoder_buffer, buffer, "f");
                __classPrivateFieldSet(this, _LineDecoder_start, 0, "f");
                __classPrivateFieldSet(this, _LineDecoder_end, length, "f");
                __classPrivateFieldSet(this, _LineDecoder_searchIndex, length, "f");
            }
        }
        return lines;
    }
    /** Emits the remaining unterminated line, or returns an empty array when idle. */
    flush() {
        __classPrivateFieldSet(this, _LineDecoder_skipLeadingLF, false, "f");
        if (__classPrivateFieldGet(this, _LineDecoder_start, "f") === __classPrivateFieldGet(this, _LineDecoder_end, "f")) {
            return [];
        }
        return this.decode('\n');
    }
}
_LineDecoder_buffer = new WeakMap(), _LineDecoder_start = new WeakMap(), _LineDecoder_end = new WeakMap(), _LineDecoder_searchIndex = new WeakMap(), _LineDecoder_skipLeadingLF = new WeakMap(), _LineDecoder_instances = new WeakSet(), _LineDecoder_append = function _LineDecoder_append(chunk) {
    if (__classPrivateFieldGet(this, _LineDecoder_end, "f") + chunk.length > __classPrivateFieldGet(this, _LineDecoder_buffer, "f").length) {
        const length = __classPrivateFieldGet(this, _LineDecoder_end, "f") - __classPrivateFieldGet(this, _LineDecoder_start, "f");
        if (__classPrivateFieldGet(this, _LineDecoder_start, "f") >= __classPrivateFieldGet(this, _LineDecoder_buffer, "f").length / 2 && length + chunk.length <= __classPrivateFieldGet(this, _LineDecoder_buffer, "f").length) {
            __classPrivateFieldGet(this, _LineDecoder_buffer, "f").copyWithin(0, __classPrivateFieldGet(this, _LineDecoder_start, "f"), __classPrivateFieldGet(this, _LineDecoder_end, "f"));
        }
        else {
            const capacity = Math.max(__classPrivateFieldGet(this, _LineDecoder_buffer, "f").length * 2, length + chunk.length, 256);
            const buffer = new Uint8Array(capacity);
            buffer.set(__classPrivateFieldGet(this, _LineDecoder_buffer, "f").subarray(__classPrivateFieldGet(this, _LineDecoder_start, "f"), __classPrivateFieldGet(this, _LineDecoder_end, "f")));
            __classPrivateFieldSet(this, _LineDecoder_buffer, buffer, "f");
        }
        __classPrivateFieldSet(this, _LineDecoder_searchIndex, __classPrivateFieldGet(this, _LineDecoder_searchIndex, "f") - __classPrivateFieldGet(this, _LineDecoder_start, "f"), "f");
        __classPrivateFieldSet(this, _LineDecoder_end, length, "f");
        __classPrivateFieldSet(this, _LineDecoder_start, 0, "f");
    }
    __classPrivateFieldGet(this, _LineDecoder_buffer, "f").set(chunk, __classPrivateFieldGet(this, _LineDecoder_end, "f"));
    __classPrivateFieldSet(this, _LineDecoder_end, __classPrivateFieldGet(this, _LineDecoder_end, "f") + chunk.length, "f");
};
// prettier-ignore
/** Individual characters recognized as possible line terminators. */
LineDecoder.NEWLINE_CHARS = new Set(['\n', '\r']);
/** Matches complete CRLF terminators as well as standalone CR and LF characters. */
LineDecoder.NEWLINE_REGEXP = /\r\n|[\n\r]/g;
/**
 * Searches the active buffer range for the next CR or LF byte and returns its
 * zero-based position, the position immediately after it, and whether the byte
 * was a carriage return. Returns `null` when the range contains no newline byte.
 *
 * ```ts
 * findNewlineIndex(new TextEncoder().encode('abc\ndef'), 0, 7)
 * // => { preceding: 3, index: 4, carriage: false }
 * ```
 */
function findNewlineIndex(buffer, start, end) {
    const newline = 0x0a; // \n
    const carriage = 0x0d; // \r
    for (let i = start; i < end; i++) {
        if (buffer[i] === newline) {
            return { preceding: i, index: i + 1, carriage: false };
        }
        if (buffer[i] === carriage) {
            return { preceding: i, index: i + 1, carriage: true };
        }
    }
    return null;
}
/**
 * Finds the first blank-line separator used to delimit streamed event records.
 *
 * @returns The byte offset immediately after the first pair of consecutive
 * line endings, or `-1` when the buffer contains no complete separator.
 */
export function findDoubleNewlineIndex(buffer) {
    for (let i = 0; i < buffer.length - 1; i++) {
        const firstEndingLength = lineEndingLength(buffer, i);
        if (firstEndingLength > 0) {
            const secondEndingIndex = i + firstEndingLength;
            const secondEndingLength = lineEndingLength(buffer, secondEndingIndex);
            if (secondEndingLength > 0) {
                return secondEndingIndex + secondEndingLength;
            }
        }
    }
    return -1;
}
function lineEndingLength(buffer, index) {
    const newline = 0x0a; // \n
    const carriage = 0x0d; // \r
    if (buffer[index] === newline) {
        return 1;
    }
    if (buffer[index] === carriage) {
        return buffer[index + 1] === newline ? 2 : 1;
    }
    return 0;
}
//# sourceMappingURL=line.mjs.map