// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../../../core/resource.mjs";
import { CursorPage } from "../../../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../../../internal/headers.mjs";
import { path } from "../../../../../../internal/utils/path.mjs";
export class Items extends APIResource {
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
        return this._client.getAPIList(path `/agents/sessions/${session_id}/subagents/${subagent_id}/turns/${turnID}/items`, (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=items.mjs.map