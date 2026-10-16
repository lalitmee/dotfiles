import * as Shims from "../internal/shims.mjs";
import { SubjectTokenProviderError } from "../core/error.mjs";
import { hasOwn, isObj } from "../internal/utils/values.mjs";
const DEFAULT_RESOURCE = 'https://management.azure.com/';
const DEFAULT_AZURE_API_VERSION = '2018-02-01';
const AZURE_IMDS_BASE_URL = 'http://169.254.169.254/metadata/identity/oauth2/token';
const MAX_AZURE_IMDS_JSON_ERROR_CAUSES = 32;
const getOwnErrorDescriptor = Object.getOwnPropertyDescriptor;
const getErrorPrototype = Object.getPrototypeOf;
const errorObjectToString = Object.prototype.toString;
const errorFunctionToString = Function.prototype.toString;
const nativeErrorSource = errorFunctionToString.call(Error);
const nativeSyntaxErrorSource = errorFunctionToString.call(SyntaxError);
const nativeErrorBrandDescriptor = getOwnErrorDescriptor(Error, 'isError');
// SAFETY: The captured Error.isError data property was checked to be callable and follows the native error-brand predicate contract.
const nativeErrorBrand = nativeErrorBrandDescriptor &&
    'value' in nativeErrorBrandDescriptor &&
    typeof nativeErrorBrandDescriptor.value === 'function'
    ? // oxlint-disable-next-line anti-slop/no-object-parameters -- The native error-brand predicate inspects arbitrary objects without trusting their properties.
        nativeErrorBrandDescriptor.value
    : undefined;
// oxlint-disable-next-line anti-slop/no-object-parameters -- Cross-realm prototypes are inspected through descriptors before any error contract is trusted.
function hasNativeErrorPrototype(prototype, kind) {
    const name = getOwnErrorDescriptor(prototype, 'name');
    const constructor = getOwnErrorDescriptor(prototype, 'constructor');
    if (!name ||
        !('value' in name) ||
        name.value !== kind ||
        !constructor ||
        !('value' in constructor) ||
        typeof constructor.value !== 'function') {
        return false;
    }
    const originalPrototype = getOwnErrorDescriptor(constructor.value, 'prototype');
    const nativeSource = kind === 'Error' ? nativeErrorSource : nativeSyntaxErrorSource;
    return Boolean(originalPrototype &&
        'value' in originalPrototype &&
        originalPrototype.value === prototype &&
        errorFunctionToString.call(constructor.value) === nativeSource);
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Untrusted thrown objects, including proxies, must be classified before treating them as errors.
function classifyCrossRealmAzureError(error) {
    try {
        const prototypes = [];
        let tagged = false;
        // SAFETY: Object.getPrototypeOf returns an object or null; the traversal never treats the prototype as a more specific instance.
        for (let prototype = error; prototype !== null; prototype = getErrorPrototype(prototype)) {
            if (prototypes.length >= MAX_AZURE_IMDS_JSON_ERROR_CAUSES) {
                return 'unsafe';
            }
            prototypes.push(prototype);
            if (!nativeErrorBrand && getOwnErrorDescriptor(prototype, Symbol.toStringTag)) {
                tagged = true;
            }
        }
        if (nativeErrorBrand
            ? !nativeErrorBrand(error)
            : !tagged && errorObjectToString.call(error) !== '[object Error]') {
            return 'unknown';
        }
        let genericErrorPrototype = false;
        for (let index = 1; index < prototypes.length; index += 1) {
            const prototype = prototypes[index];
            if (!prototype) {
                return 'unsafe';
            }
            if (hasNativeErrorPrototype(prototype, 'SyntaxError')) {
                return tagged ? 'unsafe' : 'syntax';
            }
            if (tagged && hasNativeErrorPrototype(prototype, 'Error')) {
                genericErrorPrototype = true;
            }
        }
        if (!tagged) {
            return 'error';
        }
        return genericErrorPrototype ? 'tagged-wrapper' : 'unknown';
    }
    catch {
        return 'unsafe';
    }
}
function inspectAzureJSONErrorCause(error) {
    const visited = new Set();
    let current = error;
    for (let depth = 0; depth < MAX_AZURE_IMDS_JSON_ERROR_CAUSES; depth += 1) {
        if (current instanceof SyntaxError) {
            return true;
        }
        if (typeof current !== 'object' || current === null) {
            return false;
        }
        const kind = current instanceof Error ? 'error' : classifyCrossRealmAzureError(current);
        if (kind === 'syntax' || kind === 'unsafe') {
            return true;
        }
        if (kind !== 'error' && kind !== 'tagged-wrapper') {
            return false;
        }
        if (kind === 'error') {
            const parserType = getOwnErrorDescriptor(current, 'type');
            if (parserType && 'value' in parserType && parserType.value === 'invalid-json') {
                return true;
            }
        }
        if (visited.has(current)) {
            return true;
        }
        visited.add(current);
        let cause;
        try {
            cause = getOwnErrorDescriptor(current, 'cause');
        }
        catch {
            return true;
        }
        if (!cause || !('value' in cause)) {
            return false;
        }
        current = cause.value;
    }
    return true;
}
function isMalformedAzureJSONError(error) {
    try {
        return inspectAzureJSONErrorCause(error);
    }
    catch {
        return true;
    }
}
function readAzureAccessToken(data) {
    const token = isObj(data) && hasOwn(data, 'access_token') ? data['access_token'] : undefined;
    if (typeof token !== 'string' || token.trim().length === 0) {
        throw new SubjectTokenProviderError("IMDS response missing 'access_token' field", 'azure-imds');
    }
    return token;
}
let fsPromisesModule;
async function defaultReadFile(path) {
    fsPromisesModule ?? (fsPromisesModule = import('node:fs/promises').catch((error) => {
        fsPromisesModule = undefined;
        throw error;
    }));
    const { readFile } = await fsPromisesModule;
    return readFile(path, 'utf-8');
}
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
export function k8sServiceAccountTokenProvider(tokenPath = '/var/run/secrets/kubernetes.io/serviceaccount/token', config) {
    const readFile = config?.readFile ?? defaultReadFile;
    return {
        tokenType: 'jwt',
        getToken: async () => {
            let rawToken;
            try {
                rawToken = await readFile(tokenPath);
            }
            catch (error) {
                if (error instanceof SubjectTokenProviderError) {
                    throw error;
                }
                throw new SubjectTokenProviderError(`Failed to read Kubernetes service account token from ${tokenPath}: ${error instanceof Error ? error.message : String(error)}`, 'kubernetes', error instanceof Error ? error : undefined);
            }
            const token = rawToken.trim();
            if (token.length === 0) {
                throw new SubjectTokenProviderError(`The token file at ${tokenPath} is empty.`, 'kubernetes');
            }
            return token;
        },
    };
}
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
export function azureManagedIdentityTokenProvider(resource = DEFAULT_RESOURCE, config) {
    const apiVersion = config?.apiVersion ?? DEFAULT_AZURE_API_VERSION;
    const timeout = config?.timeout ?? 10000;
    return {
        tokenType: 'jwt',
        getToken: async () => {
            const url = new URL(AZURE_IMDS_BASE_URL);
            url.searchParams.set('api-version', apiVersion);
            url.searchParams.set('resource', resource);
            if (config?.objectId) {
                url.searchParams.set('object_id', config.objectId);
            }
            if (config?.clientId) {
                url.searchParams.set('client_id', config.clientId);
            }
            if (config?.msiResId) {
                url.searchParams.set('msi_res_id', config.msiResId);
            }
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), timeout);
            try {
                const response = await (config?.fetch ?? Shims.getDefaultFetch())(url.toString(), {
                    headers: {
                        Metadata: 'true',
                    },
                    signal: controller.signal,
                });
                if (!response.ok) {
                    let abortListener;
                    try {
                        // oxlint-disable-next-line promise/avoid-new -- AbortSignal is callback-only across supported runtimes.
                        const requestAborted = new Promise((resolve) => {
                            abortListener = () => resolve();
                            if (controller.signal.aborted) {
                                abortListener();
                            }
                            else {
                                controller.signal.addEventListener('abort', abortListener, { once: true });
                            }
                        });
                        await Promise.race([Shims.CancelReadableStream(response.body), requestAborted]);
                    }
                    catch {
                        controller.abort();
                    }
                    finally {
                        if (abortListener) {
                            controller.signal.removeEventListener('abort', abortListener);
                        }
                    }
                    throw new SubjectTokenProviderError(`Failed to fetch token from Azure IMDS: status ${response.status}`, 'azure-imds');
                }
                let data;
                try {
                    data = await response.json();
                }
                catch (error) {
                    if (isMalformedAzureJSONError(error)) {
                        throw new SyntaxError('IMDS response contains invalid JSON');
                    }
                    throw error;
                }
                return readAzureAccessToken(data);
            }
            catch (error) {
                if (error instanceof SubjectTokenProviderError) {
                    throw error;
                }
                throw new SubjectTokenProviderError('failed to fetch token from IMDS', 'azure-imds', error instanceof Error ? error : undefined);
            }
            finally {
                clearTimeout(timeoutId);
            }
        },
    };
}
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
export function gcpIDTokenProvider(audience = 'https://api.openai.com/v1', config) {
    const timeout = config?.timeout ?? 10000;
    return {
        tokenType: 'id',
        getToken: async () => {
            const url = new URL(`http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity`);
            url.searchParams.set('audience', audience);
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), timeout);
            try {
                const response = await (config?.fetch ?? Shims.getDefaultFetch())(url.toString(), {
                    headers: {
                        'Metadata-Flavor': 'Google',
                    },
                    signal: controller.signal,
                });
                if (!response.ok) {
                    let abortListener;
                    try {
                        // oxlint-disable-next-line promise/avoid-new -- AbortSignal is callback-only across supported runtimes.
                        const requestAborted = new Promise((resolve) => {
                            abortListener = () => resolve();
                            if (controller.signal.aborted) {
                                abortListener();
                            }
                            else {
                                controller.signal.addEventListener('abort', abortListener, { once: true });
                            }
                        });
                        await Promise.race([Shims.CancelReadableStream(response.body), requestAborted]);
                    }
                    catch {
                        controller.abort();
                    }
                    finally {
                        if (abortListener) {
                            controller.signal.removeEventListener('abort', abortListener);
                        }
                    }
                    throw new Error(`GCP Metadata Server returned ${response.status}`);
                }
                const tokenText = await response.text();
                const token = tokenText.trim();
                if (!token) {
                    throw new Error('GCP metadata server returned an empty token');
                }
                return token;
            }
            catch (error) {
                throw new SubjectTokenProviderError(`Failed to fetch token from GCP Metadata Server: ${error instanceof Error ? error.message : String(error)}`, 'gcp-metadata', error instanceof Error ? error : undefined);
            }
            finally {
                clearTimeout(timeoutId);
            }
        },
    };
}
//# sourceMappingURL=subject-token-providers.mjs.map