// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../core/resource.mjs";
import * as EnvironmentsAPI from "./environments/environments.mjs";
import { Environments } from "./environments/environments.mjs";
import * as SessionsAPI from "./sessions/sessions.mjs";
import { Sessions, } from "./sessions/sessions.mjs";
import * as VaultsAPI from "./vaults/vaults.mjs";
import { Vaults, } from "./vaults/vaults.mjs";
import { CursorPage } from "../../../core/pagination.mjs";
import { buildHeaders } from "../../../internal/headers.mjs";
import { path } from "../../../internal/utils/path.mjs";
export class Agents extends APIResource {
    constructor() {
        super(...arguments);
        this.environments = new EnvironmentsAPI.Environments(this._client);
        this.vaults = new VaultsAPI.Vaults(this._client);
        this.sessions = new SessionsAPI.Sessions(this._client);
    }
    /**
     * Creates a reusable agent without storing credentials. See
     * [agent configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration).
     *
     * @example
     * ```ts
     * const agent = await client.beta.agents.create({
     *   model: 'model',
     * });
     * ```
     */
    create(body, options) {
        return this._client.post('/agents', {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Retrieves a reusable agent by ID. See
     * [agent configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration).
     *
     * @example
     * ```ts
     * const agent = await client.beta.agents.retrieve('agent_id');
     * ```
     */
    retrieve(agentID, options) {
        return this._client.get(path `/agents/${agentID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Updates a reusable agent. See
     * [agent configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration).
     *
     * @example
     * ```ts
     * const agent = await client.beta.agents.update('agent_id');
     * ```
     */
    update(agentID, body = {}, options) {
        return this._client.post(path `/agents/${agentID}`, {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists reusable agents in the current project. See
     * [agent configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const agent of client.beta.agents.list()) {
     *   // ...
     * }
     * ```
     */
    list(query = {}, options) {
        return this._client.getAPIList('/agents', (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Deletes a reusable agent. See
     * [agent configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration).
     *
     * @example
     * ```ts
     * const agentDeleted = await client.beta.agents.delete(
     *   'agent_id',
     * );
     * ```
     */
    delete(agentID, options) {
        return this._client.delete(path `/agents/${agentID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Agents.Environments = Environments;
Agents.Vaults = Vaults;
Agents.Sessions = Sessions;
//# sourceMappingURL=agents.mjs.map