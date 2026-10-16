"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Vaults = void 0;
const tslib_1 = require("../../../internal/tslib.js");
const resource_1 = require("../../../core/resource.js");
const CredentialsAPI = tslib_1.__importStar(require("./credentials.js"));
const credentials_1 = require("./credentials.js");
const pagination_1 = require("../../../core/pagination.js");
const headers_1 = require("../../../internal/headers.js");
const path_1 = require("../../../internal/utils/path.js");
var Vaults = /* @__PURE__ */ (() => {
    class Vaults extends resource_1.APIResource {
        constructor() {
            super(...arguments);
            this.credentials = new CredentialsAPI.Credentials(this._client);
        }
        /**
         * Create Vault
         *
         * @example
         * ```ts
         * const betaManagedAgentsVault =
         *   await client.beta.vaults.create({
         *     display_name: 'Example vault',
         *   });
         * ```
         */
        create(params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post('/v1/vaults?beta=true', {
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
         * Get Vault
         *
         * @example
         * ```ts
         * const betaManagedAgentsVault =
         *   await client.beta.vaults.retrieve(
         *     'vlt_011CZkZDLs7fYzm1hXNPeRjv',
         *   );
         * ```
         */
        retrieve(vaultID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.get((0, path_1.path) `/v1/vaults/${vaultID}?beta=true`, {
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
         * Update Vault
         *
         * @example
         * ```ts
         * const betaManagedAgentsVault =
         *   await client.beta.vaults.update(
         *     'vlt_011CZkZDLs7fYzm1hXNPeRjv',
         *   );
         * ```
         */
        update(vaultID, params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post((0, path_1.path) `/v1/vaults/${vaultID}?beta=true`, {
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
         * List Vaults
         *
         * @example
         * ```ts
         * // Automatically fetches more pages as needed.
         * for await (const betaManagedAgentsVault of client.beta.vaults.list()) {
         *   // ...
         * }
         * ```
         */
        list(params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.getAPIList('/v1/vaults?beta=true', (pagination_1.PageCursor), {
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
         * Delete Vault
         *
         * @example
         * ```ts
         * const betaManagedAgentsDeletedVault =
         *   await client.beta.vaults.delete(
         *     'vlt_011CZkZDLs7fYzm1hXNPeRjv',
         *   );
         * ```
         */
        delete(vaultID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.delete((0, path_1.path) `/v1/vaults/${vaultID}?beta=true`, {
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
         * Archive Vault
         *
         * @example
         * ```ts
         * const betaManagedAgentsVault =
         *   await client.beta.vaults.archive(
         *     'vlt_011CZkZDLs7fYzm1hXNPeRjv',
         *   );
         * ```
         */
        archive(vaultID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.post((0, path_1.path) `/v1/vaults/${vaultID}/archive?beta=true`, {
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
    Vaults.Credentials = credentials_1.Credentials;
    return Vaults;
})();
exports.Vaults = Vaults;
//# sourceMappingURL=vaults.js.map