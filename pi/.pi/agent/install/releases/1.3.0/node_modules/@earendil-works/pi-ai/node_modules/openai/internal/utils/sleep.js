"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sleep = void 0;
const sleep = (ms, ...signals) => new Promise((resolve, reject) => {
    const activeSignals = [...new Set(signals.filter((signal) => signal != null))];
    let timeout;
    let settled = false;
    const cleanup = () => {
        for (const signal of activeSignals) {
            try {
                signal.removeEventListener('abort', abort);
            }
            catch {
                // Structural signal cleanup must not prevent the promise from settling.
            }
        }
    };
    const settle = (callback) => {
        if (settled) {
            return;
        }
        settled = true;
        if (timeout !== undefined) {
            clearTimeout(timeout);
            timeout = undefined;
        }
        cleanup();
        callback();
    };
    const abort = () => {
        settle(() => reject());
    };
    if (activeSignals.some((signal) => signal.aborted)) {
        abort();
        return;
    }
    timeout = setTimeout(() => {
        settle(resolve);
    }, ms);
    for (const signal of activeSignals) {
        if (settled) {
            break;
        }
        try {
            signal.addEventListener('abort', abort, { once: true });
        }
        catch (error) {
            settle(() => reject(error));
        }
    }
    if (activeSignals.some((signal) => signal.aborted)) {
        abort();
    }
});
exports.sleep = sleep;
//# sourceMappingURL=sleep.js.map