import type { XSchema } from '../types/schema.mjs';
import type { XStaticSchema } from './schema.mjs';
export type XStaticPropertyNames<Stack extends string[], Root extends XSchema, Schema extends XSchema, StaticKey extends unknown = XStaticSchema<Stack, Root, Schema>, Result extends Record<string, unknown> = [StaticKey] extends [PropertyKey] ? {
    [Key in StaticKey]?: unknown;
} : {}> = Result;
