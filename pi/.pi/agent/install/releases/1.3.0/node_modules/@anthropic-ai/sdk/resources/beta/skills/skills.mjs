import { APIResource } from "../../../core/resource.mjs";
import * as VersionsAPI from "./versions.mjs";
import { Versions, } from "./versions.mjs";
import { PageCursor } from "../../../core/pagination.mjs";
import { buildHeaders } from "../../../internal/headers.mjs";
import { multipartFormRequestOptions } from "../../../internal/uploads.mjs";
import { path } from "../../../internal/utils/path.mjs";
export var Skills = /* @__PURE__ */ (() => {
    class Skills extends APIResource {
        constructor() {
            super(...arguments);
            this.versions = new VersionsAPI.Versions(this._client);
        }
        /**
         * Create Skill
         *
         * @example
         * ```ts
         * const betaSkill = await client.beta.skills.create({
         *   files: [fs.createReadStream('path/to/file')],
         * });
         * ```
         */
        create(params, options) {
            const { betas, workspace_id, ...body } = params;
            return this._client.post('/v1/skills?beta=true', multipartFormRequestOptions({
                body,
                ...options,
                headers: buildHeaders([
                    {
                        ...(betas?.toString() != null ? { 'anthropic-beta': betas?.toString() } : undefined),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            }, this._client, false));
        }
        /**
         * Get Skill
         *
         * @example
         * ```ts
         * const betaSkill = await client.beta.skills.retrieve(
         *   'skill_id',
         * );
         * ```
         */
        retrieve(skillID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.get(path `/v1/skills/${skillID}?beta=true`, {
                ...options,
                headers: buildHeaders([
                    {
                        ...(betas?.toString() != null ? { 'anthropic-beta': betas?.toString() } : undefined),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * List Skills
         *
         * @example
         * ```ts
         * // Automatically fetches more pages as needed.
         * for await (const betaSkill of client.beta.skills.list()) {
         *   // ...
         * }
         * ```
         */
        list(params = {}, options) {
            const { betas, workspace_id, ...query } = params ?? {};
            return this._client.getAPIList('/v1/skills?beta=true', (PageCursor), {
                query,
                ...options,
                headers: buildHeaders([
                    {
                        ...(betas?.toString() != null ? { 'anthropic-beta': betas?.toString() } : undefined),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
        /**
         * Delete Skill
         *
         * @example
         * ```ts
         * const betaDeletedSkill = await client.beta.skills.delete(
         *   'skill_id',
         * );
         * ```
         */
        delete(skillID, params = {}, options) {
            const { betas, workspace_id } = params ?? {};
            return this._client.delete(path `/v1/skills/${skillID}?beta=true`, {
                ...options,
                headers: buildHeaders([
                    {
                        ...(betas?.toString() != null ? { 'anthropic-beta': betas?.toString() } : undefined),
                        ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                    },
                    options?.headers,
                ]),
            });
        }
    }
    Skills.Versions = Versions;
    return Skills;
})();
//# sourceMappingURL=skills.mjs.map