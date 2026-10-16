import type { ZodPipelineDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.js";
import type { Refs } from "../Refs.js";
import type { JsonSchema7AllOfType } from "./intersection.js";
export declare const parsePipelineDef: (def: ZodPipelineDef<any, any>, refs: Refs, forceResolution: boolean) => JsonSchema7AllOfType | JsonSchema7Type | undefined;
//# sourceMappingURL=pipeline.d.ts.map