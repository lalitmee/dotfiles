// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Events extends APIResource {
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
    create(sessionID, params, options) {
        const { 'Idempotency-Key': idempotencyKey, ...body } = params;
        return this._client.post(path `/agents/sessions/${sessionID}/events`, {
            body,
            ...options,
            headers: buildHeaders([
                {
                    'OpenAI-Beta': 'agents=v1',
                    Accept: '*/*',
                    ...(idempotencyKey != null ? { 'Idempotency-Key': idempotencyKey } : undefined),
                },
                options?.headers,
            ]),
            __security: { bearerAuth: true },
        });
    }
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
    stream(sessionID, options) {
        return this._client.get(path `/agents/sessions/${sessionID}/events`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1', Accept: 'text/event-stream' }, options?.headers]),
            stream: true,
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=events.mjs.map