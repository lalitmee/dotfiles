/**
 * Codemode source format: JavaScript, optionally preceded by one options line.
 *
 * ```js
 * // @options: {"max_output_tokens": 2000, "timeout_ms": 30000}
 * const text = await tools.read({ path: "package.json" });
 * text(JSON.parse(text).name);
 * ```
 */
export declare const CODEMODE_OPTIONS_PREFIX = "// @options:";
/**
 * Lark grammar for providers with grammar-constrained tool input. It only fixes the shape of the
 * options line; the options JSON and the code are checked by {@link parseCodemodeSource}.
 */
export declare const CODEMODE_SOURCE_GRAMMAR: string;
export interface CodemodeSourceOptions {
    /** Token budget for the script's output. */
    maxOutputTokens?: number;
    /** Hard deadline for the whole script in milliseconds, including tool calls. */
    timeoutMs?: number;
}
export interface ParsedCodemodeSource {
    /** The script with the options line replaced by an empty line, so line numbers are unchanged. */
    code: string;
    options: CodemodeSourceOptions;
}
export declare class CodemodeSourceError extends Error {
    constructor(message: string);
}
/**
 * Split an optional first-line `// @options: {...}` from the script. Throws
 * {@link CodemodeSourceError} for empty input, invalid options, and an options line that is not the
 * first line, which would otherwise be ignored without notice.
 */
export declare function parseCodemodeSource(input: string): ParsedCodemodeSource;
//# sourceMappingURL=source.d.ts.map