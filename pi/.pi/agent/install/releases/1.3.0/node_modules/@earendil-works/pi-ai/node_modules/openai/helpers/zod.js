"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.zodResponseFormat = zodResponseFormat;
exports.zodTextFormat = zodTextFormat;
exports.zodFunction = zodFunction;
exports.zodResponsesFunction = zodResponsesFunction;
exports.zodRealtimeFunction = zodRealtimeFunction;
const tslib_1 = require("../internal/tslib.js");
const z4 = tslib_1.__importStar(require("zod/v4"));
const parser_1 = require("../lib/parser.js");
const zod_to_json_schema_1 = require("../_vendor/zod-to-json-schema/index.js");
const ResponsesParser_1 = require("../lib/ResponsesParser.js");
const transform_1 = require("../lib/transform.js");
const values_1 = require("../internal/utils/values.js");
const zod_v3_strict_schema_1 = require("./zod-v3-strict-schema.js");
function encodeSchemaDefinitionRefToken(token) {
    return encodeURIComponent(token.replace(/~/g, '~0').replace(/\//g, '~1'));
}
function validateSchemaDefinitions(schemaDefinitions) {
    if (schemaDefinitions && (0, values_1.hasOwn)(schemaDefinitions, '__proto__')) {
        throw new Error('schemaDefinitions cannot include "__proto__" as a definition name');
    }
}
function escapeSchemaDefinitionRefs(schema, definitionNames) {
    const refReplacements = new Map([...definitionNames].map(([id, name]) => [
        `#/definitions/${id}`,
        `#/definitions/${encodeSchemaDefinitionRefToken(name)}`,
    ]));
    if (refReplacements.size === 0) {
        return schema;
    }
    const visited = new Set();
    const visit = (value) => {
        if (!(0, values_1.isObj)(value) || visited.has(value)) {
            return;
        }
        visited.add(value);
        // SAFETY: The traversal has excluded primitives, null, arrays, and previously visited objects; schema property values remain unknown for validation.
        const record = value;
        const ref = record['$ref'];
        if (typeof ref === 'string') {
            const replacement = refReplacements.get(ref);
            if (replacement !== undefined && replacement !== ref) {
                record['$ref'] = replacement;
            }
        }
        (0, transform_1.forEachJSONSchemaChild)(record, [], visit);
    };
    visit(schema);
    return schema;
}
function getZodV3RootName(name, schemaDefinitions) {
    if (!schemaDefinitions) {
        return name;
    }
    let rootName = name;
    while ((0, values_1.hasOwn)(schemaDefinitions, rootName)) {
        rootName = `${rootName}_root`;
    }
    return rootName;
}
function zodV3ToJsonSchema(schema, options) {
    // SAFETY: This is the Zod v3 conversion path; assertSupportedZodV3Schema verifies the root and named definitions before conversion.
    (0, zod_v3_strict_schema_1.assertSupportedZodV3Schema)(schema, options.schemaDefinitions);
    const rootName = getZodV3RootName(options.name, options.schemaDefinitions);
    // SAFETY: This is the Zod v3 conversion path; assertSupportedZodV3Schema verifies the root and named definitions before conversion.
    const jsonSchema = (0, zod_to_json_schema_1.zodToJsonSchema)(schema, {
        openaiStrictMode: true,
        name: rootName,
        nameStrategy: 'duplicate-ref',
        $refStrategy: 'extract-to-root',
        nullableStrategy: 'property',
        ...(options.schemaDefinitions
            ? { definitions: options.schemaDefinitions }
            : undefined),
    });
    const escapedSchema = escapeSchemaDefinitionRefs(jsonSchema, new Map(Object.keys(options.schemaDefinitions ?? {}).map((name) => [name, name])));
    (0, zod_v3_strict_schema_1.assertJSONSerializableSchema)(escapedSchema);
    return escapedSchema;
}
function zodV4ToJsonSchema(schema, options = {}) {
    const metadata = options.schemaDefinitions ? z4.registry() : undefined;
    const definitionNames = new Map();
    for (const [name, definition] of Object.entries(options.schemaDefinitions ?? {})) {
        // Avoid `/` and `~` so Zod versions that escape JSON Pointer tokens emit the same IDs.
        const id = encodeURIComponent(name).replace(/~/g, '%7E');
        definitionNames.set(id, name);
        // SAFETY: The Zod v4 conversion path registers these definitions with the v4 metadata registry before toJSONSchema uses them.
        metadata?.add(definition, { id });
    }
    // SAFETY: The v4 schema converter produces JSON Schema; the following normalization checks and rewrites its schema records.
    const jsonSchema = z4.toJSONSchema(schema, {
        target: 'draft-7',
        ...(metadata ? { metadata } : undefined),
        override: ({ zodSchema, jsonSchema, path }) => {
            const def = zodSchema._zod.def;
            if (def.type === 'object' && (0, values_1.hasOwn)(def.shape, '__proto__')) {
                const propertyPath = [...path, 'properties', '__proto__']
                    .map((part) => encodeSchemaDefinitionRefToken(String(part)))
                    .join('/');
                throw new Error(`Zod field at \`#/${propertyPath}\` uses unsupported property name \`__proto__\`, which Zod omits from parsed output.`);
            }
            if (def.type === 'union' && 'discriminator' in def && Array.isArray(jsonSchema.oneOf)) {
                if (jsonSchema.anyOf !== undefined) {
                    throw new Error('Zod discriminated union generated both `anyOf` and `oneOf`, which cannot be represented in an OpenAI strict schema');
                }
                // Discriminator values are mutually exclusive, so anyOf preserves the
                // union while staying inside the API's supported JSON Schema subset.
                jsonSchema.anyOf = jsonSchema.oneOf;
                delete jsonSchema.oneOf;
            }
        },
    });
    const escapedSchema = escapeSchemaDefinitionRefs(jsonSchema, definitionNames);
    if (escapedSchema.definitions) {
        escapedSchema.definitions = Object.fromEntries(Object.entries(escapedSchema.definitions).map(([id, definition]) => [
            definitionNames.get(id) ?? id,
            definition,
        ]));
    }
    // SAFETY: Strict conversion returns the normalized object schema; the record view exposes keywords without trusting arbitrary values.
    return (0, transform_1.toStrictJsonSchema)(escapedSchema);
}
function zodV3ToNonStrictJsonSchema(schema, options) {
    return (0, zod_to_json_schema_1.zodToJsonSchema)(schema, {
        name: options.name,
        nameStrategy: 'duplicate-ref',
        $refStrategy: 'extract-to-root',
        pipeStrategy: 'input',
    });
}
function zodV4ToNonStrictJsonSchema(schema) {
    // SAFETY: Zod v4 owns this JSON Schema output; the record return preserves arbitrary supported keyword properties.
    return z4.toJSONSchema(schema, {
        target: 'draft-7',
        io: 'input',
    });
}
function isZodV4(zodObject) {
    return '_zod' in zodObject;
}
function parseZodObject(zodObject, content) {
    const parsed = (0, parser_1.parseResponseFormatContent)({ type: 'json_schema', $parseRaw: undefined }, content);
    const parser = zodObject.parse;
    if (typeof parser === 'function') {
        // SAFETY: The schema's parse method is invoked with its original receiver and owns the inferred output type.
        const result = parser.call(zodObject, parsed);
        // SAFETY: This read only identifies the supported Zod version before applying its corresponding serialization checks.
        if (!isZodV4(zodObject)) {
            (0, zod_v3_strict_schema_1.assertJSONSerializableSchema)(result);
        }
        return result;
    }
    // SAFETY: Schemas without a parse method use the supported Zod v4 core parser, which validates the input and supplies the inferred output.
    return z4.parse(zodObject, parsed);
}
/**
 * Creates a chat completion `JSONSchema` response format object from
 * the given Zod schema.
 *
 * If this is passed to the `.parse()`, `.stream()` or `.runTools()`
 * chat completion methods then the response message will contain a
 * `.parsed` property that is the result of parsing the content with
 * the given Zod object.
 *
 * ```ts
 * const completion = await client.chat.completions.parse({
 *    model: 'gpt-4o-2024-08-06',
 *    messages: [
 *      { role: 'system', content: 'You are a helpful math tutor.' },
 *      { role: 'user', content: 'solve 8x + 31 = 2' },
 *    ],
 *    response_format: zodResponseFormat(
 *      z.object({
 *        steps: z.array(z.object({
 *          explanation: z.string(),
 *          answer: z.string(),
 *        })),
 *        final_answer: z.string(),
 *      }),
 *      'math_answer',
 *    ),
 *  });
 *  const message = completion.choices[0]?.message;
 *  if (message?.parsed) {
 *    console.log(message.parsed);
 *    console.log(message.parsed.final_answer);
 * }
 * ```
 *
 * This can be passed directly to the `.create()` method but will not
 * result in any automatic parsing, you'll have to parse the response yourself.
 *
 * Supports schemas from `zod/v3`, `zod/v4`, and `zod/v4-mini`.
 *
 * @param zodObject Zod schema used to generate and validate structured model output.
 * @param name Model-visible name of the generated strict JSON Schema.
 * @param props Optional response-format metadata and named reusable schema definitions.
 */
function zodResponseFormat(zodObject, name, props) {
    // SAFETY: The public structural Zod input is dispatched by version below; each version-specific converter validates its supported schema contract.
    const zodSchema = zodObject;
    const { schemaDefinitions, ...responseFormatProps } = props ?? {};
    validateSchemaDefinitions(schemaDefinitions);
    return (0, parser_1.makeParseableResponseFormat)({
        type: 'json_schema',
        json_schema: {
            ...responseFormatProps,
            name,
            strict: true,
            schema: isZodV4(zodSchema)
                ? zodV4ToJsonSchema(zodSchema, { schemaDefinitions })
                : zodV3ToJsonSchema(zodSchema, { name, schemaDefinitions }),
        },
    }, (content) => parseZodObject(zodObject, content));
}
/**
 * Creates a strict Responses API text format that validates output with a Zod schema.
 *
 * Pass the returned format as `text.format` to `client.responses.parse()` to
 * populate `response.output_parsed` with the schema's inferred output type.
 * Calling `responses.create()` with the same format does not enable automatic
 * parsing. Schemas from `zod/v3`, `zod/v4`, and `zod/v4-mini` are supported.
 *
 * ```ts
 * const response = await client.responses.parse({
 *   model: 'gpt-5.5',
 *   input: 'Describe the weather.',
 *   text: { format: zodTextFormat(Weather, 'weather') },
 * });
 * console.log(response.output_parsed);
 * ```
 *
 * @param zodObject Zod schema used to generate and validate structured model output.
 * @param name Model-visible name of the generated strict JSON Schema.
 * @param props Optional model-visible text-format metadata, such as a description.
 */
function zodTextFormat(zodObject, name, props) {
    // SAFETY: The public structural Zod input is dispatched by version below; each version-specific converter validates its supported schema contract.
    const zodSchema = zodObject;
    return (0, parser_1.makeParseableTextFormat)({
        type: 'json_schema',
        ...props,
        name,
        strict: true,
        schema: isZodV4(zodSchema) ? zodV4ToJsonSchema(zodSchema) : zodV3ToJsonSchema(zodSchema, { name }),
    }, (content) => parseZodObject(zodObject, content));
}
/** Builds a strict Chat Completions function tool from the supplied Zod schema. */
function zodFunction(options) {
    const parameters = options.parameters;
    // SAFETY: The public structural Zod input is dispatched by version below; each version-specific converter validates its supported schema contract.
    const zodSchema = parameters;
    return (0, parser_1.makeParseableTool)({
        type: 'function',
        function: {
            name: options.name,
            parameters: isZodV4(zodSchema)
                ? zodV4ToJsonSchema(zodSchema)
                : zodV3ToJsonSchema(zodSchema, { name: options.name }),
            strict: true,
            ...(options.description ? { description: options.description } : undefined),
        },
    }, {
        callback: options.function,
        parser: (args) => parseZodObject(parameters, args),
    });
}
/**
 * Creates a strict Responses API function tool with Zod-validated arguments.
 *
 * Passing this tool to `client.responses.parse()` populates
 * `function_call.parsed_arguments` with the inferred schema output. Parsing a
 * response does not invoke the optional callback or submit tool results; the
 * application remains responsible for its function-execution loop.
 *
 * @param options Model-visible function name, Zod parameter schema, optional
 * description, and optional callback metadata.
 */
function zodResponsesFunction(options) {
    const parameters = options.parameters;
    // SAFETY: The public structural Zod input is dispatched by version below; each version-specific converter validates its supported schema contract.
    const zodSchema = parameters;
    return (0, ResponsesParser_1.makeParseableResponseTool)({
        type: 'function',
        name: options.name,
        parameters: isZodV4(zodSchema)
            ? zodV4ToJsonSchema(zodSchema)
            : zodV3ToJsonSchema(zodSchema, { name: options.name }),
        strict: true,
        ...(options.description ? { description: options.description } : undefined),
    }, {
        callback: options.function,
        parser: (args) => parseZodObject(parameters, args),
    });
}
/**
 * Creates a Realtime API `function` tool definition from the given Zod schema.
 *
 * Unlike {@link zodResponsesFunction}, this helper does not add `strict`
 * because Realtime function tools do not support that field.
 *
 * This helper only creates the tool definition. Parse function-call arguments
 * from Realtime events with the original Zod schema.
 *
 * @param options Model-visible function name, Zod parameter schema, and description.
 */
function zodRealtimeFunction(options) {
    // SAFETY: The public structural Zod input is dispatched by version below; each version-specific converter validates its supported schema contract.
    const zodSchema = options.parameters;
    return {
        type: 'function',
        name: options.name,
        parameters: isZodV4(zodSchema)
            ? zodV4ToNonStrictJsonSchema(zodSchema)
            : zodV3ToNonStrictJsonSchema(zodSchema, { name: options.name }),
        ...(options.description ? { description: options.description } : undefined),
    };
}
//# sourceMappingURL=zod.js.map