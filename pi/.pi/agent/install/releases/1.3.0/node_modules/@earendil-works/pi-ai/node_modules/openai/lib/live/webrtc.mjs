import { WebRTCConnection } from "../webrtc/connection.mjs";
import { DataChannel } from "../webrtc/data-channel.mjs";
export { WebRTCError } from "../webrtc/errors.mjs";
/** Browser Live connection with application-owned SDP exchange and typed server-event subscriptions. */
export class OpenAILiveWebRTC extends WebRTCConnection {
}
/** Typed Live events on a borrowed data channel; dispose() never closes application resources. */
export class LiveDataChannel extends DataChannel {
}
//# sourceMappingURL=webrtc.mjs.map