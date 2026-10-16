// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../core/resource.mjs";
import { path } from "../../internal/utils/path.mjs";
export class Alerts extends APIResource {
    /**
     * Get a safety alert belonging to the authenticated API project.
     */
    retrieve(id, options) {
        return this._client.get(path `/safety/alerts/${id}`, { ...options, __security: { bearerAuth: true } });
    }
}
//# sourceMappingURL=alerts.mjs.map