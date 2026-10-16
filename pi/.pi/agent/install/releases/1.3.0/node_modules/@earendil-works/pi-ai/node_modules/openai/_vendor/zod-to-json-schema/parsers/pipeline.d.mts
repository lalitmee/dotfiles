import type { ZodPipelineDef } from 'zod/v3';
import type { JsonSchema7Type } from "../parseDef.mjs";
import type { Refs } from "../Refs.mjs";
import type { JsonSchema7AllOfType } from "./intersection.mjs";
export declare const parsePipelineDef: (def: ZodPipelineDef<any, any>, refs: Refs, forceResolution: boolean) => JsonSchema7AllOfType | JsonSchema7Type | undefined;
//# sourceMappingURL=pipeline.d.mts.map