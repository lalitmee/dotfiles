type AbortCallback = () => void;
/** Keep cancellation alive until abort or collection of the response body or bodyless custom response. */
export declare function retainRequestAbortCallback(owner: object, abort: AbortCallback, requestSignal: AbortSignal): void;
/**
 * Share one caller listener without it retaining completed requests. Collection removes
 * weak subscriptions eventually; a live response body or custom response retains its callback.
 * Runtimes without weak references keep the existing listener-based behavior.
 */
export declare function addRequestAbortListener(signal: AbortSignal, abort: AbortCallback, requestSignal: AbortSignal): AbortCallback;
export {};
//# sourceMappingURL=abort.d.mts.map