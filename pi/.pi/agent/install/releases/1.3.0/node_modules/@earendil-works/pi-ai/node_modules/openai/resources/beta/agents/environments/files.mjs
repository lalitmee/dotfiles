// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import { TokenPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Files extends APIResource {
    /**
     * Copies inline bytes or a Files API file into a connected execution environment.
     * See
     * [environment files](https://developers.openai.com/api/docs/guides/agents-api/environments/files).
     *
     * @example
     * ```ts
     * const environmentFile =
     *   await client.beta.agents.environments.files.create(
     *     'environment_id',
     *     {
     *       type: 'inline',
     *       path: '/workspace/example.txt',
     *       data: 'SGVsbG8K',
     *     },
     *   );
     * ```
     */
    create(environmentID, body, options) {
        return this._client.post(path `/agents/environments/${environmentID}/files`, {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists live files on a connected execution environment with optional directory
     * filtering and opaque cursor pagination. See
     * [environment files](https://developers.openai.com/api/docs/guides/agents-api/environments/files).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const environmentFile of client.beta.agents.environments.files.list(
     *   'environment_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(environmentID, query = {}, options) {
        return this._client.getAPIList(path `/agents/environments/${environmentID}/files`, (TokenPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=files.mjs.map