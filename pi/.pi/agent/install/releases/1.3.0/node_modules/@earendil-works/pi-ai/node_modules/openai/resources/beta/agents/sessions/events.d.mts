import { APIResource } from "../../../../core/resource.mjs";
import * as AgentsAPI from "../agents.mjs";
import { APIPromise } from "../../../../core/api-promise.mjs";
import { Stream } from "../../../../core/streaming.mjs";
import { RequestOptions } from "../../../../internal/request-options.mjs";
export declare class Events extends APIResource {
    /**
     * Submits message, cancellation, or tool-result events to a managed agent session.
     * Cancellation can recover a still-open turn whose backend execution has ended by
     * marking it cancelled and abandoning unpublished outputs. Saved results,
     * published files, and existing terminal outcomes are preserved. HTTP 202 confirms
     * acceptance, not durable completion. See
     * [session events](https://developers.openai.com/api/docs/guides/agents-api/sessions/events).
     *
     * @example
     * ```ts
     * await client.beta.agents.sessions.events.create(
     *   'session_id',
     *   {
     *     events: [
     *       {
     *         input: [
     *           {
     *             content: [{ text: 'text', type: 'input_text' }],
     *             role: 'user',
     *           },
     *         ],
     *         type: 'agent.session.input.message',
     *       },
     *     ],
     *   },
     * );
     * ```
     */
    create(sessionID: string, params: EventCreateParams, options?: RequestOptions): APIPromise<void>;
    /**
     * Streams live events for an agent session. See
     * [session events](https://developers.openai.com/api/docs/guides/agents-api/sessions/events).
     *
     * @example
     * ```ts
     * const agentSessionEvent =
     *   await client.beta.agents.sessions.events.stream(
     *     'session_id',
     *   );
     * ```
     */
    stream(sessionID: string, options?: RequestOptions): APIPromise<Stream<AgentsAPI.AgentSessionEvent>>;
}
export interface EventCreateParams {
    /**
     * Body param: The input events to submit to the session.
     */
    events: Array<AgentsAPI.AgentSessionInputParam>;
    /**
     * Header param: An optional client-generated key that makes retries of submitted
     * messages idempotent.
     */
    'Idempotency-Key'?: string;
}
export declare namespace Events {
    export { type EventCreateParams as EventCreateParams };
}
//# sourceMappingURL=events.d.mts.map