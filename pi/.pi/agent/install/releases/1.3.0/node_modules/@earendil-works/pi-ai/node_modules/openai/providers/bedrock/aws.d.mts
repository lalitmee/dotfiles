import type { BedrockBearerOptions, BedrockEndpointOptions } from "../../internal/bedrock.mjs";
import type { Provider } from "../../internal/provider.mjs";
/** AWS credentials used to sign an Amazon Bedrock request with Signature Version 4. */
export interface AwsCredentialIdentity {
    /** AWS access-key identifier associated with the signing identity. */
    accessKeyId: string;
    /** Secret access key paired with the AWS access-key identifier. */
    secretAccessKey: string;
    /** Session token required by temporary AWS credentials, when present. */
    sessionToken?: string;
    /** Expiration timestamp supplied by a refreshable temporary-credential provider. */
    expiration?: Date;
}
/** Resolves current AWS signing credentials before a Bedrock request attempt. */
export type AwsCredentialsProvider = () => AwsCredentialIdentity | Promise<AwsCredentialIdentity>;
/**
 * Configures a Bedrock endpoint and exactly one explicit bearer or AWS credential mode.
 *
 * When no explicit credential mode is supplied, `AWS_BEARER_TOKEN_BEDROCK` is
 * preferred, followed by the default AWS credential-provider chain.
 */
export interface BedrockProviderOptions extends BedrockEndpointOptions, BedrockBearerOptions {
    /** Explicit AWS access-key identifier; must be paired with `secretAccessKey`. */
    accessKeyId?: string | undefined;
    /** Explicit AWS secret access key; must be paired with `accessKeyId`. */
    secretAccessKey?: string | undefined;
    /** Session token for explicit temporary AWS credentials; requires both access-key fields. */
    sessionToken?: string | undefined;
    /** AWS shared-config profile; cannot be combined with another explicit credential mode. */
    profile?: string | undefined;
    /** Refreshable signing-credential provider invoked for each request attempt, including retries. */
    credentialProvider?: AwsCredentialsProvider | undefined;
}
/**
 * Configures the standard OpenAI client for Amazon Bedrock bearer or AWS SigV4 authentication.
 *
 * Explicit bearer credentials, static AWS credentials, a shared-config profile,
 * and a credential provider are mutually exclusive. Without explicit
 * credentials, `AWS_BEARER_TOKEN_BEDROCK` takes precedence over the default AWS
 * credential chain. The region defaults to `AWS_REGION` or `AWS_DEFAULT_REGION`.
 *
 * This entrypoint requires `@aws-sdk/credential-provider-node`,
 * `@smithy/hash-node`, and `@smithy/signature-v4`. AWS signing is available in
 * Node.js-compatible server runtimes and requires replayable request bodies.
 *
 * @param options Bedrock endpoint and optional explicit authentication settings.
 * @returns A provider accepted by `new OpenAI({ provider })`.
 * @throws {OpenAIError} If endpoint settings or credential modes are invalid or ambiguous.
 */
export declare function bedrock(options?: BedrockProviderOptions): Provider;
//# sourceMappingURL=aws.d.mts.map