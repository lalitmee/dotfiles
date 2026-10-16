import type { Api, AssistantImages, AssistantMessage, AssistantMessageEventStream, AuthOperationOptions, AuthResult, ClassifierApi, ClassifierContext, ClassifierModel, ClassifierResult, Context, ImageApi, ImageModel, ImagesContext, Model, ModelsApiStreamOptions, ModelsClassifierOptions, ModelsImagesOptions, ModelsRefreshOptions, ModelsRefreshResult, ModelsSimpleStreamOptions, ModelType, ModelTypeMap, Provider, ProviderHeaders } from "@earendil-works/pi-ai";
import type { ModelRuntime } from "./model-runtime.ts";
import type { AuthStatus, ProviderConfigInput } from "./provider-composer.ts";
import type { VirtualModelDefinition } from "./virtual-models.ts";
export type { ProviderConfigInput } from "./provider-composer.ts";
export type ResolvedRequestAuth = {
    ok: true;
    apiKey?: string;
    headers?: ProviderHeaders;
    baseUrl?: string;
    env?: Record<string, string>;
} | {
    ok: false;
    error: string;
};
export { clearApiKeyCache } from "./provider-composer.ts";
/**
 * Synchronous compatibility facade exposed to extensions.
 * Coding-agent internals use ModelRuntime directly.
 */
export declare class ModelRegistry {
    private readonly runtime;
    constructor(runtime: ModelRuntime);
    /** Reload models.json asynchronously. Await before making synchronous registry reads. */
    refresh(options?: ModelsRefreshOptions): Promise<ModelsRefreshResult>;
    getError(): string | undefined;
    getAll(): Model<Api>[];
    getAvailable(): Model<Api>[];
    find(provider: string, modelId: string): Model<Api> | undefined;
    /** Find a model of a non-chat type, e.g. `findOfType("classifier", "typesafe", "jev-latest")`. */
    findOfType<TType extends ModelType>(type: TType, provider: string, modelId: string): ModelTypeMap[TType] | undefined;
    hasConfiguredAuth(model: Model<Api>): boolean;
    getApiKeyAndHeaders(model: Model<Api>): Promise<ResolvedRequestAuth>;
    getProviderAuthStatus(provider: string): AuthStatus;
    getProvider(provider: string): Provider | undefined;
    /** Stream through the configured provider with request-time authentication. */
    stream<TApi extends Api>(model: Model<TApi>, context: Context, options?: ModelsApiStreamOptions<TApi>): AssistantMessageEventStream;
    /** Stream with provider-neutral options and request-time authentication. */
    streamSimple(model: Model<Api>, context: Context, options?: ModelsSimpleStreamOptions): AssistantMessageEventStream;
    complete<TApi extends Api>(model: Model<TApi>, context: Context, options?: ModelsApiStreamOptions<TApi>): Promise<AssistantMessage>;
    /** Every known model of a type (chat, image, classifier), optionally for one provider. */
    getModelsOfType<TType extends ModelType>(type: TType, provider?: string): readonly ModelTypeMap[TType][];
    /** Models of a type whose provider has working credentials. */
    getAvailableOfType<TType extends ModelType>(type: TType, provider?: string, options?: AuthOperationOptions): Promise<readonly ModelTypeMap[TType][]>;
    getModelOfType<TType extends ModelType>(type: TType, provider: string, modelId: string): ModelTypeMap[TType] | undefined;
    /** Classify structured state with request-time authentication. Never rejects. */
    classify(model: ClassifierModel<ClassifierApi>, context: ClassifierContext, options?: ModelsClassifierOptions): Promise<ClassifierResult>;
    /** Generate images with request-time authentication. Never rejects. */
    generateImages(model: ImageModel<ImageApi>, context: ImagesContext, options?: ModelsImagesOptions): Promise<AssistantImages>;
    getProviderDisplayName(provider: string): string;
    getProviderAuth(provider: string): Promise<AuthResult | undefined>;
    getApiKeyForProvider(provider: string): Promise<string | undefined>;
    isUsingOAuth(model: Model<Api>): boolean;
    registerProvider(provider: Provider): void;
    registerProvider(providerName: string, config: ProviderConfigInput): void;
    unregisterProvider(providerName: string): void;
    registerVirtualModel(definition: VirtualModelDefinition): void;
    unregisterVirtualModel(providerName: string, id: string): void;
    getRegisteredProviderConfig(providerName: string): ProviderConfigInput | undefined;
    getRegisteredNativeProvider(providerName: string): Provider | undefined;
    getRegisteredProviderIds(): readonly string[];
}
//# sourceMappingURL=model-registry.d.ts.map