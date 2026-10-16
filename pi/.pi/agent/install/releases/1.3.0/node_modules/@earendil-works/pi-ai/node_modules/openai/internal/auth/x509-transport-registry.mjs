import { OpenAIError } from "../../core/error.mjs";
import { findRegisteredX509Transport } from './x509-transport-state.mjs';
const transientX509TransportCodes = new Set([
    'ECONNRESET',
    'ECONNREFUSED',
    'ENETUNREACH',
    'EHOSTUNREACH',
    'ENETDOWN',
    'EPIPE',
    'ETIMEDOUT',
    'EAI_AGAIN',
    'UND_ERR_CONNECT_TIMEOUT',
    'UND_ERR_HEADERS_TIMEOUT',
    'UND_ERR_BODY_TIMEOUT',
    'UND_ERR_SOCKET',
]);
/** Retries only known temporary failures when neither error layer reports a permanent code. */
export function isRetryableX509TransportFailure(failure) {
    const cause = typeof failure === 'object' && failure !== null
        ? Object.getOwnPropertyDescriptor(failure, 'cause')?.value
        : undefined;
    let retryable = false;
    for (const candidate of [failure, cause]) {
        const code = typeof candidate === 'object' && candidate !== null
            ? Object.getOwnPropertyDescriptor(candidate, 'code')?.value
            : undefined;
        if (typeof code === 'string') {
            if (!transientX509TransportCodes.has(code)) {
                return false;
            }
            retryable = true;
        }
    }
    return retryable;
}
export const x509TransportBrand = Symbol('X.509 transport capability');
/** Resolves a previously registered opaque capability without importing an optional transport peer. */
export function resolveX509Transport(value) {
    if (!value || typeof value !== 'object') {
        throw new OpenAIError('X.509 workload identity requires an approved X.509 transport capability.');
    }
    const registered = findRegisteredX509Transport(value);
    if (!registered) {
        throw new OpenAIError('X.509 workload identity requires an approved X.509 transport capability.');
    }
    return registered;
}
//# sourceMappingURL=x509-transport-registry.mjs.map