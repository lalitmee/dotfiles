"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
var _Webhooks_instances, _Webhooks_validateSecret, _Webhooks_getRequiredHeader;
Object.defineProperty(exports, "__esModule", { value: true });
exports.Webhooks = void 0;
const tslib_1 = require("../../internal/tslib.js");
const resource_1 = require("../../core/resource.js");
const headers_1 = require("../../internal/headers.js");
const webhook_signature_1 = require("../../lib/webhook-signature.js");
const EventTypesAPI = tslib_1.__importStar(require("./event-types.js"));
const event_types_1 = require("./event-types.js");
const pagination_1 = require("../../core/pagination.js");
const path_1 = require("../../internal/utils/path.js");
class Webhooks extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        _Webhooks_instances.add(this);
        this.eventTypes = new EventTypesAPI.EventTypes(this._client);
    }
    /**
     * Creates a webhook endpoint for the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEndpointWithSecret =
     *   await client.webhooks.create({
     *     event_types: ['batch.completed'],
     *     name: 'x',
     *     url: 'https://',
     *   });
     * ```
     */
    create(body, options) {
        return this._client.post('/webhook_endpoints', { body, ...options, __security: { bearerAuth: true } });
    }
    /**
     * Retrieves a webhook endpoint for the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEndpoint = await client.webhooks.retrieve(
     *   'whe_123',
     * );
     * ```
     */
    retrieve(webhookEndpointID, options) {
        return this._client.get((0, path_1.path) `/webhook_endpoints/${webhookEndpointID}`, {
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Updates a webhook endpoint for the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEndpoint = await client.webhooks.update('whe_123');
     * ```
     */
    update(webhookEndpointID, body = {}, options) {
        return this._client.post((0, path_1.path) `/webhook_endpoints/${webhookEndpointID}`, {
            body,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Returns webhook endpoints for the authenticated project in newest-first order.
     *
     * @example
     * ```ts
     * // Automatically fetches more pages as needed.
     * for await (const webhookEndpoint of client.webhooks.list()) {
     *   // ...
     * }
     * ```
     */
    list(query = {}, options) {
        return this._client.getAPIList('/webhook_endpoints', (pagination_1.CursorPage), {
            query,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Deletes a webhook endpoint for the authenticated project.
     *
     * @example
     * ```ts
     * const deletedWebhookEndpoint = await client.webhooks.delete(
     *   'whe_123',
     * );
     * ```
     */
    delete(webhookEndpointID, options) {
        return this._client.delete((0, path_1.path) `/webhook_endpoints/${webhookEndpointID}`, {
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Rotates the signing secret for a webhook endpoint in the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEndpointWithSecret =
     *   await client.webhooks.rotateSecret('whe_123');
     * ```
     */
    rotateSecret(webhookEndpointID, body = {}, options) {
        return this._client.post((0, path_1.path) `/webhook_endpoints/${webhookEndpointID}/rotate_secret`, {
            body,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Sends a sample event to a webhook endpoint for the authenticated project.
     *
     * @example
     * ```ts
     * const webhookEndpointTestResult =
     *   await client.webhooks.test('whe_123', {
     *     event_type: 'batch.completed',
     *   });
     * ```
     */
    test(webhookEndpointID, body, options) {
        return this._client.post((0, path_1.path) `/webhook_endpoints/${webhookEndpointID}/test`, {
            body,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Validates that the given payload was sent by OpenAI and parses the payload.
     */
    async unwrap(payload, headers, secret = this._client.webhookSecret, tolerance = 300) {
        await this.verifySignature(payload, headers, secret, tolerance);
        return JSON.parse(payload);
    }
    /**
     * Validates whether or not the webhook payload was sent by OpenAI.
     *
     * An error will be raised if the webhook payload was not sent by OpenAI.
     *
     * @param payload - The webhook payload
     * @param headers - The webhook headers
     * @param secret - The webhook secret (optional, will use client secret if not provided)
     * @param tolerance - Maximum age of the webhook in seconds (default: 300 = 5 minutes)
     */
    async verifySignature(payload, headers, secret = this._client.webhookSecret, tolerance = 300) {
        if (typeof crypto === 'undefined' ||
            typeof crypto.subtle?.importKey !== 'function' ||
            typeof crypto.subtle.verify !== 'function') {
            throw new Error('Webhook signature verification is only supported when the `crypto` global is defined');
        }
        tslib_1.__classPrivateFieldGet(this, _Webhooks_instances, "m", _Webhooks_validateSecret).call(this, secret);
        const headersObj = (0, headers_1.buildHeaders)([headers]).values;
        const signatureHeader = tslib_1.__classPrivateFieldGet(this, _Webhooks_instances, "m", _Webhooks_getRequiredHeader).call(this, headersObj, 'webhook-signature');
        const timestamp = tslib_1.__classPrivateFieldGet(this, _Webhooks_instances, "m", _Webhooks_getRequiredHeader).call(this, headersObj, 'webhook-timestamp');
        const webhookId = tslib_1.__classPrivateFieldGet(this, _Webhooks_instances, "m", _Webhooks_getRequiredHeader).call(this, headersObj, 'webhook-id');
        if ((0, webhook_signature_1.webhookSignatureRequiresSigning)(signatureHeader) && typeof crypto.subtle.sign !== 'function') {
            throw new Error('Webhook signature verification is only supported when the `crypto` global is defined');
        }
        return await (0, webhook_signature_1.verifyWebhookSignature)(payload, signatureHeader, timestamp, webhookId, secret, tolerance);
    }
}
exports.Webhooks = Webhooks;
_Webhooks_instances = new WeakSet(), _Webhooks_validateSecret = function _Webhooks_validateSecret(secret) {
    if (typeof secret !== 'string' || secret.length === 0) {
        throw new Error(`The webhook secret must either be set using the env var, OPENAI_WEBHOOK_SECRET, on the client class, OpenAI({ webhookSecret: '123' }), or passed to this function`);
    }
}, _Webhooks_getRequiredHeader = function _Webhooks_getRequiredHeader(headers, name) {
    if (!headers) {
        throw new Error(`Headers are required`);
    }
    const value = headers.get(name);
    if (value === null || value === undefined) {
        throw new Error(`Missing required header: ${name}`);
    }
    return value;
};
Webhooks.EventTypes = event_types_1.EventTypes;
//# sourceMappingURL=webhooks.js.map