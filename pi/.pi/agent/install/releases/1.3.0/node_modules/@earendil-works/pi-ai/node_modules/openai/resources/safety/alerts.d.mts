import { APIResource } from "../../core/resource.mjs";
import { APIPromise } from "../../core/api-promise.mjs";
import { RequestOptions } from "../../internal/request-options.mjs";
export declare class Alerts extends APIResource {
    /**
     * Get a safety alert belonging to the authenticated API project.
     */
    retrieve(id: string, options?: RequestOptions): APIPromise<SafetyAlert>;
}
export interface SafetyAlert {
    id: string;
    created_at: number;
    error_type: 'potentially_unintended_data_transfer' | 'potentially_unintended_data_access' | 'potentially_unintended_destructive_activity' | 'other';
    model: string;
    object: 'safety.alert';
    /**
     * A customer-safe description derived from error_type, or null for zero data
     * retention requests.
     */
    reason: string | null;
    request_id: string;
    /**
     * Whether block registration succeeded for this request. This does not confirm
     * that response execution stopped.
     */
    request_paused: boolean;
    response_id: string;
}
export declare namespace Alerts {
    export { type SafetyAlert as SafetyAlert };
}
//# sourceMappingURL=alerts.d.mts.map