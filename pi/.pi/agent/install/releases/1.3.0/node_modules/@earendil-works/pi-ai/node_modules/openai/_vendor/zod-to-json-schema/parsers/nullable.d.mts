import type { ZodNullableDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.mjs";
import type { Refs } from "../Refs.mjs";
import type { JsonSchema7NullType } from "./null.mjs";
export type JsonSchema7NullableType = {
    anyOf: [JsonSchema7Type, JsonSchema7NullType];
} | {
    type: [string, 'null'];
};
export declare function parseNullableDef(def: ZodNullableDef, refs: Refs, forceResolution: boolean): JsonSchema7NullableType | undefined;
//# sourceMappingURL=nullable.d.mts.map