import { type XStatic } from '../static/index.mjs';
import * as S from '../types/index.mjs';
export interface XIntern<Type extends unknown = unknown> {
    '~unsafe': Type;
    $ref: string;
    $defs: Record<string, S.XSchemaObject>;
}
/**
 * [Experimental] Performs a Common Subexpression Elimination (CSE) transform on the given
 * schema. This function restructures the schema such that each distinct sub-schema is stored
 * exactly once in a $defs object and keyed by content hash. This function can be used to
 * both compress and optimize schemas prior to compilation.
 */
export declare function Intern<const Schema extends S.XSchema>(schema: Schema): XIntern<XStatic<Schema>>;
