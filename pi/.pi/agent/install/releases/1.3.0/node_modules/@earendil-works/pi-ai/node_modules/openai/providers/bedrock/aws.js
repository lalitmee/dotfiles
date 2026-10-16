"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.bedrock = bedrock;
const tslib_1 = require("../../internal/tslib.js");
const credential_provider_node_1 = require("@aws-sdk/credential-provider-node");
const hash_node_1 = require("@smithy/hash-node");
const signature_v4_1 = require("@smithy/signature-v4");
const Errors = tslib_1.__importStar(require("../../error.js"));
const bedrock_1 = require("../../internal/bedrock.js");
const provider_1 = require("../../internal/provider.js");
function validateStaticCredentials(options) {
    const hasAccessKey = options.accessKeyId !== undefined;
    const hasSecretKey = options.secretAccessKey !== undefined;
    if (hasAccessKey !== hasSecretKey || (options.sessionToken !== undefined && !hasAccessKey)) {
        throw new Errors.OpenAIError('The `accessKeyId` and `secretAccessKey` options must be provided together. A `sessionToken` may only be used with both.');
    }
    if (!hasAccessKey) {
        return undefined;
    }
    if (typeof options.accessKeyId !== 'string' ||
        !options.accessKeyId.trim() ||
        typeof options.secretAccessKey !== 'string' ||
        !options.secretAccessKey.trim()) {
        throw new Errors.OpenAIError('Static AWS credentials require non-empty `accessKeyId` and `secretAccessKey` values.');
    }
    if (options.sessionToken !== undefined &&
        (typeof options.sessionToken !== 'string' || !options.sessionToken.trim())) {
        throw new Errors.OpenAIError('A static AWS `sessionToken` must not be empty when provided.');
    }
    return {
        accessKeyId: options.accessKeyId,
        secretAccessKey: options.secretAccessKey,
        // Spread creates an own data property without invoking inherited setters or changing the object prototype.
        ...(options.sessionToken ? { sessionToken: options.sessionToken } : {}),
    };
}
function requestTarget(parsedURL) {
    const query = Object.create(null);
    for (const [name, value] of parsedURL.searchParams) {
        if (name === '__proto__') {
            throw new Errors.OpenAIError('The Bedrock SigV4 signer cannot safely sign a `__proto__` query parameter.');
        }
        const existing = query[name];
        if (existing === undefined) {
            query[name] = value;
        }
        else if (typeof existing === 'string') {
            query[name] = [existing, value];
        }
        else {
            existing.push(value);
        }
    }
    return { path: parsedURL.pathname, query };
}
function signableBody(body) {
    if (body === undefined || body === null) {
        return undefined;
    }
    if (typeof body === 'string' || body instanceof ArrayBuffer || ArrayBuffer.isView(body)) {
        return body;
    }
    throw new Errors.OpenAIError("The SDK's Bedrock SigV4 mode requires a replayable request body. Buffer the body before sending or use bearer authentication.");
}
function validateCredentialIdentity(identity) {
    if (typeof identity?.accessKeyId !== 'string' ||
        !identity.accessKeyId.trim() ||
        typeof identity.secretAccessKey !== 'string' ||
        !identity.secretAccessKey.trim() ||
        (identity.sessionToken !== undefined &&
            (typeof identity.sessionToken !== 'string' || !identity.sessionToken.trim()))) {
        throw new Errors.OpenAIError('Failed to resolve AWS credentials for Bedrock. Verify your AWS profile, environment variables, or runtime identity configuration and try again.');
    }
    return identity;
}
class BedrockSigV4Auth {
    constructor(options) {
        this.options = options;
    }
    credentialsProvider() {
        if (this.resolvedCredentialsProvider) {
            return this.resolvedCredentialsProvider;
        }
        if (this.options.staticCredentials) {
            const credentials = this.options.staticCredentials;
            return (this.resolvedCredentialsProvider = async () => credentials);
        }
        if (this.options.credentialProvider) {
            const provider = this.options.credentialProvider;
            return (this.resolvedCredentialsProvider = async () => validateCredentialIdentity(await provider()));
        }
        const provider = (0, credential_provider_node_1.defaultProvider)(this.options.profile ? { profile: this.options.profile } : {});
        return (this.resolvedCredentialsProvider = async () => validateCredentialIdentity(await provider()));
    }
    signatureV4() {
        return (this.signer ?? (this.signer = new signature_v4_1.SignatureV4({
            credentials: this.credentialsProvider(),
            region: this.options.region,
            service: this.options.endpoint === 'runtime' ? 'bedrock' : 'bedrock-mantle',
            sha256: hash_node_1.Hash.bind(null, 'sha256'),
        })));
    }
    async prepareRequest(request, context) {
        // SAFETY: process is optional outside Node; the native process tag is checked before using Node-specific signing and credential behavior.
        if (Object.prototype.toString.call(globalThis.process) !== '[object process]') {
            throw new Errors.OpenAIError('Bedrock AWS credential authentication is only supported in Node.js and compatible server runtimes. Use bearer authentication in this runtime.');
        }
        const parsedURL = new URL(context.url);
        const canonicalEndpoint = (0, bedrock_1.parseBedrockEndpointHostname)(parsedURL.hostname);
        if (canonicalEndpoint && canonicalEndpoint.endpoint !== this.options.endpoint) {
            throw new Errors.OpenAIError(`The Bedrock ${canonicalEndpoint.endpoint} hostname does not match the selected \`${this.options.endpoint}\` endpoint.`);
        }
        if (canonicalEndpoint && canonicalEndpoint.region !== this.options.region) {
            throw new Errors.OpenAIError(`The Bedrock endpoint region \`${canonicalEndpoint.region}\` does not match the SigV4 region \`${this.options.region}\`.`);
        }
        const headers = new Headers(request.headers);
        (0, bedrock_1.assertProviderOwnsAuthorization)(headers);
        headers.delete('x-amz-date');
        headers.delete('x-amz-security-token');
        headers.delete('x-amz-content-sha256');
        headers.set('host', parsedURL.host);
        const method = (request.method ?? 'GET').toUpperCase();
        const body = signableBody(request.body);
        const target = requestTarget(parsedURL);
        await (0, bedrock_1.prepareBedrockAuth)(request, context, {
            resolve: () => this.signatureV4().sign({
                protocol: parsedURL.protocol,
                hostname: parsedURL.hostname,
                // Spread creates an own data property without invoking inherited setters or changing the object prototype.
                ...(parsedURL.port ? { port: Number(parsedURL.port) } : {}),
                method,
                ...target,
                headers: Object.fromEntries(headers.entries()),
                // Spread creates an own data property without invoking inherited setters or changing the object prototype.
                ...(body === undefined ? {} : { body }),
            }),
            failureMessage: this.options.usesDefaultChain
                ? 'Could not find credentials for Bedrock. Pass AWS credentials to `bedrock(...)` or configure the default AWS credential chain.'
                : 'Failed to resolve AWS credentials for Bedrock. Verify your AWS profile, environment variables, or runtime identity configuration and try again.',
            apply: (signed) => {
                request.method = method;
                request.redirect = 'manual';
                request.headers = new Headers(signed.headers);
            },
        });
    }
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
function bedrock(options = {}) {
    const staticCredentials = validateStaticCredentials(options);
    const profile = (0, bedrock_1.normalizeOptionalString)(options.profile);
    if (options.profile !== undefined && !profile) {
        throw new Errors.OpenAIError('The Bedrock AWS `profile` must not be empty.');
    }
    const awsModes = [!!staticCredentials, !!profile, !!options.credentialProvider].filter(Boolean).length;
    if (awsModes > 1) {
        throw new Errors.OpenAIError('Bedrock authentication is ambiguous. Configure exactly one explicit AWS mode: static credentials, profile, or credential provider.');
    }
    const explicitAwsAuth = awsModes === 1;
    const bearerAuth = (0, bedrock_1.resolveBedrockBearerAuth)(options, { allowEnvironment: !explicitAwsAuth });
    if (bearerAuth.explicit && explicitAwsAuth) {
        throw new Errors.OpenAIError('Bearer and AWS credential authentication are mutually exclusive. Configure exactly one explicit mode: bearer credential, static AWS credentials, profile, or credential provider.');
    }
    const { endpoint, region, baseURL } = (0, bedrock_1.resolveBedrockEndpoint)(options);
    if (!bearerAuth.factory && !region) {
        throw new Errors.OpenAIError('Bedrock requires an AWS region. Pass `region` to `bedrock(...)`, or set `AWS_REGION` or `AWS_DEFAULT_REGION`.');
    }
    if (!bearerAuth.factory &&
        options.endpoint === undefined &&
        !(0, bedrock_1.parseBedrockEndpointHostname)(new URL(baseURL).hostname)) {
        throw new Errors.OpenAIError('A custom Bedrock endpoint requires an explicit `endpoint` option when using AWS credential authentication.');
    }
    const credentialProvider = options.credentialProvider;
    return (0, provider_1.createProvider)({
        configure() {
            const auth = bearerAuth.factory?.() ??
                new BedrockSigV4Auth({
                    endpoint,
                    region: region,
                    staticCredentials,
                    profile,
                    credentialProvider,
                    usesDefaultChain: !explicitAwsAuth,
                });
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
//# sourceMappingURL=aws.js.map