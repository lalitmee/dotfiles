import type { ZodLiteralDef } from 'zod/v3';
import type { Refs } from "../Refs.mjs";
export type JsonSchema7LiteralType = {
    type: 'string' | 'number' | 'integer' | 'boolean';
    const: string | number | boolean;
} | {
    type: 'null';
    const?: null;
} | {
    type: 'object' | 'array';
};
export declare function parseLiteralDef(def: ZodLiteralDef, refs: Refs): JsonSchema7LiteralType;
//# sourceMappingURL=literal.d.mts.map