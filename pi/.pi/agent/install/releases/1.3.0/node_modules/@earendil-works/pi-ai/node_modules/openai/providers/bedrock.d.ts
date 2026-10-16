import type { Provider } from "../internal/provider.js";
import type { BedrockBearerOptions, BedrockEndpointOptions } from "../internal/bedrock.js";
/** Endpoint and bearer-credential settings for the dependency-free Amazon Bedrock provider. */
export interface BedrockProviderOptions extends BedrockEndpointOptions, BedrockBearerOptions {
}
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
export declare function bedrock(options?: BedrockProviderOptions): Provider;
//# sourceMappingURL=bedrock.d.ts.map