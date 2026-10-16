// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import * as WS from 'ws';
import { NodeWebSocket } from "../../internal/ws-adapter-node.mjs";
import { LiveWSBase } from "./ws-base.mjs";
export class LiveWS extends LiveWSBase {
    constructor(client, options) {
        if (!WS?.WebSocket) {
            throw new Error('LiveWS from "openai/resources/live/ws" requires the "ws" package but it could not be loaded.');
        }
        const { reconnect, maxQueueSize, ...wsOptions } = options ?? {};
        super(client, { reconnect, maxQueueSize });
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
        return new NodeWebSocket(ws);
    }
}
//# sourceMappingURL=ws.mjs.map