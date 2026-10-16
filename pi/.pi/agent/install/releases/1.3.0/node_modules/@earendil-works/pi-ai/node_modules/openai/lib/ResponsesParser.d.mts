import type { ChatCompletionTool } from "../resources/chat/completions.mjs";
import type { FunctionTool, ParsedResponse, Response, ResponseCreateParamsBase, ResponseCreateParamsNonStreaming, ResponseFormatTextJSONSchemaConfig, ResponseFunctionToolCall, ResponseTextConfig, Tool } from "../resources/responses/responses.mjs";
import type { AutoParseableTextFormat } from "../lib/parser.mjs";
/** Response tools, a compatible chat completion tool, or no tools. */
export type ParseableToolsParams = Tool[] | ChatCompletionTool | null;
/** Response-creation parameters that may include tools recognized by parsing helpers. */
export type ResponseCreateParamsWithTools = ResponseCreateParamsBase & {
    /** Tools available to the model while producing the response. */
    tools?: ParseableToolsParams;
};
/** Request fields that can select a plain-text or structured Responses API output format. */
type TextConfigParams = {
    /** Optional text output configuration, including its structured JSON format. */
    text?: ResponseTextConfig;
};
/** Infers parsed output for each member of a possibly optional text-format union. */
type ParsedTextFormat<Format> = [Format] extends [never] ? null : Format extends AutoParseableTextFormat<infer ParsedT> ? ParsedT : Format extends ResponseFormatTextJSONSchemaConfig ? unknown : null;
/**
 * Resolves the type of `output_parsed` / `content[].parsed` for the given params.
 *
 * This must stay in sync with `isParseableResponseFormat()` and
 * `parseResponseFormatContent()`: formats built by an SDK helper carry their parsed
 * type in the brand, while a raw `{ type: 'json_schema' }` format is parsed with
 * `JSON.parse()` and so can only be described as `unknown`.
 */
export type ExtractParsedContentFromParams<Params extends TextConfigParams> = ParsedTextFormat<NonNullable<Params['text']>['format']>;
/**
 * Adds parsed-output fields to a response, invoking parsers only when its request
 * includes an auto-parseable text format or strict function tool.
 */
export declare function maybeParseResponse<Params extends ResponseCreateParamsBase | null, ParsedT = Params extends null ? null : ExtractParsedContentFromParams<NonNullable<Params>>>(response: Response, params: Params): ParsedResponse<ParsedT>;
/**
 * Parses completed response text and strict function-tool arguments, matching
 * namespaced functions by both namespace and name.
 *
 * Incomplete or nonterminal responses keep their parsed values as `null`, and
 * `output_parsed` returns the first successfully parsed output-text item.
 */
export declare function parseResponse<Params extends ResponseCreateParamsBase, ParsedT = ExtractParsedContentFromParams<Params>>(response: Response, params: Params): ParsedResponse<ParsedT>;
/** Returns whether the request includes an auto-parseable text format or strict function tool. */
export declare function hasAutoParseableInput(params: ResponseCreateParamsWithTools): boolean;
/** Type-level details used to infer a Responses API function tool's parser and callback. */
type ToolOptions = {
    /** Model-visible function name used to match generated tool calls. */
    name: string;
    /** Parsed argument value accepted by the optional execution callback. */
    arguments: any;
    /** Optional callback metadata associated with the parsed function tool. */
    function?: ((args: any) => any) | undefined;
};
/** A Responses API function tool with an argument parser and optional executable callback. */
export type AutoParseableResponseTool<OptionsT extends ToolOptions, HasFunction = OptionsT['function'] extends (...args: never[]) => unknown ? true : false> = FunctionTool & {
    /** Type-only marker for parsed tool arguments; this property does not exist at runtime. */
    __arguments: OptionsT['arguments'];
    /** Type-only marker for the function name; this property does not exist at runtime. */
    __name: OptionsT['name'];
    /** Non-enumerable SDK marker identifying a tool with an attached argument parser. */
    $brand: 'auto-parseable-tool';
    /** Optional callback available to helpers that execute parsed function tools. */
    $callback: ((args: OptionsT['arguments']) => any) | undefined;
    /** Parses the raw JSON argument string into the function's typed argument value. */
    $parseRaw(args: string): OptionsT['arguments'];
};
/** Copies a Responses API function tool and attaches non-enumerable parser and callback metadata. */
export declare function makeParseableResponseTool<OptionsT extends ToolOptions>(tool: FunctionTool, { parser, callback, }: {
    /** Converts the raw JSON argument string into the function's typed argument value. */
    parser: (content: string) => OptionsT['arguments'];
    /** Optional callback available to helpers that execute the parsed function. */
    callback: ((args: OptionsT['arguments']) => any) | undefined;
}): AutoParseableResponseTool<OptionsT>;
/** Returns whether a Responses API tool carries the SDK's argument-parser marker. */
export declare function isAutoParsableTool(tool: any): tool is AutoParseableResponseTool<any>;
/** Matches a response function call to a strict or auto-parseable tool by namespace and name. */
export declare function shouldParseToolCall(params: ResponseCreateParamsNonStreaming | null | undefined, toolCall: ResponseFunctionToolCall): boolean;
/**
 * Validates that compatible chat completion tools can be automatically parsed.
 *
 * @throws {OpenAIError} If a tool is not a function or is missing `strict: true`.
 */
export declare function validateInputTools(tools: ChatCompletionTool[] | undefined): void;
/** Replaces `output_text` with the concatenated text from every response output message. */
export declare function addOutputText(rsp: Response): void;
export {};
//# sourceMappingURL=ResponsesParser.d.mts.map