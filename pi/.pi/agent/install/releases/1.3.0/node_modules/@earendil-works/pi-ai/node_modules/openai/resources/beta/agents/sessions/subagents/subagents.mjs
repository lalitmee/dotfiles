// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../../core/resource.mjs";
import * as ItemsAPI from "./items.mjs";
import { Items } from "./items.mjs";
import * as TurnsAPI from "./turns/turns.mjs";
import { Turns } from "./turns/turns.mjs";
import { CursorPage } from "../../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../../internal/headers.mjs";
import { path } from "../../../../../internal/utils/path.mjs";
export class Subagents extends APIResource {
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
        return this._client.get(path `/agents/sessions/${session_id}/subagents/${subagentID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList(path `/agents/sessions/${sessionID}/subagents`, (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Subagents.Items = Items;
Subagents.Turns = Turns;
//# sourceMappingURL=subagents.mjs.map