import { APIResource } from "../../core/resource.mjs";
import * as AlertsAPI from "./alerts.mjs";
import { Alerts, SafetyAlert } from "./alerts.mjs";
export declare class Safety extends APIResource {
    alerts: AlertsAPI.Alerts;
}
export declare namespace Safety {
    export { Alerts as Alerts, type SafetyAlert as SafetyAlert };
}
//# sourceMappingURL=safety.d.mts.map