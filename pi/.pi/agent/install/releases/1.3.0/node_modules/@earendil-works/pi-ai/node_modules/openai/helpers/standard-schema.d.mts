import type { AutoParseableResponseFormat, AutoParseableTextFormat, AutoParseableTool } from "../lib/parser.mjs";
import type { AutoParseableResponseTool } from "../lib/ResponsesParser.mjs";
import type { JSONSchema } from "../lib/jsonschema.mjs";
import type { ResponseFormatJSONSchema } from "../resources/index.mjs";
import type { ResponseFormatTextJSONSchemaConfig } from "../resources/responses/responses.mjs";
/** Validation issue returned by a Standard Schema-compatible validator. */
type StandardSchemaIssue = {
    /** Human-readable explanation of the validation failure. */
    readonly message: string;
    /** Optional path identifying the input property or array element that failed validation. */
    readonly path?: readonly (PropertyKey | {
        /** Property name, symbol, or array index associated with this path segment. */
        readonly key: PropertyKey;
    })[] | undefined;
};
/** Successful parsed output or validation issues produced by a Standard Schema validator. */
type StandardSchemaResult<Output> = {
    /** Parsed and validated value returned by a successful validation. */
    readonly value: Output;
    /** Validation issues are absent when parsing succeeds. */
    readonly issues?: undefined;
} | {
    /** Validation issues describing why the input could not be parsed. */
    readonly issues: readonly StandardSchemaIssue[];
};
/** JSON Schema conversion settings passed to a Standard Schema implementation. */
type StandardJSONSchemaOptions = {
    /** JSON Schema dialect required by the SDK's structured-output helpers. */
    readonly target: 'draft-07';
    /** Optional validator-specific JSON Schema conversion settings. */
    readonly libraryOptions?: Record<string, unknown> | undefined;
};
/** Minimal Standard Schema v1 validator contract accepted by the public parsing helpers. */
type StandardSchemaLike<Input = unknown, Output = Input> = {
    /** Standard Schema metadata, validation entrypoint, and optional JSON Schema conversion. */
    readonly '~standard': {
        /** Standard Schema specification version supported by the validator. */
        readonly version: 1;
        /** Identifier of the library that implements this Standard Schema validator. */
        readonly vendor: string;
        /** Optional type-level input and output metadata used to infer parsed result types. */
        readonly types?: {
            /** Type accepted by the validator before parsing or transformation. */
            readonly input: Input;
            /** Type produced after successful validation or transformation. */
            readonly output: Output;
        } | undefined;
        /**
         * Validates model output; SDK parsing helpers require this method to finish synchronously.
         * Promise-returning validators are rejected when a response is parsed.
         */
        readonly validate: (value: unknown) => StandardSchemaResult<Output> | Promise<StandardSchemaResult<Output>>;
        /** Optional JSON Schema conversion methods; provide an explicit `schema` when absent. */
        readonly jsonSchema?: {
            /** Produces the model-facing input JSON Schema for the requested dialect. */
            readonly input: (options: StandardJSONSchemaOptions) => Record<string, unknown>;
            /** Produces an optional output JSON Schema; structured-output helpers use `input` instead. */
            readonly output?: (options: StandardJSONSchemaOptions) => Record<string, unknown>;
        } | undefined;
    };
};
/** Extracts parsed Standard Schema output, falling back to `unknown` without type metadata. */
type InferStandardOutput<Schema extends StandardSchemaLike> = [
    NonNullable<Schema['~standard']['types']>
] extends [never] ? unknown : NonNullable<Schema['~standard']['types']> extends {
    /** Parsed output type declared by the Standard Schema validator's type metadata. */
    readonly output: infer Output;
} ? Output : unknown;
/** Supplies a model-facing JSON Schema when a validator cannot generate one itself. */
type StandardSchemaJSONSchemaProps = {
    /**
     * A JSON Schema override for Standard Schema implementations that do not
     * expose `~standard.jsonSchema.input()`.
     */
    schema?: JSONSchema | Record<string, unknown> | undefined;
};
/** Optional Chat Completions response-format metadata and explicit JSON Schema override. */
type StandardResponseFormatProps = Omit<ResponseFormatJSONSchema.JSONSchema, 'schema' | 'strict' | 'name'> & StandardSchemaJSONSchemaProps;
/** Optional Responses API text-format metadata and explicit JSON Schema override. */
type StandardTextFormatProps = Omit<ResponseFormatTextJSONSchemaConfig, 'schema' | 'type' | 'strict' | 'name'> & StandardSchemaJSONSchemaProps;
/** Function callback invoked with arguments validated by a Standard Schema implementation. */
type StandardToolFunction<Parameters extends StandardSchemaLike> = (args: InferStandardOutput<Parameters>) => unknown | Promise<unknown>;
/** Model-facing function-tool settings and optional Standard Schema validation callback. */
type StandardToolOptions<Parameters extends StandardSchemaLike> = {
    /** Model-visible function name used to identify matching tool calls. */
    name: string;
    /** Standard Schema validator used to describe and validate the function's arguments. */
    parameters: Parameters;
    /**
     * A JSON Schema override for Standard Schema implementations that do not
     * expose `~standard.jsonSchema.input()`.
     */
    schema?: JSONSchema | Record<string, unknown> | undefined;
    /** Optional callback retained on the tool and invoked by compatible chat `runTools()` helpers. */
    function?: StandardToolFunction<Parameters> | undefined;
    /** Optional model-visible explanation of when and how the function should be used. */
    description?: string | undefined;
};
/** Type-level function-tool metadata preserving validated arguments and callback availability. */
type StandardToolReturnOptions<Parameters extends StandardSchemaLike, ToolFunction extends StandardToolFunction<Parameters> | undefined> = {
    /** Inferred argument type returned by the Standard Schema validator. */
    arguments: InferStandardOutput<Parameters>;
    /** Model-visible name used to match generated function calls. */
    name: string;
    /** Callback type when supplied, or `undefined` for a parse-only function tool. */
    function: ToolFunction;
};
/**
 * Creates a chat completion `JSONSchema` response format from a Standard
 * Schema validator.
 *
 * The helper uses `~standard.jsonSchema.input()` for the model-facing schema
 * and `~standard.validate()` for parsed output. Validation must be
 * synchronous because the SDK's parse helpers are synchronous.
 *
 * Pass the returned format to `client.chat.completions.parse()` to populate
 * `message.parsed`. Supply `props.schema` when the validator does not implement
 * `~standard.jsonSchema.input()`.
 *
 * @param standardSchema Standard Schema v1 validator used to describe and parse output.
 * @param name Model-visible name of the generated strict JSON Schema.
 * @param props Optional response-format metadata and explicit JSON Schema override.
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardResponseFormat<Schema extends StandardSchemaLike>(standardSchema: Schema, name: string, props?: StandardResponseFormatProps): AutoParseableResponseFormat<InferStandardOutput<Schema>>;
/**
 * Creates a Responses API `json_schema` text format from a Standard Schema
 * validator.
 *
 * Pass the returned format as `text.format` to `client.responses.parse()` to
 * populate `response.output_parsed`. Validation must be synchronous. Supply
 * `props.schema` when the validator cannot generate its own input JSON Schema.
 *
 * @param standardSchema Standard Schema v1 validator used to describe and parse output.
 * @param name Model-visible name of the generated strict JSON Schema.
 * @param props Optional text-format metadata and explicit JSON Schema override.
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardTextFormat<Schema extends StandardSchemaLike>(standardSchema: Schema, name: string, props?: StandardTextFormatProps): AutoParseableTextFormat<InferStandardOutput<Schema>>;
/**
 * Creates a chat completion `function` tool from a Standard Schema
 * validator and a callback that can be invoked by `chat.completions.runTools()`.
 *
 * The generated tool uses strict JSON Schema, and arguments are validated
 * synchronously before the callback receives them. Supply `options.schema`
 * when the validator cannot generate an input JSON Schema.
 *
 * @param options Model-visible function details, synchronous parameter validator,
 * optional schema override, and required execution callback.
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardFunction<Parameters extends StandardSchemaLike, ToolFunction extends StandardToolFunction<Parameters>>(options: StandardToolOptions<Parameters> & {
    /** Callback invoked with synchronously validated arguments by chat `runTools()`. */
    function: ToolFunction;
}): AutoParseableTool<StandardToolReturnOptions<Parameters, ToolFunction>>;
/**
 * Creates a parse-only Chat Completions function tool without an execution callback.
 *
 * Arguments are validated synchronously by `chat.completions.parse()` or
 * `.stream()`. Callback-free tools cannot be executed by `runTools()`.
 *
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardFunction<Parameters extends StandardSchemaLike>(options: StandardToolOptions<Parameters> & {
    /** No execution callback is attached to this parse-only function tool. */
    function?: undefined;
}): AutoParseableTool<StandardToolReturnOptions<Parameters, undefined>>;
/**
 * Creates a strict Chat Completions function tool with an optionally available callback.
 * The validator must support synchronous validation and provide or receive a JSON Schema.
 *
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardFunction<Parameters extends StandardSchemaLike>(options: StandardToolOptions<Parameters>): AutoParseableTool<StandardToolReturnOptions<Parameters, StandardToolFunction<Parameters> | undefined>>;
/**
 * Creates a strict Responses API function tool from a Standard Schema validator and callback.
 *
 * `client.responses.parse()` validates matching function-call arguments and
 * exposes them as `parsed_arguments`; it does not execute the attached callback
 * or submit tool results. Validation must complete synchronously.
 *
 * @param options Model-visible function details, synchronous parameter validator,
 * optional schema override, and callback metadata.
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardResponsesFunction<Parameters extends StandardSchemaLike, ToolFunction extends StandardToolFunction<Parameters>>(options: StandardToolOptions<Parameters> & {
    /** Callback retained on the tool; `responses.parse()` does not execute it. */
    function: ToolFunction;
}): AutoParseableResponseTool<StandardToolReturnOptions<Parameters, ToolFunction>>;
/**
 * Creates a parse-only Responses API function tool without an execution callback.
 * `responses.parse()` exposes synchronously validated arguments as `parsed_arguments`.
 *
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardResponsesFunction<Parameters extends StandardSchemaLike>(options: StandardToolOptions<Parameters> & {
    /** No execution callback is attached to this parse-only function tool. */
    function?: undefined;
}): AutoParseableResponseTool<StandardToolReturnOptions<Parameters, undefined>>;
/**
 * Creates a strict Responses API function tool with an optionally available callback.
 * Argument validation is synchronous; `responses.parse()` does not execute callbacks.
 *
 * @throws {OpenAIError} If no JSON Schema is available or its `oneOf` branches
 * cannot be represented safely.
 * @throws {Error} If strict normalization rejects another unsupported or
 * unrepresentable JSON Schema feature.
 * @throws {TypeError} If malformed JSON Schema values have unexpected structural types.
 */
export declare function standardResponsesFunction<Parameters extends StandardSchemaLike>(options: StandardToolOptions<Parameters>): AutoParseableResponseTool<StandardToolReturnOptions<Parameters, StandardToolFunction<Parameters> | undefined>>;
export {};
//# sourceMappingURL=standard-schema.d.mts.map