"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Vaults = void 0;
const tslib_1 = require("../../../../internal/tslib.js");
const resource_1 = require("../../../../core/resource.js");
const CredentialsAPI = tslib_1.__importStar(require("./credentials.js"));
const credentials_1 = require("./credentials.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Vaults extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        this.credentials = new CredentialsAPI.Credentials(this._client);
    }
    /**
     * Creates a vault for the current project. See
     * [vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults).
     *
     * @example
     * ```ts
     * const vault = await client.beta.agents.vaults.create();
     * ```
     */
    create(body = {}, options) {
        return this._client.post('/vaults', {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
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
    retrieve(vaultID, options) {
        return this._client.get((0, path_1.path) `/vaults/${vaultID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
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
    list(query = {}, options) {
        return this._client.getAPIList('/vaults', (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
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
    delete(vaultID, options) {
        return this._client.delete((0, path_1.path) `/vaults/${vaultID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Vaults = Vaults;
Vaults.Credentials = credentials_1.Credentials;
//# sourceMappingURL=vaults.js.map