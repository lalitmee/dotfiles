import type { AgentTool } from "@earendil-works/pi-agent-core";
import type { ModelImageResizeOptions } from "@earendil-works/pi-ai";
import { type Static, Type } from "typebox";
import type { ToolDefinition } from "../extensions/types.ts";
import { type TruncationResult } from "./truncate.ts";
declare const readSchema: Type.TObject<{
    path: Type.TString;
    offset: Type.TOptional<Type.TNumber>;
    limit: Type.TOptional<Type.TNumber>;
}>;
export declare const readToolSystemPromptContribution: {
    readonly snippet: "Read file contents";
    readonly guidelines: readonly ["Use read to examine files instead of cat or sed."];
};
export type ReadToolInput = Static<typeof readSchema>;
/**
 * Result for programmatic callers such as codemode scripts: the text for text files, and an image
 * block for images that codemode's `image()` accepts. `note` is the text that goes with the image,
 * such as resize hints. Property descriptions are left out so the type stays on one line in tool
 * descriptions.
 */
declare const readOutputSchema: Type.TUnion<[Type.TString, Type.TObject<{
    type: Type.TLiteral<"image">;
    data: Type.TString;
    mimeType: Type.TString;
    note: Type.TString;
}>]>;
export type ReadToolOutput = Static<typeof readOutputSchema>;
export interface ReadToolDetails {
    truncation?: TruncationResult;
}
/**
 * Pluggable operations for the read tool.
 * Override these to delegate file reading to remote systems (for example SSH).
 */
export interface ReadOperations {
    /** Read file contents as a Buffer */
    readFile: (absolutePath: string) => Promise<Buffer>;
    /** Check if file is readable (throw if not) */
    access: (absolutePath: string) => Promise<void>;
    /** Detect image MIME type, return null or undefined for non-images */
    detectImageMimeType?: (absolutePath: string) => Promise<string | null | undefined>;
}
export interface ReadToolOptions {
    /** Whether to auto-resize images. Default: true */
    autoResizeImages?: boolean;
    /** Fallback resize profile when the execution context has no model metadata. */
    resizeOptions?: ModelImageResizeOptions;
    /** Custom operations for file reading. Default: local filesystem */
    operations?: ReadOperations;
}
export declare function createReadToolDefinition(cwd: string, options?: ReadToolOptions): ToolDefinition<typeof readSchema, ReadToolDetails | undefined>;
export declare function createReadTool(cwd: string, options?: ReadToolOptions): AgentTool<typeof readSchema>;
export {};
//# sourceMappingURL=read.d.ts.map