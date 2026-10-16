import type { ZodBigIntDef } from 'zod/v3';
import type { Refs } from "../Refs.js";
import type { ErrorMessages } from "../errorMessages.js";
export type JsonSchema7BigintType = {
    type: 'integer';
    format: 'int64';
    minimum?: bigint;
    exclusiveMinimum?: bigint;
    maximum?: bigint;
    exclusiveMaximum?: bigint;
    multipleOf?: bigint;
    errorMessage?: ErrorMessages<JsonSchema7BigintType>;
};
export declare function parseBigintDef(def: ZodBigIntDef, refs: Refs): JsonSchema7BigintType;
//# sourceMappingURL=bigint.d.ts.map