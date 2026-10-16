import { type TSchema } from '../../types/schema.mjs';
import { type TAny } from '../../types/any.mjs';
import { type TNever } from '../../types/never.mjs';
import { type TObject } from '../../types/object.mjs';
import { type TUnknown } from '../../types/unknown.mjs';
import { type TCompare, CompareResultLeftInside, CompareResultEqual, CompareResultDisjoint } from './compare.mjs';
import { type TFlatten } from './flatten.mjs';
import { type TEvaluateType } from './evaluate.mjs';
type TBroadenFilter<Type extends TSchema, Types extends TSchema[], Result extends TSchema[] = [], All extends TSchema[] = Types> = (Types extends [infer Left extends TSchema, ...infer Right extends TSchema[]] ? TCompare<Type, Left> extends typeof CompareResultLeftInside | typeof CompareResultEqual ? All : TCompare<Type, Left> extends typeof CompareResultDisjoint ? TBroadenFilter<Type, Right, [...Result, Left], All> : TBroadenFilter<Type, Right, Result, All> : [...Result, Type]);
type TBroadenType<Type extends TSchema, Types extends TSchema[], Result extends TSchema[], Evaluated extends TSchema = TEvaluateType<Type>> = (Evaluated extends TAny ? [Evaluated] : Evaluated extends TUnknown ? [Evaluated] : Evaluated extends TNever ? TBroadenTypes<Types, Result> : Evaluated extends TObject ? TBroadenTypes<Types, [...Result, Evaluated]> : TBroadenTypes<Types, TBroadenFilter<Evaluated, Result>>);
type TBroadenTypes<Types extends TSchema[], Result extends TSchema[] = []> = (Types extends [infer Left extends TSchema, ...infer Right extends TSchema[]] ? TBroadenType<Left, Right, Result> : Result);
export type TBroaden<Types extends TSchema[], Broadened extends TSchema[] = TBroadenTypes<Types>, Flattened extends TSchema[] = TFlatten<Broadened>> = Flattened;
/** Broadens a set of types and returns either the most broad type, or union or disjoint types. */
export declare function Broaden<Types extends TSchema[]>(types: [...Types]): TBroaden<Types>;
export {};
