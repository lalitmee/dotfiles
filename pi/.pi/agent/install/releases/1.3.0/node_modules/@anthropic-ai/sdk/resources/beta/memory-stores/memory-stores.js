"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MemoryStores = void 0;
const tslib_1 = require("../../../internal/tslib.js");
const resource_1 = require("../../../core/resource.js");
const MemoriesAPI = tslib_1.__importStar(require("./memories.js"));
const memories_1 = require("./memories.js");
const MemoryVersionsAPI = tslib_1.__importStar(require("./memory-versions.js"));
const memory_versions_1 = require("./memory-versions.js");
const pagination_1 = require("../../../core/pagination.js");
const headers_1 = require("../../../internal/headers.js");
const path_1 = require("../../../internal/utils/path.js");
var MemoryStores = /* @__PURE__ */ (() => {
    class MemoryStores extends resource_1.APIResource {
        constructor() {
            super(...arguments);
            this.memories = new MemoriesAPI.Memories(this._client);
            this.memoryVersions = new MemoryVersionsAPI.MemoryVersions(this._client);
        }
        /**
         * Create a memory store
         *
         * @example
         * ```ts
         * const betaManagedAgentsMemoryStore =
         *   await client.beta.memoryStores.create({ name: 'x' });
         * ```
         */
        create(params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post('/v1/memory_stores?beta=true', {
                body,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Retrieve a memory store
         *
         * @example
         * ```ts
         * const betaManagedAgentsMemoryStore =
         *   await client.beta.memoryStores.retrieve(
         *     'memory_store_id',
         *   );
         * ```
         */
        retrieve(memoryStoreID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.get((0, path_1.path) `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Update a memory store
         *
         * @example
         * ```ts
         * const betaManagedAgentsMemoryStore =
         *   await client.beta.memoryStores.update('memory_store_id');
         * ```
         */
        update(memoryStoreID, params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post((0, path_1.path) `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                body,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * List memory stores
         *
         * @example
         * ```ts
         * // Automatically fetches more pages as needed.
         * for await (const betaManagedAgentsMemoryStore of client.beta.memoryStores.list()) {
         *   // ...
         * }
         * ```
         */
        list(params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.getAPIList('/v1/memory_stores?beta=true', (pagination_1.PageCursor), {
                query,
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Delete a memory store
         *
         * @example
         * ```ts
         * const betaManagedAgentsDeletedMemoryStore =
         *   await client.beta.memoryStores.delete('memory_store_id');
         * ```
         */
        delete(memoryStoreID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.delete((0, path_1.path) `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Archive a memory store
         *
         * @example
         * ```ts
         * const betaManagedAgentsMemoryStore =
         *   await client.beta.memoryStores.archive('memory_store_id');
         * ```
         */
        archive(memoryStoreID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.post((0, path_1.path) `/v1/memory_stores/${memoryStoreID}/archive?beta=true`, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
    }
    MemoryStores.Memories = memories_1.Memories;
    MemoryStores.MemoryVersions = memory_versions_1.MemoryVersions;
    return MemoryStores;
})();
exports.MemoryStores = MemoryStores;
//# sourceMappingURL=memory-stores.js.map