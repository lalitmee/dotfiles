import * as WS from 'ws';
import { NodeWebSocket } from "../../../internal/ws-adapter-node.js";
import { SidebandWSBase, type SidebandWSBaseOptions, type SidebandWSParameters } from "./ws-base.js";
import { OpenAI } from "../../../client.js";
export type { WebSocketStreamOptions } from "../../../internal/ws.js";
export type { SidebandWSParameters, SidebandWSReconnectOptions } from "./ws-base.js";
export interface SidebandWSClientOptions extends WS.ClientOptions, SidebandWSBaseOptions {
}
export declare class SidebandWS extends SidebandWSBase<NodeWebSocket> {
    private _wsOptions;
    constructor(client: OpenAI, parameters: SidebandWSParameters, options?: SidebandWSClientOptions | null | undefined);
    protected _createSocket(url: URL, authHeaders: Record<string, string>): NodeWebSocket;
}
//# sourceMappingURL=ws.d.ts.map