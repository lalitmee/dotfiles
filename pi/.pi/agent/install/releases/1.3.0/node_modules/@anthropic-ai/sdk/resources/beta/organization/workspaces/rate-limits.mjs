import { APIResource } from "../../../../core/resource.mjs";
import { PageCursor } from "../../../../core/pagination.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class RateLimits extends APIResource {
    /**
     * List a workspace's rate limits.
     *
     * By default, returns only the groups and limiter types that have a
     * workspace-level override. With `include_inherited=true`, returns every group
     * with organization-level limits the workspace can see, listing for each the
     * values it inherits from the organization as well as its own overrides. Each
     * value's `source` says which it is.
     *
     * When `limit` is omitted, every matching entry is returned in a single page; when
     * `limit` truncates the result, follow `next_page` to fetch the remaining entries.
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const betaWorkspaceRateLimit of client.beta.organization.workspaces.rateLimits.list(
     *   'workspace_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(workspaceID, query = {}, options) {
        return this._client.getAPIList(path `/v1/organizations/workspaces/${workspaceID}/rate_limits?beta=true`, (PageCursor), { query, ...options });
    }
}
//# sourceMappingURL=rate-limits.mjs.map