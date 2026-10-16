import type { ZodDefaultDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.mjs";
import type { Refs } from "../Refs.mjs";
export declare function parseDefaultDef(_def: ZodDefaultDef, refs: Refs, forceResolution: boolean): JsonSchema7Type & {
    default: any;
};
//# sourceMappingURL=default.d.mts.map