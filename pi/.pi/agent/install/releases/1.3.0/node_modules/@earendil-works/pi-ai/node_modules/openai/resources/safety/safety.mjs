// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../core/resource.mjs";
import * as AlertsAPI from "./alerts.mjs";
import { Alerts } from "./alerts.mjs";
export class Safety extends APIResource {
    constructor() {
        super(...arguments);
        this.alerts = new AlertsAPI.Alerts(this._client);
    }
}
Safety.Alerts = Alerts;
//# sourceMappingURL=safety.mjs.map