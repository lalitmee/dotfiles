// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../core/resource.mjs";
import { buildHeaders } from "../../internal/headers.mjs";
import { path } from "../../internal/utils/path.mjs";
export class Sessions extends APIResource {
    /**
     * Accept an incoming SIP call. Supply session with type live, the model, and
     * startup configuration. Before accepting calls, follow the
     * [Live prompting guide](https://developers.openai.com/api/docs/guides/live-prompting)
     * to write frontend conversation instructions and a separate backend prompt. SIP
     * media format is negotiated; omit audio.format.
     *
     * @example
     * ```ts
     * await client.live.sessions.accept('session_id', {
     *   session: { model: 'gpt-live-1', type: 'live' },
     * });
     * ```
     */
    accept(sessionID, body, options) {
        return this._client.post(path `/live/sessions/${sessionID}/accept`, {
            body,
            ...options,
            headers: buildHeaders([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Get Live session content
     *
     * @example
     * ```ts
     * const response =
     *   await client.live.sessions.downloadRecording('live_SQ');
     *
     * const content = await response.blob();
     * console.log(content);
     * ```
     */
    downloadRecording(sessionID, options) {
        return this._client.get(path `/live/sessions/${sessionID}/content`, {
            ...options,
            headers: buildHeaders([{ Accept: 'application/binary' }, options?.headers]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        });
    }
    /**
     * Fork a stored Live session onto a new WebRTC connection.
     *
     * @example
     * ```ts
     * const response = await client.live.sessions.fork(
     *   'session_id',
     *   { transport: { sdp: 'x', type: 'webrtc' } },
     * );
     * ```
     */
    fork(sessionID, body, options) {
        return this._client.post(path `/live/sessions/${sessionID}/fork`, {
            body,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * End a SIP call identified by session_id.
     *
     * @example
     * ```ts
     * await client.live.sessions.hangup('session_id');
     * ```
     */
    hangup(sessionID, options) {
        return this._client.post(path `/live/sessions/${sessionID}/hangup`, {
            ...options,
            headers: buildHeaders([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Transfer a SIP call to another destination. Supply a nonblank target_uri for the
     * SIP Refer-To header.
     *
     * @example
     * ```ts
     * await client.live.sessions.refer('session_id', {
     *   target_uri: 'tel:+14155550123',
     * });
     * ```
     */
    refer(sessionID, body, options) {
        return this._client.post(path `/live/sessions/${sessionID}/refer`, {
            body,
            ...options,
            headers: buildHeaders([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
    /**
     * Reject an incoming SIP call. Send a required SIP rejection status_code between
     * 300 and 699.
     *
     * @example
     * ```ts
     * await client.live.sessions.reject('session_id', {
     *   status_code: 486,
     * });
     * ```
     */
    reject(sessionID, body, options) {
        return this._client.post(path `/live/sessions/${sessionID}/reject`, {
            body,
            ...options,
            headers: buildHeaders([{ Accept: '*/*' }, options?.headers]),
            __security: { bearerAuth: true },
        });
    }
}
//# sourceMappingURL=sessions.mjs.map