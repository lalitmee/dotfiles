"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Files = void 0;
const resource_1 = require("../../../../core/resource.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Files extends resource_1.APIResource {
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
        return this._client.post((0, path_1.path) `/agents/environments/${environmentID}/files`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList((0, path_1.path) `/agents/environments/${environmentID}/files`, (pagination_1.TokenPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Files = Files;
//# sourceMappingURL=files.js.map