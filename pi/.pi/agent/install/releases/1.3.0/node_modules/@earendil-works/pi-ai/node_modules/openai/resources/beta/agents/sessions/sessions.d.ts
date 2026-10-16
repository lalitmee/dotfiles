import { AgentSessionStream, type AgentSessionStreamParams } from "../../../../lib/agents/agent-session-stream.js";
import { APIResource } from "../../../../core/resource.js";
import * as SessionsAPI from "./sessions.js";
import * as AgentsAPI from "../agents.js";
import { AgentSessionsPage } from "../agents.js";
import * as ArtifactsAPI from "./artifacts.js";
import { ArtifactContentParams, ArtifactDeleteParams, ArtifactListParams, ArtifactRetrieveParams, Artifacts, SessionArtifact, SessionArtifactDeleted, SessionArtifactsPage } from "./artifacts.js";
import * as EventsAPI from "./events.js";
import { EventCreateParams, Events } from "./events.js";
import * as ItemsAPI from "./items.js";
import { ItemListParams, Items } from "./items.js";
import * as TurnsAPI from "./turns.js";
import { Turn, TurnListParams, TurnRetrieveParams, Turns, TurnsPage } from "./turns.js";
import * as SubagentsAPI from "./subagents/subagents.js";
import { SubagentListParams, SubagentRetrieveParams, Subagents } from "./subagents/subagents.js";
import { APIPromise } from "../../../../core/api-promise.js";
import { type CursorPageParams, PagePromise } from "../../../../core/pagination.js";
import { Stream } from "../../../../core/streaming.js";
import { RequestOptions } from "../../../../internal/request-options.js";
export declare class Sessions extends APIResource {
    /** Stream one turn on an idle session with a single input writer. See AgentSessionStream for lifecycle and tool handling. */
    stream(sessionID: string, params: AgentSessionStreamParams, options?: RequestOptions): AgentSessionStream;
    subagents: SubagentsAPI.Subagents;
    artifacts: ArtifactsAPI.Artifacts;
    items: ItemsAPI.Items;
    events: EventsAPI.Events;
    turns: TurnsAPI.Turns;
    /**
     * Creates a managed agent session, optionally submits initial input, and returns
     * the session or streams its events when stream is true. See
     * [running sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions).
     *
     * @example
     * ```ts
     * const agentSession =
     *   await client.beta.agents.sessions.create({
     *     environment: { type: 'none' },
     *   });
     * ```
     */
    create(body: SessionCreateParamsNonStreaming, options?: RequestOptions): APIPromise<AgentsAPI.AgentSession>;
    create(body: SessionCreateParamsStreaming, options?: RequestOptions): APIPromise<Stream<AgentsAPI.AgentSessionEvent>>;
    create(body: SessionCreateParamsBase, options?: RequestOptions): APIPromise<Stream<AgentsAPI.AgentSessionEvent> | AgentsAPI.AgentSession>;
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
    retrieve(sessionID: string, options?: RequestOptions): APIPromise<AgentsAPI.AgentSession>;
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
    update(sessionID: string, body?: SessionUpdateParams | null | undefined, options?: RequestOptions): APIPromise<AgentsAPI.AgentSession>;
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
    list(query?: SessionListParams | null | undefined, options?: RequestOptions): PagePromise<AgentSessionsPage, AgentsAPI.AgentSession>;
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
    delete(sessionID: string, options?: RequestOptions): APIPromise<AgentsAPI.AgentSessionDeleted>;
}
export type SessionCreateParams = SessionCreateParamsNonStreaming | SessionCreateParamsStreaming;
export interface SessionCreateParamsBase {
    /**
     * An inline execution environment or a reference to an environment template.
     */
    environment: AgentsAPI.EnvironmentParam;
    /**
     * Agent configuration. With `agent_id`, supplied fields override the saved agent
     * for this session. Without `agent_id`, `model` is required.
     */
    agent?: SessionCreateParams.Agent;
    /**
     * The ID of a saved reusable agent. Omit `agent` to use its configuration
     * unchanged.
     */
    agent_id?: string;
    /**
     * Initial input submitted when creating a session.
     */
    input?: string | Array<AgentsAPI.AgentSessionInputMessageParam> | null;
    /**
     * Up to 16 string key-value pairs, with keys up to 64 and values up to 512
     * characters. Omission or null defaults to an empty map.
     */
    metadata?: {
        [key: string]: string;
    } | null;
    /**
     * Whether to stream session events as server-sent events. Defaults to `false`.
     */
    stream?: boolean;
    /**
     * The IDs of vaults made available to the session.
     */
    vault_ids?: Array<string> | null;
}
export declare namespace SessionCreateParams {
    /**
     * Agent configuration. With `agent_id`, supplied fields override the saved agent
     * for this session. Without `agent_id`, `model` is required.
     */
    interface Agent {
        /**
         * Additional instructions appended to the agent's default base instructions. Omit
         * to leave unchanged.
         */
        instructions?: string | null;
        /**
         * The model to use for the agent. The requested model name is preserved.
         */
        model?: string;
        /**
         * Explicit configuration for creating and coordinating subagents.
         */
        multi_agent?: AgentsAPI.MultiAgentConfigParam | null;
        /**
         * Reasoning configuration for the agent.
         */
        reasoning?: AgentsAPI.AgentReasoningParam | null;
        /**
         * The service tier used for model requests.
         *
         * - `auto` - Selects the service tier automatically.
         * - `default` - Uses the default service tier.
         * - `flex` - Uses the flex service tier.
         * - `priority` - Uses the priority service tier.
         * - `fast` - Uses the fast service tier.
         */
        service_tier?: 'auto' | 'default' | 'flex' | 'priority' | 'fast' | null;
        /**
         * Configuration for text generated by the agent.
         */
        text?: AgentsAPI.AgentTextParam | null;
        /**
         * Tools available to the agent. Omit to inherit, or pass null to clear them.
         */
        tools?: Array<AgentsAPI.AgentToolParam> | null;
    }
    type SessionCreateParamsNonStreaming = SessionsAPI.SessionCreateParamsNonStreaming;
    type SessionCreateParamsStreaming = SessionsAPI.SessionCreateParamsStreaming;
}
export interface SessionCreateParamsNonStreaming extends SessionCreateParamsBase {
    /**
     * Whether to stream session events as server-sent events. Defaults to `false`.
     */
    stream?: false;
}
export interface SessionCreateParamsStreaming extends SessionCreateParamsBase {
    /**
     * Whether to stream session events as server-sent events. Defaults to `false`.
     */
    stream: true;
}
export interface SessionUpdateParams {
    /**
     * Model settings for subsequent turns. Omitted fields stay unchanged.
     */
    agent?: SessionUpdateParams.Agent;
    /**
     * Replaces all metadata. Omit to leave unchanged, or pass null or {} to clear it.
     * Up to 16 string key-value pairs, with keys up to 64 and values up to 512
     * characters.
     */
    metadata?: {
        [key: string]: string;
    } | null;
}
export declare namespace SessionUpdateParams {
    /**
     * Model settings for subsequent turns. Omitted fields stay unchanged.
     */
    interface Agent {
        /**
         * The model for subsequent turns. Omit to keep the current model.
         */
        model?: string;
        /**
         * Reasoning settings to update. Omit to keep the current effort.
         */
        reasoning?: Agent.Reasoning;
        /**
         * The service tier used for model requests.
         *
         * - `auto` - Selects the service tier automatically.
         * - `default` - Uses the default service tier.
         * - `flex` - Uses the flex service tier.
         * - `priority` - Uses the priority service tier.
         * - `fast` - Uses the fast service tier.
         */
        service_tier?: 'auto' | 'default' | 'flex' | 'priority' | 'fast' | null;
    }
    namespace Agent {
        /**
         * Reasoning settings to update. Omit to keep the current effort.
         */
        interface Reasoning {
            /**
             * The amount of reasoning effort the model should use.
             */
            effort?: 'none' | 'minimal' | 'low' | 'medium' | 'high' | 'xhigh' | 'max' | null;
        }
    }
}
export interface SessionListParams extends Omit<CursorPageParams, 'limit'> {
    /**
     * Only return sessions whose root agent has this ID. Omit to return sessions for
     * all agents.
     */
    agent_id?: string;
    /**
     * The maximum number of resources to return.
     */
    limit?: number | null;
    /**
     * Sort order by the `created_at` timestamp. Use `asc` for ascending order or
     * `desc` for descending order. Defaults to `desc`.
     *
     * - `asc` - Returns resources in ascending order.
     * - `desc` - Returns resources in descending order.
     */
    order?: 'asc' | 'desc';
}
export declare namespace Sessions {
    export { type SessionCreateParams as SessionCreateParams, type SessionCreateParamsNonStreaming as SessionCreateParamsNonStreaming, type SessionCreateParamsStreaming as SessionCreateParamsStreaming, type SessionUpdateParams as SessionUpdateParams, type SessionListParams as SessionListParams, };
    export { Subagents as Subagents, type SubagentRetrieveParams as SubagentRetrieveParams, type SubagentListParams as SubagentListParams, };
    export { Artifacts as Artifacts, type SessionArtifact as SessionArtifact, type SessionArtifactDeleted as SessionArtifactDeleted, type SessionArtifactsPage as SessionArtifactsPage, type ArtifactRetrieveParams as ArtifactRetrieveParams, type ArtifactListParams as ArtifactListParams, type ArtifactDeleteParams as ArtifactDeleteParams, type ArtifactContentParams as ArtifactContentParams, };
    export { Items as Items, type ItemListParams as ItemListParams };
    export { Events as Events, type EventCreateParams as EventCreateParams };
    export { Turns as Turns, type Turn as Turn, type TurnsPage as TurnsPage, type TurnRetrieveParams as TurnRetrieveParams, type TurnListParams as TurnListParams, };
}
export { type AgentSessionsPage };
//# sourceMappingURL=sessions.d.ts.map