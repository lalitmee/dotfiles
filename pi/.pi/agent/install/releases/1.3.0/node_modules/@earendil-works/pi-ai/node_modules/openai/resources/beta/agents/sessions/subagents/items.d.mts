import { APIResource } from "../../../../../core/resource.mjs";
import * as AgentsAPI from "../../agents.mjs";
import { AgentSessionItemsPage } from "../../agents.mjs";
import { type CursorPageParams, PagePromise } from "../../../../../core/pagination.mjs";
import { RequestOptions } from "../../../../../internal/request-options.mjs";
export declare class Items extends APIResource {
    /**
     * Lists this subagent's own items across all of its turns. See
     * [subagent workflows](https://developers.openai.com/api/docs/guides/agents-api/multi-agent).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const agentSessionItem of client.beta.agents.sessions.subagents.items.list(
     *   'subagent_id',
     *   { session_id: 'session_id' },
     * )) {
     *   // ...
     * }
     * ```
     */
    list(subagentID: string, params: ItemListParams, options?: RequestOptions): PagePromise<AgentSessionItemsPage, AgentsAPI.AgentSessionItem>;
}
export interface ItemListParams extends CursorPageParams {
    /**
     * Path param: The ID of the session.
     */
    session_id: string;
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
//# sourceMappingURL=items.d.mts.map