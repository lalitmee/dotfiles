import { type TSchema } from '../../types/schema.mjs';
import { type TAny } from '../../types/any.mjs';
import { type TNever } from '../../types/never.mjs';
import { type TUnknown } from '../../types/unknown.mjs';
import { type TCompare, type TCompareResult, CompareResultLeftInside, CompareResultRightInside, CompareResultEqual } from './compare.mjs';
import { type TComposite, type TCanComposite } from './composite.mjs';
type TNarrowCompareRule<Left extends TSchema, Right extends TSchema, Result extends TCompareResult = TCompare<Left, Right>> = (Result extends typeof CompareResultLeftInside ? Left : Result extends typeof CompareResultRightInside ? Right : Result extends typeof CompareResultEqual ? Right : TNever);
type TNarrowCompositeRule<Left extends TSchema, Right extends TSchema, CanCompositeLeft extends boolean = TCanComposite<Left>, CanCompositeRight extends boolean = TCanComposite<Right>> = ([
    CanCompositeLeft,
    CanCompositeRight
] extends [true, true] ? TComposite<Left, Right> : [
    CanCompositeLeft,
    CanCompositeRight
] extends [true, false] ? Left : [
    CanCompositeLeft,
    CanCompositeRight
] extends [false, true] ? Right : TNarrowCompareRule<Left, Right>);
export type TNarrow<Left extends TSchema, Right extends TSchema> = (Left extends TNever ? TNever : Left extends TAny ? TAny : Left extends TUnknown ? Right : Right extends TNever ? TNever : Right extends TAny ? TAny : Right extends TUnknown ? Left : TNarrowCompositeRule<Left, Right>);
export declare function Narrow<Left extends TSchema, Right extends TSchema>(left: Left, right: Right): TNarrow<Left, Right>;
export {};
