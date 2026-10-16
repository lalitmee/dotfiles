// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import { CursorPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Artifacts extends APIResource {
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
        return this._client.get(path `/agents/sessions/${session_id}/artifacts/${artifactID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList(path `/agents/sessions/${sessionID}/artifacts`, (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.delete(path `/agents/sessions/${session_id}/artifacts/${artifactID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.get(path `/agents/sessions/${session_id}/artifacts/${artifactID}/content`, {
            ...options,
            headers: buildHeaders([
                { 'OpenAI-Beta': 'agents=v1', Accept: 'application/octet-stream' },
                options?.headers,
            ]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        });
    }
}
//# sourceMappingURL=artifacts.mjs.map