// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../../core/resource.mjs";
import * as SessionsAPI from "./sessions.mjs";
import { Sessions, } from "./sessions.mjs";
import * as ForksAPI from "./forks/forks.mjs";
import { Forks } from "./forks/forks.mjs";
import * as SidebandAPI from "./sideband/sideband.mjs";
import { Sideband } from "./sideband/sideband.mjs";
export class Live extends APIResource {
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
Live.Sideband = Sideband;
Live.Forks = Forks;
Live.Sessions = Sessions;
//# sourceMappingURL=live.mjs.map