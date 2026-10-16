import type { SubjectTokenProvider } from "./types.js";
import type { Fetch } from "../internal/builtin-types.js";
/** Reads the UTF-8 contents of a Kubernetes service-account token file. */
type ReadFile = (path: string) => Promise<string>;
/**
 * Reads a Kubernetes service-account JWT from its mounted token file.
 *
 * The file is read again for each token exchange so projected or rotated tokens
 * are picked up automatically. The default reader requires Node.js filesystem
 * access; provide `config.readFile` when using another compatible runtime.
 *
 * @param tokenPath Path to the token file; defaults to
 * `/var/run/secrets/kubernetes.io/serviceaccount/token`.
 * @param config Optional replacement for the default UTF-8 file reader.
 * @returns A JWT subject-token provider suitable for `workloadIdentity.provider`.
 * @throws {SubjectTokenProviderError} When the returned provider cannot read the
 * token file or the file contains no token.
 */
export declare function k8sServiceAccountTokenProvider(tokenPath?: string, config?: {
    /** Reads token-file contents; defaults to Node.js `fs/promises.readFile`. */
    readFile?: ReadFile;
}): SubjectTokenProvider;
/**
 * Retrieves an Azure managed-identity access token from the Instance Metadata Service.
 *
 * Run this provider in an Azure-hosted workload that can reach the link-local
 * metadata endpoint. Select a user-assigned identity with `objectId`, `clientId`,
 * or `msiResId`; otherwise Azure selects the available managed identity.
 *
 * @param resource Azure resource identifier; defaults to
 * `https://management.azure.com/`.
 * @param config Managed-identity selection, metadata API version, request
 * timeout, and optional `fetch` implementation.
 * @returns A JWT subject-token provider suitable for `workloadIdentity.provider`.
 * @throws {SubjectTokenProviderError} When the returned provider cannot retrieve
 * an access token, the metadata response is invalid, or the request times out.
 */
export declare function azureManagedIdentityTokenProvider(resource?: string, config?: {
    /** Object ID of the user-assigned managed identity to request. */
    objectId?: string;
    /** Client ID of the user-assigned managed identity to request. */
    clientId?: string;
    /** Azure resource ID of the user-assigned managed identity to request. */
    msiResId?: string;
    /** Azure Instance Metadata Service API version; defaults to `2018-02-01`. */
    apiVersion?: string;
    /** Metadata request timeout in milliseconds; defaults to 10,000. */
    timeout?: number;
    /** Fetch implementation used for metadata requests; defaults to the runtime fetch. */
    fetch?: Fetch;
}): SubjectTokenProvider;
/**
 * Retrieves a Google Cloud identity token from the default service account's metadata endpoint.
 *
 * Run this provider in a Google Cloud workload with access to its Compute Engine
 * metadata server. A fresh identity token is requested for each token exchange.
 *
 * @param audience Intended identity-token audience; defaults to
 * `https://api.openai.com/v1`.
 * @param config Optional metadata request timeout and `fetch` implementation.
 * @returns An identity-token subject-token provider for `workloadIdentity.provider`.
 * @throws {SubjectTokenProviderError} When the returned provider cannot retrieve
 * a nonempty identity token or the metadata request times out.
 */
export declare function gcpIDTokenProvider(audience?: string, config?: {
    /** Metadata request timeout in milliseconds; defaults to 10,000. */
    timeout?: number;
    /** Fetch implementation used for metadata requests; defaults to the runtime fetch. */
    fetch?: Fetch;
}): SubjectTokenProvider;
export {};
//# sourceMappingURL=subject-token-providers.d.ts.map