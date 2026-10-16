import * as WS from 'ws';
import { NodeWebSocket } from "../../internal/ws-adapter-node.mjs";
import { LiveWSBase, type LiveWSBaseOptions } from "./ws-base.mjs";
import { OpenAI } from "../../client.mjs";
export type { WebSocketStreamOptions } from "../../internal/ws.mjs";
export type { LiveWSReconnectOptions } from "./ws-base.mjs";
export interface LiveWSClientOptions extends WS.ClientOptions, LiveWSBaseOptions {
}
export declare class LiveWS extends LiveWSBase<NodeWebSocket> {
    private _wsOptions;
    constructor(client: OpenAI, options?: LiveWSClientOptions | null | undefined);
    protected _createSocket(url: URL, authHeaders: Record<string, string>): NodeWebSocket;
}
//# sourceMappingURL=ws.d.mts.map