import { APIResource } from "../../../../core/resource.js";
import * as AgentsAPI from "../agents.js";
import { AgentSessionItemsPage } from "../agents.js";
import { type CursorPageParams, PagePromise } from "../../../../core/pagination.js";
import { RequestOptions } from "../../../../internal/request-options.js";
export declare class Items extends APIResource {
    /**
     * Lists items produced by the session's root agent, including its interactions
     * with subagents. Each subagent has its own item history. See
     * [inspecting agent output](https://developers.openai.com/api/docs/guides/agents-api/observability).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const agentSessionItem of client.beta.agents.sessions.items.list(
     *   'session_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(sessionID: string, query?: ItemListParams | null | undefined, options?: RequestOptions): PagePromise<AgentSessionItemsPage, AgentsAPI.AgentSessionItem>;
}
export interface ItemListParams extends CursorPageParams {
    /**
     * The order in which resources are returned. Defaults to `desc`.
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