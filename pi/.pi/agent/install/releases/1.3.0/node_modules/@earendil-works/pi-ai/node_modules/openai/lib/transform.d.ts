import type { JSONSchema, JSONSchemaDefinition } from "./jsonschema.js";
/** Visits a nested schema together with its root-relative path and containing schema keyword. */
type JSONSchemaChildVisitor = (schema: unknown, path: string[], keyword: string) => void;
/**
 * Visits only values carried by JSON Schema keywords that contain schemas.
 * Literal payloads such as enum, const, and default deliberately do not
 * participate.
 */
export declare function forEachJSONSchemaChild(schema: JSONSchema | Record<string, unknown>, path: string[], visit: JSONSchemaChildVisitor): void;
/**
 * Returns a cloned schema normalized for strict Structured Outputs.
 *
 * Object properties become required, object schemas are closed to additional
 * properties, and representable local references and intersections are preserved.
 *
 * @throws {Error} If the schema cannot be represented without changing its validation semantics.
 */
export declare function toStrictJsonSchema(schema: JSONSchema): JSONSchema;
/**
 * Resolves a local JSON Pointer through schema-bearing keywords only.
 *
 * Returns `undefined` for external references, malformed pointers, missing
 * targets, and pointers into literal values such as `default` or `enum`.
 */
export declare function resolveLocalRef(root: JSONSchema, ref: string): JSONSchemaDefinition | undefined;
/** Returns whether a schema contains only a reference, reusable definitions, and annotations. */
export declare function hasOnlyRefAndAnnotations(schema: JSONSchema): boolean;
/**
 * Rejects nested schema resource identifiers that would change local reference scope.
 *
 * @throws {Error} If a nested subschema defines its own `$id`.
 */
export declare function assertNoNestedSchemaIds(schema: JSONSchema): void;
/**
 * Standard Schema normalization moves representable oneOf branches to anyOf.
 * Rewrite only pointers that traverse an actual oneOf schema array while the
 * original tree is still intact, preserving escaped tokens for every other
 * path segment.
 */
export declare function rewriteLocalRefsIntoMovedOneOfBranches(root: JSONSchema): void;
/**
 * Standard Schema needs to prove oneOf branches exclusive before it rewrites
 * them to anyOf. Inspect a cloned branch through the same conservative object
 * allOf merger without mutating the caller's schema or broadening failures.
 */
export declare function normalizeObjectAllOfForExclusivity(schema: JSONSchema, root: JSONSchema): JSONSchema | undefined;
export {};
//# sourceMappingURL=transform.d.ts.map