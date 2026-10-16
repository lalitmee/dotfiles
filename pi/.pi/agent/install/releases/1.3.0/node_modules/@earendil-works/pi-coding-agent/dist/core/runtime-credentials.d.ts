import type { AuthOperationOptions, Credential, CredentialInfo, CredentialStore } from "@earendil-works/pi-ai";
/** Async credential store overlay for non-persistent runtime API keys. */
export declare class RuntimeCredentials implements CredentialStore {
    private readonly store;
    private readonly overrides;
    constructor(store: CredentialStore);
    setRuntimeApiKey(providerId: string, apiKey: string): void;
    removeRuntimeApiKey(providerId: string): void;
    hasRuntimeApiKey(providerId: string): boolean;
    read(providerId: string, options?: AuthOperationOptions): Promise<Credential | undefined>;
    list(options?: AuthOperationOptions): Promise<readonly CredentialInfo[]>;
    modify(providerId: string, fn: (current: Credential | undefined) => Promise<Credential | undefined>, options?: AuthOperationOptions): Promise<Credential | undefined>;
    delete(providerId: string, options?: AuthOperationOptions): Promise<void>;
}
//# sourceMappingURL=runtime-credentials.d.ts.map