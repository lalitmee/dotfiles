// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import { CursorPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Turns extends APIResource {
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
        return this._client.get(path `/agents/sessions/${session_id}/turns/${turnID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList(path `/agents/sessions/${sessionID}/turns`, (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=turns.mjs.map