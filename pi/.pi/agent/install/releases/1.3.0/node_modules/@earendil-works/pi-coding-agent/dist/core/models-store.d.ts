import type { ModelsStore, ModelsStoreEntry, ModelsStoreOperationOptions } from "@earendil-works/pi-ai";
export declare class InMemoryCodingAgentModelsStore implements ModelsStore {
    private readonly entries;
    read(providerId: string, options?: ModelsStoreOperationOptions): Promise<ModelsStoreEntry | undefined>;
    write(providerId: string, entry: ModelsStoreEntry, options?: ModelsStoreOperationOptions): Promise<void>;
    delete(providerId: string, options?: ModelsStoreOperationOptions): Promise<void>;
}
/** Locked JSON-backed storage for dynamically refreshed provider catalogs. */
export declare class FileModelsStore implements ModelsStore {
    private readonly storage;
    private readonly path;
    private readonly readState;
    constructor(path?: string);
    private parse;
    private updateReadState;
    private reloadFromStorage;
    private readLatest;
    read(providerId: string, options?: ModelsStoreOperationOptions): Promise<ModelsStoreEntry | undefined>;
    write(providerId: string, entry: ModelsStoreEntry, options?: ModelsStoreOperationOptions): Promise<void>;
    delete(providerId: string, options?: ModelsStoreOperationOptions): Promise<void>;
}
//# sourceMappingURL=models-store.d.ts.map