"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.x509TransportBrand = void 0;
exports.isRetryableX509TransportFailure = isRetryableX509TransportFailure;
exports.resolveX509Transport = resolveX509Transport;
const error_1 = require("../../core/error.js");
const _x509_transport_state_1 = require('./x509-transport-state.js');
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
function isRetryableX509TransportFailure(failure) {
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
exports.x509TransportBrand = Symbol('X.509 transport capability');
/** Resolves a previously registered opaque capability without importing an optional transport peer. */
function resolveX509Transport(value) {
    if (!value || typeof value !== 'object') {
        throw new error_1.OpenAIError('X.509 workload identity requires an approved X.509 transport capability.');
    }
    const registered = (0, _x509_transport_state_1.findRegisteredX509Transport)(value);
    if (!registered) {
        throw new error_1.OpenAIError('X.509 workload identity requires an approved X.509 transport capability.');
    }
    return registered;
}
//# sourceMappingURL=x509-transport-registry.js.map