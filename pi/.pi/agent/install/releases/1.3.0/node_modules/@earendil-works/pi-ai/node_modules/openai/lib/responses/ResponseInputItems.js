"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toResponseInputItems = toResponseInputItems;
exports.toResponseInputItem = toResponseInputItem;
/**
 * Normalizes a mixed array of stored response history items into clean
 * `ResponseInputItem`s that can be sent back to `responses.create()`. Known items
 * that cannot be replayed without changing their meaning are omitted. SDK-only
 * parsed values are removed without changing the stored items.
 *
 * @throws {TypeError} If an item type is not supported by the installed SDK.
 */
function toResponseInputItems(items) {
    const inputItems = [];
    for (const item of items) {
        const inputItem = toResponseInputItem(item);
        if (inputItem) {
            inputItems.push(inputItem);
        }
    }
    return inputItems;
}
/**
 * Normalizes a stored response history item into a clean `ResponseInputItem`, or
 * returns `null` when a known item cannot be replayed without changing its
 * meaning. SDK-only parsed values are removed without changing the stored item.
 *
 * @throws {TypeError} If the item type is not supported by the installed SDK.
 */
function toResponseInputItem(item) {
    switch (item.type) {
        case 'message': {
            if (item.role !== 'assistant' || !('id' in item) || !Array.isArray(item.content)) {
                return stripCreatedBy(item);
            }
            const content = item.content.map((part) => {
                if ((part.type === 'output_text' || part.type === 'refusal') && 'parsed' in part) {
                    const { parsed: _parsed, ...inputPart } = part;
                    return inputPart;
                }
                return part;
            });
            if (content.every((part, index) => part === item.content[index])) {
                return stripCreatedBy(item);
            }
            return { ...stripCreatedBy(item), content };
        }
        case 'function_call': {
            const inputItem = stripCreatedBy(item);
            if (!('parsed_arguments' in inputItem)) {
                return inputItem;
            }
            const { parsed_arguments: _parsedArguments, ...withoutParsedArguments } = inputItem;
            return withoutParsedArguments;
        }
        case 'additional_tools': {
            if (item.role !== 'developer') {
                return null;
            }
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            return stripCreatedBy(item);
        }
        case 'shell_call_output': {
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            const output = item.output.map((chunk) => stripCreatedBy(chunk));
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            return {
                ...stripCreatedBy(item),
                output,
            };
        }
        case 'computer_call_output': {
            // SAFETY: Runtime API items may contain the output-only created_by field; this view permits removing it without changing the declared input type.
            const { created_by: _createdBy, ...withoutCreatedBy } = item;
            if (withoutCreatedBy.status === 'failed') {
                return null;
            }
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            return withoutCreatedBy;
        }
        case 'custom_tool_call_output': {
            if ('status' in item && item.status !== 'completed') {
                return null;
            }
            // SAFETY: Runtime API items may contain the output-only created_by field; this view permits removing it without changing the declared input type.
            const { created_by: _createdBy, status: _status, ...inputItem } = item;
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            return inputItem;
        }
        case 'apply_patch_call':
        case 'apply_patch_call_output':
        case 'code_interpreter_call':
        case 'compaction':
        case 'compaction_trigger':
        case 'computer_call':
        case 'configuration_update':
        case 'custom_tool_call':
        case 'file_search_call':
        case 'function_call_output':
        case 'image_generation_call':
        case 'item_reference':
        case 'local_shell_call':
        case 'local_shell_call_output':
        case 'mcp_approval_request':
        case 'mcp_approval_response':
        case 'mcp_call':
        case 'mcp_list_tools':
        case 'program':
        case 'program_output':
        case 'reasoning':
        case 'shell_call':
        case 'tool_search_call':
        case 'tool_search_output':
        case 'web_search_call':
        case null:
        case undefined: {
            // SAFETY: The item discriminator selects its matching input type; removing output-only provenance fields preserves the remaining wire input fields.
            return stripCreatedBy(item);
        }
        default: {
            return assertNever(item);
        }
    }
}
function stripCreatedBy(item) {
    if (!('created_by' in item)) {
        return item;
    }
    // SAFETY: Runtime API items may contain the output-only created_by field; this view permits removing it without changing the declared input type.
    const { created_by: _createdBy, ...rest } = item;
    // SAFETY: Only the optional output provenance property was removed; every field belonging to the generic input contract remains.
    return rest;
}
function assertNever(value) {
    // SAFETY: This always-throwing path reports a runtime discriminator outside the current TypeScript union without accepting it as a valid item.
    const type = value.type;
    throw new TypeError(`Unsupported response item type: ${String(type)}`);
}
//# sourceMappingURL=ResponseInputItems.js.map