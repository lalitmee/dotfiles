/** OpenAI endpoint regions selectable without specifying a full base URL. */
export type DataResidency = 'global' | 'us' | 'eu' | 'ae';
/** Resolves an explicit residency selection before client options are inherited. */
export declare function resolveDataResidency(options: {
    /** Residency shorthand; null and undefined preserve ordinary URL resolution. */
    dataResidency?: DataResidency | null | undefined;
    /** Explicit API root, mutually exclusive with a residency selection. */
    baseURL?: string | null | undefined;
}): string | undefined;
/** Prevents legacy provider clients from selecting an OpenAI endpoint. */
export declare function assertNoDataResidency(dataResidency: DataResidency | null | undefined, clientName: string): void;
//# sourceMappingURL=data-residency.d.ts.map