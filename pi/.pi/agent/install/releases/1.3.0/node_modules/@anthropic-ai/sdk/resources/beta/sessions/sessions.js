"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Sessions = void 0;
const tslib_1 = require("../../../internal/tslib.js");
const resource_1 = require("../../../core/resource.js");
const EventsAPI = tslib_1.__importStar(require("./events.js"));
const events_1 = require("./events.js");
const ResourcesAPI = tslib_1.__importStar(require("./resources.js"));
const resources_1 = require("./resources.js");
const ThreadsAPI = tslib_1.__importStar(require("./threads/threads.js"));
const threads_1 = require("./threads/threads.js");
const pagination_1 = require("../../../core/pagination.js");
const headers_1 = require("../../../internal/headers.js");
const path_1 = require("../../../internal/utils/path.js");
var Sessions = /* @__PURE__ */ (() => {
    class Sessions extends resource_1.APIResource {
        constructor() {
            super(...arguments);
            this.events = new EventsAPI.Events(this._client);
            this.resources = new ResourcesAPI.Resources(this._client);
            this.threads = new ThreadsAPI.Threads(this._client);
        }
        /**
         * Create Session
         *
         * @example
         * ```ts
         * const betaManagedAgentsSession =
         *   await client.beta.sessions.create({
         *     agent: 'agent_011CZkYpogX7uDKUyvBTophP',
         *     environment_id: 'env_011CZkZ9X2dpNyB7HsEFoRfW',
         *   });
         * ```
         */
        create(params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post('/v1/sessions?beta=true', {
                body,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Get Session
         *
         * @example
         * ```ts
         * const betaManagedAgentsSession =
         *   await client.beta.sessions.retrieve(
         *     'sesn_011CZkZAtmR3yMPDzynEDxu7',
         *   );
         * ```
         */
        retrieve(sessionID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.get((0, path_1.path) `/v1/sessions/${sessionID}?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Update Session
         *
         * @example
         * ```ts
         * const betaManagedAgentsSession =
         *   await client.beta.sessions.update(
         *     'sesn_011CZkZAtmR3yMPDzynEDxu7',
         *   );
         * ```
         */
        update(sessionID, params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post((0, path_1.path) `/v1/sessions/${sessionID}?beta=true`, {
                body,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * List Sessions
         *
         * @example
         * ```ts
         * // Automatically fetches more pages as needed.
         * for await (const betaManagedAgentsSession of client.beta.sessions.list()) {
         *   // ...
         * }
         * ```
         */
        list(params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.getAPIList('/v1/sessions?beta=true', (pagination_1.BidirectionalPageCursor), {
                query,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Delete Session
         *
         * @example
         * ```ts
         * const betaManagedAgentsDeletedSession =
         *   await client.beta.sessions.delete(
         *     'sesn_011CZkZAtmR3yMPDzynEDxu7',
         *   );
         * ```
         */
        delete(sessionID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.delete((0, path_1.path) `/v1/sessions/${sessionID}?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Archive Session
         *
         * @example
         * ```ts
         * const betaManagedAgentsSession =
         *   await client.beta.sessions.archive(
         *     'sesn_011CZkZAtmR3yMPDzynEDxu7',
         *   );
         * ```
         */
        archive(sessionID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.post((0, path_1.path) `/v1/sessions/${sessionID}/archive?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'managed-agents-2026-04-01'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
    }
    Sessions.Events = events_1.Events;
    Sessions.Resources = resources_1.Resources;
    Sessions.Threads = threads_1.Threads;
    return Sessions;
})();
exports.Sessions = Sessions;
//# sourceMappingURL=sessions.js.map