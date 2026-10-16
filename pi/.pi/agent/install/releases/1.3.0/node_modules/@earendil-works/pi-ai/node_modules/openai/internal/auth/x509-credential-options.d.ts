import type { ClientOptions } from "../../client.js";
import type { X509Credential } from "../../auth/types.js";
/** Validates one privately registered credential and suppresses ambient legacy authentication. */
export declare function normalizeX509CredentialOptions(options: ClientOptions): {
    credential: X509Credential | undefined;
    options: ClientOptions;
};
/** Reconciles one client's credential and provider ownership before cloning its options. */
export declare function prepareX509ClientClone(inherited: ClientOptions, overrides: Partial<ClientOptions>, credential: X509Credential | undefined, currentlyX509: boolean): {
    credential: X509Credential | undefined;
    provider: ClientOptions['provider'];
};
//# sourceMappingURL=x509-credential-options.d.ts.map