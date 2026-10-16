import type { Api, AssistantMessage, ImageContent, Message, Model, TextContent, ToolResultMessage } from "../types.ts";
/** An error tool result split into a text-only result and the images to send after the tool results. */
export interface SplitErrorToolResult {
    /** The result content with each run of images replaced by a note. */
    content: TextContent[];
    /** Text naming the tool call, to send before `images`. */
    caption: string;
    images: ImageContent[];
}
/**
 * Split the images out of an error tool result, for APIs that reject images in error results
 * (Anthropic, and Claude on Bedrock). Send the returned content as the tool result and the caption and
 * images after all tool results of the turn, in the same user message. Returns undefined for results
 * that need no split (#10794).
 */
export declare function splitErrorToolResultImages(msg: ToolResultMessage): SplitErrorToolResult | undefined;
/**
 * Normalize tool call ID for cross-provider compatibility.
 * OpenAI Responses API generates IDs that are 450+ chars with special characters like `|`.
 * Anthropic APIs require IDs matching ^[a-zA-Z0-9_-]+$ (max 64 chars).
 */
export declare function transformMessages<TApi extends Api>(messages: Message[], model: Model<TApi>, normalizeToolCallId?: (id: string, model: Model<TApi>, source: AssistantMessage) => string): Message[];
//# sourceMappingURL=transform-messages.d.ts.map