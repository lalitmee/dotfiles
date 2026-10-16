"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Environments = void 0;
const tslib_1 = require("../../../../internal/tslib.js");
const resource_1 = require("../../../../core/resource.js");
const FilesAPI = tslib_1.__importStar(require("./files.js"));
const files_1 = require("./files.js");
const TemplatesAPI = tslib_1.__importStar(require("./templates.js"));
const templates_1 = require("./templates.js");
const headers_1 = require("../../../../internal/headers.js");
const path_1 = require("../../../../internal/utils/path.js");
class Environments extends resource_1.APIResource {
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
        return this._client.get((0, path_1.path) `/agents/environments/${environmentID}`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ 'OpenAI-Beta': 'agents=v1' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Environments = Environments;
Environments.Files = files_1.Files;
Environments.Templates = templates_1.Templates;
//# sourceMappingURL=environments.js.map