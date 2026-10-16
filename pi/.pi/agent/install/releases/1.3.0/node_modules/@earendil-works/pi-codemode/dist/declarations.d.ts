import { toCodemodeIdentifier } from "./identifier.ts";
export { toCodemodeIdentifier };
import type { CodemodeJsonSchema, CodemodeTool } from "./types.ts";
/** Largest rendered input type, in characters, before it becomes `unknown`. */
export declare const DEFAULT_INPUT_SCHEMA_MAX_CHARS = 16000;
export interface RenderDeclarationsOptions {
    tools?: readonly CodemodeTool[];
    globals?: readonly CodemodeTool[];
}
/**
 * Render TypeScript declarations for the script-visible API. Tools become members of
 * `declare const tools`, globals become `declare function` statements, and `ns.member` globals
 * members of `declare const ns`. Descriptions become doc comments; schemas become types.
 */
export declare function renderDeclarations(options: RenderDeclarationsOptions): string;
/**
 * One tool as a member of the `tools` object: `name(args: T): Promise<R>;` with the
 * name as the identifier scripts use. Input types longer than `inputMaxChars` render as `unknown`.
 */
export declare function renderToolSignature(tool: Pick<CodemodeTool, "name" | "inputSchema" | "outputSchema">, options?: {
    inputMaxChars?: number;
}): string;
/**
 * A tool's sample: the description followed by the tool's declaration. Used for tool
 * listings and `ALL_TOOLS` entries.
 */
export declare function renderToolSample(tool: Pick<CodemodeTool, "name" | "description" | "inputSchema" | "outputSchema">, options?: {
    inputMaxChars?: number;
}): string;
/** The type a tool call resolves to: the output schema's type, and `unknown` without a schema. */
export declare function renderToolOutputType(schema: CodemodeJsonSchema | undefined): string;
/**
 * Convert a JSON Schema to a TypeScript type expression: objects on one line (`{ a: string; b?: number; }`) with properties sorted by name,
 * or one property per line with `//` comments when a property has a description or constraints the
 * type cannot express (`// @integer @minimum 1 @default 20`); `Array<T>` for arrays. Local references
 * (`#/$defs/...`, `#/definitions/...`) resolve against `schema`; recursive and remote references
 * render as `unknown`. A result longer than `maxChars` is rendered again without the constraint tags,
 * and renders as `unknown` if it is still too long.
 */
export declare function schemaToType(schema: CodemodeJsonSchema, options?: {
    maxChars?: number;
}): string;
//# sourceMappingURL=declarations.d.ts.map