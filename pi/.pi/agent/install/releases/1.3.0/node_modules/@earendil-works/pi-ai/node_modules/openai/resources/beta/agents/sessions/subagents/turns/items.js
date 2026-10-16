"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Items = void 0;
const resource_1 = require("../../../../../../core/resource.js");
const pagination_1 = require("../../../../../../core/pagination.js");
const headers_1 = require("../../../../../../internal/headers.js");
const path_1 = require("../../../../../../internal/utils/path.js");
class Items extends resource_1.APIResource {
    /**
     * Lists items belonging to one turn of this subagent. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const agentSessionItem of client.beta.agents.sessions.subagents.turns.items.list(
     *   'turn_id',
     *   { session_id: 'session_id', subagent_id: 'subagent_id' },
     * )) {
     *   // ...
     * }
     * ```
     */
    list(turnID, params, options) {
        const { session_id, subagent_id, ...query } = params;
        return this._client.getAPIList((0, path_1.path) `/agents/sessions/${session_id}/subagents/${subagent_id}/turns/${turnID}/items`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Items = Items;
//# sourceMappingURL=items.js.map