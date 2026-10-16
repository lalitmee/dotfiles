"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Sessions = void 0;
const tslib_1 = require("../../../../internal/tslib.js");
const agent_session_stream_1 = require("../../../../lib/agents/agent-session-stream.js");
const resource_1 = require("../../../../core/resource.js");
const ArtifactsAPI = tslib_1.__importStar(require("./artifacts.js"));
const artifacts_1 = require("./artifacts.js");
const EventsAPI = tslib_1.__importStar(require("./events.js"));
const events_1 = require("./events.js");
const ItemsAPI = tslib_1.__importStar(require("./items.js"));
const items_1 = require("./items.js");
const TurnsAPI = tslib_1.__importStar(require("./turns.js"));
const turns_1 = require("./turns.js");
const SubagentsAPI = tslib_1.__importStar(require("./subagents/subagents.js"));
const subagents_1 = require("./subagents/subagents.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Sessions extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        this.subagents = new SubagentsAPI.Subagents(this._client);
        this.artifacts = new ArtifactsAPI.Artifacts(this._client);
        this.items = new ItemsAPI.Items(this._client);
        this.events = new EventsAPI.Events(this._client);
        this.turns = new TurnsAPI.Turns(this._client);
    }
    /** Stream one turn on an idle session with a single input writer. See AgentSessionStream for lifecycle and tool handling. */
    stream(sessionID, params, options) {
        return new agent_session_stream_1.AgentSessionStream(this, sessionID, params, options);
    }
    create(body, options) {
        return this._client.post('/agents/sessions', {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            stream: body.stream ?? false,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Retrieves the current state of a managed agent session. See
     * [managing sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage).
     *
     * @example
     * ```ts
     * const agentSession =
     *   await client.beta.agents.sessions.retrieve('session_id');
     * ```
     */
    retrieve(sessionID, options) {
        return this._client.get((0, path_1.path) `/agents/sessions/${sessionID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Updates session metadata, model, reasoning effort, or service tier. Model
     * settings apply to subsequent turns. Omitted fields are unchanged. See
     * [managing sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage).
     *
     * @example
     * ```ts
     * const agentSession =
     *   await client.beta.agents.sessions.update('session_id');
     * ```
     */
    update(sessionID, body = {}, options) {
        return this._client.post((0, path_1.path) `/agents/sessions/${sessionID}`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists managed agent sessions using ID-based pagination and the requested sort
     * order. See
     * [managing sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const agentSession of client.beta.agents.sessions.list()) {
     *   // ...
     * }
     * ```
     */
    list(query = {}, options) {
        return this._client.getAPIList('/agents/sessions', (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Removes a managed agent session from the public API and returns a deletion
     * confirmation. If backend execution has ended, deletion can cancel a still-open
     * public turn and abandon unpublished outputs. Running execution must be cancelled
     * first. Physical cleanup may continue asynchronously. See
     * [managing sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions/manage).
     *
     * @example
     * ```ts
     * const agentSessionDeleted =
     *   await client.beta.agents.sessions.delete('session_id');
     * ```
     */
    delete(sessionID, options) {
        return this._client.delete((0, path_1.path) `/agents/sessions/${sessionID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Sessions = Sessions;
Sessions.Subagents = subagents_1.Subagents;
Sessions.Artifacts = artifacts_1.Artifacts;
Sessions.Items = items_1.Items;
Sessions.Events = events_1.Events;
Sessions.Turns = turns_1.Turns;
//# sourceMappingURL=sessions.js.map