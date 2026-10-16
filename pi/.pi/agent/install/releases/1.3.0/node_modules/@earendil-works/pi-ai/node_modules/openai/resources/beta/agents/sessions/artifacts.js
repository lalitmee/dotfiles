"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Artifacts = void 0;
const resource_1 = require("../../../../core/resource.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Artifacts extends resource_1.APIResource {
    /**
     * Retrieves immutable metadata for one durable session artifact. See
     * [session artifacts](https://developers.openai.com/api/docs/guides/agents-api/environments/files#openai-hosted-artifacts).
     *
     * @example
     * ```ts
     * const sessionArtifact =
     *   await client.beta.agents.sessions.artifacts.retrieve(
     *     'artifact_id',
     *     { session_id: 'session_id' },
     *   );
     * ```
     */
    retrieve(artifactID, params, options) {
        const { session_id } = params;
        return this._client.get((0, path_1.path) `/agents/sessions/${session_id}/artifacts/${artifactID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists immutable artifacts published by completed hosted session turns. See
     * [session artifacts](https://developers.openai.com/api/docs/guides/agents-api/environments/files#openai-hosted-artifacts).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const sessionArtifact of client.beta.agents.sessions.artifacts.list(
     *   'session_id',
     * )) {
     *   // ...
     * }
     * ```
     */
    list(sessionID, query = {}, options) {
        return this._client.getAPIList((0, path_1.path) `/agents/sessions/${sessionID}/artifacts`, (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Deletes an immutable session artifact without deleting its live environment file
     * or original Files API object. See
     * [session artifacts](https://developers.openai.com/api/docs/guides/agents-api/environments/files#openai-hosted-artifacts).
     *
     * @example
     * ```ts
     * const sessionArtifactDeleted =
     *   await client.beta.agents.sessions.artifacts.delete(
     *     'artifact_id',
     *     { session_id: 'session_id' },
     *   );
     * ```
     */
    delete(artifactID, params, options) {
        const { session_id } = params;
        return this._client.delete((0, path_1.path) `/agents/sessions/${session_id}/artifacts/${artifactID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Downloads immutable session artifact bytes after the execution environment
     * expires. See
     * [session artifacts](https://developers.openai.com/api/docs/guides/agents-api/environments/files#openai-hosted-artifacts).
     *
     * @example
     * ```ts
     * const response =
     *   await client.beta.agents.sessions.artifacts.content(
     *     'artifact_id',
     *     { session_id: 'session_id' },
     *   );
     *
     * const content = await response.blob();
     * console.log(content);
     * ```
     */
    content(artifactID, params, options) {
        const { session_id } = params;
        return this._client.get((0, path_1.path) `/agents/sessions/${session_id}/artifacts/${artifactID}/content`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([
                { 'OpenAI-Beta': 'agents=v1', Accept: 'application/octet-stream' },
                options?.headers,
            ]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        });
    }
}
exports.Artifacts = Artifacts;
//# sourceMappingURL=artifacts.js.map