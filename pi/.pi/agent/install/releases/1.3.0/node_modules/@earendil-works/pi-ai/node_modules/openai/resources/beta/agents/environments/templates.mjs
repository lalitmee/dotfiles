// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import { CursorPage } from "../../../../core/pagination.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Templates extends APIResource {
    /**
     * Creates reusable environment configuration without returning confidential setup
     * commands or environment values. See
     * [reusing a hosted setup](https://developers.openai.com/api/docs/guides/agents-api/tools#reuse-a-hosted-plugin-setup).
     *
     * @example
     * ```ts
     * const environmentTemplate =
     *   await client.beta.agents.environments.templates.create();
     * ```
     */
    create(body = {}, options) {
        return this._client.post('/agents/environments/templates', {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Retrieves reusable environment configuration without returning confidential
     * values. See
     * [reusing a hosted setup](https://developers.openai.com/api/docs/guides/agents-api/tools#reuse-a-hosted-plugin-setup).
     *
     * @example
     * ```ts
     * const environmentTemplate =
     *   await client.beta.agents.environments.templates.retrieve(
     *     'environment_template_id',
     *   );
     * ```
     */
    retrieve(environmentTemplateID, options) {
        return this._client.get(path `/agents/environments/templates/${environmentTemplateID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Updates reusable environment configuration without returning confidential
     * values. See
     * [reusing a hosted setup](https://developers.openai.com/api/docs/guides/agents-api/tools#reuse-a-hosted-plugin-setup).
     *
     * @example
     * ```ts
     * const environmentTemplate =
     *   await client.beta.agents.environments.templates.update(
     *     'environment_template_id',
     *   );
     * ```
     */
    update(environmentTemplateID, body = {}, options) {
        return this._client.post(path `/agents/environments/templates/${environmentTemplateID}`, {
            body,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Lists reusable environment templates without returning confidential values. See
     * [reusing a hosted setup](https://developers.openai.com/api/docs/guides/agents-api/tools#reuse-a-hosted-plugin-setup).
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const environmentTemplate of client.beta.agents.environments.templates.list()) {
     *   // ...
     * }
     * ```
     */
    list(query = {}, options) {
        return this._client.getAPIList('/agents/environments/templates', (CursorPage), {
            query,
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Deletes reusable environment configuration and all confidential template inputs.
     * See
     * [reusing a hosted setup](https://developers.openai.com/api/docs/guides/agents-api/tools#reuse-a-hosted-plugin-setup).
     *
     * @example
     * ```ts
     * const environmentTemplateDeleted =
     *   await client.beta.agents.environments.templates.delete(
     *     'environment_template_id',
     *   );
     * ```
     */
    delete(environmentTemplateID, options) {
        return this._client.delete(path `/agents/environments/templates/${environmentTemplateID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=templates.mjs.map