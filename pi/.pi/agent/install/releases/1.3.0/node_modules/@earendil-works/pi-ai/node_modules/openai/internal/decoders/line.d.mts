/** Text or UTF-8 bytes accepted by the incremental line decoder. */
export type Bytes = string | ArrayBuffer | Uint8Array | null | undefined;
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
export declare class LineDecoder {
    #private;
    /** Individual characters recognized as possible line terminators. */
    static NEWLINE_CHARS: Set<string>;
    /** Matches complete CRLF terminators as well as standalone CR and LF characters. */
    static NEWLINE_REGEXP: RegExp;
    /** Creates a decoder with no buffered bytes or pending newline continuation. */
    constructor();
    /**
     * Appends a text or UTF-8 byte chunk and returns every newly completed line.
     *
     * Incomplete lines remain buffered for the next call. A trailing `\r`
     * completes its line immediately, and a following `\n` is consumed as its
     * continuation. `null` and `undefined` are ignored and do not flush buffered
     * content.
     */
    decode(chunk: Bytes): string[];
    /** Emits the remaining unterminated line, or returns an empty array when idle. */
    flush(): string[];
}
/**
 * Finds the first blank-line separator used to delimit streamed event records.
 *
 * @returns The byte offset immediately after the first pair of consecutive
 * line endings, or `-1` when the buffer contains no complete separator.
 */
export declare function findDoubleNewlineIndex(buffer: Uint8Array): number;
//# sourceMappingURL=line.d.mts.map