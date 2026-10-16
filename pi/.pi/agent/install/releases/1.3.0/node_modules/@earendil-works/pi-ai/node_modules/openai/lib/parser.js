"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isChatCompletionFunctionTool = isChatCompletionFunctionTool;
exports.makeParseableResponseFormat = makeParseableResponseFormat;
exports.makeParseableTextFormat = makeParseableTextFormat;
exports.isAutoParsableResponseFormat = isAutoParsableResponseFormat;
exports.isParseableResponseFormat = isParseableResponseFormat;
exports.parseResponseFormatContent = parseResponseFormatContent;
exports.makeParseableTool = makeParseableTool;
exports.isAutoParsableTool = isAutoParsableTool;
exports.maybeParseChatCompletion = maybeParseChatCompletion;
exports.parseChatCompletion = parseChatCompletion;
exports.shouldParseToolCall = shouldParseToolCall;
exports.hasAutoParseableInput = hasAutoParseableInput;
exports.assertToolCallsAreChatCompletionFunctionToolCalls = assertToolCallsAreChatCompletionFunctionToolCalls;
exports.validateInputTools = validateInputTools;
const error_1 = require("../error.js");
/** Returns whether an optional chat completion tool contains a function-tool definition. */
function isChatCompletionFunctionTool(tool) {
    return tool !== undefined && 'function' in tool && tool.function !== undefined;
}
/** Copies a JSON Schema response format and attaches a non-enumerable structured-output parser. */
function makeParseableResponseFormat(response_format, parser) {
    const obj = { ...response_format, type: 'json_schema' };
    obj.json_schema = { ...obj.json_schema };
    // SAFETY: The fresh copy may retain a caller-provided toJSON property; deleting it prevents serialization from replacing the validated schema.
    delete obj.toJSON;
    // SAFETY: The fresh copy may retain a caller-provided toJSON property; deleting it prevents serialization from replacing the validated schema.
    delete obj.json_schema.toJSON;
    Object.defineProperties(obj, {
        $brand: {
            value: 'auto-parseable-response-format',
            enumerable: false,
        },
        $parseRaw: {
            value: parser,
            enumerable: false,
        },
    });
    // SAFETY: Object.defineProperties installed the parser brand and callbacks required by the returned helper type.
    return obj;
}
/** Copies a Responses API text format and attaches a non-enumerable structured-output parser. */
function makeParseableTextFormat(response_format, parser) {
    const obj = { ...response_format, type: 'json_schema' };
    // SAFETY: The fresh copy may retain a caller-provided toJSON property; deleting it prevents serialization from replacing the validated schema.
    delete obj.toJSON;
    Object.defineProperties(obj, {
        $brand: {
            value: 'auto-parseable-response-format',
            enumerable: false,
        },
        $parseRaw: {
            value: parser,
            enumerable: false,
        },
    });
    // SAFETY: Object.defineProperties installed the parser brand and callbacks required by the returned helper type.
    return obj;
}
/**
 * Whether the given format was built by an SDK helper (e.g. `zodResponseFormat()`)
 * and therefore carries its own `$parseRaw` callback.
 *
 * Prefer {@link isParseableResponseFormat} when deciding whether output should be
 * parsed at all; raw `{ type: 'json_schema' }` formats are parsed too, but are not
 * branded.
 */
function isAutoParsableResponseFormat(response_format) {
    return response_format?.['$brand'] === 'auto-parseable-response-format';
}
/**
 * The canonical definition of an auto-parseable response format, covering both the
 * Chat Completions `response_format` and the Responses `text.format` shapes.
 *
 * Every gate that decides whether output should be parsed must go through this
 * predicate so the runtime, the streaming events and
 * {@link ExtractParsedContentFromParams} cannot drift apart.
 */
function isParseableResponseFormat(format) {
    // SAFETY: Only the optional discriminator is read; arbitrary input is not treated as a validated response-format schema.
    return isAutoParsableResponseFormat(format) || format?.type === 'json_schema';
}
/**
 * The canonical parser for auto-parseable response formats. This is the only place
 * that chooses between an existing `$parseRaw` callback and generic `JSON.parse()`.
 *
 * Returns `null` for formats that are not auto-parseable.
 */
function parseResponseFormatContent(format, content) {
    if (!isParseableResponseFormat(format)) {
        return null;
    }
    if (typeof format === 'object' &&
        format !== null &&
        '$parseRaw' in format &&
        typeof format.$parseRaw === 'function') {
        // SAFETY: The format's captured parser owns the ParsedT output contract; this function forwards its result without coercion.
        return format.$parseRaw(content);
    }
    try {
        // SAFETY: ParsedT represents the caller's response schema; JSON syntax is checked here and schema validation remains with the configured format.
        return JSON.parse(content);
    }
    catch (error) {
        if (error instanceof SyntaxError) {
            throw new SyntaxError('Error reading response: invalid structured output JSON.');
        }
        throw error;
    }
}
/** Copies a function tool and attaches non-enumerable parsing and callback metadata. */
function makeParseableTool(tool, { parser, callback }) {
    const obj = { ...tool };
    Object.defineProperties(obj, {
        $brand: {
            value: 'auto-parseable-tool',
            enumerable: false,
        },
        $parseRaw: {
            value: parser,
            enumerable: false,
        },
        $callback: {
            value: callback,
            enumerable: false,
        },
    });
    // SAFETY: Object.defineProperties installed the parser brand and callbacks required by the returned helper type.
    return obj;
}
/** Returns whether a Chat Completions tool carries the SDK's argument-parser marker. */
function isAutoParsableTool(tool) {
    return tool?.['$brand'] === 'auto-parseable-tool';
}
/**
 * Adds parsed-content fields to a chat completion, invoking parsers only when the
 * request includes an auto-parseable response format or a strict function tool.
 */
function maybeParseChatCompletion(completion, params) {
    if (!params || !hasAutoParseableInput(params)) {
        return {
            ...completion,
            choices: completion.choices.map((choice) => ({
                ...choice,
                message: {
                    ...choice.message,
                    parsed: null,
                    ...(choice.message.tool_calls
                        ? {
                            tool_calls: choice.message.tool_calls,
                        }
                        : undefined),
                },
            })),
        };
    }
    return parseChatCompletion(completion, params);
}
/**
 * Parses structured assistant content and strict function-tool arguments.
 *
 * @throws {LengthFinishReasonError} If generation stopped at its token limit.
 * @throws {ContentFilterFinishReasonError} If generation stopped because of content filtering.
 * @throws {OpenAIError} If the completion contains an unsupported tool-call type.
 */
function parseChatCompletion(completion, params) {
    const choices = completion.choices.map((choice) => {
        if (choice.finish_reason === 'length') {
            throw new error_1.LengthFinishReasonError();
        }
        if (choice.finish_reason === 'content_filter') {
            throw new error_1.ContentFilterFinishReasonError();
        }
        return {
            ...choice,
            message: {
                ...choice.message,
                ...(choice.message.tool_calls
                    ? {
                        tool_calls: choice.message.tool_calls?.map((toolCall) => parseToolCall(params, toolCall)) ?? undefined,
                    }
                    : undefined),
                parsed: choice.message.content !== null &&
                    choice.message.content !== undefined &&
                    !choice.message.refusal &&
                    (choice.message.content !== '' ||
                        (!choice.message.tool_calls?.length && !choice.message.function_call))
                    ? parseResponseFormat(params, choice.message.content)
                    : null,
            },
        };
    });
    return { ...completion, choices };
}
function parseResponseFormat(params, content) {
    return parseResponseFormatContent(params.response_format, content);
}
function parseToolCall(params, toolCall) {
    if (toolCall.type === 'custom') {
        return toolCall;
    }
    if (toolCall.type !== 'function') {
        // SAFETY: This branch handles unsupported JavaScript discriminators that the current TypeScript union excludes; the value is only used in the error.
        const unsupportedType = toolCall.type;
        throw new error_1.OpenAIError(`Currently only \`function\` and \`custom\` tool calls are supported; Received \`${unsupportedType}\``);
    }
    // SAFETY: The find predicate checks the function-tool discriminator before matching its name; the cast retains that narrowing through find.
    const inputTool = params.tools?.find((inputTool) => isChatCompletionFunctionTool(inputTool) && inputTool.function?.name === toolCall.function.name); // TS doesn't narrow based on isChatCompletionTool
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The parser callback may return any value; null only represents an unparsed tool call.
    let parsedArguments = null;
    if (isAutoParsableTool(inputTool)) {
        parsedArguments = inputTool.$parseRaw(toolCall.function.arguments);
    }
    else if (inputTool?.function.strict) {
        parsedArguments = parseResponseFormatContent({ type: 'json_schema', $parseRaw: undefined }, toolCall.function.arguments);
    }
    return {
        ...toolCall,
        function: {
            ...toolCall.function,
            parsed_arguments: parsedArguments,
        },
    };
}
/** Returns whether a tool call matches a strict or auto-parseable function in the request. */
function shouldParseToolCall(params, 
// accepts partially accumulated tool calls so streaming snapshots can be checked as they build up
toolCall) {
    if (!params || !('tools' in params) || !params.tools || toolCall.type !== 'function') {
        return false;
    }
    const inputTool = params.tools?.find((inputTool) => isChatCompletionFunctionTool(inputTool) && inputTool.function?.name === toolCall.function?.name);
    return (isChatCompletionFunctionTool(inputTool) &&
        (isAutoParsableTool(inputTool) || inputTool?.function.strict || false));
}
/** Returns whether the request contains an auto-parseable response format or strict function tool. */
function hasAutoParseableInput(params) {
    if (isParseableResponseFormat(params.response_format)) {
        return true;
    }
    return (params.tools?.some((t) => isAutoParsableTool(t) || (t.type === 'function' && t.function.strict === true)) ?? false);
}
/**
 * Narrows completion tool calls to function calls supported by parsing helpers.
 *
 * @throws {OpenAIError} If any tool call has a non-function type.
 */
function assertToolCallsAreChatCompletionFunctionToolCalls(toolCalls) {
    for (const toolCall of toolCalls || []) {
        if (toolCall.type !== 'function') {
            throw new error_1.OpenAIError(`Currently only \`function\` tool calls are supported; Received \`${toolCall.type}\``);
        }
    }
}
/**
 * Validates strict function tools while preserving supported custom tools.
 *
 * @throws {OpenAIError} If a tool is unsupported or a function is missing `strict: true`.
 */
function validateInputTools(tools) {
    for (const tool of tools ?? []) {
        if (tool.type === 'custom') {
            continue;
        }
        if (tool.type !== 'function') {
            // SAFETY: This branch handles unsupported JavaScript discriminators that the current TypeScript union excludes; the value is only used in the error.
            const unsupportedType = tool.type;
            throw new error_1.OpenAIError(`Currently only \`function\` and \`custom\` tool types are supported; Received \`${unsupportedType}\``);
        }
        if (tool.function.strict !== true) {
            throw new error_1.OpenAIError(`The \`${tool.function.name}\` tool is not marked with \`strict: true\`. Only strict function tools can be auto-parsed`);
        }
    }
}
//# sourceMappingURL=parser.js.map