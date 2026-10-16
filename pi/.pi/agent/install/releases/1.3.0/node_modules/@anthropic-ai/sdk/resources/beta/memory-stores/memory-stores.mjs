import { APIResource } from "../../../core/resource.mjs";
import * as MemoriesAPI from "./memories.mjs";
import { Memories, } from "./memories.mjs";
import * as MemoryVersionsAPI from "./memory-versions.mjs";
import { MemoryVersions, } from "./memory-versions.mjs";
import { PageCursor } from "../../../core/pagination.mjs";
import { buildHeaders } from "../../../internal/headers.mjs";
import { path } from "../../../internal/utils/path.mjs";
export var MemoryStores = /* @__PURE__ */ (() => {
    class MemoryStores extends APIResource {
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
                headers: buildHeaders([
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
            return this._client.get(path `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                ...options,
                headers: buildHeaders([
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
            return this._client.post(path `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                body,
                ...options,
                headers: buildHeaders([
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
            return this._client.getAPIList('/v1/memory_stores?beta=true', (PageCursor), {
                query,
                ...options,
                headers: buildHeaders([
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
            return this._client.delete(path `/v1/memory_stores/${memoryStoreID}?beta=true`, {
                ...options,
                headers: buildHeaders([
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
            return this._client.post(path `/v1/memory_stores/${memoryStoreID}/archive?beta=true`, {
                ...options,
                headers: buildHeaders([
                    {
                        'anthropic-beta': [...(betas ?? []), 'agent-memory-2026-07-22'].toString(),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
    }
    MemoryStores.Memories = Memories;
    MemoryStores.MemoryVersions = MemoryVersions;
    return MemoryStores;
})();
//# sourceMappingURL=memory-stores.mjs.map