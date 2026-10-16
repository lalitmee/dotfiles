import { type AnyModel, type Api, type AssistantImages, type AssistantMessage, type AssistantMessageEventStream, type AuthCheck, type AuthInteraction, type AuthOperationOptions, type AuthResult, type AuthType, type ClassifierApi, type ClassifierContext, type ClassifierModel, type ClassifierResult, type Context, type Credential, type CredentialInfo, type CredentialStore, type DeferredHandle, type ImageApi, type ImageModel, type ImagesContext, type LoginOptions, type Message, type Model, type Models, type ModelsApiStreamOptions, type ModelsClassifierOptions, type ModelsDeferredCancelOptions, type ModelsDeferredFetchOptions, type ModelsImagesOptions, type ModelsRefreshOptions, type ModelsRefreshResult, type ModelsSimpleStreamOptions, type ModelsStore, type ModelThinkingLevel, type ModelType, type ModelTypeMap, type Provider } from "@earendil-works/pi-ai";
import { type AuthStatus, type CompatibilityRequestConfig, type ProviderConfigInput } from "./provider-composer.ts";
import { type ModelRoute, type ModelRouteReason, type VirtualModelDefinition } from "./virtual-models.ts";
export interface CreateModelRuntimeOptions {
    /** Credential storage. Defaults to the file at authPath. */
    credentials?: CredentialStore;
    authPath?: string;
    modelsPath?: string | null;
    modelsStore?: ModelsStore;
    modelsStorePath?: string;
    /** Allow create() to refresh model catalogs over the network. Defaults to false. */
    allowModelNetwork?: boolean;
    /** Timeout for the create-time network model refresh. */
    modelRefreshTimeoutMs?: number;
    catalogBaseUrl?: string;
    /** Optional caller cancellation for initial cache restoration and availability checks. */
    signal?: AbortSignal;
    /** Skip initial catalog and availability refresh. Static models remain available. */
    refreshOnCreate?: boolean;
}
export interface ModelRuntimeAuthOverrides extends AuthOperationOptions {
    apiKey?: string;
    env?: Record<string, string>;
    /** Require this much remaining OAuth-token validity; defaults to five minutes. */
    minOAuthValidityMs?: number;
}
export type CredentialSynchronizationOperation = "login" | "logout" | "setRuntimeApiKey" | "removeRuntimeApiKey";
/** Credentials changed successfully, but the local model/auth snapshot could not be synchronized. */
export declare class CredentialSynchronizationError extends Error {
    readonly providerId: string;
    readonly operation: CredentialSynchronizationOperation;
    readonly credential: Credential | undefined;
    constructor(providerId: string, operation: CredentialSynchronizationOperation, credential: Credential | undefined, options: ErrorOptions);
}
/** Configured pi-ai Models collection used by coding-agent and SDK consumers. */
export declare class ModelRuntime implements Models {
    private readonly models;
    private readonly credentials;
    private readonly defaultBuiltins;
    private readonly builtins;
    private readonly nativeExtensionProviders;
    private readonly extensionProviders;
    /** Virtual models by provider id, then model id. */
    private readonly virtualModels;
    private readonly compositionErrors;
    private readonly modelsPath;
    private readonly modelNetworkEnabled;
    private config;
    private snapshot;
    private availabilityRefreshSeq;
    private availabilityErrorSeq;
    private readonly providerAvailabilitySeq;
    private availabilityError;
    private readonly credentialOperations;
    private constructor();
    static create(options?: CreateModelRuntimeOptions): Promise<ModelRuntime>;
    private configureRadiusProviders;
    private providerIds;
    /** Returns the provider without virtual models, or undefined when only virtual models define it. */
    private recomposeProvider;
    /** The provider without virtual models, or undefined when nothing defines it. */
    private composeProvider;
    private rebuildProviders;
    private updateModelSnapshot;
    private runAvailabilityRefresh;
    private queueAvailabilityRefresh;
    private refreshProviderAvailability;
    getProviders(): readonly Provider[];
    getProvider(providerId: string): Provider | undefined;
    getModels(providerId?: string): readonly Model<Api>[];
    getModel(providerId: string, modelId: string): Model<Api> | undefined;
    getModelsOfType<TType extends ModelType>(type: TType, providerId?: string): readonly ModelTypeMap[TType][];
    getModelOfType<TType extends ModelType>(type: TType, providerId: string, modelId: string): ModelTypeMap[TType] | undefined;
    getAllModels(providerId?: string): readonly AnyModel[];
    getAvailableOfType<TType extends ModelType>(type: TType, providerId?: string, options?: AuthOperationOptions): Promise<readonly ModelTypeMap[TType][]>;
    getAllAvailable(providerId?: string, options?: AuthOperationOptions): Promise<readonly AnyModel[]>;
    checkAuth(providerId: string, options?: AuthOperationOptions): Promise<AuthCheck | undefined>;
    getAvailable(providerId?: string, options?: AuthOperationOptions): Promise<readonly Model<Api>[]>;
    getAvailableSnapshot(): readonly Model<Api>[];
    getError(): string | undefined;
    getRegisteredProviderConfig(providerId: string): ProviderConfigInput | undefined;
    getRegisteredProviderIds(): readonly string[];
    getRegisteredNativeProvider(providerId: string): Provider | undefined;
    /** @internal Compatibility fallback for ModelRegistry when provider auth is unconfigured. */
    getCompatibilityRequestConfig(model: Model<Api>): CompatibilityRequestConfig;
    isUsingOAuth(providerId: string): boolean;
    isUsingSubscription(providerId: string): boolean;
    hasConfiguredAuth(providerId: string): boolean;
    getAuth(providerId: string, overrides?: ModelRuntimeAuthOverrides): Promise<AuthResult | undefined>;
    getAuth(model: AnyModel, overrides?: ModelRuntimeAuthOverrides): Promise<AuthResult | undefined>;
    private enqueueCredentialOperation;
    private synchronizeCredentialState;
    setRuntimeApiKey(providerId: string, apiKey: string, options?: AuthOperationOptions): Promise<void>;
    removeRuntimeApiKey(providerId: string, options?: AuthOperationOptions): Promise<void>;
    listCredentials(options?: AuthOperationOptions): Promise<readonly CredentialInfo[]>;
    getProviderAuthStatus(providerId: string): AuthStatus;
    private prepareRequest;
    stream<TApi extends Api>(model: Model<TApi>, context: Context, options?: ModelsApiStreamOptions<TApi>): AssistantMessageEventStream;
    complete<TApi extends Api>(model: Model<TApi>, context: Context, options?: ModelsApiStreamOptions<TApi>): Promise<AssistantMessage>;
    streamSimple(model: Model<Api>, context: Context, options?: ModelsSimpleStreamOptions): AssistantMessageEventStream;
    completeSimple(model: Model<Api>, context: Context, options?: ModelsSimpleStreamOptions): Promise<AssistantMessage>;
    streamDeferred(model: Model<Api>, handle: DeferredHandle, options?: ModelsDeferredFetchOptions): AssistantMessageEventStream;
    fetchDeferred(model: Model<Api>, handle: DeferredHandle, options?: ModelsDeferredFetchOptions): Promise<AssistantMessage>;
    cancelDeferred(model: Model<Api>, handle: DeferredHandle, options?: ModelsDeferredCancelOptions): Promise<void>;
    generateImages(model: ImageModel<ImageApi>, context: ImagesContext, options?: ModelsImagesOptions): Promise<AssistantImages>;
    classify(model: ClassifierModel<ClassifierApi>, context: ClassifierContext, options?: ModelsClassifierOptions): Promise<ClassifierResult>;
    login(providerId: string, type: AuthType, interaction: AuthInteraction, options?: LoginOptions): Promise<Credential>;
    logout(providerId: string, options?: AuthOperationOptions): Promise<void>;
    refresh(options?: ModelsRefreshOptions): Promise<ModelsRefreshResult>;
    registerNativeProvider(provider: Provider): void;
    /**
     * Mark a newly registered provider as configured when it has a stored credential or a configured
     * API key. Availability checks run asynchronously, and callers such as initial model selection
     * read the snapshot before they finish. The next availability pass replaces this entry.
     */
    private markProvisionallyConfigured;
    registerProvider(providerId: string, config: ProviderConfigInput): void;
    unregisterProvider(providerId: string): void;
    /**
     * Register a virtual model under `definition.provider`, which may also list physical models or
     * several virtual models. Re-registering the same provider and id replaces the virtual model.
     * Throws when the id belongs to a physical model of that provider.
     */
    registerVirtualModel(definition: VirtualModelDefinition): void;
    unregisterVirtualModel(providerId: string, id: string): void;
    /**
     * Ask a virtual model's router for the model and thinking level of one request. The router must
     * return a physical catalog model whose provider has credentials; the thinking level is clamped
     * to that model. Throws when routing fails.
     *
     * `previous` reports the latest successful response in `messages`. A retry passes the failed
     * response as `options.failed`; `messages` no longer contains it. `options.state` is the router
     * state stored by the caller, which also stores the returned state.
     */
    resolveModel(model: Model<Api>, messages: readonly Message[], options: {
        reason: ModelRouteReason;
        thinkingLevel: ModelThinkingLevel;
        signal?: AbortSignal;
        failed?: AssistantMessage;
        state?: unknown;
    }): Promise<ModelRoute>;
    /** A catalog chat model that is not virtual. */
    getPhysicalModel(providerId: string, modelId: string): Model<Api> | undefined;
}
//# sourceMappingURL=model-runtime.d.ts.map