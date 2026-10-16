export declare function isAssistantStreamValueExternallyMutable(value: unknown): boolean;
export declare function markAssistantStreamValueExternallyMutable(value: unknown): void;
export declare function defineAssistantStreamArrayEntry(accumulator: unknown[], index: number, value: unknown): void;
export declare function assertSafeAssistantStreamDelta(value: unknown): void;
export declare function accumulateAssistantStreamDelta<Accumulator extends object>(accumulator: Accumulator, delta: object, cacheArrays?: boolean): Accumulator;
export declare function createAssistantStreamArrayDeltaCommit(accumulator: unknown[], delta: unknown[], kind: 'content' | 'array', cacheArrays?: boolean): () => void;
//# sourceMappingURL=assistant-stream-delta.d.mts.map