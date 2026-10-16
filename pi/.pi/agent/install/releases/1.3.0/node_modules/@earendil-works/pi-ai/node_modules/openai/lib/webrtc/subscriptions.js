"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Subscriptions = void 0;
function reportApplicationError(error) {
    // SAFETY: reportError is an optional host facility and is checked to be callable before forwarding an application error.
    const host = globalThis;
    if (typeof host.reportError === 'function') {
        host.reportError(error);
    }
    else {
        setTimeout(() => {
            throw error;
        }, 0);
    }
}
async function observeResult(result) {
    try {
        await result;
    }
    catch (error) {
        reportApplicationError(error);
    }
}
/** Internal callback subscriptions with optional discriminator filters; no buffering or replay. */
class Subscriptions {
    constructor() {
        this.listeners = new Set();
    }
    /** Registers independently, including when the same function is supplied twice. */
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    add(listener, type) {
        const registration = { listener, type };
        this.listeners.add(registration);
        return () => {
            this.listeners.delete(registration);
        };
    }
    /** Delivers in registration order, isolating application exceptions from the transport. */
    emit(event) {
        const { type } = event;
        const snapshot = [...this.listeners];
        for (const registration of snapshot) {
            if (!this.listeners.has(registration) ||
                (registration.type !== undefined && registration.type !== type)) {
                continue;
            }
            try {
                const result = registration.listener(event);
                if (result !== null && (typeof result === 'object' || typeof result === 'function')) {
                    void observeResult(result);
                }
            }
            catch (error) {
                reportApplicationError(error);
            }
        }
    }
    /** Releases all subscriber references. Existing unsubscribe functions remain safe. */
    clear() {
        this.listeners.clear();
    }
}
exports.Subscriptions = Subscriptions;
//# sourceMappingURL=subscriptions.js.map