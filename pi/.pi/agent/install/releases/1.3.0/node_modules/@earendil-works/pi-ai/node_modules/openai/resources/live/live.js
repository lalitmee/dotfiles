"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Live = void 0;
const tslib_1 = require("../../internal/tslib.js");
const resource_1 = require("../../core/resource.js");
const SessionsAPI = tslib_1.__importStar(require("./sessions.js"));
const sessions_1 = require("./sessions.js");
const ForksAPI = tslib_1.__importStar(require("./forks/forks.js"));
const forks_1 = require("./forks/forks.js");
const SidebandAPI = tslib_1.__importStar(require("./sideband/sideband.js"));
const sideband_1 = require("./sideband/sideband.js");
class Live extends resource_1.APIResource {
    constructor() {
        super(...arguments);
        this.sideband = new SidebandAPI.Sideband(this._client);
        this.forks = new ForksAPI.Forks(this._client);
        this.sessions = new SessionsAPI.Sessions(this._client);
    }
    /**
     * Create a Live WebRTC session. Start with the
     * [Live prompting guide](https://developers.openai.com/api/docs/guides/live-prompting).
     *
     * @example
     * ```ts
     * const live = await client.live.create({
     *   session: { model: 'gpt-live-1' },
     *   transport: { sdp: 'x', type: 'webrtc' },
     * });
     * ```
     */
    create(body, options) {
        return this._client.post('/live/sessions', { body, ...options, __security: { bearerAuth: true } });
    }
}
exports.Live = Live;
Live.Sideband = sideband_1.Sideband;
Live.Forks = forks_1.Forks;
Live.Sessions = sessions_1.Sessions;
//# sourceMappingURL=live.js.map