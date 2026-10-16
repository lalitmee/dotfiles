"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReadyState = void 0;
/** Standard WebSocket readyState values (RFC 6455). */
exports.ReadyState = {
    /** The connection has been created but is not ready to send messages. */
    CONNECTING: 0,
    /** The connection is established and ready to send messages. */
    OPEN: 1,
    /** The closing handshake has started but is not complete. */
    CLOSING: 2,
    /** The connection is closed or could not be established. */
    CLOSED: 3,
};
//# sourceMappingURL=ws-adapter.js.map