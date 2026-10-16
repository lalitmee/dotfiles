/** Normalize an optional public signal without imposing a deadline. */
export declare function operationSignal(signal?: AbortSignal): AbortSignal;
/** Stop waiting on abort while observing the abandoned operation through settlement. */
export declare function raceWithAbortSignal<T>(operation: Promise<T>, signal: AbortSignal | undefined): Promise<T>;
//# sourceMappingURL=abort.d.ts.map