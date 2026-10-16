import type { ZodDateDef } from 'zod/v3';
import type { Refs } from "../Refs.js";
import type { ErrorMessages } from "../errorMessages.js";
import type { JsonSchema7NumberType } from "./number.js";
import type { DateStrategy } from "../Options.js";
export type JsonSchema7DateType = {
    type: 'integer' | 'string';
    format: 'unix-time' | 'date-time' | 'date';
    minimum?: number;
    maximum?: number;
    errorMessage?: ErrorMessages<JsonSchema7NumberType>;
} | {
    anyOf: JsonSchema7DateType[];
};
export declare function parseDateDef(def: ZodDateDef, refs: Refs, overrideDateStrategy?: DateStrategy): JsonSchema7DateType;
//# sourceMappingURL=date.d.ts.map