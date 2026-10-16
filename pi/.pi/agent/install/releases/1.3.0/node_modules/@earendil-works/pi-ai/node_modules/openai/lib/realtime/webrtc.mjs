import { WebRTCConnection } from "../webrtc/connection.mjs";
import { DataChannel } from "../webrtc/data-channel.mjs";
export { WebRTCError } from "../webrtc/errors.mjs";
/** Browser Realtime connection with application-owned SDP exchange and typed server-event subscriptions. */
export class OpenAIRealtimeWebRTC extends WebRTCConnection {
}
/** Typed Realtime events on a borrowed data channel; dispose() never closes application resources. */
export class RealtimeDataChannel extends DataChannel {
}
//# sourceMappingURL=webrtc.mjs.map