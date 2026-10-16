import { APIResource } from "../../../../../core/resource.mjs";
import * as AgentsAPI from "../../agents.mjs";
import { SubagentsPage } from "../../agents.mjs";
import * as ItemsAPI from "./items.mjs";
import { ItemListParams, Items } from "./items.mjs";
import * as TurnsAPI from "./turns/turns.mjs";
import { TurnListParams, TurnRetrieveParams, Turns } from "./turns/turns.mjs";
import { APIPromise } from "../../../../../core/api-promise.mjs";
import { type CursorPageParams, PagePromise } from "../../../../../core/pagination.mjs";
import { RequestOptions } from "../../../../../internal/request-options.mjs";
export declare class Subagents extends APIResource {
    items: ItemsAPI.Items;
    turns: TurnsAPI.Turns;
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
    retrieve(subagentID: string, params: SubagentRetrieveParams, options?: RequestOptions): APIPromise<AgentsAPI.Subagent>;
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
    list(sessionID: string, query?: SubagentListParams | null | undefined, options?: RequestOptions): PagePromise<SubagentsPage, AgentsAPI.Subagent>;
}
export interface SubagentRetrieveParams {
    /**
     * The ID of the session.
     */
    session_id: string;
}
export interface SubagentListParams extends CursorPageParams {
    /**
     * The order in which resources are returned. Defaults to `desc`.
     *
     * - `asc` - Returns resources in ascending order.
     * - `desc` - Returns resources in descending order.
     */
    order?: 'asc' | 'desc';
}
export declare namespace Subagents {
    export { type SubagentRetrieveParams as SubagentRetrieveParams, type SubagentListParams as SubagentListParams, };
    export { Items as Items, type ItemListParams as ItemListParams };
    export { Turns as Turns, type TurnRetrieveParams as TurnRetrieveParams, type TurnListParams as TurnListParams, };
}
export { type SubagentsPage };
//# sourceMappingURL=subagents.d.mts.map