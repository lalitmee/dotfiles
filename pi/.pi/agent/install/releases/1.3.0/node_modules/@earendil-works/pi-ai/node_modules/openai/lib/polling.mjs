import { APIUserAbortError } from "../core/error.mjs";
import { buildHeaders } from "../internal/headers.mjs";
import { sleep } from "../internal/utils/sleep.mjs";
function sleepUntilAborted(milliseconds, signal) {
    // oxlint-disable-next-line promise/avoid-new -- Timer and abort callbacks need a portable Promise bridge.
    return new Promise((resolve, reject) => {
        let timer;
        let registered;
        let settled = false;
        const removeAbortListener = (listener) => {
            try {
                signal.removeEventListener('abort', listener);
            }
            catch {
                // Caller-controlled cleanup must never prevent the polling promise from settling.
            }
        };
        const cleanup = () => {
            if (timer !== undefined) {
                clearTimeout(timer);
                timer = undefined;
            }
            if (registered) {
                const listener = registered;
                registered = undefined;
                removeAbortListener(listener);
            }
        };
        const abort = () => {
            if (settled) {
                return;
            }
            settled = true;
            cleanup();
            try {
                const error = new APIUserAbortError();
                Object.defineProperty(error, 'cause', {
                    value: signal.reason,
                    writable: true,
                    configurable: true,
                });
                reject(error);
            }
            catch (error) {
                reject(error);
            }
        };
        if (signal.aborted) {
            abort();
            return;
        }
        timer = setTimeout(() => {
            if (settled) {
                return;
            }
            settled = true;
            cleanup();
            resolve();
        }, milliseconds);
        registered = abort;
        try {
            signal.addEventListener('abort', abort, { once: true });
            if (settled) {
                removeAbortListener(abort);
            }
            else if (signal.aborted) {
                abort();
            }
        }
        catch (error) {
            if (settled) {
                removeAbortListener(abort);
            }
            else {
                settled = true;
                cleanup();
                reject(error);
            }
        }
    });
}
/**
 * Repeatedly retrieves a lifecycle resource using the existing polling-helper
 * headers. Intermediate states wait for the explicit interval (including zero),
 * the server interval, or five-second default; terminal states return the same parsed object.
 * The caller's signal interrupts intermediate waits, unknown states retry
 * immediately, and retrieval errors propagate unchanged.
 *
 * @internal
 */
export async function pollWithResponse(retrieve, intermediateStatuses, terminalStatuses, options) {
    const headers = buildHeaders([
        options?.headers,
        {
            'X-Stainless-Poll-Helper': 'true',
            'X-Stainless-Custom-Poll-Interval': options?.pollIntervalMs?.toString() ?? undefined,
        },
    ]);
    while (true) {
        // oxlint-disable-next-line no-await-in-loop -- Each poll depends on the previous response.
        const { data, response } = await retrieve(headers).withResponse();
        const { status } = data;
        if (intermediateStatuses.includes(status)) {
            let sleepInterval = 5000;
            const pollIntervalMs = options?.pollIntervalMs;
            if (pollIntervalMs || pollIntervalMs === 0) {
                sleepInterval = pollIntervalMs;
            }
            else {
                const headerInterval = response.headers.get('openai-poll-after-ms');
                if (headerInterval) {
                    // oxlint-disable-next-line radix -- Preserve the existing decimal and hexadecimal header parsing.
                    const headerIntervalMs = Number.parseInt(headerInterval);
                    if (!Number.isNaN(headerIntervalMs)) {
                        sleepInterval = headerIntervalMs;
                    }
                }
            }
            const signal = options && Object.prototype.propertyIsEnumerable.call(options, 'signal') ? options.signal : undefined;
            // oxlint-disable-next-line no-await-in-loop -- Each poll waits or aborts before the next request.
            await (signal ? sleepUntilAborted(sleepInterval, signal) : sleep(sleepInterval));
        }
        else if (terminalStatuses.includes(status)) {
            return data;
        }
    }
}
//# sourceMappingURL=polling.mjs.map