/** Internal callback subscriptions with optional discriminator filters; no buffering or replay. */
export declare class Subscriptions<Event extends {
    type: string;
}> {
    private readonly listeners;
    /** Registers independently, including when the same function is supplied twice. */
    add(listener: (event: Event) => unknown, type?: Event['type']): () => void;
    /** Delivers in registration order, isolating application exceptions from the transport. */
    emit(event: Event): void;
    /** Releases all subscriber references. Existing unsubscribe functions remain safe. */
    clear(): void;
}
//# sourceMappingURL=subscriptions.d.ts.map