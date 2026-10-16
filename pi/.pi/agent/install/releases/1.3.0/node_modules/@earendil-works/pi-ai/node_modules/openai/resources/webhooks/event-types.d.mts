import { APIResource } from "../../core/resource.mjs";
import * as WebhooksAPI from "./webhooks.mjs";
import { APIPromise } from "../../core/api-promise.mjs";
import { RequestOptions } from "../../internal/request-options.mjs";
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
//# sourceMappingURL=event-types.d.mts.map