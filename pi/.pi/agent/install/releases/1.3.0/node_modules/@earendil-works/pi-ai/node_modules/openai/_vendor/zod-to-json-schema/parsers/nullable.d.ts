import type { ZodNullableDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.js";
import type { Refs } from "../Refs.js";
import type { JsonSchema7NullType } from "./null.js";
export type JsonSchema7NullableType = {
    anyOf: [JsonSchema7Type, JsonSchema7NullType];
} | {
    type: [string, 'null'];
};
export declare function parseNullableDef(def: ZodNullableDef, refs: Refs, forceResolution: boolean): JsonSchema7NullableType | undefined;
//# sourceMappingURL=nullable.d.ts.map