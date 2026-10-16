/**
 * Output files: files pi writes so the model can use output it was not shown in full, such as the
 * full text of truncated tool output, binary MCP resources, and images shown by codemode scripts.
 * Every output file is created here, so where they are stored can change in one place. Today they
 * go to the OS temp directory.
 */
import { type WriteStream } from "node:fs";
/** Write `data` to a new output file and return its path. */
export declare function writeOutputFile(prefix: string, extension: string, data: string | Uint8Array): Promise<string>;
/** Open a new output file for streamed output. */
export declare function createOutputFileStream(prefix: string, extension: string): {
    path: string;
    stream: WriteStream;
};
//# sourceMappingURL=output-files.d.ts.map