import type { ZodSetDef } from 'zod/v3';
import type { ErrorMessages } from "../errorMessages.js";
import type { JsonSchema7Type } from "../parseDef.js";
import type { Refs } from "../Refs.js";
export type JsonSchema7SetType = {
    type: 'array';
    uniqueItems: true;
    items?: JsonSchema7Type | undefined;
    minItems?: number;
    maxItems?: number;
    errorMessage?: ErrorMessages<JsonSchema7SetType>;
};
export declare function parseSetDef(def: ZodSetDef, refs: Refs): JsonSchema7SetType;
//# sourceMappingURL=set.d.ts.map