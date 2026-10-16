import { OpenAIError } from "../error.mjs";
import { isParseableResponseFormat, parseResponseFormatContent } from "../lib/parser.mjs";
/**
 * Adds parsed-output fields to a response, invoking parsers only when its request
 * includes an auto-parseable text format or strict function tool.
 */
export function maybeParseResponse(response, params) {
    if (!params || !hasAutoParseableInput(params)) {
        const parsed = {
            ...response,
            output_parsed: null,
            output: response.output.map((item) => {
                if (item.type === 'function_call') {
                    return {
                        ...item,
                        parsed_arguments: null,
                    };
                }
                if (item.type === 'message') {
                    return {
                        ...item,
                        content: item.content.map((content) => ({
                            ...content,
                            parsed: null,
                        })),
                    };
                }
                return item;
            }),
        };
        if (needsOutputText(response, parsed)) {
            // SAFETY: The copy retains every response field and only adds parsed metadata; addOutputText accepts that original response structure.
            addOutputText(parsed);
        }
        return parsed;
    }
    return parseResponse(response, params);
}
/**
 * Parses completed response text and strict function-tool arguments, matching
 * namespaced functions by both namespace and name.
 *
 * Incomplete or nonterminal responses keep their parsed values as `null`, and
 * `output_parsed` returns the first successfully parsed output-text item.
 */
export function parseResponse(response, params) {
    const shouldParse = !response.status || response.status === 'completed';
    const output = response.output.map((item) => {
        if (item.type === 'function_call') {
            return shouldParse ? parseToolCall(params, item) : { ...item, parsed_arguments: null };
        }
        if (item.type === 'message') {
            const content = item.content.map((content) => {
                if (content.type === 'output_text') {
                    return {
                        ...content,
                        parsed: shouldParse ? parseTextFormat(params, content.text) : null,
                    };
                }
                return content;
            });
            return {
                ...item,
                content,
            };
        }
        return item;
    });
    const parsed = { ...response, output };
    if (needsOutputText(response, parsed)) {
        addOutputText(parsed);
    }
    Object.defineProperty(parsed, 'output_parsed', {
        enumerable: true,
        get() {
            for (const output of parsed.output) {
                if (output.type !== 'message') {
                    continue;
                }
                for (const content of output.content) {
                    if (content.type === 'output_text' && content.parsed !== null) {
                        return content.parsed;
                    }
                }
            }
            return null;
        },
    });
    // SAFETY: The output_parsed getter was installed immediately above and returns the first parsed content or null.
    return parsed;
}
function parseTextFormat(params, content) {
    return parseResponseFormatContent(params.text?.format, content);
}
/** Returns whether the request includes an auto-parseable text format or strict function tool. */
export function hasAutoParseableInput(params) {
    if (isParseableResponseFormat(params.text?.format)) {
        return true;
    }
    return (Array.isArray(params.tools) &&
        params.tools.some((tool) => isAutoParsableTool(tool) ||
            (tool.type === 'function' && tool.strict === true) ||
            (tool.type === 'namespace' &&
                tool.tools.some((nested) => nested.type === 'function' && (isAutoParsableTool(nested) || nested.strict === true)))));
}
/** Copies a Responses API function tool and attaches non-enumerable parser and callback metadata. */
export function makeParseableResponseTool(tool, { parser, callback, }) {
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
    // SAFETY: The non-enumerable parser brand and callbacks were installed on this copied tool immediately above.
    return obj;
}
/** Returns whether a Responses API tool carries the SDK's argument-parser marker. */
export function isAutoParsableTool(tool) {
    return tool?.['$brand'] === 'auto-parseable-tool';
}
function getInputToolByName(input_tools, name, namespace) {
    for (const tool of input_tools) {
        if (namespace == null) {
            if (tool.type === 'function' && tool.name === name) {
                return tool;
            }
        }
        else if (tool.type === 'namespace' && tool.name === namespace) {
            return tool.tools.find((nested) => nested.type === 'function' && nested.name === name);
        }
    }
    return undefined;
}
function parseToolCall(params, toolCall) {
    const inputTool = getInputToolByName(params.tools ?? [], toolCall.name, toolCall.namespace);
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- Parsing replaces the initial null with an arbitrary caller-parser result, so unknown is required.
    let parsedArguments = null;
    if (isAutoParsableTool(inputTool)) {
        parsedArguments = inputTool.$parseRaw(toolCall.arguments);
    }
    else if (inputTool?.strict) {
        parsedArguments = parseResponseFormatContent({ type: 'json_schema', $parseRaw: undefined }, toolCall.arguments);
    }
    return {
        ...toolCall,
        parsed_arguments: parsedArguments,
    };
}
/** Matches a response function call to a strict or auto-parseable tool by namespace and name. */
export function shouldParseToolCall(params, toolCall) {
    if (!params) {
        return false;
    }
    const inputTool = getInputToolByName(params.tools ?? [], toolCall.name, toolCall.namespace);
    return isAutoParsableTool(inputTool) || inputTool?.strict || false;
}
/**
 * Validates that compatible chat completion tools can be automatically parsed.
 *
 * @throws {OpenAIError} If a tool is not a function or is missing `strict: true`.
 */
export function validateInputTools(tools) {
    for (const tool of tools ?? []) {
        if (tool.type !== 'function') {
            throw new OpenAIError(`Currently only \`function\` tool types support auto-parsing; Received \`${tool.type}\``);
        }
        if (tool.function.strict !== true) {
            throw new OpenAIError(`The \`${tool.function.name}\` tool is not marked with \`strict: true\`. Only strict function tools can be auto-parsed`);
        }
    }
}
function needsOutputText(response, target) {
    return !Object.getOwnPropertyDescriptor(response, 'output_text') || target.output_text == null;
}
/** Replaces `output_text` with the concatenated text from every response output message. */
export function addOutputText(rsp) {
    const texts = [];
    for (const output of rsp.output) {
        if (output.type !== 'message') {
            continue;
        }
        for (const content of output.content) {
            if (content.type === 'output_text') {
                texts.push(content.text);
            }
        }
    }
    rsp.output_text = texts.join('');
}
//# sourceMappingURL=ResponsesParser.mjs.map