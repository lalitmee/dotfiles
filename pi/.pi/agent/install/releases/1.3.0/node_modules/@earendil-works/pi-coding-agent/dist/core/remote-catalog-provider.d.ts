import { type AnyModel, type ModelType, type Provider, type RefreshModelsContext } from "@earendil-works/pi-ai";
export declare const REMOTE_CATALOG_REFRESH_INTERVAL_MS: number;
/**
 * Model types this client can consume. Sent as `?types=` so the catalog server
 * returns the full-type shard instead of the chat-only one served to clients
 * that predate model types. A server that ignores the parameter still returns
 * the chat-only shard, which this client handles unchanged.
 */
export declare const REMOTE_CATALOG_MODEL_TYPES: readonly ModelType[];
/** Replaces the catalog with a credential-specific model list. */
export type PersonalizeCatalog = (catalog: readonly AnyModel[], context: RefreshModelsContext) => Promise<readonly AnyModel[]>;
/** Add a persisted pi.dev catalog overlay to a static built-in provider. */
export declare function withRemoteCatalog(provider: Provider, catalogBaseUrl?: string, localGeneratedAt?: number): Provider;
/**
 * Like `withRemoteCatalog`, but on each network refresh the catalog (built-in models plus a newer
 * pi.dev catalog) is passed through `personalize` and the result is saved. The saved entry holds
 * the personalized list, not the pi.dev catalog, and replaces the catalog, including offline.
 * The refresh interval and etag revalidation are skipped. An empty list (nothing saved yet, or an
 * empty catalog saved by an older pi after a failed or missing pi.dev catalog) falls back to the
 * built-in models.
 */
export declare function withPersonalizedCatalog(provider: Provider, personalize: PersonalizeCatalog, catalogBaseUrl?: string, localGeneratedAt?: number): Provider;
//# sourceMappingURL=remote-catalog-provider.d.ts.map