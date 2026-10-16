"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Credentials = void 0;
const resource_1 = require("../../../../core/resource.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Credentials extends resource_1.APIResource {
    /**
     * Creates a vault credential. Secret values are write-only and are never returned.
     * See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const credential =
     *   await client.beta.agents.vaults.credentials.create(
     *     'vault_id',
     *     {
     *       auth: {
     *         access_token: 'access_token',
     *         mcp_server_url: 'mcp_server_url',
     *         type: 'mcp_oauth',
     *       },
     *       name: 'x',
     *     },
     *   );
     * ```
     */
    create(vaultID, body, options) {
        return this._client.post((0, path_1.path) `/vaults/${vaultID}/credentials`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Retrieves vault credential metadata without returning secret values. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const credential =
     *   await client.beta.agents.vaults.credentials.retrieve(
     *     'credential_id',
     *     { vault_id: 'vault_id' },
     *   );
     * ```
     */
    retrieve(credentialID, params, options) {
        const { vault_id } = params;
        return this._client.get((0, path_1.path) `/vaults/${vault_id}/credentials/${credentialID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Rotates a vault credential's write-only secret and returns only credential
     * metadata. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const credential =
     *   await client.beta.agents.vaults.credentials.update(
     *     'credential_id',
     *     {
     *       vault_id: 'vault_id',
     *       auth: { type: 'mcp_oauth' },
     *     },
     *   );
     * ```
     */
    update(credentialID, params, options) {
        const { vault_id, ...body } = params;
        return this._client.post((0, path_1.path) `/vaults/${vault_id}/credentials/${credentialID}`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists a vault's credentials using ID-based pagination without returning secret
     * values. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const credential of client.beta.agents.vaults.credentials.list(
     *   'vault_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(vaultID, query = {}, options) {
        return this._client.getAPIList((0, path_1.path) `/vaults/${vaultID}/credentials`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Deletes a vault credential. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const credentialDeleted =
     *   await client.beta.agents.vaults.credentials.delete(
     *     'credential_id',
     *     { vault_id: 'vault_id' },
     *   );
     * ```
     */
    delete(credentialID, params, options) {
        const { vault_id } = params;
        return this._client.delete((0, path_1.path) `/vaults/${vault_id}/credentials/${credentialID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Credentials = Credentials;
//# sourceMappingURL=credentials.js.map