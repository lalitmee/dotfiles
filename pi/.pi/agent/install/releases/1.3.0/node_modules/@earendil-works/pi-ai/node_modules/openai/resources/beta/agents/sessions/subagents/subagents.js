"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Subagents = void 0;
const tslib_1 = require("../../../../../internal/tslib.js");
const resource_1 = require("../../../../../core/resource.js");
const ItemsAPI = tslib_1.__importStar(require("./items.js"));
const items_1 = require("./items.js");
const TurnsAPI = tslib_1.__importStar(require("./turns/turns.js"));
const turns_1 = require("./turns/turns.js");
const pagination_1 = require("../../../../../core/pagination.js");
const headers_1 = require("../../../../../internal/headers.js");
const path_1 = require("../../../../../internal/utils/path.js");
class Subagents extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        this.items = new ItemsAPI.Items(this._client);
        this.turns = new TurnsAPI.Turns(this._client);
    }
    /**
     * Retrieves a subagent belonging to this session. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * const subagent =
     *   await client.beta.agents.sessions.subagents.retrieve(
     *     'subagent_id',
     *     { session_id: 'session_id' },
     *   );
     * ```
     */
    retrieve(subagentID, params, options) {
        const { session_id } = params;
        return this._client.get((0, path_1.path) `/agents/sessions/${session_id}/subagents/${subagentID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists subagents in a session, including nested and closed subagents. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const subagent of client.beta.agents.sessions.subagents.list(
     *   'session_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(sessionID, query = {}, options) {
        return this._client.getAPIList((0, path_1.path) `/agents/sessions/${sessionID}/subagents`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Subagents = Subagents;
Subagents.Items = items_1.Items;
Subagents.Turns = turns_1.Turns;
//# sourceMappingURL=subagents.js.map