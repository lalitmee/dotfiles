import type { ZodArrayDef } from 'zod/v3';
import type { ErrorMessages } from "../errorMessages.mjs";
import type { JsonSchema7Type } from "../parseDef.mjs";
import type { Refs } from "../Refs.mjs";
export type JsonSchema7ArrayType = {
    type: 'array';
    items?: JsonSchema7Type | undefined;
    minItems?: number;
    maxItems?: number;
    errorMessages?: ErrorMessages<JsonSchema7ArrayType, 'items'>;
};
export declare function parseArrayDef(def: ZodArrayDef, refs: Refs): JsonSchema7ArrayType;
//# sourceMappingURL=array.d.mts.map