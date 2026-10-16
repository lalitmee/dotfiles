import type { ZodIntersectionDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.js";
import type { Refs } from "../Refs.js";
export type JsonSchema7AllOfType = {
    allOf: JsonSchema7Type[];
    unevaluatedProperties?: boolean;
};
export declare function parseIntersectionDef(def: ZodIntersectionDef, refs: Refs): JsonSchema7AllOfType | JsonSchema7Type | undefined;
//# sourceMappingURL=intersection.d.ts.map