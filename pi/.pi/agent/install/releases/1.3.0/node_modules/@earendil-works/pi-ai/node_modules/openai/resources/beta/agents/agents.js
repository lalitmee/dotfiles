"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Agents = void 0;
const tslib_1 = require("../../../internal/tslib.js");
const resource_1 = require("../../../core/resource.js");
const EnvironmentsAPI = tslib_1.__importStar(require("./environments/environments.js"));
const environments_1 = require("./environments/environments.js");
const SessionsAPI = tslib_1.__importStar(require("./sessions/sessions.js"));
const sessions_1 = require("./sessions/sessions.js");
const VaultsAPI = tslib_1.__importStar(require("./vaults/vaults.js"));
const vaults_1 = require("./vaults/vaults.js");
const pagination_1 = require("../../../core/pagination.js");
const headers_1 = require("../../../internal/headers.js");
const path_1 = require("../../../internal/utils/path.js");
class Agents extends resource_1.APIResource {
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
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.get((0, path_1.path) `/agents/${agentID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.post((0, path_1.path) `/agents/${agentID}`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList('/agents', (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.delete((0, path_1.path) `/agents/${agentID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Agents = Agents;
Agents.Environments = environments_1.Environments;
Agents.Vaults = vaults_1.Vaults;
Agents.Sessions = sessions_1.Sessions;
//# sourceMappingURL=agents.js.map