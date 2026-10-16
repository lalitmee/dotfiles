import type { ImageContent, ModelImageResizeOptions, TextContent } from "@earendil-works/pi-ai";
export type ToolResultContent = TextContent | ImageContent;
export interface NormalizeToolResultImagesOptions {
    /** Whether oversized images are resized to inline provider limits. Default: true */
    autoResizeImages?: boolean;
    /** Model-specific resize profile. Uses the conservative built-in defaults when omitted. */
    resizeOptions?: ModelImageResizeOptions;
}
/**
 * Normalize image blocks returned by tool results.
 *
 * The `read` tool and `@file` CLI attachments run their images through `processImage`, but tools
 * that produce images themselves (extensions, MCP bridges, screenshot tools) hand back arbitrary
 * base64 payloads that go straight into session history and every subsequent provider request.
 * Oversized images make the provider reject the whole conversation, not just the offending turn,
 * so normalize them once as they enter history.
 *
 * Returns the original array when nothing changed so callers can skip rewriting the result.
 */
export declare function normalizeToolResultImages(content: ToolResultContent[], options?: NormalizeToolResultImagesOptions): Promise<ToolResultContent[]>;
//# sourceMappingURL=tool-result-images.d.ts.map