// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../../../core/resource.mjs";
import * as ItemsAPI from "./items.mjs";
import { Items } from "./items.mjs";
import { CursorPage } from "../../../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../../../internal/headers.mjs";
import { path } from "../../../../../../internal/utils/path.mjs";
export class Turns extends APIResource {
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
        return this._client.get(path `/agents/sessions/${session_id}/subagents/${subagent_id}/turns/${turnID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList(path `/agents/sessions/${session_id}/subagents/${subagentID}/turns`, (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Turns.Items = Items;
//# sourceMappingURL=turns.mjs.map