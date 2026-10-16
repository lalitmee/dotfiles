/**
 * Percent-encodes a single URI path parameter while preserving RFC 3986 path characters.
 *
 * Slash, question-mark, and hash characters are encoded so an interpolated value
 * cannot create another path segment, query string, or fragment.
 *
 * Taken from https://datatracker.ietf.org/doc/html/rfc3986#section-3.3:
 * > unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
 * > sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
 * > pchar       = unreserved / pct-encoded / sub-delims / ":" / "@"
 */
export declare function encodeURIPath(str: string): string;
/**
 * Creates a template tag that safely interpolates SDK resource paths.
 *
 * Path values use the supplied encoder; values after a literal `?` or `#` use
 * `encodeURIComponent`. Nullish values, ordinary objects, and literal or
 * percent-encoded `.`/`..` path segments are rejected with an SDK error.
 */
export declare const createPathTagFunction: (pathEncoder?: typeof encodeURIPath) => (statics: readonly string[], ...params: readonly unknown[]) => string;
/**
 * Template tag that encodes resource-path parameters and rejects traversal segments.
 *
 * Values inside query strings and fragments are encoded as URI components.
 */
export declare const path: (statics: readonly string[], ...params: readonly unknown[]) => string;
//# sourceMappingURL=path.d.ts.map