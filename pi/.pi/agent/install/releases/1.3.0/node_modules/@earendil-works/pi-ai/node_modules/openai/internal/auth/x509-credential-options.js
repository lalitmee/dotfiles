"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.normalizeX509CredentialOptions = normalizeX509CredentialOptions;
exports.prepareX509ClientClone = prepareX509ClientClone;
const error_1 = require("../../core/error.js");
const values_1 = require("../utils/values.js");
const x509_workload_identity_auth_1 = require("./x509-workload-identity-auth.js");
const _x509_transport_state_1 = require('./x509-transport-state.js');
/** Validates one privately registered credential and suppresses ambient legacy authentication. */
function normalizeX509CredentialOptions(options) {
    const { credential } = options;
    if (credential === undefined) {
        // oxlint-disable-next-line anti-slop/no-known-value-widening -- Preserve the exported normalization contract when no X.509 credential is configured.
        return { credential, options };
    }
    const registered = (0, _x509_transport_state_1.findX509Credential)(credential);
    if (!registered) {
        throw new error_1.OpenAIError('An X.509 credential must be created by the SDK authentication helper.');
    }
    const conflicting = ['apiKey', 'adminAPIKey', 'workloadIdentity', 'x509Transport'].filter((name) => {
        const value = options[name];
        return value !== null && value !== undefined;
    });
    if (conflicting.length > 0) {
        throw new error_1.OpenAIError(`The \`credential\` option cannot be combined with ${conflicting.map((name) => `\`${name}\``).join(', ')}.`);
    }
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The declared ClientOptions return contract supports both normalized and unchanged client options.
    return {
        credential,
        options: {
            ...options,
            apiKey: null,
            adminAPIKey: null,
            baseURL: options.baseURL ?? null,
            organization: options.organization ?? null,
            project: options.project ?? null,
            workloadIdentity: registered.identity,
            x509Transport: registered.transport,
        },
    };
}
/** Distinguishes explicitly supplied ordinary credentials from nullish inheritance. */
function overridesOrdinaryAuthentication({ apiKey, adminAPIKey }) {
    return (apiKey !== null && apiKey !== undefined) || (adminAPIKey !== null && adminAPIKey !== undefined);
}
/** Keeps origin-bound configuration with its owning provider during a client clone. */
function prepareProviderClone(inherited, overrides) {
    const inheritedProvider = inherited.provider;
    const replacingProvider = overrides.credential ?? overrides.workloadIdentity;
    const provider = overrides.provider ?? (replacingProvider ? undefined : inheritedProvider);
    if (provider !== inheritedProvider) {
        delete inherited.baseURL;
        delete inherited.organization;
        delete inherited.project;
        delete inherited.defaultHeaders;
        delete inherited.defaultQuery;
        delete inherited.fetchOptions;
        delete inherited.fetch;
    }
    if (provider) {
        delete inherited.apiKey;
        delete inherited.adminAPIKey;
        delete inherited.credential;
        delete inherited.workloadIdentity;
        delete inherited.x509Transport;
        delete inherited.baseURL;
    }
    return provider;
}
/** Reconciles one client's credential and provider ownership before cloning its options. */
function prepareX509ClientClone(inherited, overrides, credential, currentlyX509) {
    const nextIdentity = (0, values_1.hasOwn)(overrides, 'workloadIdentity')
        ? overrides.workloadIdentity
        : inherited.workloadIdentity;
    const dropping = credential !== undefined &&
        ((overridesOrdinaryAuthentication(overrides) && overrides.workloadIdentity === undefined) ||
            overrides.provider !== undefined);
    if (credential !== undefined && (0, values_1.hasOwn)(overrides, 'workloadIdentity')) {
        delete inherited.x509Transport;
    }
    const inheritedCredential = credential !== undefined &&
        !dropping &&
        overrides.credential === undefined &&
        !(0, values_1.hasOwn)(overrides, 'workloadIdentity') &&
        !(0, values_1.hasOwn)(overrides, 'x509Transport')
        ? credential
        : undefined;
    const nextCredential = overrides.credential === undefined ? inheritedCredential : overrides.credential;
    const nextX509 = nextCredential !== undefined || (!dropping && (0, x509_workload_identity_auth_1.isX509WorkloadIdentity)(nextIdentity));
    if (currentlyX509 !== nextX509) {
        delete inherited.fetch;
        delete inherited.baseURL;
        delete inherited.organization;
        delete inherited.project;
        delete inherited.defaultHeaders;
        delete inherited.defaultQuery;
        delete inherited.fetchOptions;
        if (nextX509) {
            inherited.apiKey = null;
        }
        else {
            delete inherited.x509Transport;
            if (dropping) {
                delete inherited.workloadIdentity;
            }
        }
    }
    if (nextCredential !== undefined) {
        delete inherited.apiKey;
        delete inherited.adminAPIKey;
        delete inherited.workloadIdentity;
        delete inherited.x509Transport;
        inherited.credential = nextCredential;
        if (overrides.credential !== undefined) {
            delete inherited.organization;
            delete inherited.project;
            delete inherited.defaultHeaders;
            delete inherited.defaultQuery;
            delete inherited.fetchOptions;
        }
    }
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- Preserve the exported clone contract across inherited and replaced credentials and providers.
    return { credential: nextCredential, provider: prepareProviderClone(inherited, overrides) };
}
//# sourceMappingURL=x509-credential-options.js.map