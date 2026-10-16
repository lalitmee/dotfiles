"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Turns = void 0;
const resource_1 = require("../../../../core/resource.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Turns extends resource_1.APIResource {
    /**
     * Retrieves a turn's current status, timestamps, usage, and error. Returns 404 if
     * the turn does not belong to the session. See
     * [session turns](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage#inspect-session-turns).
     *
     * @example
     * ```ts
     * const turn =
     *   await client.beta.agents.sessions.turns.retrieve(
     *     'turn_id',
     *     { session_id: 'session_id' },
     *   );
     * ```
     */
    retrieve(turnID, params, options) {
        const { session_id } = params;
        return this._client.get((0, path_1.path) `/agents/sessions/${session_id}/turns/${turnID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists turns by creation time and turn ID. The after cursor is exclusive in the
     * selected order. See
     * [session turns](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage#inspect-session-turns).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const turn of client.beta.agents.sessions.turns.list(
     *   'session_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(sessionID, query = {}, options) {
        return this._client.getAPIList((0, path_1.path) `/agents/sessions/${sessionID}/turns`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Turns = Turns;
//# sourceMappingURL=turns.js.map