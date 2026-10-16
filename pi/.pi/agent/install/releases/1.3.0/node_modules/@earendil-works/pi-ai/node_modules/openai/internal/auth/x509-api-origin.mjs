import { OpenAIError } from "../../core/error.mjs";
import { isSensitiveQueryParameter } from "../utils/log.mjs";
/** Sole API authority approved for OpenAI X.509 workload-identity federation. */
export const X509_API_BASE_URL = 'https://mtls.api.openai.com/v1';
/** Validates the enrolled API authority and rejects credential-bearing query parameters. */
export function assertX509APIOrigin(value) {
    let target;
    try {
        target = new URL(value);
    }
    catch {
        throw new OpenAIError('X.509 workload identity requires the approved global mTLS API origin.');
    }
    if (target.origin !== 'https://mtls.api.openai.com' || target.username || target.password) {
        throw new OpenAIError('X.509 workload identity requires the approved global mTLS API origin.');
    }
    for (const name of target.searchParams.keys()) {
        if (isSensitiveQueryParameter(name)) {
            throw new OpenAIError('X.509 workload identity cannot send conflicting query authentication credentials.');
        }
    }
    return target;
}
//# sourceMappingURL=x509-api-origin.mjs.map