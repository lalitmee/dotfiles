// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { AgentSessionStream, } from "../../../../lib/agents/agent-session-stream.mjs";
import { APIResource } from "../../../../core/resource.mjs";
import * as ArtifactsAPI from "./artifacts.mjs";
import { Artifacts, } from "./artifacts.mjs";
import * as EventsAPI from "./events.mjs";
import { Events } from "./events.mjs";
import * as ItemsAPI from "./items.mjs";
import { Items } from "./items.mjs";
import * as TurnsAPI from "./turns.mjs";
import { Turns } from "./turns.mjs";
import * as SubagentsAPI from "./subagents/subagents.mjs";
import { Subagents } from "./subagents/subagents.mjs";
import { CursorPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Sessions extends APIResource {
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
        return new AgentSessionStream(this, sessionID, params, options);
    }
    create(body, options) {
        return this._client.post('/agents/sessions', {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.get(path `/agents/sessions/${sessionID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.post(path `/agents/sessions/${sessionID}`, {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList('/agents/sessions', (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.delete(path `/agents/sessions/${sessionID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Sessions.Subagents = Subagents;
Sessions.Artifacts = Artifacts;
Sessions.Items = Items;
Sessions.Events = Events;
Sessions.Turns = Turns;
//# sourceMappingURL=sessions.mjs.map