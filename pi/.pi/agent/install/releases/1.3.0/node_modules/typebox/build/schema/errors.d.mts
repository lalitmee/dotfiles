import { type TLocalizedValidationError } from '../error/index.mjs';
import * as Schema from './types/index.mjs';
/** Returns an array of validation errors for the given value. */
export declare function Errors(schema: Schema.XSchema, value: unknown): [boolean, TLocalizedValidationError[]];
/** Returns an array of validation errors for the given value. */
export declare function Errors(context: Record<PropertyKey, Schema.XSchema>, schema: Schema.XSchema, value: unknown): [boolean, TLocalizedValidationError[]];
