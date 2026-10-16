"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Events = void 0;
const resource_1 = require("../../../../core/resource.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Events extends resource_1.APIResource {
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
        return this._client.post((0, path_1.path) `/agents/sessions/${sessionID}/events`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([
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
        return this._client.get((0, path_1.path) `/agents/sessions/${sessionID}/events`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1', Accept: 'text/event-stream' }, options?.headers]),
            stream: true,
            __security: { bearerAuth: true },
        });
    }
}
exports.Events = Events;
//# sourceMappingURL=events.js.map