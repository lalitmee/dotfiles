"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LiveDataChannel = exports.OpenAILiveWebRTC = exports.WebRTCError = void 0;
const connection_1 = require("../webrtc/connection.js");
const data_channel_1 = require("../webrtc/data-channel.js");
var errors_1 = require("../webrtc/errors.js");
Object.defineProperty(exports, "WebRTCError", { enumerable: true, get: function () { return errors_1.WebRTCError; } });
/** Browser Live connection with application-owned SDP exchange and typed server-event subscriptions. */
class OpenAILiveWebRTC extends connection_1.WebRTCConnection {
}
exports.OpenAILiveWebRTC = OpenAILiveWebRTC;
/** Typed Live events on a borrowed data channel; dispose() never closes application resources. */
class LiveDataChannel extends data_channel_1.DataChannel {
}
exports.LiveDataChannel = LiveDataChannel;
//# sourceMappingURL=webrtc.js.map