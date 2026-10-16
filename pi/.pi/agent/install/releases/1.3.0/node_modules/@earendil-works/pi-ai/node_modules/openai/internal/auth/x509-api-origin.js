"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.X509_API_BASE_URL = void 0;
exports.assertX509APIOrigin = assertX509APIOrigin;
const error_1 = require("../../core/error.js");
const log_1 = require("../utils/log.js");
/** Sole API authority approved for OpenAI X.509 workload-identity federation. */
exports.X509_API_BASE_URL = 'https://mtls.api.openai.com/v1';
/** Validates the enrolled API authority and rejects credential-bearing query parameters. */
function assertX509APIOrigin(value) {
    let target;
    try {
        target = new URL(value);
    }
    catch {
        throw new error_1.OpenAIError('X.509 workload identity requires the approved global mTLS API origin.');
    }
    if (target.origin !== 'https://mtls.api.openai.com' || target.username || target.password) {
        throw new error_1.OpenAIError('X.509 workload identity requires the approved global mTLS API origin.');
    }
    for (const name of target.searchParams.keys()) {
        if ((0, log_1.isSensitiveQueryParameter)(name)) {
            throw new error_1.OpenAIError('X.509 workload identity cannot send conflicting query authentication credentials.');
        }
    }
    return target;
}
//# sourceMappingURL=x509-api-origin.js.map