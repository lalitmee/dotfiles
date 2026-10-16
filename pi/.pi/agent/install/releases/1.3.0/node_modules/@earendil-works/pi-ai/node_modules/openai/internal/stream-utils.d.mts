/**
 * Exposes a readable stream as an async iterator across runtimes with different
 * built-in stream iteration support.
 *
 * Existing async iterators are reused; async-iterable streams that are not
 * themselves iterators are converted through `Symbol.asyncIterator`. Iterator
 * results without their own async-iterator method are adapted while preserving
 * cancellation and error propagation. Streams without built-in iteration are
 * locked with `getReader()` until iteration completes, fails, or is canceled.
 * Returning early cancels a fallback stream and releases its reader lock.
 *
 * Adapted from https://github.com/MattiasBuelens/web-streams-polyfill/pull/122#issuecomment-1627354490.
 */
export declare function ReadableStreamToAsyncIterable<T>(stream: any): AsyncIterableIterator<T>;
//# sourceMappingURL=stream-utils.d.mts.map