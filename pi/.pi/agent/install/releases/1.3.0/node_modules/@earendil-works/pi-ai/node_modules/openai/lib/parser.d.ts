import type { ChatCompletion, ChatCompletionCreateParams, ChatCompletionCreateParamsBase, ChatCompletionFunctionTool, ChatCompletionMessage, ChatCompletionMessageFunctionToolCall, ChatCompletionMessageToolCall, ChatCompletionStreamingToolRunnerParams, ChatCompletionStreamingToolRunnerParamsWithContext, ChatCompletionStreamParams, ChatCompletionToolRunnerParams, ChatCompletionToolRunnerParamsWithContext, ParsedChatCompletion } from "../resources/chat/completions.js";
import type { ResponseFormatTextJSONSchemaConfig } from "../resources/responses/responses.js";
import type { ResponseFormatJSONSchema } from "../resources/shared.js";
/** Chat completion creation, parsing, streaming, or tool-runner request parameters. */
type AnyChatCompletionCreateParams = ChatCompletionCreateParams | ChatCompletionToolRunnerParams<any> | ChatCompletionToolRunnerParamsWithContext<any, any> | ChatCompletionStreamingToolRunnerParams<any> | ChatCompletionStreamingToolRunnerParamsWithContext<any, any> | ChatCompletionStreamParams;
/** Extracts the element type from an array while preserving non-array values. */
type Unpacked<T> = T extends (infer U)[] ? U : T;
/** One optional tool definition accepted by a chat completion request. */
type ToolCall = Unpacked<ChatCompletionCreateParamsBase['tools']>;
/** Returns whether an optional chat completion tool contains a function-tool definition. */
export declare function isChatCompletionFunctionTool(tool: ToolCall): tool is ChatCompletionFunctionTool;
/** Infers parsed output for each member of a possibly optional response-format union. */
type ParsedResponseFormat<Format> = [Format] extends [never] ? null : Format extends AutoParseableResponseFormat<infer ParsedT> ? ParsedT : Format extends ResponseFormatJSONSchema ? unknown : null;
/**
 * Resolves the type of `message.parsed` / `content[].parsed` for the given params.
 *
 * This must stay in sync with {@link isParseableResponseFormat} and
 * {@link parseResponseFormatContent}: formats built by an SDK helper carry their
 * parsed type in the brand, while a raw `{ type: 'json_schema' }` format is parsed
 * with `JSON.parse()` and so can only be described as `unknown`.
 */
export type ExtractParsedContentFromParams<Params extends AnyChatCompletionCreateParams> = ParsedResponseFormat<Params['response_format']>;
/** A Chat Completions JSON Schema response format with an attached structured-output parser. */
export type AutoParseableResponseFormat<ParsedT> = ResponseFormatJSONSchema & {
    /** Type-only marker used to infer the parser's output; this property does not exist at runtime. */
    __output: ParsedT;
    /** Non-enumerable SDK marker identifying a response format with an attached parser. */
    $brand: 'auto-parseable-response-format';
    /** Parses the completed raw assistant text into the response format's output type. */
    $parseRaw(content: string): ParsedT;
};
/** Copies a JSON Schema response format and attaches a non-enumerable structured-output parser. */
export declare function makeParseableResponseFormat<ParsedT>(response_format: ResponseFormatJSONSchema, parser: (content: string) => ParsedT): AutoParseableResponseFormat<ParsedT>;
/** A Responses API JSON Schema text format with an attached structured-output parser. */
export type AutoParseableTextFormat<ParsedT> = ResponseFormatTextJSONSchemaConfig & {
    /** Type-only marker used to infer the parser's output; this property does not exist at runtime. */
    __output: ParsedT;
    /** Non-enumerable SDK marker identifying a text format with an attached parser. */
    $brand: 'auto-parseable-response-format';
    /** Parses completed output text into the text format's structured output type. */
    $parseRaw(content: string): ParsedT;
};
/** Copies a Responses API text format and attaches a non-enumerable structured-output parser. */
export declare function makeParseableTextFormat<ParsedT>(response_format: ResponseFormatTextJSONSchemaConfig, parser: (content: string) => ParsedT): AutoParseableTextFormat<ParsedT>;
/**
 * Whether the given format was built by an SDK helper (e.g. `zodResponseFormat()`)
 * and therefore carries its own `$parseRaw` callback.
 *
 * Prefer {@link isParseableResponseFormat} when deciding whether output should be
 * parsed at all; raw `{ type: 'json_schema' }` formats are parsed too, but are not
 * branded.
 */
export declare function isAutoParsableResponseFormat<ParsedT>(response_format: any): response_format is AutoParseableResponseFormat<ParsedT>;
/**
 * The canonical definition of an auto-parseable response format, covering both the
 * Chat Completions `response_format` and the Responses `text.format` shapes.
 *
 * Every gate that decides whether output should be parsed must go through this
 * predicate so the runtime, the streaming events and
 * {@link ExtractParsedContentFromParams} cannot drift apart.
 */
export declare function isParseableResponseFormat(format: unknown): boolean;
/**
 * The canonical parser for auto-parseable response formats. This is the only place
 * that chooses between an existing `$parseRaw` callback and generic `JSON.parse()`.
 *
 * Returns `null` for formats that are not auto-parseable.
 */
export declare function parseResponseFormatContent<ParsedT>(format: unknown, content: string): ParsedT | null;
/** Type-level details used to infer a chat function tool's parser and execution callback. */
type ToolOptions = {
    /** Model-visible function name used to match generated tool calls. */
    name: string;
    /** Parsed argument value accepted by the optional execution callback. */
    arguments: any;
    /** Optional callback invoked by chat completion tool-running helpers. */
    function?: ((args: any) => any) | undefined;
};
/** A Chat Completions function tool with an argument parser and optional executable callback. */
export type AutoParseableTool<OptionsT extends ToolOptions, HasFunction = OptionsT['function'] extends (...args: never[]) => unknown ? true : false> = ChatCompletionFunctionTool & {
    /** Type-only marker for parsed tool arguments; this property does not exist at runtime. */
    __arguments: OptionsT['arguments'];
    /** Type-only marker for the tool name; this property does not exist at runtime. */
    __name: OptionsT['name'];
    /** Type-only marker indicating whether a runnable callback was supplied. */
    __hasFunction: HasFunction;
    /** Non-enumerable SDK marker identifying a tool with an attached argument parser. */
    $brand: 'auto-parseable-tool';
    /** Optional runnable callback used by `.runTools()` after arguments are parsed. */
    $callback: ((args: OptionsT['arguments']) => any) | undefined;
    /** Parses the raw JSON argument string into the callback's typed argument value. */
    $parseRaw(args: string): OptionsT['arguments'];
};
/** Parser and optional callback supplied when creating a custom chat function tool. */
type ToolParserOptions<OptionsT extends ToolOptions> = {
    /** Converts the raw JSON argument string into the tool's typed argument value. */
    parser: (content: string) => OptionsT['arguments'];
    /** Optional callback invoked by a chat completion tool runner. */
    callback: ((args: OptionsT['arguments']) => any) | undefined;
};
/** Creates a runnable function tool with a guaranteed execution callback. */
export declare function makeParseableTool<OptionsT extends ToolOptions>(tool: ChatCompletionFunctionTool, options: ToolParserOptions<OptionsT> & {
    /** Callback invoked with the parsed tool arguments. */
    callback: (args: OptionsT['arguments']) => any;
}): AutoParseableTool<OptionsT, true>;
/** Creates a parse-only function tool without an execution callback. */
export declare function makeParseableTool<OptionsT extends ToolOptions>(tool: ChatCompletionFunctionTool, options: ToolParserOptions<OptionsT> & {
    /** No execution callback is attached to this tool. */
    callback: undefined;
}): AutoParseableTool<OptionsT, false>;
/** Creates a function tool whose execution callback may be unavailable. */
export declare function makeParseableTool<OptionsT extends ToolOptions>(tool: ChatCompletionFunctionTool, options: ToolParserOptions<OptionsT>): AutoParseableTool<OptionsT, boolean>;
/** Returns whether a Chat Completions tool carries the SDK's argument-parser marker. */
export declare function isAutoParsableTool(tool: any): tool is AutoParseableTool<any>;
/**
 * Adds parsed-content fields to a chat completion, invoking parsers only when the
 * request includes an auto-parseable response format or a strict function tool.
 */
export declare function maybeParseChatCompletion<Params extends ChatCompletionCreateParams | null, ParsedT = Params extends null ? null : ExtractParsedContentFromParams<NonNullable<Params>>>(completion: ChatCompletion, params: Params): ParsedChatCompletion<ParsedT>;
/**
 * Parses structured assistant content and strict function-tool arguments.
 *
 * @throws {LengthFinishReasonError} If generation stopped at its token limit.
 * @throws {ContentFilterFinishReasonError} If generation stopped because of content filtering.
 * @throws {OpenAIError} If the completion contains an unsupported tool-call type.
 */
export declare function parseChatCompletion<Params extends ChatCompletionCreateParams, ParsedT = ExtractParsedContentFromParams<Params>>(completion: ChatCompletion, params: Params): ParsedChatCompletion<ParsedT>;
/** Returns whether a tool call matches a strict or auto-parseable function in the request. */
export declare function shouldParseToolCall(params: ChatCompletionCreateParams | null | undefined, toolCall: {
    type?: ChatCompletionMessageToolCall['type'];
    function?: {
        name?: string;
    };
}): boolean;
/** Returns whether the request contains an auto-parseable response format or strict function tool. */
export declare function hasAutoParseableInput(params: AnyChatCompletionCreateParams): boolean;
/**
 * Narrows completion tool calls to function calls supported by parsing helpers.
 *
 * @throws {OpenAIError} If any tool call has a non-function type.
 */
export declare function assertToolCallsAreChatCompletionFunctionToolCalls(toolCalls: ChatCompletionMessage['tool_calls']): asserts toolCalls is ChatCompletionMessageFunctionToolCall[];
/**
 * Validates strict function tools while preserving supported custom tools.
 *
 * @throws {OpenAIError} If a tool is unsupported or a function is missing `strict: true`.
 */
export declare function validateInputTools(tools: ChatCompletionCreateParamsBase['tools']): void;
export {};
//# sourceMappingURL=parser.d.ts.map