import { APIResource } from "../../../../../../core/resource.js";
import * as AgentsAPI from "../../../agents.js";
import { AgentSessionItemsPage } from "../../../agents.js";
import { type CursorPageParams, PagePromise } from "../../../../../../core/pagination.js";
import { RequestOptions } from "../../../../../../internal/request-options.js";
export declare class Items extends APIResource {
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
    list(turnID: string, params: ItemListParams, options?: RequestOptions): PagePromise<AgentSessionItemsPage, AgentsAPI.AgentSessionItem>;
}
export interface ItemListParams extends CursorPageParams {
    /**
     * Path param: The ID of the session.
     */
    session_id: string;
    /**
     * Path param: The ID of the subagent in this session.
     */
    subagent_id: string;
    /**
     * Query param: The order in which resources are returned. Defaults to `desc`.
     *
     * - `asc` - Returns resources in ascending order.
     * - `desc` - Returns resources in descending order.
     */
    order?: 'asc' | 'desc';
}
export declare namespace Items {
    export { type ItemListParams as ItemListParams };
}
export { type AgentSessionItemsPage };
//# sourceMappingURL=items.d.ts.map