import { type TSchema } from '../../types/index.mjs';
import { type TExtends, ExtendsResult } from "../../extends/index.mjs";
export declare const CompareResultEqual = 0;
export declare const CompareResultDisjoint = 1;
export declare const CompareResultLeftInside = 2;
export declare const CompareResultRightInside = 3;
export type TCompareResult = (typeof CompareResultEqual | typeof CompareResultDisjoint | typeof CompareResultLeftInside | typeof CompareResultRightInside);
/** Compares left and right types and determines their set relationship */
export type TCompare<Left extends TSchema, Right extends TSchema, Extends extends [ExtendsResult.TResult, ExtendsResult.TResult] = [TExtends<{}, Left, Right>, TExtends<{}, Right, Left>]> = (Extends extends [ExtendsResult.TExtendsTrueLike, ExtendsResult.TExtendsTrueLike] ? typeof CompareResultEqual : Extends extends [ExtendsResult.TExtendsTrueLike, ExtendsResult.TExtendsFalse] ? typeof CompareResultLeftInside : Extends extends [ExtendsResult.TExtendsFalse, ExtendsResult.TExtendsTrueLike] ? typeof CompareResultRightInside : typeof CompareResultDisjoint);
/** Compares left and right types and determines their set relationship. */
export declare function Compare<Left extends TSchema, Right extends TSchema>(left: Left, right: Right): TCompare<Left, Right>;
