import type { TProperties, TSchema } from '../../type/index.mjs';
import type { TLocalizedValidationError } from '../../error/index.mjs';
/** Returns an array of validation errors for the given value. */
export declare function Errors<Type extends TSchema>(type: Type, value: unknown): TLocalizedValidationError[];
/** Returns an array of validation errors for the given value. */
export declare function Errors<Context extends TProperties, Type extends TSchema>(context: Context, type: Type, value: unknown): TLocalizedValidationError[];
