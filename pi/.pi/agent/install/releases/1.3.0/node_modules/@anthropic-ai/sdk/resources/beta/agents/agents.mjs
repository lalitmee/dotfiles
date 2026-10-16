import { APIResource } from "../../../core/resource.mjs";
import * as VersionsAPI from "./versions.mjs";
import { Versions } from "./versions.mjs";
import { PageCursor } from "../../../core/pagination.mjs";
import { buildHeaders } from "../../../internal/headers.mjs";
import { path } from "../../../internal/utils/path.mjs";
export var Agents = /* @__PURE__ */ (() => {
    class Agents extends APIResource {
        constructor() {
            super(...arguments);
            this.versions = new VersionsAPI.Versions(this._client);
        }
        /**
         * Create Agent
         *
         * @example
         * ```ts
         * const betaManagedAgentsAgent =
         *   await client.beta.agents.create({
         *     model: 'claude-opus-5',
         *     name: 'My First Agent',
         *   });
         * ```
         */
        create(params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post('/v1/agents?beta=true', {
                body,
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Get Agent
         *
         * @example
         * ```ts
         * const betaManagedAgentsAgent =
         *   await client.beta.agents.retrieve(
         *     'agent_011CZkYpogX7uDKUyvBTophP',
         *   );
         * ```
         */
        retrieve(agentID, params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.get(path `/v1/agents/${agentID}?beta=true`, {
                query,
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Update Agent
         *
         * @example
         * ```ts
         * const betaManagedAgentsAgent =
         *   await client.beta.agents.update(
         *     'agent_011CZkYpogX7uDKUyvBTophP',
         *     { description: 'updated' },
         *   );
         * ```
         */
        update(agentID, params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post(path `/v1/agents/${agentID}?beta=true`, {
                body,
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * List Agents
         *
         * @example
         * ```ts
         * // Automatically fetches more pages as needed.
         * for await (const betaManagedAgentsAgent of client.beta.agents.list()) {
         *   // ...
         * }
         * ```
         */
        list(params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.getAPIList('/v1/agents?beta=true', (PageCursor), {
                query,
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Archive Agent
         *
         * @example
         * ```ts
         * const betaManagedAgentsAgent =
         *   await client.beta.agents.archive(
         *     'agent_011CZkYpogX7uDKUyvBTophP',
         *   );
         * ```
         */
        archive(agentID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.post(path `/v1/agents/${agentID}/archive?beta=true`, {
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
    }
    Agents.Versions = Versions;
    return Agents;
})();
//# sourceMappingURL=agents.mjs.map