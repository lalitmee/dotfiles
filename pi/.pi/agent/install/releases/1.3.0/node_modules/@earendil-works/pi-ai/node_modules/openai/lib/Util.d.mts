/**
 * Like `Promise.allSettled()` but throws an error if any promises are rejected.
 * Rejection reasons remain available on the thrown error's non-enumerable `rejections`
 * property without being written to the global console.
 */
export declare const allSettledWithThrow: <R>(promises: Promise<R>[]) => Promise<R[]>;
//# sourceMappingURL=Util.d.mts.map