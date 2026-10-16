import type { ZodDefaultDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.js";
import type { Refs } from "../Refs.js";
export declare function parseDefaultDef(_def: ZodDefaultDef, refs: Refs, forceResolution: boolean): JsonSchema7Type & {
    default: any;
};
//# sourceMappingURL=default.d.ts.map