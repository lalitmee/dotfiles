/**
 * CredentialStore implementation backed by auth.json.
 * Provider auth orchestration belongs to ModelRuntime and pi-ai Models.
 */
import type { AuthOperationOptions, Credential, CredentialInfo, CredentialStore } from "@earendil-works/pi-ai";
type AuthStorageData = Record<string, Credential>;
type LockResult<T> = {
    result: T;
    next?: string;
};
export interface AuthStorageBackend {
    withLock<T>(fn: (current: string | undefined) => LockResult<T>): T;
    withLockAsync<T>(fn: (current: string | undefined) => Promise<LockResult<T>>, options?: AuthOperationOptions): Promise<T>;
}
export declare class FileAuthStorageBackend implements AuthStorageBackend {
    private authPath;
    constructor(authPath?: string);
    private ensureParentDir;
    private ensureFileExists;
    private acquireLockSyncWithRetry;
    withLock<T>(fn: (current: string | undefined) => LockResult<T>): T;
    private acquireLockAsync;
    withLockAsync<T>(fn: (current: string | undefined) => Promise<LockResult<T>>, options?: AuthOperationOptions): Promise<T>;
}
export declare class ReadOnlyAuthStorage implements CredentialStore {
    private readonly authPath;
    private data;
    constructor(authPath?: string);
    private load;
    read(providerId: string, options?: AuthOperationOptions): Promise<Credential | undefined>;
    list(options?: AuthOperationOptions): Promise<readonly CredentialInfo[]>;
    modify(_providerId: string, _fn: (current: Credential | undefined) => Promise<Credential | undefined>, _options?: AuthOperationOptions): Promise<Credential | undefined>;
    delete(_providerId: string, _options?: AuthOperationOptions): Promise<void>;
}
export declare class InMemoryAuthStorageBackend implements AuthStorageBackend {
    private value;
    private asyncChain;
    withLock<T>(fn: (current: string | undefined) => LockResult<T>): T;
    withLockAsync<T>(fn: (current: string | undefined) => Promise<LockResult<T>>, options?: AuthOperationOptions): Promise<T>;
}
/**
 * Credential storage backed by a JSON file.
 */
export declare class AuthStorage implements CredentialStore {
    private storage;
    private authPath;
    private readState;
    private constructor();
    static create(authPath?: string): AuthStorage;
    static fromStorage(storage: AuthStorageBackend): AuthStorage;
    static inMemory(data?: AuthStorageData): AuthStorage;
    private parseStorageData;
    private updateReadState;
    /**
     * Reload credentials from storage.
     */
    reload(): void;
    private reloadFromStorageAsync;
    private readLatestData;
    read(provider: string, options?: AuthOperationOptions): Promise<Credential | undefined>;
    modify(provider: string, fn: (current: Credential | undefined) => Promise<Credential | undefined>, options?: AuthOperationOptions): Promise<Credential | undefined>;
    delete(provider: string, options?: AuthOperationOptions): Promise<void>;
    /** List credential metadata without resolving configured key values. */
    list(options?: AuthOperationOptions): Promise<readonly CredentialInfo[]>;
}
/**
 * One-off synchronous read of a stored credential from an auth.json file,
 * without instantiating a store or resolving configured key values.
 */
export declare function readStoredCredential(providerId: string, authPath?: string): Credential | undefined;
export {};
//# sourceMappingURL=auth-storage.d.ts.map