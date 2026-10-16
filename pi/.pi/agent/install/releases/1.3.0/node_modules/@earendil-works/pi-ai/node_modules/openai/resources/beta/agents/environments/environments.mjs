// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../../../core/resource.mjs";
import * as FilesAPI from "./files.mjs";
import { Files } from "./files.mjs";
import * as TemplatesAPI from "./templates.mjs";
import { Templates, } from "./templates.mjs";
import { buildHeaders } from "../../../../internal/headers.mjs";
import { path } from "../../../../internal/utils/path.mjs";
export class Environments extends APIResource {
    constructor() {
        super(...arguments);
        this.files = new FilesAPI.Files(this._client);
        this.templates = new TemplatesAPI.Templates(this._client);
    }
    /**
     * Retrieves an execution environment's connection status and safe installed
     * metadata. See
     * [environment lifecycle](https://developers.openai.com/api/docs/guides/agents-api/environments/lifecycle).
     *
     * @example
     * ```ts
     * const environmentInfo =
     *   await client.beta.agents.environments.retrieve(
     *     'environment_id',
     *   );
     * ```
     */
    retrieve(environmentID, options) {
        return this._client.get(path `/agents/environments/${environmentID}`, {
            ...options,
            headers: buildHeaders([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
Environments.Files = Files;
Environments.Templates = Templates;
//# sourceMappingURL=environments.mjs.map