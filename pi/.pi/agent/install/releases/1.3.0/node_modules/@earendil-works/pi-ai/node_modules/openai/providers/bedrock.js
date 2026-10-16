"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.bedrock = bedrock;
const tslib_1 = require("../internal/tslib.js");
const Errors = tslib_1.__importStar(require("../error.js"));
const provider_1 = require("../internal/provider.js");
const bedrock_1 = require("../internal/bedrock.js");
/**
 * Configures the standard OpenAI client for Amazon Bedrock bearer authentication.
 *
 * Supply `apiKey` or `tokenProvider`, or set `AWS_BEARER_TOKEN_BEDROCK`.
 * The endpoint defaults to Mantle; pass `endpoint: 'runtime'` to use Bedrock
 * Runtime. The region defaults to `AWS_REGION` or `AWS_DEFAULT_REGION`, and a
 * custom endpoint can be supplied with `baseURL` or `AWS_BEDROCK_BASE_URL`.
 *
 * This entrypoint has no AWS SDK dependencies. To use AWS credentials or
 * Signature Version 4, import `bedrock` from `openai/providers/bedrock/aws`.
 *
 * @param options Bedrock endpoint and mutually exclusive bearer-credential settings.
 * @returns A provider accepted by `new OpenAI({ provider })`.
 * @throws {OpenAIError} If no usable endpoint or bearer credential is configured.
 */
function bedrock(options = {}) {
    const { baseURL } = (0, bedrock_1.resolveBedrockEndpoint)(options);
    const { factory } = (0, bedrock_1.resolveBedrockBearerAuth)(options);
    if (!factory) {
        throw new Errors.OpenAIError('Bedrock bearer authentication requires an `apiKey`, `tokenProvider`, or `AWS_BEARER_TOKEN_BEDROCK`. For AWS credential authentication, import `bedrock` from `openai/providers/bedrock/aws`.');
    }
    return (0, provider_1.createProvider)({
        configure() {
            const auth = factory();
            return {
                name: 'bedrock',
                baseURL,
                async prepareRequest(request, context) {
                    (0, bedrock_1.assertBedrockRequestOrigin)(baseURL, context.url);
                    await auth.prepareRequest(request, context);
                },
            };
        },
    });
}
//# sourceMappingURL=bedrock.js.map