interface ZodV3Schema {
    _def: unknown;
}
export declare function assertSupportedZodV3Schema(schema: ZodV3Schema, definitions: Record<string, ZodV3Schema> | undefined): void;
export declare function assertJSONSerializableSchema(value: unknown, path?: string, ancestors?: Set<object>): void;
export {};
//# sourceMappingURL=zod-v3-strict-schema.d.mts.map