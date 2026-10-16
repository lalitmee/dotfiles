// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import * as CredentialsAPI from "./credentials.mjs";
import { Credentials, } from "./credentials.mjs";
import { CursorPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Vaults extends APIResource {
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
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.get(path `/vaults/${vaultID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList('/vaults', (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.delete(path `/vaults/${vaultID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Vaults.Credentials = Credentials;
//# sourceMappingURL=vaults.mjs.map