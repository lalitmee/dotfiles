import { APIResource } from "../../core/resource.js";
import * as AlertsAPI from "./alerts.js";
import { Alerts, SafetyAlert } from "./alerts.js";
export declare class Safety extends APIResource {
    alerts: AlertsAPI.Alerts;
}
export declare namespace Safety {
    export { Alerts as Alerts, type SafetyAlert as SafetyAlert };
}
//# sourceMappingURL=safety.d.ts.map