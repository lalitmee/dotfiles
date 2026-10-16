"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventTypes = void 0;
const resource_1 = require("../../core/resource.js");
class EventTypes extends resource_1.APIResource {
    /**
     * Returns webhook event types visible to the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEventTypeList =
     *   await client.webhooks.eventTypes.list();
     * ```
     */
    list(options) {
        return this._client.get('/webhook_event_types', { ...options, __security: { bearerAuth: true } });
    }
}
exports.EventTypes = EventTypes;
//# sourceMappingURL=event-types.js.map