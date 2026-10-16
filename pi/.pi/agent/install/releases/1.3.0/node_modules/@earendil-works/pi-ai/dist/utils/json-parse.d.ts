import type { ToolCall } from "../types.ts";
/**
 * Repairs malformed JSON string literals by:
 * - escaping raw control characters inside strings
 * - doubling backslashes before invalid escape characters
 */
export declare function repairJson(json: string): string;
export declare function parseJsonWithRepair<T>(json: string): T;
/**
 * Parses the model's complete arguments text of a finished tool call.
 *
 * Unlike {@link parseStreamingJson}, this never keeps a partially parsed prefix: once the call is
 * finished, text that is not a valid JSON object means the model sent malformed arguments. In that
 * case `arguments` is `{}` and `argumentsError` describes the problem, including the text the
 * model sent, so tool validation can report it back to the model.
 */
export declare function parseToolCallArguments(json: string | undefined): Pick<ToolCall, "arguments" | "argumentsError">;
/**
 * Attempts to parse potentially incomplete JSON during streaming.
 * Always returns a valid object, even if the JSON is incomplete.
 *
 * @param partialJson The partial JSON string from streaming
 * @returns Parsed object or empty object if parsing fails
 */
export declare function parseStreamingJson<T = Record<string, unknown>>(partialJson: string | undefined): T;
//# sourceMappingURL=json-parse.d.ts.map