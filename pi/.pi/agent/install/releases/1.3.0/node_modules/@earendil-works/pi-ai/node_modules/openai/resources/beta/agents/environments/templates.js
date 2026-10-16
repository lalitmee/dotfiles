"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Templates = void 0;
const resource_1 = require("../../../../core/resource.js");
const pagination_1 = require("../../../../core/pagination.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Templates extends resource_1.APIResource {
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
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.get((0, path_1.path) `/agents/environments/templates/${environmentTemplateID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.post((0, path_1.path) `/agents/environments/templates/${environmentTemplateID}`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.getAPIList('/agents/environments/templates', (pagination_1.CursorPage), {
            query,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
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
        return this._client.delete((0, path_1.path) `/agents/environments/templates/${environmentTemplateID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Templates = Templates;
//# sourceMappingURL=templates.js.map