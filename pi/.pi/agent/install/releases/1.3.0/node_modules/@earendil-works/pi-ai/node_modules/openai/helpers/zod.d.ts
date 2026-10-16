import type { ResponseFormatJSONSchema } from "../resources/index.js";
import type { AutoParseableResponseFormat, AutoParseableTextFormat, AutoParseableTool } from "../lib/parser.js";
import type { AutoParseableResponseTool } from "../lib/ResponsesParser.js";
import type { ResponseFormatTextJSONSchemaConfig } from "../resources/responses/responses.js";
import type { RealtimeFunctionTool } from "../resources/realtime/realtime.js";
/** Minimal Zod v3, v4, or v4 Mini schema shape accepted by the public parsing helpers. */
type ZodTypeLike = ({
    /** Inferred parsed-output type exposed by Zod v3 and compatible Zod schemas. */
    _output: unknown;
} | {
    /** Zod v4 schema metadata that exposes the inferred parsed-output type. */
    _zod: {
        /** Inferred value produced after successful schema validation. */
        output: unknown;
    };
}) & {
    /** Synchronous schema parser when the validator exposes an instance-level parse method. */
    parse?: (data: unknown) => unknown;
};
/** Extracts the validated output type from a supported Zod schema. */
type InferZodType<T extends ZodTypeLike> = T extends {
    /** Parsed output type exposed directly by Zod v3 and compatible schemas. */
    _output: infer Output;
} ? Output : T extends {
    /** Zod v4 schema metadata containing its inferred parsed-output type. */
    _zod: {
        /** Parsed value type inferred from the Zod v4 schema. */
        output: infer Output;
    };
} ? Output : never;
/** Named reusable Zod schemas extracted into a generated JSON Schema definitions object. */
type ZodSchemaDefinitions = Record<string, ZodTypeLike>;
/** Optional model-visible metadata and reusable schema definitions for a chat response format. */
type ZodResponseFormatProps = Omit<ResponseFormatJSONSchema.JSONSchema, 'schema' | 'strict' | 'name'> & {
    /**
     * Schemas to extract into the generated JSON Schema definitions.
     * Use this to reuse large shared schemas instead of inlining them at every occurrence.
     */
    schemaDefinitions?: ZodSchemaDefinitions | undefined;
};
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
export declare function zodResponseFormat<ZodInput extends ZodTypeLike>(zodObject: ZodInput, name: string, props?: ZodResponseFormatProps): AutoParseableResponseFormat<InferZodType<ZodInput>>;
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
export declare function zodTextFormat<ZodInput extends ZodTypeLike>(zodObject: ZodInput, name: string, props?: Omit<ResponseFormatTextJSONSchemaConfig, 'schema' | 'type' | 'strict' | 'name'>): AutoParseableTextFormat<InferZodType<ZodInput>>;
/** Model-facing settings and an optional execution callback for a Zod function tool. */
interface ZodFunctionOptions<Parameters extends ZodTypeLike> {
    /** Model-visible function name used to identify matching tool calls. */
    name: string;
    /** Zod schema used to describe and validate the function's JSON arguments. */
    parameters: Parameters;
    /** Optional callback invoked with validated arguments by chat `runTools()`. */
    function?: ((args: InferZodType<Parameters>) => unknown | Promise<unknown>) | undefined;
    /** Optional model-visible explanation of when and how the function should be used. */
    description?: string | undefined;
}
/** A Zod function tool retaining its inferred argument and callback types. */
type ZodFunctionTool<Parameters extends ZodTypeLike, Callback extends ZodFunctionOptions<Parameters>['function']> = AutoParseableTool<{
    /** Inferred argument type produced by the Zod parameter schema. */
    arguments: InferZodType<Parameters>;
    /** Model-visible name used to match generated function calls. */
    name: string;
    /** Callback availability determines whether the tool can be executed. */
    function: Callback;
}>;
/**
 * Creates a chat completion `function` tool that can be invoked automatically
 * by `.runTools()` or parsed by `.parse()` / `.stream()`.
 *
 * Arguments are converted to strict JSON Schema and validated with the supplied
 * Zod schema before the callback receives them.
 *
 * @param options Model-visible function name, Zod parameter schema, description,
 * and callback used by `chat.completions.runTools()`.
 */
export declare function zodFunction<Parameters extends ZodTypeLike>(options: ZodFunctionOptions<Parameters> & {
    /** Callback invoked with validated arguments by chat `runTools()`. */
    function: NonNullable<ZodFunctionOptions<Parameters>['function']>;
}): ZodFunctionTool<Parameters, NonNullable<ZodFunctionOptions<Parameters>['function']>>;
/**
 * Creates a strict chat completion function tool for `.parse()` / `.stream()`.
 * Without a guaranteed callback, the tool cannot be executed by `.runTools()`.
 *
 * @param options Model-visible function details and an optional callback.
 */
export declare function zodFunction<Parameters extends ZodTypeLike>(options: ZodFunctionOptions<Parameters>): ZodFunctionTool<Parameters, ZodFunctionOptions<Parameters>['function']>;
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
export declare function zodResponsesFunction<Parameters extends ZodTypeLike>(options: {
    /** Model-visible function name used to identify matching tool calls. */
    name: string;
    /** Zod schema used to describe and validate the function's JSON arguments. */
    parameters: Parameters;
    /** Optional callback retained on the tool; `responses.parse()` does not execute it. */
    function?: ((args: InferZodType<Parameters>) => unknown | Promise<unknown>) | undefined;
    /** Optional model-visible explanation of when and how the function should be used. */
    description?: string | undefined;
}): AutoParseableResponseTool<{
    /** Inferred argument type produced by the Zod parameter schema. */
    arguments: InferZodType<Parameters>;
    /** Model-visible name used to match generated function calls. */
    name: string;
    /** Callback signature associated with validated function-call arguments. */
    function: (args: InferZodType<Parameters>) => unknown;
}>;
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
export declare function zodRealtimeFunction<Parameters extends ZodTypeLike>(options: {
    /** Model-visible function name used to identify Realtime function calls. */
    name: string;
    /** Zod schema converted into the Realtime function's non-strict JSON Schema. */
    parameters: Parameters;
    /** Optional model-visible explanation of when and how the function should be used. */
    description?: string | undefined;
}): RealtimeFunctionTool;
export {};
//# sourceMappingURL=zod.d.ts.map