"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResponsesWS = void 0;
const tslib_1 = require("../../internal/tslib.js");
const WS = tslib_1.__importStar(require("ws"));
const ws_adapter_node_1 = require("../../internal/ws-adapter-node.js");
const ws_base_1 = require("./ws-base.js");
const error_1 = require("../../core/error.js");
const ws_1 = require("../../internal/ws.js");
class ResponsesWS extends ws_base_1.ResponsesWSBase {
    constructor(client, options) {
        if (!WS?.WebSocket) {
            throw new Error('ResponsesWS from "openai/resources/responses/ws" requires the "ws" package but it could not be loaded.');
        }
        const { reconnect, maxQueueSize, ...wsOptions } = options ?? {};
        super(client, { reconnect, maxQueueSize });
        this._wsOptions = wsOptions;
        this._connectInitial();
    }
    _createSocket(url, authHeaders) {
        const capturedAuthHeaders = { ...authHeaders };
        const headers = new Map(Object.entries(this._client._buildWebSocketHeaders(capturedAuthHeaders)));
        for (const [name, value] of Object.entries(this._wsOptions?.headers ?? {})) {
            if (value === null) {
                headers.delete(name.toLowerCase());
            }
            else if (value !== undefined) {
                headers.set(name.toLowerCase(), value);
            }
        }
        const socketOptions = {
            ...this._wsOptions,
            headers: Object.fromEntries(headers),
            followRedirects: false,
        };
        if (this._client._hasApiKeyProvider() &&
            !capturedAuthHeaders['Authorization'] &&
            !(0, ws_1.snapshotWebSocketCredentials)(socketOptions)) {
            throw new error_1.OpenAIError('Cannot open a Responses WebSocket with an unresolved function-based apiKey. Resolve it before constructing the WebSocket or provide explicit WebSocket credentials.');
        }
        const ws = new WS.WebSocket(url, socketOptions);
        return new ws_adapter_node_1.NodeWebSocket(ws);
    }
}
exports.ResponsesWS = ResponsesWS;
//# sourceMappingURL=ws.js.map