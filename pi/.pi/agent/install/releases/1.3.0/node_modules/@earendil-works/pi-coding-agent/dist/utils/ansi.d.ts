/**
 * Split streamed text into a part that is safe to pass to stripAnsi now and a trailing
 * unfinished escape sequence that should be prepended to the next chunk.
 */
export declare function splitIncompleteAnsiSuffix(value: string): {
    complete: string;
    pending: string;
};
export declare function stripAnsi(value: string): string;
//# sourceMappingURL=ansi.d.ts.map