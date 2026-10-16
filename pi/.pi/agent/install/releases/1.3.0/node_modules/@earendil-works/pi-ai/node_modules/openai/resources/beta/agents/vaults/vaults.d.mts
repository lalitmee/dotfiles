import { APIResource } from "../../../../core/resource.mjs";
import * as CredentialsAPI from "./credentials.mjs";
import { Credential, CredentialAuth, CredentialAuthCreateParam, CredentialAuthRotateParam, CredentialCreateParams, CredentialDeleteParams, CredentialDeleted, CredentialListParams, CredentialRetrieveParams, CredentialUpdateParams, Credentials, CredentialsPage, McpOauthTokenEndpointAuth, McpOauthTokenEndpointAuthCreateParam, McpOauthTokenEndpointAuthRotateParam } from "./credentials.mjs";
import { APIPromise } from "../../../../core/api-promise.mjs";
import { CursorPage, type CursorPageParams, PagePromise } from "../../../../core/pagination.mjs";
import { RequestOptions } from "../../../../internal/request-options.mjs";
export declare class Vaults extends APIResource {
    credentials: CredentialsAPI.Credentials;
    /**
     * Creates a vault for the current project. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const vault = await client.beta.agents.vaults.create();
     * ```
     */
    create(body?: VaultCreateParams | null | undefined, options?: RequestOptions): APIPromise<Vault>;
    /**
     * Retrieves a vault by its ID. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const vault = await client.beta.agents.vaults.retrieve(
     *   'vault_id',
     * );
     * ```
     */
    retrieve(vaultID: string, options?: RequestOptions): APIPromise<Vault>;
    /**
     * Lists vaults using ID-based pagination. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const vault of client.beta.agents.vaults.list()) {
     *   // ...
     * }
     * ```
     */
    list(query?: VaultListParams | null | undefined, options?: RequestOptions): PagePromise<VaultsPage, Vault>;
    /**
     * Deletes a vault and all its credentials. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const vaultDeleted = await client.beta.agents.vaults.delete(
     *   'vault_id',
     * );
     * ```
     */
    delete(vaultID: string, options?: RequestOptions): APIPromise<VaultDeleted>;
}
export type VaultsPage = CursorPage<Vault>;
/**
 * A collection of credentials that agent tools can use to authenticate to MCP
 * servers.
 */
export interface Vault {
    /**
     * The ID of the vault.
     */
    id: string;
    /**
     * The Unix timestamp, in seconds, when the vault was created.
     */
    created_at: number;
    /**
     * Key-value pairs associated with the vault, such as an application or team
     * identifier.
     */
    metadata: {
        [key: string]: string;
    };
    /**
     * The human-readable name of the vault, if set.
     */
    name: string | null;
    /**
     * The object type. Always `vault`.
     */
    object: 'vault';
}
/**
 * Confirmation that a vault was deleted.
 */
export interface VaultDeleted {
    /**
     * The ID of the deleted vault.
     */
    id: string;
    /**
     * Whether the resource was deleted. Always `true`.
     */
    deleted: boolean;
    /**
     * The object type. Always `vault.deleted`.
     */
    object: 'vault.deleted';
}
/**
 * Whether a vault or credential is active or archived.
 */
export type VaultStatus = 'active' | 'archived';
/**
 * One or more lifecycle statuses to include when listing vaults or credentials.
 */
export type VaultStatusFilter = VaultStatus | Array<VaultStatus>;
export interface VaultCreateParams {
    /**
     * Key-value pairs to associate with the vault, such as an application or team
     * identifier.
     */
    metadata?: {
        [key: string]: string;
    } | null;
    /**
     * The name is trimmed before storage. It must contain 1 to 256 UTF-8 bytes after
     * trimming.
     */
    name?: string;
}
export interface VaultListParams extends Omit<CursorPageParams, 'limit'> {
    /**
     * The maximum number of resources to return. Defaults to 20. Values are clamped
     * between 1 and 100.
     */
    limit?: number | null;
    /**
     * Sort order by the `created_at` timestamp. Use `asc` for ascending order or
     * `desc` for descending order. Defaults to `desc`.
     *
     * - `asc` - Returns resources in ascending order.
     * - `desc` - Returns resources in descending order.
     */
    order?: 'asc' | 'desc';
    /**
     * Filter by one status or a list, such as `status=active` or
     * `status[]=active&status[]=archived`. Both statuses are included by default.
     */
    status?: VaultStatusFilter;
}
export declare namespace Vaults {
    export { type Vault as Vault, type VaultDeleted as VaultDeleted, type VaultStatus as VaultStatus, type VaultStatusFilter as VaultStatusFilter, type VaultsPage as VaultsPage, type VaultCreateParams as VaultCreateParams, type VaultListParams as VaultListParams, };
    export { Credentials as Credentials, type Credential as Credential, type CredentialAuth as CredentialAuth, type CredentialAuthCreateParam as CredentialAuthCreateParam, type CredentialAuthRotateParam as CredentialAuthRotateParam, type CredentialDeleted as CredentialDeleted, type McpOauthTokenEndpointAuth as McpOauthTokenEndpointAuth, type McpOauthTokenEndpointAuthCreateParam as McpOauthTokenEndpointAuthCreateParam, type McpOauthTokenEndpointAuthRotateParam as McpOauthTokenEndpointAuthRotateParam, type CredentialsPage as CredentialsPage, type CredentialCreateParams as CredentialCreateParams, type CredentialRetrieveParams as CredentialRetrieveParams, type CredentialUpdateParams as CredentialUpdateParams, type CredentialListParams as CredentialListParams, type CredentialDeleteParams as CredentialDeleteParams, };
}
//# sourceMappingURL=vaults.d.mts.map