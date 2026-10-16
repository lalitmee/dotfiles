import { APIResource } from "../../core/resource.js";
import * as WebhooksAPI from "./webhooks.js";
import { APIPromise } from "../../core/api-promise.js";
import { RequestOptions } from "../../internal/request-options.js";
export declare class EventTypes extends APIResource {
    /**
     * Returns webhook event types visible to the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEventTypeList =
     *   await client.webhooks.eventTypes.list();
     * ```
     */
    list(options?: RequestOptions): APIPromise<WebhooksAPI.WebhookEventTypeList>;
}
//# sourceMappingURL=event-types.d.ts.map