/** Sole API authority approved for OpenAI X.509 workload-identity federation. */
export declare const X509_API_BASE_URL = "https://mtls.api.openai.com/v1";
/** Validates the enrolled API authority and rejects credential-bearing query parameters. */
export declare function assertX509APIOrigin(value: string | URL): URL;
//# sourceMappingURL=x509-api-origin.d.mts.map