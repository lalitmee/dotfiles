"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Calls = void 0;
const resource_1 = require("../../core/resource.js");
const headers_1 = require("../../internal/headers.js");
const path_1 = require("../../internal/utils/path.js");
const multipart_encoding_1 = require("../../internal/multipart-encoding.js");
class Calls extends resource_1.APIResource {
    /**
     * Create a new Realtime API call over WebRTC and receive the SDP answer needed to
     * complete the peer connection.
     *
     * @example
     * ```ts
     * await client.realtime.calls.create({
     *   sdp: 'sdp',
     * });
     * ```
     */
    create(body, options) {
        return this._client.post('/realtime/calls', (0, multipart_encoding_1.encodedMultipartFormRequestOptions)({
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ Accept: 'application/sdp' }, options?.headers]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        }, this._client, {
            sdp: { content_type: 'application/sdp', json: false },
            session: { content_type: 'application/json', json: true },
        }, 'sdp'));
    }
    /**
     * Accept an incoming SIP call and configure the realtime session that will handle
     * it.
     *
     * @example
     * ```ts
     * await client.realtime.calls.accept('call_id', {
     *   type: 'realtime',
     * });
     * ```
     */
    accept(callID, body, options) {
        return this._client.post((0, path_1.path) `/realtime/calls/${callID}/accept`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * End an active Realtime API call, whether it was initiated over SIP or WebRTC.
     *
     * @example
     * ```ts
     * await client.realtime.calls.hangup('call_id');
     * ```
     */
    hangup(callID, options) {
        return this._client.post((0, path_1.path) `/realtime/calls/${callID}/hangup`, {
            ...options,
            headers: (0, headers_1.buildHeaders)([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Transfer an active SIP call to a new destination using the SIP REFER verb.
     *
     * @example
     * ```ts
     * await client.realtime.calls.refer('call_id', {
     *   target_uri: 'tel:+14155550123',
     * });
     * ```
     */
    refer(callID, body, options) {
        return this._client.post((0, path_1.path) `/realtime/calls/${callID}/refer`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Decline an incoming SIP call by returning a SIP status code to the caller.
     *
     * @example
     * ```ts
     * await client.realtime.calls.reject('call_id');
     * ```
     */
    reject(callID, body = {}, options) {
        return this._client.post((0, path_1.path) `/realtime/calls/${callID}/reject`, {
            body,
            ...options,
            headers: (0, headers_1.buildHeaders)([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
exports.Calls = Calls;
//# sourceMappingURL=calls.js.map