var _ChatCompletionStream_instances, _ChatCompletionStream_params, _ChatCompletionStream_rejectsUnfinishedTurns, _ChatCompletionStream_audioDoneChoiceIndexes, _ChatCompletionStream_choiceEventStates, _ChatCompletionStream_currentChatCompletionSnapshot, _ChatCompletionStream_hasAutoParseableTool, _ChatCompletionStream_partialJSONParseBudget, _ChatCompletionStream_beginRequest, _ChatCompletionStream_getChoiceEventState, _ChatCompletionStream_addChunk, _ChatCompletionStream_emitToolCallDoneEvent, _ChatCompletionStream_emitContentDoneEvents, _ChatCompletionStream_validateStructuredSnapshots, _ChatCompletionStream_endRequest, _ChatCompletionStream_accumulateChatCompletion;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../internal/tslib.mjs";
import { MalformedJSON, partialParse } from "../_vendor/partial-json-parser/parser.mjs";
import { APIError, ContentFilterFinishReasonError, LengthFinishReasonError, OpenAIError } from "../error.mjs";
import { observeJSONRequestBody } from "../internal/request-options.mjs";
import { uuid4 } from "../internal/utils/uuid.mjs";
import { hasOwn } from "../internal/utils/values.mjs";
import { hasAutoParseableInput, isAutoParsableTool, isChatCompletionFunctionTool, isParseableResponseFormat, maybeParseChatCompletion, parseResponseFormatContent, shouldParseToolCall, } from "../lib/parser.mjs";
import { Stream } from "../streaming.mjs";
import { AbstractChatCompletionRunner } from "./AbstractChatCompletionRunner.mjs";
// oxlint-disable-next-line anti-slop/no-unknown-returns -- Partial JSON may have any shape; callers validate or parse it against their response schema.
function parseStructuredStreamingJSON(content) {
    try {
        return partialParse(content);
    }
    catch (error) {
        if (error instanceof MalformedJSON || error instanceof SyntaxError) {
            return parseResponseFormatContent({ type: 'json_schema', $parseRaw: undefined }, content);
        }
        throw error;
    }
}
// Keep message records readable as empty chunks by older SDKs. Their finalizer
// overwrites `object`, so the encoded payload does not leak into completions.
const CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX = 'chat.completion.chunk.message:';
/** Encodes a tool-result message as a backwards-compatible, empty completion chunk. */
export function makeChatCompletionReadableStreamMessageChunk(chunk, message, toolCallIds) {
    const payload = {
        type: 'message',
        message,
        // Spread creates an own data property without invoking inherited setters or changing the object prototype.
        ...(toolCallIds ? { tool_call_ids: toolCallIds } : {}),
    };
    return {
        id: chunk.id,
        choices: [],
        created: chunk.created,
        model: chunk.model,
        object: `${CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX}${JSON.stringify(payload)}`,
    };
}
function isChatCompletionReadableStreamMessage(item) {
    return (('type' in item && item.type === 'message' && 'message' in item) ||
        ('object' in item &&
            typeof item.object === 'string' &&
            item.object.startsWith(CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX)));
}
function getChatCompletionReadableStreamMessage(item) {
    if ('type' in item) {
        return item;
    }
    // SAFETY: This decoder reads the SDK's tagged readable-stream envelope; JSON parsing restores its serialized message fields for the stream accumulator.
    return JSON.parse(item.object.slice(CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX.length));
}
// The Chat Completions schema limits n to 128. Replayed streams do not retain
// request parameters, so apply that choice limit independently and use the same
// conservative ceiling to prevent sparse tool-call arrays from growing unbounded.
const MAX_STREAM_CHOICES = 128;
const MAX_STREAM_TOOL_CALLS = 128;
const MAX_PARTIAL_JSON_BYTES = 16 * 1024 * 1024;
const MAX_PARTIAL_JSON_FRAGMENTS = 65536;
const MAX_PARTIAL_JSON_DEPTH = 128;
const MAX_PARTIAL_JSON_PARSE_WORK = 64 * 1024 * 1024;
const EAGER_PARTIAL_JSON_BYTES = 1024;
function createPartialJSONParseState() {
    return {
        bytes: 0,
        depth: 0,
        fragments: 0,
        work: 0,
        escaped: false,
        has_non_whitespace: false,
        in_string: false,
        last_parsed_bytes: 0,
        pending_high_surrogate: false,
    };
}
function recordPartialJSONFragment(state, budget, fragment, validationWorkBudget) {
    if (budget.fragments >= MAX_PARTIAL_JSON_FRAGMENTS) {
        throw new OpenAIError('Chat completion stream exceeded its structured JSON fragment limit');
    }
    let bytes = 0;
    let { depth, escaped, has_non_whitespace: hasNonWhitespace, in_string: inString } = state;
    let completed = false;
    let firstCharacter = true;
    for (const character of fragment) {
        const previousBytes = bytes;
        const codePoint = character.codePointAt(0);
        if (firstCharacter && state.pending_high_surrogate && codePoint >= 56320 && codePoint <= 57343) {
            bytes += 1;
        }
        else if (codePoint <= 0x7f) {
            bytes += 1;
        }
        else if (codePoint <= 2047) {
            bytes += 2;
        }
        else if (codePoint <= 65535) {
            bytes += 3;
        }
        else {
            bytes += 4;
        }
        firstCharacter = false;
        if (budget.bytes + bytes > MAX_PARTIAL_JSON_BYTES) {
            throw new OpenAIError('Chat completion stream exceeded its structured JSON byte limit');
        }
        if (validationWorkBudget && validationWorkBudget.work + bytes > MAX_PARTIAL_JSON_PARSE_WORK) {
            validationWorkBudget.work += previousBytes;
            throw new OpenAIError('Chat completion stream exceeded its structured JSON parse-work limit');
        }
        if (character !== ' ' && character !== '\n' && character !== '\r' && character !== '\t') {
            hasNonWhitespace = true;
        }
        if (inString) {
            if (escaped) {
                escaped = false;
            }
            else if (character === '\\') {
                escaped = true;
            }
            else if (character === '"') {
                inString = false;
                completed || (completed = depth === 0);
            }
            continue;
        }
        if (character === '"') {
            inString = true;
        }
        else if (character === '{' || character === '[') {
            depth += 1;
            if (depth > MAX_PARTIAL_JSON_DEPTH) {
                throw new OpenAIError('Chat completion stream exceeded its structured JSON nesting depth limit');
            }
        }
        else if ((character === '}' || character === ']') && depth > 0) {
            depth -= 1;
            completed || (completed = depth === 0);
        }
    }
    state.bytes += bytes;
    state.fragments += 1;
    state.depth = depth;
    state.escaped = escaped;
    state.has_non_whitespace = hasNonWhitespace;
    state.in_string = inString;
    if (fragment.length > 0) {
        const finalCodeUnit = fragment.codePointAt(fragment.length - 1) ?? 0;
        state.pending_high_surrogate = finalCodeUnit >= 55296 && finalCodeUnit <= 56319;
    }
    budget.bytes += bytes;
    budget.fragments += 1;
    if (validationWorkBudget) {
        validationWorkBudget.work += bytes;
    }
    if (!hasNonWhitespace || bytes === 0) {
        return false;
    }
    const minimumGrowth = Math.max(EAGER_PARTIAL_JSON_BYTES, Math.floor(state.last_parsed_bytes / 2));
    if (state.bytes > EAGER_PARTIAL_JSON_BYTES &&
        !completed &&
        state.bytes - state.last_parsed_bytes < minimumGrowth) {
        return false;
    }
    return true;
}
function reservePartialJSONParse(state, budget) {
    if (budget.work + state.bytes > MAX_PARTIAL_JSON_PARSE_WORK) {
        return false;
    }
    budget.work += state.bytes;
    state.work += state.bytes;
    state.last_parsed_bytes = state.bytes;
    return true;
}
function captureStructuredJSONSnapshot(snapshot, property) {
    const descriptor = Object.getOwnPropertyDescriptor(snapshot, property);
    if (!descriptor) {
        // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
        let prototype = Object.getPrototypeOf(snapshot);
        for (let depth = 0; prototype !== null; depth += 1) {
            if (depth >= MAX_PARTIAL_JSON_DEPTH || Object.getOwnPropertyDescriptor(prototype, property)) {
                throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
            }
            // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
            prototype = Object.getPrototypeOf(prototype);
        }
        return undefined;
    }
    if (!('value' in descriptor) ||
        (typeof descriptor.value !== 'string' && descriptor.value !== null && descriptor.value !== undefined)) {
        throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
    }
    // SAFETY: The own data descriptor was explicitly checked to contain only a string, null, or undefined.
    return descriptor.value;
}
function captureStructuredMessageSnapshot(choice) {
    const descriptor = Object.getOwnPropertyDescriptor(choice, 'message');
    if (!descriptor ||
        !('value' in descriptor) ||
        typeof descriptor.value !== 'object' ||
        descriptor.value === null) {
        throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
    }
    // SAFETY: The choice contract supplies a message; the own data descriptor check prevents getters from changing which object is captured.
    return descriptor.value;
}
function captureSnapshotArray(snapshot, property, maximum, kind) {
    const descriptor = Object.getOwnPropertyDescriptor(snapshot, property);
    if (!descriptor) {
        // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
        let prototype = Object.getPrototypeOf(snapshot);
        for (let depth = 0; prototype !== null; depth += 1) {
            if (depth >= MAX_PARTIAL_JSON_DEPTH || Object.getOwnPropertyDescriptor(prototype, property)) {
                throw new OpenAIError(`Chat completion stream contains an unsafe snapshot ${kind} collection`);
            }
            // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
            prototype = Object.getPrototypeOf(prototype);
        }
        return undefined;
    }
    if (!('value' in descriptor) || !Array.isArray(descriptor.value)) {
        throw new OpenAIError(`Chat completion stream contains an unsafe snapshot ${kind} collection`);
    }
    const length = Object.getOwnPropertyDescriptor(descriptor.value, 'length');
    if (!length || !('value' in length) || !Number.isSafeInteger(length.value) || length.value > maximum) {
        throw new OpenAIError(`Chat completion stream exceeded its snapshot ${kind} limit`);
    }
    // SAFETY: The captured data property is an array with a checked bounded length; Item comes from the owning snapshot collection's contract.
    return descriptor.value;
}
function captureSnapshotArrayItem(array, index) {
    const descriptor = Object.getOwnPropertyDescriptor(array, index);
    if (!descriptor) {
        return undefined;
    }
    if (!('value' in descriptor)) {
        throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
    }
    // SAFETY: The descriptor is a data property of the typed Item array, so its value retains that array's element contract.
    return descriptor.value;
}
function mapCapturedSnapshotArray(array, maximum, kind, map) {
    const descriptor = Object.getOwnPropertyDescriptor(array, 'length');
    const length = descriptor && 'value' in descriptor ? descriptor.value : undefined;
    if (typeof length !== 'number' || !Number.isSafeInteger(length) || length < 0 || length > maximum) {
        throw new OpenAIError(`Chat completion stream exceeded its snapshot ${kind} limit`);
    }
    const mapped = [];
    mapped.length = length;
    for (let index = 0; index < length; index += 1) {
        const item = Object.getOwnPropertyDescriptor(array, index);
        if (!item) {
            continue;
        }
        if (!('value' in item)) {
            throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
        }
        // SAFETY: The descriptor is a data property of the typed Item array, so its value retains that array's element contract.
        mapped[index] = map(item.value, index);
    }
    return mapped;
}
function validateStructuredJSONSnapshot(value, budget, validationWorkBudget) {
    const state = createPartialJSONParseState();
    const parseBudget = budget ?? { bytes: 0, fragments: 0, work: 0 };
    recordPartialJSONFragment(state, parseBudget, value, validationWorkBudget);
    if (!reservePartialJSONParse(state, parseBudget)) {
        throw new OpenAIError('Chat completion stream exceeded its structured JSON parse-work limit');
    }
    return value;
}
function ownFunctionToolIdentity(toolCall) {
    const type = Object.getOwnPropertyDescriptor(toolCall, 'type');
    const fn = Object.getOwnPropertyDescriptor(toolCall, 'function');
    if (!type || !('value' in type) || type.value !== 'function' || !fn || !('value' in fn)) {
        return undefined;
    }
    if (typeof fn.value !== 'object' || fn.value === null) {
        return undefined;
    }
    const name = Object.getOwnPropertyDescriptor(fn.value, 'name');
    if (!name || !('value' in name) || typeof name.value !== 'string' || name.value.length === 0) {
        return undefined;
    }
    return { type: 'function', name: name.value };
}
function assertBoundToolCallIdentity(toolCall, identity) {
    const current = ownFunctionToolIdentity(toolCall);
    if (!current || current.name !== identity.name || current.type !== identity.type) {
        throw new OpenAIError('Chat completion stream contains a changed tool call identity');
    }
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- This assignment primitive copies own properties from heterogeneous snapshot and delta objects.
function assignOwnProperties(target, source) {
    if (Object.prototype.propertyIsEnumerable.call(source, '__proto__') && !hasOwn(target, '__proto__')) {
        Object.defineProperty(target, '__proto__', {
            value: undefined,
            writable: true,
            enumerable: true,
            configurable: true,
        });
    }
    return Object.assign(target, source);
}
function cloneParserConfigObject(value, stableFields = []) {
    const descriptors = Object.getOwnPropertyDescriptors(value);
    for (const field of stableFields) {
        const descriptor = descriptors[field];
        if (!descriptor && !(field in value)) {
            continue;
        }
        descriptors[field] = {
            // oxlint-disable-next-line anti-slop/no-reflect-get -- Generic config cloning must resolve inherited/accessor keys outside the declared config shape.
            value: descriptor && 'value' in descriptor ? descriptor.value : Reflect.get(value, field, value),
            enumerable: descriptor?.enumerable ?? false,
            configurable: descriptor?.configurable ?? true,
            writable: descriptor && 'writable' in descriptor ? descriptor.writable : false,
        };
    }
    // SAFETY: The clone preserves the original prototype and descriptors, replacing only the parser metadata captured from that same value.
    return Object.create(Object.getPrototypeOf(value), descriptors);
}
function snapshotChatCompletionParserParams(params) {
    const snapshot = cloneParserConfigObject(params);
    if (params.tools) {
        const stableTools = [];
        const lengthDescriptor = Object.getOwnPropertyDescriptor(params.tools, 'length');
        const length = lengthDescriptor && 'value' in lengthDescriptor ? lengthDescriptor.value : undefined;
        const toolCount = typeof length === 'number' && Number.isSafeInteger(length) && length >= 0
            ? Math.min(length, MAX_STREAM_TOOL_CALLS)
            : 0;
        for (let index = 0; index < toolCount; index += 1) {
            const item = Object.getOwnPropertyDescriptor(params.tools, String(index));
            if (!item || !('value' in item)) {
                stableTools.length = index + 1;
                continue;
            }
            // SAFETY: This own data descriptor comes from the request's typed tools array; the following code captures its parser metadata.
            const tool = item.value;
            const stableTool = cloneParserConfigObject(tool, [
                'type',
                '$brand',
                '$parseRaw',
                '$callback',
                'function',
            ]);
            const descriptors = Object.getOwnPropertyDescriptors(stableTool);
            if (isChatCompletionFunctionTool(stableTool)) {
                const descriptor = descriptors.function;
                descriptors.function = {
                    ...(descriptor && 'value' in descriptor
                        ? descriptor
                        : { configurable: true, enumerable: true, writable: true }),
                    value: cloneParserConfigObject(stableTool.function, ['name', 'strict']),
                };
            }
            // SAFETY: The cloned tool retains the original prototype and descriptors while substituting its captured parser configuration.
            stableTools[index] = Object.create(Object.getPrototypeOf(tool), descriptors);
        }
        snapshot.tools = stableTools;
    }
    if (params.response_format) {
        snapshot.response_format = cloneParserConfigObject(params.response_format, [
            'type',
            '$brand',
            '$parseRaw',
        ]);
    }
    return snapshot;
}
const MAX_SERIALIZED_PARSER_SCHEMA_NODES = 4096;
const stringifyParserSchemaValue = JSON.stringify;
const MAX_SERIALIZED_PARSER_SCHEMA_BYTES = 1024 * 1024;
const MAX_SERIALIZED_PARSER_SCHEMA_DEPTH = 64;
const OMITTED_SERIALIZED_PARSER_VALUE = Symbol('omitted serialized parser value');
const UNSAFE_SERIALIZED_PARSER_VALUE = Symbol('unsafe serialized parser value');
function canonicalSerializedParserSchema(value, budget) {
    const ancestors = new WeakSet();
    const charge = (bytes) => {
        if (!Number.isSafeInteger(bytes) ||
            bytes < 0 ||
            budget.bytes + bytes > MAX_SERIALIZED_PARSER_SCHEMA_BYTES) {
            return false;
        }
        budget.bytes += bytes;
        return true;
    };
    // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
    const visit = (current, depth) => {
        if (depth > MAX_SERIALIZED_PARSER_SCHEMA_DEPTH || budget.nodes >= MAX_SERIALIZED_PARSER_SCHEMA_NODES) {
            return UNSAFE_SERIALIZED_PARSER_VALUE;
        }
        budget.nodes += 1;
        if (current === undefined || typeof current === 'function' || typeof current === 'symbol') {
            return OMITTED_SERIALIZED_PARSER_VALUE;
        }
        if (typeof current === 'bigint') {
            return UNSAFE_SERIALIZED_PARSER_VALUE;
        }
        if (current === null || typeof current === 'boolean' || typeof current === 'number') {
            const serialized = stringifyParserSchemaValue(current);
            return typeof serialized === 'string' && charge(serialized.length)
                ? serialized
                : UNSAFE_SERIALIZED_PARSER_VALUE;
        }
        if (typeof current === 'string') {
            if (!charge(current.length * 6 + 2)) {
                return UNSAFE_SERIALIZED_PARSER_VALUE;
            }
            return stringifyParserSchemaValue(current);
        }
        if (typeof current !== 'object' || ancestors.has(current)) {
            return UNSAFE_SERIALIZED_PARSER_VALUE;
        }
        const array = Array.isArray(current);
        // SAFETY: Object.getPrototypeOf returns an object or null; the following traversal checks inherited properties without assuming a specific prototype type.
        const prototype = Object.getPrototypeOf(current);
        if ((array && prototype !== Array.prototype) ||
            (!array && prototype !== null && prototype !== Object.prototype)) {
            return UNSAFE_SERIALIZED_PARSER_VALUE;
        }
        for (let owner = current; owner !== null; owner = Object.getPrototypeOf(owner)) {
            const serializer = Object.getOwnPropertyDescriptor(owner, 'toJSON');
            if (!serializer) {
                continue;
            }
            if (!('value' in serializer) || typeof serializer.value === 'function') {
                return UNSAFE_SERIALIZED_PARSER_VALUE;
            }
            break;
        }
        ancestors.add(current);
        try {
            if (!charge(2)) {
                return UNSAFE_SERIALIZED_PARSER_VALUE;
            }
            if (array) {
                const lengthDescriptor = Object.getOwnPropertyDescriptor(current, 'length');
                const length = lengthDescriptor && 'value' in lengthDescriptor ? lengthDescriptor.value : undefined;
                if (typeof length !== 'number' ||
                    !Number.isSafeInteger(length) ||
                    length < 0 ||
                    length > MAX_SERIALIZED_PARSER_SCHEMA_NODES - budget.nodes) {
                    return UNSAFE_SERIALIZED_PARSER_VALUE;
                }
                const items = [];
                for (let index = 0; index < length; index += 1) {
                    const key = String(index);
                    const descriptor = Object.getOwnPropertyDescriptor(current, key);
                    if (!descriptor) {
                        if (Object.getOwnPropertyDescriptor(Array.prototype, key) ||
                            Object.getOwnPropertyDescriptor(Object.prototype, key)) {
                            return UNSAFE_SERIALIZED_PARSER_VALUE;
                        }
                        budget.nodes += 1;
                        if (!charge(4)) {
                            return UNSAFE_SERIALIZED_PARSER_VALUE;
                        }
                        items.push('null');
                        continue;
                    }
                    if (!('value' in descriptor)) {
                        return UNSAFE_SERIALIZED_PARSER_VALUE;
                    }
                    const item = visit(descriptor.value, depth + 1);
                    if (item === UNSAFE_SERIALIZED_PARSER_VALUE) {
                        return item;
                    }
                    items.push(item === OMITTED_SERIALIZED_PARSER_VALUE ? 'null' : item);
                }
                return `[${items.join(',')}]`;
            }
            const keys = Reflect.ownKeys(current);
            if (keys.length > MAX_SERIALIZED_PARSER_SCHEMA_NODES - budget.nodes) {
                return UNSAFE_SERIALIZED_PARSER_VALUE;
            }
            const entries = [];
            for (const key of keys) {
                if (typeof key !== 'string') {
                    continue;
                }
                const descriptor = Object.getOwnPropertyDescriptor(current, key);
                if (!descriptor) {
                    return UNSAFE_SERIALIZED_PARSER_VALUE;
                }
                if (!descriptor.enumerable) {
                    continue;
                }
                if (!('value' in descriptor)) {
                    return UNSAFE_SERIALIZED_PARSER_VALUE;
                }
                entries.push([key, descriptor.value]);
            }
            entries.sort(([left], [right]) => {
                if (left === right) {
                    return 0;
                }
                return left < right ? -1 : 1;
            });
            const fields = [];
            for (const [key, entry] of entries) {
                const normalized = visit(entry, depth + 1);
                if (normalized === UNSAFE_SERIALIZED_PARSER_VALUE) {
                    return normalized;
                }
                if (normalized === OMITTED_SERIALIZED_PARSER_VALUE) {
                    continue;
                }
                if (!charge(key.length * 6 + 3)) {
                    return UNSAFE_SERIALIZED_PARSER_VALUE;
                }
                fields.push(`${stringifyParserSchemaValue(key)}:${normalized}`);
            }
            return `{${fields.join(',')}}`;
        }
        finally {
            ancestors.delete(current);
        }
    };
    try {
        const normalized = visit(value, 0);
        return typeof normalized === 'string' ? normalized : undefined;
    }
    catch {
        return undefined;
    }
}
function rememberSerializedParserSchema(signatures, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- Parser owners are tracked by identity before their metadata descriptors are validated.
source, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- Serialized schema holders may be arbitrary objects with hostile accessors or prototypes.
holder, key) {
    const parser = Object.getOwnPropertyDescriptor(source, '$parseRaw');
    const schema = Object.getOwnPropertyDescriptor(holder, key);
    if (!parser ||
        !('value' in parser) ||
        typeof parser.value !== 'function' ||
        !schema ||
        !('value' in schema)) {
        return;
    }
    const normalized = canonicalSerializedParserSchema(schema.value, { nodes: 0, bytes: 0 });
    if (normalized !== undefined) {
        signatures.set(source, normalized);
    }
}
function hasMatchingSerializedParserSchema(signatures, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- Parser signatures belong to the original object identity, independent of its fields.
source, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- The schema holder is inspected through own descriptors before its contents are trusted.
holder, key, value) {
    const expected = source && signatures.get(source);
    const descriptor = Object.getOwnPropertyDescriptor(holder, key);
    return (expected !== undefined &&
        descriptor !== undefined &&
        'value' in descriptor &&
        canonicalSerializedParserSchema(value, { nodes: 0, bytes: 0 }) === expected);
}
function serializedParserDescriptor(descriptor, value) {
    return descriptor && 'value' in descriptor
        ? { ...descriptor, value }
        : { configurable: true, enumerable: true, writable: true, value };
}
function shadowSerializedParserMetadata(descriptors, source, fields) {
    for (const field of fields) {
        const descriptor = descriptors[field];
        if (!descriptor && !(field in source)) {
            continue;
        }
        descriptors[field] =
            descriptor && 'value' in descriptor
                ? { ...descriptor, value: undefined }
                : {
                    configurable: descriptor?.configurable ?? true,
                    enumerable: descriptor?.enumerable ?? false,
                    writable: false,
                    value: undefined,
                };
    }
}
function snapshotSerializedParserTool(serialized) {
    // SAFETY: The fallback is a serialization scaffold: the code below installs the captured wire fields before the tool is returned.
    const source = serialized.source ??
        {
            type: serialized.type,
            ...(serialized.type === 'function' ? { function: {} } : {}),
        };
    const descriptors = Object.getOwnPropertyDescriptors(source);
    descriptors.type = serializedParserDescriptor(descriptors.type, serialized.type);
    if (serialized.type !== 'function' || !serialized.function) {
        if (descriptors.function) {
            descriptors.function = serializedParserDescriptor(descriptors.function, undefined);
        }
        shadowSerializedParserMetadata(descriptors, source, ['$brand', '$parseRaw', '$callback']);
        // SAFETY: The descriptors reconstruct the tool's captured serialized fields and shadow parser metadata while retaining its original prototype.
        return Object.create(Object.getPrototypeOf(source), descriptors);
    }
    const descriptor = descriptors.function;
    // SAFETY: The preceding guard proves this data descriptor contains a non-null object; no more specific type is assumed.
    const original = descriptor && 'value' in descriptor && typeof descriptor.value === 'object' && descriptor.value !== null
        ? descriptor.value
        : {};
    const functionDescriptors = Object.getOwnPropertyDescriptors(original);
    functionDescriptors['name'] = serializedParserDescriptor(functionDescriptors['name'], serialized.function.name);
    functionDescriptors['strict'] = serializedParserDescriptor(functionDescriptors['strict'], serialized.function.strict);
    descriptors.function = serializedParserDescriptor(descriptor, Object.create(Object.getPrototypeOf(original), functionDescriptors));
    if (!serialized.function.schemaMatches) {
        shadowSerializedParserMetadata(descriptors, source, ['$brand', '$parseRaw', '$callback']);
    }
    // SAFETY: The descriptors reconstruct the tool's captured serialized fields and shadow parser metadata while retaining its original prototype.
    return Object.create(Object.getPrototypeOf(source), descriptors);
}
function snapshotSerializedResponseFormat(serialized) {
    // SAFETY: The fallback seeds only the discriminator; the captured response-format fields are installed below before returning it.
    const source = serialized.source ?? { type: serialized.type };
    const descriptors = Object.getOwnPropertyDescriptors(source);
    descriptors.type = serializedParserDescriptor(descriptors.type, serialized.type);
    if (serialized.type !== 'json_schema' || !serialized.source || !serialized.schemaMatches) {
        shadowSerializedParserMetadata(descriptors, source, ['$brand', '$parseRaw']);
    }
    // SAFETY: The descriptors restore the captured response-format fields and parser metadata on the original prototype.
    return Object.create(Object.getPrototypeOf(source), descriptors);
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- The serialization visitor accepts arbitrary object and array holders, inspecting own descriptors only.
function ownSerializedParserObject(holder, key) {
    const descriptor = Object.getOwnPropertyDescriptor(holder, key);
    if (!descriptor || !('value' in descriptor)) {
        return undefined;
    }
    const { value } = descriptor;
    return typeof value === 'object' && value !== null ? value : undefined;
}
function observeSerializedChatCompletionParserParams(body, initial, update) {
    const originalToolOwners = new WeakMap();
    const originalSchemaSignatures = new WeakMap();
    // At most 128 tools plus one response format each receive an independent
    // 4,096-node/1 MiB source and wire allowance (129 MiB maximum per pass).
    if (body.tools) {
        for (let index = 0; index < body.tools.length && index < MAX_STREAM_TOOL_CALLS; index += 1) {
            const owner = ownSerializedParserObject(body.tools, String(index));
            const source = initial.tools?.[index];
            if (owner && source) {
                originalToolOwners.set(owner, source);
                const originalFunction = ownSerializedParserObject(source, 'function');
                if (originalFunction) {
                    rememberSerializedParserSchema(originalSchemaSignatures, source, originalFunction, 'parameters');
                }
            }
        }
    }
    if (initial.response_format) {
        rememberSerializedParserSchema(originalSchemaSignatures, initial.response_format, initial.response_format, 'json_schema');
    }
    let root;
    let tools;
    let responseFormat;
    let responseFrame;
    let frames = [];
    let toolFrames = new WeakMap();
    let actualToolOwners = new Map();
    let functionFrames = new WeakMap();
    return observeJSONRequestBody(body, {
        value(holder, key, value) {
            if (!root && key === '' && typeof value === 'object' && value !== null) {
                root = value;
                tools = undefined;
                responseFormat = undefined;
                responseFrame = undefined;
                frames = [];
                toolFrames = new WeakMap();
                actualToolOwners = new Map();
                functionFrames = new WeakMap();
                return;
            }
            if (holder === root && key === 'response_format') {
                if (typeof value === 'object' && value !== null) {
                    responseFormat = value;
                    const owner = ownSerializedParserObject(holder, key);
                    responseFrame = {
                        source: owner === body.response_format ? initial.response_format : undefined,
                        schemaMatches: false,
                    };
                }
                return;
            }
            if (holder === root && key === 'tools') {
                if (Array.isArray(value)) {
                    tools = new Proxy(value, {
                        get(target, property) {
                            // SAFETY: Proxy property values may be arbitrary; unknown preserves that uncertainty before the property-specific checks below.
                            // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys with the original target as accessor receiver.
                            const actual = Reflect.get(target, property, target);
                            if (typeof property === 'string') {
                                const index = Number(property);
                                if (Number.isSafeInteger(index) &&
                                    index >= 0 &&
                                    index < MAX_STREAM_TOOL_CALLS &&
                                    String(index) === property) {
                                    actualToolOwners.set(index, typeof actual === 'object' && actual !== null ? actual : undefined);
                                }
                            }
                            return actual;
                        },
                    });
                    return tools;
                }
                return;
            }
            if (holder === tools) {
                const index = Number(key);
                if (!Number.isSafeInteger(index) ||
                    index < 0 ||
                    index >= MAX_STREAM_TOOL_CALLS ||
                    typeof value !== 'object' ||
                    value === null) {
                    return;
                }
                const owner = actualToolOwners.get(index);
                const source = owner ? originalToolOwners.get(owner) : undefined;
                const frame = { source };
                frames[index] = frame;
                toolFrames.set(value, frame);
                return;
            }
            const tool = toolFrames.get(holder);
            if (tool) {
                if (key === 'type' && typeof value === 'string') {
                    tool.type = value;
                }
                else if (key === 'function' && typeof value === 'object' && value !== null) {
                    const fn = { source: tool.source, schemaMatches: false };
                    tool.function = fn;
                    functionFrames.set(value, fn);
                }
                return;
            }
            if (holder === responseFormat && responseFrame) {
                if (key === 'type' && typeof value === 'string') {
                    responseFrame.type = value;
                }
                else if (key === 'json_schema') {
                    responseFrame.schemaMatches = hasMatchingSerializedParserSchema(originalSchemaSignatures, responseFrame.source, holder, key, value);
                }
                return;
            }
            const fn = functionFrames.get(holder);
            if (fn) {
                if (key === 'name' && typeof value === 'string') {
                    fn.name = value;
                }
                else if (key === 'strict' && typeof value === 'boolean') {
                    fn.strict = value;
                }
                else if (key === 'parameters') {
                    fn.schemaMatches = hasMatchingSerializedParserSchema(originalSchemaSignatures, fn.source, holder, key, value);
                }
            }
            return undefined;
        },
        complete() {
            if (!root) {
                return;
            }
            const snapshot = cloneParserConfigObject(initial);
            if (tools) {
                const serializedTools = [];
                for (let index = 0; index < frames.length; index += 1) {
                    const frame = frames[index];
                    if (frame) {
                        serializedTools[index] = snapshotSerializedParserTool(frame);
                    }
                }
                snapshot.tools = serializedTools;
            }
            else {
                delete snapshot.tools;
            }
            if (responseFrame) {
                snapshot.response_format = snapshotSerializedResponseFormat(responseFrame);
            }
            else {
                delete snapshot.response_format;
            }
            update(snapshot);
            root = undefined;
            tools = undefined;
            responseFormat = undefined;
            responseFrame = undefined;
            frames = [];
            toolFrames = new WeakMap();
            actualToolOwners = new Map();
            functionFrames = new WeakMap();
        },
    });
}
/** Streams chat completion chunks while accumulating snapshots, parsed output, and events. */
export class ChatCompletionStream extends AbstractChatCompletionRunner {
    /** Creates an unstarted stream, retaining request parameters for structured-output parsing. */
    constructor(params) {
        super();
        _ChatCompletionStream_instances.add(this);
        _ChatCompletionStream_params.set(this, void 0);
        _ChatCompletionStream_rejectsUnfinishedTurns.set(this, false);
        _ChatCompletionStream_audioDoneChoiceIndexes.set(this, void 0);
        _ChatCompletionStream_choiceEventStates.set(this, void 0);
        _ChatCompletionStream_currentChatCompletionSnapshot.set(this, void 0);
        _ChatCompletionStream_hasAutoParseableTool.set(this, void 0);
        _ChatCompletionStream_partialJSONParseBudget.set(this, void 0);
        __classPrivateFieldSet(this, _ChatCompletionStream_params, params, "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_audioDoneChoiceIndexes, new Set(), "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_choiceEventStates, [], "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_hasAutoParseableTool, false, "f");
        const tools = params?.tools;
        const lengthDescriptor = tools && Object.getOwnPropertyDescriptor(tools, 'length');
        const length = lengthDescriptor && 'value' in lengthDescriptor ? lengthDescriptor.value : undefined;
        if (tools && typeof length === 'number' && Number.isSafeInteger(length) && length >= 0) {
            for (let index = 0; index < Math.min(length, MAX_STREAM_TOOL_CALLS); index += 1) {
                const descriptor = Object.getOwnPropertyDescriptor(tools, String(index));
                if (!descriptor || !('value' in descriptor)) {
                    continue;
                }
                // SAFETY: The descriptor is read from the typed request tools array and checked as an own data property before accessing the tool.
                const tool = descriptor.value;
                if (isChatCompletionFunctionTool(tool) &&
                    (isAutoParsableTool(tool) || tool.function.strict === true)) {
                    __classPrivateFieldSet(this, _ChatCompletionStream_hasAutoParseableTool, true, "f");
                    break;
                }
            }
        }
        __classPrivateFieldSet(this, _ChatCompletionStream_partialJSONParseBudget, { bytes: 0, fragments: 0, work: 0 }, "f");
    }
    /** The latest accumulated completion, or `undefined` before a chunk arrives or after finalization. */
    get currentChatCompletionSnapshot() {
        return __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f");
    }
    /**
     * Intended for use on the frontend, consuming a stream produced with
     * `.toReadableStream()` on the backend.
     *
     * Original input messages are not included in the serialized stream. Tool-result
     * messages explicitly serialized by a streaming tool runner are replayed.
     */
    static fromReadableStream(stream) {
        const runner = new ChatCompletionStream(null);
        runner._run(() => runner._fromReadableStream(stream));
        return runner;
    }
    /** Starts a streaming chat completion request and returns its event-driven helper. */
    static createChatCompletion(client, params, options) {
        // SAFETY: The runner forces stream: true when sending this request; the same parameters retain the caller's parsing configuration.
        const runner = new ChatCompletionStream(params);
        runner._run(() => runner._runChatCompletion(client, { ...params, stream: true }, { ...options, __metadata: { ...options?.__metadata, helperMethod: 'stream' } }));
        return runner;
    }
    /** Rejects unfinished turns before tool callbacks while preserving ordinary stream and replay behavior. */
    _runTools(client, params, runner, options) {
        __classPrivateFieldSet(this, _ChatCompletionStream_rejectsUnfinishedTurns, true, "f");
        return super._runTools(client, params, runner, options);
    }
    async _createChatCompletion(client, params, options) {
        this._listenForAbort(options?.signal);
        const requestParams = { ...params, stream: true };
        __classPrivateFieldSet(this, _ChatCompletionStream_params, requestParams, "f");
        __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_beginRequest).call(this);
        const parserParams = snapshotChatCompletionParserParams(requestParams);
        __classPrivateFieldSet(this, _ChatCompletionStream_params, parserParams, "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_hasAutoParseableTool, parserParams.tools?.some((tool) => isChatCompletionFunctionTool(tool) && (isAutoParsableTool(tool) || tool.function.strict === true)) ?? false, "f");
        const stopObserving = requestParams.tools || requestParams.response_format
            ? observeSerializedChatCompletionParserParams(requestParams, parserParams, (serialized) => {
                __classPrivateFieldSet(this, _ChatCompletionStream_params, serialized, "f");
                __classPrivateFieldSet(this, _ChatCompletionStream_hasAutoParseableTool, serialized.tools?.some((tool) => isChatCompletionFunctionTool(tool) &&
                    (isAutoParsableTool(tool) || tool.function.strict === true)) ?? false, "f");
            })
            : undefined;
        const stream = await client.chat.completions
            .create(requestParams, {
            ...options,
            signal: this.controller.signal,
        })
            .finally(stopObserving);
        this._connected();
        for await (const chunk of stream) {
            __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_addChunk).call(this, chunk);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return this._addChatCompletion(__classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_endRequest).call(this));
    }
    async _fromReadableStream(readableStream, options) {
        this._listenForAbort(options?.signal);
        __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_beginRequest).call(this);
        this._connected();
        const stream = Stream.fromReadableStream(readableStream, this.controller);
        let chatId;
        for await (const item of stream) {
            if ('error' in item && hasOwn(item, 'error') && typeof item.error === 'object' && item.error !== null) {
                throw new APIError(undefined, item.error, undefined, undefined);
            }
            if (isChatCompletionReadableStreamMessage(item)) {
                const message = getChatCompletionReadableStreamMessage(item);
                if (__classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f")) {
                    const toolCalls = __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f").choices[0]?.message.tool_calls;
                    for (const [index, id] of message.tool_call_ids?.entries() ?? []) {
                        const toolCall = toolCalls?.[index];
                        if (toolCall && id) {
                            toolCall.id = id;
                        }
                    }
                    this._addChatCompletion(__classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_endRequest).call(this));
                    chatId = undefined;
                }
                this._addMessage(message.message);
                continue;
            }
            const chunk = item;
            if (chatId && chunk.id && chatId !== chunk.id) {
                // A new request has been made.
                this._addChatCompletion(__classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_endRequest).call(this));
            }
            __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_addChunk).call(this, chunk);
            if (chunk.id) {
                chatId = chunk.id;
            }
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        if (__classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f")) {
            return this._addChatCompletion(__classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_endRequest).call(this));
        }
        const lastChatCompletion = this._chatCompletions[this._chatCompletions.length - 1];
        if (lastChatCompletion) {
            return lastChatCompletion;
        }
        throw new OpenAIError(`request ended without sending any chunks`);
    }
    /** Iterates over raw API chunks; stopping iteration early aborts the underlying request. */
    [(_ChatCompletionStream_params = new WeakMap(), _ChatCompletionStream_rejectsUnfinishedTurns = new WeakMap(), _ChatCompletionStream_audioDoneChoiceIndexes = new WeakMap(), _ChatCompletionStream_choiceEventStates = new WeakMap(), _ChatCompletionStream_currentChatCompletionSnapshot = new WeakMap(), _ChatCompletionStream_hasAutoParseableTool = new WeakMap(), _ChatCompletionStream_partialJSONParseBudget = new WeakMap(), _ChatCompletionStream_instances = new WeakSet(), _ChatCompletionStream_beginRequest = function _ChatCompletionStream_beginRequest() {
        if (this.ended) {
            return;
        }
        __classPrivateFieldSet(this, _ChatCompletionStream_audioDoneChoiceIndexes, new Set(), "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_currentChatCompletionSnapshot, undefined, "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_partialJSONParseBudget, { bytes: 0, fragments: 0, work: 0 }, "f");
    }, _ChatCompletionStream_getChoiceEventState = function _ChatCompletionStream_getChoiceEventState(choice) {
        let state = __classPrivateFieldGet(this, _ChatCompletionStream_choiceEventStates, "f")[choice.index];
        if (state) {
            return state;
        }
        state = {
            content_done: false,
            content_parse_state: undefined,
            refusal_done: false,
            logprobs_content_done: false,
            logprobs_refusal_done: false,
            done_tool_calls: new Set(),
            current_tool_call_index: null,
            tool_call_parse_states: new Map(),
            tool_call_identities: new Map(),
        };
        __classPrivateFieldGet(this, _ChatCompletionStream_choiceEventStates, "f")[choice.index] = state;
        return state;
    }, _ChatCompletionStream_addChunk = function _ChatCompletionStream_addChunk(chunk) {
        if (this.ended) {
            return;
        }
        const capturedChoiceFrames = new WeakMap();
        const completion = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_accumulateChatCompletion).call(this, chunk, capturedChoiceFrames);
        this._emit('chunk', chunk, completion);
        for (const choice of chunk.choices) {
            const capturedChoice = capturedChoiceFrames.get(choice);
            const choiceSnapshot = completion.choices[capturedChoice?.index ?? choice.index];
            const capturedToolCalls = capturedChoice?.tool_calls ?? [];
            const { delta } = choice;
            const structuredResponse = isParseableResponseFormat(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format);
            const boundedSnapshot = structuredResponse || __classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f");
            const messageSnapshot = boundedSnapshot
                ? captureStructuredMessageSnapshot(choiceSnapshot)
                : choiceSnapshot.message;
            const refusal = boundedSnapshot
                ? captureStructuredJSONSnapshot(messageSnapshot, 'refusal')
                : messageSnapshot.refusal;
            const parseableContent = !refusal && structuredResponse;
            const messageContent = parseableContent
                ? captureStructuredJSONSnapshot(messageSnapshot, 'content')
                : messageSnapshot.content;
            if (delta?.content != null && messageSnapshot.role === 'assistant' && messageContent) {
                this._emit('content', delta.content, messageContent);
                this._emit('content.delta', {
                    delta: delta.content,
                    snapshot: messageContent,
                    parsed: messageSnapshot.parsed,
                });
            }
            if (delta?.refusal != null && messageSnapshot.role === 'assistant' && refusal) {
                this._emit('refusal.delta', {
                    delta: delta.refusal,
                    snapshot: refusal,
                });
            }
            if (choice.logprobs?.content != null && messageSnapshot.role === 'assistant') {
                this._emit('logprobs.content.delta', {
                    content: choice.logprobs?.content,
                    snapshot: choiceSnapshot.logprobs?.content ?? [],
                });
            }
            if (choice.logprobs?.refusal != null && messageSnapshot.role === 'assistant') {
                this._emit('logprobs.refusal.delta', {
                    refusal: choice.logprobs?.refusal,
                    snapshot: choiceSnapshot.logprobs?.refusal ?? [],
                });
            }
            const state = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_getChoiceEventState).call(this, choiceSnapshot);
            if (choiceSnapshot.finish_reason) {
                __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_emitContentDoneEvents).call(this, choiceSnapshot);
                if (state.current_tool_call_index != null) {
                    __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_emitToolCallDoneEvent).call(this, choiceSnapshot, state.current_tool_call_index);
                }
            }
            for (const toolCall of capturedToolCalls) {
                if (state.current_tool_call_index !== toolCall.index) {
                    __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_emitContentDoneEvents).call(this, choiceSnapshot);
                    // new tool call started, the previous one is done
                    if (state.current_tool_call_index != null) {
                        __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_emitToolCallDoneEvent).call(this, choiceSnapshot, state.current_tool_call_index);
                    }
                }
                state.current_tool_call_index = toolCall.index;
            }
            for (const toolCallDelta of capturedToolCalls) {
                const toolCallSnapshot = messageSnapshot.tool_calls?.[toolCallDelta.index];
                if (!toolCallSnapshot?.type) {
                    continue;
                }
                if (toolCallSnapshot.type === 'function') {
                    const boundIdentity = state.tool_call_identities.get(toolCallDelta.index);
                    let argumentsSnapshot;
                    if (boundIdentity?.parseable) {
                        const capturedArguments = captureStructuredJSONSnapshot(toolCallSnapshot.function, 'arguments');
                        if (typeof capturedArguments !== 'string') {
                            throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                        }
                        argumentsSnapshot = capturedArguments;
                    }
                    else {
                        argumentsSnapshot = toolCallSnapshot.function.arguments;
                    }
                    this._emit('tool_calls.function.arguments.delta', {
                        name: toolCallSnapshot.function.name,
                        index: toolCallDelta.index,
                        arguments: argumentsSnapshot,
                        parsed_arguments: toolCallSnapshot.function.parsed_arguments,
                        arguments_delta: toolCallDelta.arguments_delta,
                    });
                }
                else if (toolCallSnapshot.type !== 'custom') {
                    assertNever(toolCallSnapshot);
                }
            }
        }
    }, _ChatCompletionStream_emitToolCallDoneEvent = function _ChatCompletionStream_emitToolCallDoneEvent(choiceSnapshot, toolCallIndex) {
        const state = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_getChoiceEventState).call(this, choiceSnapshot);
        if (state.done_tool_calls.has(toolCallIndex)) {
            // we've already fired the done event
            return;
        }
        const messageSnapshot = __classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f")
            ? captureStructuredMessageSnapshot(choiceSnapshot)
            : choiceSnapshot.message;
        const toolCallSnapshot = messageSnapshot.tool_calls?.[toolCallIndex];
        if (!toolCallSnapshot) {
            throw new Error('no tool call snapshot');
        }
        const boundIdentity = state.tool_call_identities.get(toolCallIndex);
        if (boundIdentity) {
            assertBoundToolCallIdentity(toolCallSnapshot, boundIdentity);
        }
        if (!toolCallSnapshot.type) {
            throw new Error('tool call snapshot missing `type`');
        }
        if (toolCallSnapshot.type === 'function') {
            // SAFETY: The find predicate verifies the function-tool discriminator before matching its name; the cast carries that refinement through find.
            const inputTool = __classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.tools?.find((tool) => isChatCompletionFunctionTool(tool) && tool.function.name === toolCallSnapshot.function.name); // TS doesn't narrow based on isChatCompletionTool
            // oxlint-disable-next-line anti-slop/no-known-value-widening -- The initial null is replaced with an arbitrary tool-parser result after snapshot validation.
            let parsedArguments = null;
            const parseable = isAutoParsableTool(inputTool) || inputTool?.function.strict === true;
            let argumentsSnapshot;
            if (parseable) {
                if (__classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f")) {
                    __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_validateStructuredSnapshots).call(this, __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f"));
                }
                const capturedArguments = captureStructuredJSONSnapshot(toolCallSnapshot.function, 'arguments');
                if (typeof capturedArguments !== 'string') {
                    throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                }
                argumentsSnapshot = capturedArguments;
            }
            else {
                argumentsSnapshot = toolCallSnapshot.function.arguments;
            }
            if (isAutoParsableTool(inputTool)) {
                parsedArguments = inputTool.$parseRaw(validateStructuredJSONSnapshot(argumentsSnapshot));
            }
            else if (inputTool?.function.strict) {
                parsedArguments = parseResponseFormatContent({ type: 'json_schema', $parseRaw: undefined }, validateStructuredJSONSnapshot(argumentsSnapshot));
            }
            if (choiceSnapshot.finish_reason) {
                state.done_tool_calls.add(toolCallIndex);
            }
            this._emit('tool_calls.function.arguments.done', {
                name: toolCallSnapshot.function.name,
                index: toolCallIndex,
                arguments: argumentsSnapshot,
                parsed_arguments: parsedArguments,
            });
        }
        else if (toolCallSnapshot.type !== 'custom') {
            assertNever(toolCallSnapshot);
        }
    }, _ChatCompletionStream_emitContentDoneEvents = function _ChatCompletionStream_emitContentDoneEvents(choiceSnapshot) {
        const state = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_getChoiceEventState).call(this, choiceSnapshot);
        const structuredResponse = isParseableResponseFormat(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format);
        const boundedSnapshot = structuredResponse || __classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f");
        const messageSnapshot = boundedSnapshot
            ? captureStructuredMessageSnapshot(choiceSnapshot)
            : choiceSnapshot.message;
        const refusal = boundedSnapshot
            ? captureStructuredJSONSnapshot(messageSnapshot, 'refusal')
            : messageSnapshot.refusal;
        const parseableContent = !refusal && structuredResponse;
        const content = parseableContent
            ? captureStructuredJSONSnapshot(messageSnapshot, 'content')
            : messageSnapshot.content;
        if (content != null &&
            (content !== '' ||
                (!refusal && !messageSnapshot.tool_calls?.length && !messageSnapshot.function_call)) &&
            !state.content_done) {
            if (parseableContent && __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f")) {
                __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_validateStructuredSnapshots).call(this, __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f"));
            }
            state.content_done = true;
            this._emit('content.done', {
                content,
                parsed: refusal
                    ? null
                    : parseResponseFormatContent(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format, parseableContent ? validateStructuredJSONSnapshot(content) : content),
            });
        }
        if (refusal && !state.refusal_done) {
            state.refusal_done = true;
            this._emit('refusal.done', { refusal });
        }
        if (choiceSnapshot.logprobs?.content && !state.logprobs_content_done) {
            state.logprobs_content_done = true;
            this._emit('logprobs.content.done', { content: choiceSnapshot.logprobs.content });
        }
        if (choiceSnapshot.logprobs?.refusal && !state.logprobs_refusal_done) {
            state.logprobs_refusal_done = true;
            this._emit('logprobs.refusal.done', { refusal: choiceSnapshot.logprobs.refusal });
        }
    }, _ChatCompletionStream_validateStructuredSnapshots = function _ChatCompletionStream_validateStructuredSnapshots(snapshot) {
        const finalJSONBudget = { bytes: 0, fragments: 0, work: 0 };
        const parseableContent = isParseableResponseFormat(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format);
        const validatedMessages = new WeakMap();
        const choices = captureSnapshotArray(snapshot, 'choices', MAX_STREAM_CHOICES, 'choice');
        if (!choices) {
            throw new OpenAIError('Chat completion stream contains an unsafe snapshot choice collection');
        }
        for (let choiceIndex = 0; choiceIndex < choices.length; choiceIndex += 1) {
            const choice = captureSnapshotArrayItem(choices, choiceIndex);
            if (!choice) {
                continue;
            }
            const message = captureStructuredMessageSnapshot(choice);
            const refusal = captureStructuredJSONSnapshot(message, 'refusal');
            const content = captureStructuredJSONSnapshot(message, 'content');
            const validatedTools = new Map();
            const toolCalls = captureSnapshotArray(message, 'tool_calls', MAX_STREAM_TOOL_CALLS, 'tool-call');
            validatedMessages.set(choice, Object.freeze({
                message,
                content,
                refusal,
                toolCallCollection: toolCalls,
                toolCalls: validatedTools,
            }));
            const state = __classPrivateFieldGet(this, _ChatCompletionStream_choiceEventStates, "f")[choice.index];
            if (parseableContent && !refusal && typeof content === 'string') {
                validateStructuredJSONSnapshot(content, finalJSONBudget, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"));
            }
            for (const [index, identity] of state?.tool_call_identities ?? []) {
                const toolCall = toolCalls && captureSnapshotArrayItem(toolCalls, index);
                if (!toolCall) {
                    throw new OpenAIError('Chat completion stream contains a changed tool call identity');
                }
                assertBoundToolCallIdentity(toolCall, identity);
            }
            if (!__classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f")) {
                continue;
            }
            for (let toolCallIndex = 0; toolCallIndex < (toolCalls?.length ?? 0); toolCallIndex += 1) {
                const toolCall = captureSnapshotArrayItem(toolCalls, toolCallIndex);
                if (!toolCall) {
                    continue;
                }
                const identity = ownFunctionToolIdentity(toolCall);
                if (!identity) {
                    const type = Object.getOwnPropertyDescriptor(toolCall, 'type');
                    if (type && !('value' in type)) {
                        throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                    }
                    if (type?.value !== 'function') {
                        continue;
                    }
                    const fn = Object.getOwnPropertyDescriptor(toolCall, 'function');
                    if (fn && !('value' in fn)) {
                        throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                    }
                    if (fn && typeof fn.value === 'object' && fn.value !== null) {
                        const name = Object.getOwnPropertyDescriptor(fn.value, 'name');
                        if (name && !('value' in name)) {
                            throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                        }
                    }
                    continue;
                }
                if (!shouldParseToolCall(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f"), {
                    type: identity.type,
                    function: { name: identity.name },
                })) {
                    continue;
                }
                const descriptor = Object.getOwnPropertyDescriptor(toolCall, 'function');
                if (!descriptor || !('value' in descriptor)) {
                    throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                }
                // SAFETY: The tool-call function is captured through an own data descriptor; its fields are subsequently checked by the structured snapshot reader.
                const fn = descriptor.value;
                const argumentsSnapshot = captureStructuredJSONSnapshot(fn, 'arguments');
                if (typeof argumentsSnapshot !== 'string') {
                    throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                }
                validateStructuredJSONSnapshot(argumentsSnapshot, finalJSONBudget, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"));
                validatedTools.set(toolCallIndex, Object.freeze({
                    tool: toolCall,
                    function: fn,
                    type: identity.type,
                    name: identity.name,
                    arguments: argumentsSnapshot,
                }));
            }
        }
        return validatedMessages;
    }, _ChatCompletionStream_endRequest = function _ChatCompletionStream_endRequest() {
        if (this.ended) {
            throw new OpenAIError(`stream has ended, this shouldn't happen`);
        }
        const snapshot = __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f");
        if (!snapshot) {
            throw new OpenAIError(`request ended without sending any chunks`);
        }
        const validatedMessages = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_validateStructuredSnapshots).call(this, snapshot);
        const audioDoneChoiceIndexes = __classPrivateFieldGet(this, _ChatCompletionStream_audioDoneChoiceIndexes, "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_audioDoneChoiceIndexes, new Set(), "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_currentChatCompletionSnapshot, undefined, "f");
        __classPrivateFieldSet(this, _ChatCompletionStream_choiceEventStates, [], "f");
        return finalizeChatCompletion(snapshot, __classPrivateFieldGet(this, _ChatCompletionStream_params, "f"), audioDoneChoiceIndexes, validatedMessages);
    }, _ChatCompletionStream_accumulateChatCompletion = function _ChatCompletionStream_accumulateChatCompletion(chunk, capturedChoiceFrames) {
        var _a, _b, _c, _d, _e;
        let snapshot = __classPrivateFieldGet(this, _ChatCompletionStream_currentChatCompletionSnapshot, "f");
        const { choices, obfuscation: _obfuscation, ...rest } = chunk;
        if (!snapshot) {
            const newSnapshot = {
                ...rest,
                choices: [],
            };
            __classPrivateFieldSet(this, _ChatCompletionStream_currentChatCompletionSnapshot, newSnapshot, "f");
            snapshot = newSnapshot;
        }
        else if (chunk.id) {
            assignOwnProperties(snapshot, rest);
        }
        const requestedChoiceCount = __classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.n;
        const maxChoices = typeof requestedChoiceCount === 'number' &&
            Number.isSafeInteger(requestedChoiceCount) &&
            requestedChoiceCount > 0
            ? Math.min(requestedChoiceCount, MAX_STREAM_CHOICES)
            : MAX_STREAM_CHOICES;
        for (const chunkChoice of chunk.choices) {
            const { delta, finish_reason, index, logprobs = null, ...other } = chunkChoice;
            const capturedToolCalls = [];
            capturedChoiceFrames.set(chunkChoice, Object.freeze({ index, tool_calls: capturedToolCalls }));
            if (!Number.isSafeInteger(index) || index < 0 || index >= maxChoices) {
                throw new OpenAIError(`Chat completion stream contains an invalid choice index: ${index}`);
            }
            let choice = snapshot.choices[index];
            if (!choice) {
                const newChoice = { finish_reason, index, message: {}, logprobs: null, ...other };
                snapshot.choices[index] = newChoice;
                choice = newChoice;
            }
            if (isParseableResponseFormat(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format) || __classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f")) {
                captureStructuredJSONSnapshot(captureStructuredMessageSnapshot(choice), 'refusal');
            }
            if (logprobs) {
                if (choice.logprobs) {
                    const { content, refusal, ...rest } = logprobs;
                    assertIsEmpty(rest);
                    assignOwnProperties(choice.logprobs, rest);
                    if (content) {
                        (_a = choice.logprobs).content ?? (_a.content = []);
                        choice.logprobs.content.push(...content);
                    }
                    if (refusal) {
                        (_b = choice.logprobs).refusal ?? (_b.refusal = []);
                        choice.logprobs.refusal.push(...refusal);
                    }
                }
                else {
                    choice.logprobs = { ...logprobs };
                    if (logprobs.content) {
                        choice.logprobs.content = [...logprobs.content];
                    }
                    if (logprobs.refusal) {
                        choice.logprobs.refusal = [...logprobs.refusal];
                    }
                }
            }
            if (finish_reason) {
                choice.finish_reason = finish_reason;
                if (__classPrivateFieldGet(this, _ChatCompletionStream_params, "f") && (__classPrivateFieldGet(this, _ChatCompletionStream_rejectsUnfinishedTurns, "f") || hasAutoParseableInput(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")))) {
                    if (finish_reason === 'length') {
                        throw new LengthFinishReasonError();
                    }
                    if (finish_reason === 'content_filter') {
                        throw new ContentFilterFinishReasonError();
                    }
                }
            }
            assignOwnProperties(choice, other);
            if (!delta) {
                Object.freeze(capturedToolCalls);
                continue;
            } // Shouldn't happen; just in case.
            __classPrivateFieldGet(this, _ChatCompletionStream_audioDoneChoiceIndexes, "f").delete(index);
            // SAFETY: Streaming audio fields arrive incrementally even though the generated delta type omits them; each present field is merged below.
            const { audio, content, refusal, function_call, role, ...capturedDeltaFields } = delta;
            const { tool_calls: capturedToolCallDelta, ...rest } = capturedDeltaFields;
            const tool_calls = hasOwn(capturedDeltaFields, 'tool_calls') ? capturedToolCallDelta : delta.tool_calls;
            assertIsEmpty(rest);
            assignOwnProperties(choice.message, rest);
            if (audio?.expires_at != null &&
                audio.id == null &&
                audio.data == null &&
                audio.transcript == null &&
                content == null &&
                refusal == null &&
                function_call == null &&
                role == null &&
                tool_calls == null &&
                Object.keys(rest).length === 0) {
                __classPrivateFieldGet(this, _ChatCompletionStream_audioDoneChoiceIndexes, "f").add(index);
            }
            if (refusal) {
                choice.message.refusal = (choice.message.refusal || '') + refusal;
            }
            if (role) {
                choice.message.role = role;
            }
            if (audio) {
                const audioSnapshot = ((_c = choice.message).audio ?? (_c.audio = {}));
                if (audio.id != null) {
                    audioSnapshot.id = audio.id;
                }
                if (audio.data != null) {
                    audioSnapshot.data = (audioSnapshot.data ?? '') + audio.data;
                }
                if (audio.transcript != null) {
                    audioSnapshot.transcript = (audioSnapshot.transcript ?? '') + audio.transcript;
                }
                if (audio.expires_at != null) {
                    audioSnapshot.expires_at = audio.expires_at;
                }
            }
            if (function_call) {
                if (choice.message.function_call) {
                    if (function_call.name) {
                        choice.message.function_call.name = function_call.name;
                    }
                    if (function_call.arguments) {
                        (_d = choice.message.function_call).arguments ?? (_d.arguments = '');
                        choice.message.function_call.arguments += function_call.arguments;
                    }
                }
                else {
                    choice.message.function_call = function_call;
                }
            }
            if (content != null) {
                if (!choice.message.refusal && isParseableResponseFormat(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.response_format)) {
                    const eventState = __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_getChoiceEventState).call(this, choice);
                    const parseState = (eventState.content_parse_state ?? (eventState.content_parse_state = createPartialJSONParseState()));
                    const shouldParse = recordPartialJSONFragment(parseState, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"), content);
                    choice.message.content = (captureStructuredJSONSnapshot(choice.message, 'content') || '') + content;
                    // The partial parser does not accept whitespace-only input. Once output
                    // grows, coalesce prefix reparses while preserving every raw snapshot.
                    if (!parseState.has_non_whitespace) {
                        choice.message.parsed = null;
                    }
                    else if (shouldParse && reservePartialJSONParse(parseState, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"))) {
                        __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_validateStructuredSnapshots).call(this, snapshot);
                        choice.message.parsed = parseStructuredStreamingJSON(validateStructuredJSONSnapshot(choice.message.content));
                    }
                    else if (content.length > 0) {
                        choice.message.parsed = null;
                    }
                }
                else {
                    choice.message.content = (choice.message.content || '') + content;
                }
            }
            if (tool_calls) {
                // Tool calls are built up across chunks, so while the stream is in progress the
                // entries are only partially filled in; they match `ChatCompletionSnapshot.Choice.Message.ToolCall`
                // once every delta for them has been accumulated.
                // SAFETY: This SDK-owned collection holds partial tool calls during accumulation; finalization checks required fields before exposing completed calls.
                const toolCallSnapshots = ((_e = choice.message).tool_calls ?? (_e.tool_calls = []));
                for (const toolCallDelta of tool_calls) {
                    const { index, id, type, function: fn, custom, ...rest } = toolCallDelta;
                    if (!Number.isSafeInteger(index) || index < 0 || index >= MAX_STREAM_TOOL_CALLS) {
                        throw new OpenAIError(`Chat completion stream contains an invalid tool call index: ${index}`);
                    }
                    let argumentsDelta = '';
                    const tool_call = (toolCallSnapshots[index] ?? (toolCallSnapshots[index] = {}));
                    const functionName = fn?.name;
                    const eventState = __classPrivateFieldGet(this, _ChatCompletionStream_hasAutoParseableTool, "f") ? __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_getChoiceEventState).call(this, choice) : undefined;
                    let boundIdentity = eventState?.tool_call_identities.get(index);
                    if (boundIdentity) {
                        assertBoundToolCallIdentity(tool_call, boundIdentity);
                        if ((type !== undefined && type !== boundIdentity.type) ||
                            (functionName !== undefined && functionName !== boundIdentity.name)) {
                            throw new OpenAIError('Chat completion stream contains a changed tool call identity');
                        }
                    }
                    assignOwnProperties(tool_call, rest);
                    if (id) {
                        tool_call.id = id;
                    }
                    if (type) {
                        tool_call.type = type;
                    }
                    if (custom) {
                        const customSnapshot = (tool_call.custom ?? (tool_call.custom = { name: custom.name ?? '', input: '' }));
                        if (custom.name) {
                            customSnapshot.name = custom.name;
                        }
                        if (custom.input) {
                            customSnapshot.input += custom.input;
                        }
                    }
                    if (fn) {
                        const functionSnapshot = (tool_call.function ?? (tool_call.function = { name: functionName ?? '', arguments: '' }));
                        if (functionName) {
                            functionSnapshot.name = functionName;
                        }
                        if (eventState && !boundIdentity) {
                            const identity = ownFunctionToolIdentity(tool_call);
                            const configuredTool = identity &&
                                __classPrivateFieldGet(this, _ChatCompletionStream_params, "f")?.tools?.find((tool) => isChatCompletionFunctionTool(tool) && tool.function.name === identity.name);
                            if (identity) {
                                boundIdentity = {
                                    ...identity,
                                    parseable: configuredTool !== undefined &&
                                        shouldParseToolCall(__classPrivateFieldGet(this, _ChatCompletionStream_params, "f"), {
                                            type: identity.type,
                                            function: { name: identity.name },
                                        }),
                                };
                                eventState.tool_call_identities.set(index, boundIdentity);
                                if (!boundIdentity.parseable) {
                                    const provisionalState = eventState.tool_call_parse_states.get(index);
                                    if (provisionalState) {
                                        __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f").bytes -= provisionalState.bytes;
                                        __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f").fragments -= provisionalState.fragments;
                                        __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f").work -= provisionalState.work;
                                        eventState.tool_call_parse_states.delete(index);
                                    }
                                }
                            }
                        }
                        const argumentFragment = fn.arguments;
                        if (argumentFragment != null) {
                            argumentsDelta = argumentFragment;
                            if (eventState && boundIdentity?.parseable !== false) {
                                let parseState = eventState.tool_call_parse_states.get(index);
                                if (!parseState) {
                                    parseState = createPartialJSONParseState();
                                    eventState.tool_call_parse_states.set(index, parseState);
                                }
                                const shouldParse = recordPartialJSONFragment(parseState, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"), argumentFragment);
                                const previousArguments = captureStructuredJSONSnapshot(functionSnapshot, 'arguments');
                                if (typeof previousArguments !== 'string') {
                                    throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                                }
                                functionSnapshot.arguments = previousArguments + argumentFragment;
                                if (shouldParse &&
                                    boundIdentity?.parseable === true &&
                                    reservePartialJSONParse(parseState, __classPrivateFieldGet(this, _ChatCompletionStream_partialJSONParseBudget, "f"))) {
                                    __classPrivateFieldGet(this, _ChatCompletionStream_instances, "m", _ChatCompletionStream_validateStructuredSnapshots).call(this, snapshot);
                                    functionSnapshot.parsed_arguments = parseStructuredStreamingJSON(validateStructuredJSONSnapshot(functionSnapshot.arguments));
                                }
                                else if (argumentFragment.length > 0 && hasOwn(functionSnapshot, 'parsed_arguments')) {
                                    functionSnapshot.parsed_arguments = undefined;
                                }
                            }
                            else {
                                functionSnapshot.arguments += argumentFragment;
                            }
                        }
                    }
                    capturedToolCalls.push(Object.freeze({ index, arguments_delta: argumentsDelta }));
                }
            }
            Object.freeze(capturedToolCalls);
        }
        return snapshot;
    }, Symbol.asyncIterator)]() {
        return this._createIterator((push) => {
            const onChunk = (chunk) => push(chunk);
            this.on('chunk', onChunk);
            return () => this.off('chunk', onChunk);
        }, { onReturn: () => this.abort() });
    }
    /** Serializes raw completion chunks into a readable stream for transfer to another runtime. */
    toReadableStream() {
        const stream = new Stream(this[Symbol.asyncIterator].bind(this), this.controller);
        return stream.toReadableStream();
    }
}
function finalizeChatCompletion(snapshot, params, audioDoneChoiceIndexes, validatedMessages) {
    const { id, choices, created, model, system_fingerprint, ...rest } = snapshot;
    const completion = {
        ...rest,
        id,
        choices: mapCapturedSnapshotArray(choices, MAX_STREAM_CHOICES, 'choice', (choice) => {
            const validated = validatedMessages.get(choice);
            if (!validated) {
                throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
            }
            const stableChoice = new Proxy(choice, {
                get(target, property, receiver) {
                    // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys and the original accessor receiver.
                    return property === 'message' ? validated.message : Reflect.get(target, property, receiver);
                },
            });
            const { message: sourceMessage, finish_reason, index, logprobs, ...choiceRest } = stableChoice;
            const message = new Proxy(sourceMessage, {
                get(target, property, receiver) {
                    if (property === 'content') {
                        return validated.content;
                    }
                    if (property === 'refusal') {
                        return validated.refusal;
                    }
                    if (property === 'tool_calls') {
                        return validated.toolCallCollection;
                    }
                    // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys and the original accessor receiver.
                    return Reflect.get(target, property, receiver);
                },
            });
            const { content = null, function_call, tool_calls, audio, ...messageRest } = message;
            // Audio streams can end with an expires_at-only chunk after the
            // generated audio, without a separate finish_reason.
            const finishReason = finish_reason ?? (audioDoneChoiceIndexes.has(index) && isCompleteAudio(audio) ? 'stop' : null);
            if (!finishReason) {
                throw new OpenAIError(`missing finish_reason for choice ${index}`);
            }
            // SAFETY: The completed API response contract supplies the audio fields; this preserves the existing pass-through behavior at finalization.
            const audioResponse = audio ? { audio: audio } : {};
            // SAFETY: The API completion contract uses assistant role; retaining the wire role preserves existing behavior without adding runtime rejection.
            const role = message.role; // this is what we expect; in theory it could be different which would make our types a slight lie but would be fine.
            if (!role) {
                throw new OpenAIError(`missing role for choice ${index}`);
            }
            if (function_call) {
                const { arguments: args, name } = function_call;
                if (args == null) {
                    throw new OpenAIError(`missing function_call.arguments for choice ${index}`);
                }
                if (!name) {
                    throw new OpenAIError(`missing function_call.name for choice ${index}`);
                }
                return {
                    ...choiceRest,
                    message: {
                        ...audioResponse,
                        content,
                        function_call: { arguments: args, name },
                        role,
                        refusal: message.refusal ?? null,
                    },
                    finish_reason: finishReason,
                    index,
                    logprobs,
                };
            }
            if (tool_calls) {
                return {
                    ...choiceRest,
                    index,
                    finish_reason: finishReason,
                    logprobs,
                    message: {
                        ...messageRest,
                        ...audioResponse,
                        role,
                        content,
                        refusal: message.refusal ?? null,
                        tool_calls: mapCapturedSnapshotArray(tool_calls, MAX_STREAM_TOOL_CALLS, 'tool-call', (tool_call, i) => {
                            const captured = validated.toolCalls.get(i);
                            if (!captured) {
                                const identity = ownFunctionToolIdentity(tool_call);
                                if (identity &&
                                    shouldParseToolCall(params, {
                                        type: identity.type,
                                        function: { name: identity.name },
                                    })) {
                                    throw new OpenAIError('Chat completion stream contains an unsafe structured JSON snapshot');
                                }
                            }
                            if (captured && captured.tool !== tool_call) {
                                throw new OpenAIError('Chat completion stream contains a changed tool call identity');
                            }
                            const stableFunction = captured &&
                                new Proxy(captured.function, {
                                    get(target, property, receiver) {
                                        if (property === 'arguments') {
                                            return captured.arguments;
                                        }
                                        if (property === 'name') {
                                            return captured.name;
                                        }
                                        // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys and the original accessor receiver.
                                        return Reflect.get(target, property, receiver);
                                    },
                                });
                            const stableTool = captured && stableFunction
                                ? new Proxy(tool_call, {
                                    get(target, property, receiver) {
                                        if (property === 'type') {
                                            return captured.type;
                                        }
                                        if (property === 'function') {
                                            return stableFunction;
                                        }
                                        // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys and the original accessor receiver.
                                        return Reflect.get(target, property, receiver);
                                    },
                                })
                                : tool_call;
                            if (stableTool.type == null) {
                                throw new OpenAIError(`missing choices[${index}].tool_calls[${i}].type`);
                            }
                            if (stableTool.type === 'custom') {
                                const { custom, type, id, ...toolRest } = stableTool;
                                const { input = '', name, ...customRest } = custom || {};
                                if (name == null) {
                                    throw new OpenAIError(`missing choices[${index}].tool_calls[${i}].custom.name`);
                                }
                                return {
                                    ...toolRest,
                                    id: id || `call_${uuid4()}`,
                                    type,
                                    custom: { ...customRest, name, input },
                                };
                            }
                            const { function: fn, type, id, ...toolRest } = stableTool;
                            const { arguments: args, name, ...fnRest } = fn || {};
                            if (name == null) {
                                throw new OpenAIError(`missing choices[${index}].tool_calls[${i}].function.name`);
                            }
                            if (args == null) {
                                throw new OpenAIError(`missing choices[${index}].tool_calls[${i}].function.arguments`);
                            }
                            return {
                                ...toolRest,
                                id: id || `call_${uuid4()}`,
                                type,
                                function: { ...fnRest, name, arguments: args },
                            };
                        }),
                    },
                };
            }
            return {
                ...choiceRest,
                message: { ...messageRest, ...audioResponse, content, role, refusal: message.refusal ?? null },
                finish_reason: finishReason,
                index,
                logprobs,
            };
        }),
        created,
        model,
        object: 'chat.completion',
        // Spread creates an own data property without invoking inherited setters or changing the object prototype.
        ...(system_fingerprint ? { system_fingerprint } : {}),
    };
    return maybeParseChatCompletion(completion, params);
}
function isCompleteAudio(audio) {
    return audio?.id != null && audio.data != null && audio.transcript != null && audio.expires_at != null;
}
/**
 * Ensures the given argument is an empty object, useful for
 * asserting that all known properties on an object have been
 * destructured.
 */
function assertIsEmpty(obj) {
    void obj;
}
function assertNever(_x) {
    return _x;
}
//# sourceMappingURL=ChatCompletionStream.mjs.map