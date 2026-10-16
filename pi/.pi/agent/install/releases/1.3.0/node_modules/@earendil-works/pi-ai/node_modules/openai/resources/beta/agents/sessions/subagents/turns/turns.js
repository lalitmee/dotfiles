"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Turns = void 0;
const tslib_1 = require("../../../../../../internal/tslib.js");
const resource_1 = require("../../../../../../core/resource.js");
const ItemsAPI = tslib_1.__importStar(require("./items.js"));
const items_1 = require("./items.js");
const pagination_1 = require("../../../../../../core/pagination.js");
const headers_1 = require("../../../../../../internal/headers.js");
const path_1 = require("../../../../../../internal/utils/path.js");
class Turns extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        this.items = new ItemsAPI.Items(this._client);
    }
    /**
     * Retrieves a turn belonging to this subagent. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * const turn =
     *   await client.beta.agents.sessions.subagents.turns.retrieve(
     *     'turn_id',
     *     {
     *       session_id: 'session_id',
     *       subagent_id: 'subagent_id',
     *     },
     *   );
     * ```
     */
    retrieve(turnID, params, options) {
        const { session_id, subagent_id } = params;
        return this._client.get((0, path_1.path) `/agents/sessions/${session_id}/subagents/${subagent_id}/turns/${turnID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists all turns of this subagent, including turns after a resume. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const turn of client.beta.agents.sessions.subagents.turns.list(
     *   'subagent_id',
     *   { session_id: 'session_id' },
     * )) {
     *   // ...
     * }
     * ```
     */
    list(subagentID, params, options) {
        const { session_id, ...query } = params;
        return this._client.getAPIList((0, path_1.path) `/agents/sessions/${session_id}/subagents/${subagentID}/turns`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Turns = Turns;
Turns.Items = items_1.Items;
//# sourceMappingURL=turns.js.map