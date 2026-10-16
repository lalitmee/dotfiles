import { APIResource } from "../../../../../../core/resource.js";
import * as TurnsAPI from "../../turns.js";
import { TurnsPage } from "../../turns.js";
import * as ItemsAPI from "./items.js";
import { ItemListParams, Items } from "./items.js";
import { APIPromise } from "../../../../../../core/api-promise.js";
import { type CursorPageParams, PagePromise } from "../../../../../../core/pagination.js";
import { RequestOptions } from "../../../../../../internal/request-options.js";
export declare class Turns extends APIResource {
    items: ItemsAPI.Items;
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
    retrieve(turnID: string, params: TurnRetrieveParams, options?: RequestOptions): APIPromise<TurnsAPI.Turn>;
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
    list(subagentID: string, params: TurnListParams, options?: RequestOptions): PagePromise<TurnsPage, TurnsAPI.Turn>;
}
export interface TurnRetrieveParams {
    /**
     * The ID of the session.
     */
    session_id: string;
    /**
     * The ID of the subagent in this session.
     */
    subagent_id: string;
}
export interface TurnListParams extends CursorPageParams {
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
export declare namespace Turns {
    export { type TurnRetrieveParams as TurnRetrieveParams, type TurnListParams as TurnListParams };
    export { Items as Items, type ItemListParams as ItemListParams };
}
export { type TurnsPage };
//# sourceMappingURL=turns.d.ts.map