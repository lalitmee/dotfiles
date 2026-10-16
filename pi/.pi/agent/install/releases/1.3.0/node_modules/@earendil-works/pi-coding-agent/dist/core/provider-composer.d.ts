import { type AnyModel, type Api, type AssistantMessageEventStream, type ClassifierApi, type ImageApi, type Model, type OAuthCredentials, type OAuthLoginCallbacks, type Provider, type ProviderClassifier, type ProviderHeaders, type ProviderImages, type RefreshModelsContext, type SimpleStreamOptions, type TranscriptContext } from "@earendil-works/pi-ai";
import type { ModelConfig, ModelsJsonProvider } from "./model-config.ts";
import { clearConfigValueCache } from "./resolve-config-value.ts";
export interface ExtensionOAuthConfig {
    name: string;
    /** Whether access through this auth method is backed by a provider subscription. */
    isSubscription?: boolean;
    /** @deprecated Retained for extension source compatibility; ignored by canonical auth flows. */
    usesCallbackServer?: boolean;
    login(callbacks: OAuthLoginCallbacks): Promise<OAuthCredentials>;
    refreshToken(credentials: OAuthCredentials, signal: AbortSignal): Promise<OAuthCredentials>;
    getApiKey(credentials: OAuthCredentials): string;
    modifyModels?(models: Model<Api>[], credentials: OAuthCredentials): Model<Api>[];
}
interface ProviderModelConfigBase {
    id: string;
    name: string;
    api?: string;
    baseUrl?: string;
    input: ("text" | "image")[];
    inputLimits?: AnyModel["inputLimits"];
    cost: AnyModel["cost"];
    headers?: Record<string, string>;
}
export interface ProviderChatModelConfig extends ProviderModelConfigBase {
    type?: "chat";
    api?: Api;
    reasoning: boolean;
    thinkingLevelMap?: Model<Api>["thinkingLevelMap"];
    promptCache?: Model<Api>["promptCache"];
    contextWindow: number;
    maxTokens: number;
    samplingParams?: Model<Api>["samplingParams"];
    samplingParamsByThinkingLevel?: Model<Api>["samplingParamsByThinkingLevel"];
    compat?: Model<Api>["compat"];
}
export interface ProviderImageModelConfig extends ProviderModelConfigBase {
    type: "image";
    api?: ImageApi;
    output: ("text" | "image")[];
}
export interface ProviderClassifierModelConfig extends ProviderModelConfigBase {
    type: "classifier";
    api?: ClassifierApi;
    contextWindow: number;
}
export type ProviderModelConfig = ProviderChatModelConfig | ProviderImageModelConfig | ProviderClassifierModelConfig;
/** Input type for the extension registerProvider API. */
export interface ProviderConfigInput {
    name?: string;
    baseUrl?: string;
    apiKey?: string;
    api?: Api;
    streamSimple?: (model: Model<Api>, context: TranscriptContext, options?: SimpleStreamOptions) => AssistantMessageEventStream;
    images?: Partial<Record<ImageApi, ProviderImages>>;
    classifiers?: Partial<Record<ClassifierApi, ProviderClassifier>>;
    headers?: Record<string, string>;
    authHeader?: boolean;
    oauth?: ExtensionOAuthConfig;
    models?: ProviderModelConfig[];
    refreshModels?(context: RefreshModelsContext): Promise<ProviderModelConfig[]>;
}
export type AuthStatus = {
    configured: boolean;
    source?: "stored" | "runtime" | "environment" | "fallback" | "models_json_key" | "models_json_command";
    label?: string;
};
export declare const clearApiKeyCache: typeof clearConfigValueCache;
export declare function validateExtensionProvider(providerId: string, base: Provider | undefined, modelsConfig: ModelsJsonProvider | undefined, extension: ProviderConfigInput): void;
/** Compose built-in, models.json, and extension layers without reading credentials. */
export declare function composeModelProvider(providerId: string, base: Provider | undefined, modelConfig: ModelConfig, extension: ProviderConfigInput | undefined): Provider;
export declare function resolveConfiguredModelHeaders(model: AnyModel, config: ModelsJsonProvider | undefined, extension: ProviderConfigInput | undefined, env?: Record<string, string>): Record<string, string> | undefined;
export interface CompatibilityRequestConfig {
    headers?: ProviderHeaders;
    authHeader: boolean;
}
export declare function resolveCompatibilityRequestConfig(model: AnyModel, config: ModelsJsonProvider | undefined, extension: ProviderConfigInput | undefined): CompatibilityRequestConfig;
export declare function configuredRequestAuthStatus(config: ModelsJsonProvider | undefined, extension: ProviderConfigInput | undefined): AuthStatus | undefined;
export {};
//# sourceMappingURL=provider-composer.d.ts.map