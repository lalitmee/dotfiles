"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.ForksWS = void 0;
const tslib_1 = require("../../../internal/tslib.js");
const WS = tslib_1.__importStar(require("ws"));
const ws_adapter_node_1 = require("../../../internal/ws-adapter-node.js");
const ws_base_1 = require("./ws-base.js");
class ForksWS extends ws_base_1.ForksWSBase {
    constructor(client, parameters, options) {
        if (!WS?.WebSocket) {
            throw new Error('ForksWS from "openai/resources/live/forks/ws" requires the "ws" package but it could not be loaded.');
        }
        const { reconnect, maxQueueSize, ...wsOptions } = options ?? {};
        super(client, parameters, { reconnect, maxQueueSize });
        this._wsOptions = wsOptions;
        this._connectInitial();
    }
    _createSocket(url, authHeaders) {
        const ws = new WS.WebSocket(url, {
            ...this._wsOptions,
            headers: {
                ...this._client._buildWebSocketHeaders(authHeaders),
                ...Object.fromEntries(Object.entries(this._wsOptions?.headers ?? {}).map(([name, value]) => [name.toLowerCase(), value])),
            },
            followRedirects: false,
        });
        return new ws_adapter_node_1.NodeWebSocket(ws);
    }
}
exports.ForksWS = ForksWS;
//# sourceMappingURL=ws.js.map