import * as WS from 'ws';
import { NodeWebSocket } from "../../../internal/ws-adapter-node.mjs";
import { SidebandWSBase, type SidebandWSBaseOptions, type SidebandWSParameters } from "./ws-base.mjs";
import { OpenAI } from "../../../client.mjs";
export type { WebSocketStreamOptions } from "../../../internal/ws.mjs";
export type { SidebandWSParameters, SidebandWSReconnectOptions } from "./ws-base.mjs";
export interface SidebandWSClientOptions extends WS.ClientOptions, SidebandWSBaseOptions {
}
export declare class SidebandWS extends SidebandWSBase<NodeWebSocket> {
    private _wsOptions;
    constructor(client: OpenAI, parameters: SidebandWSParameters, options?: SidebandWSClientOptions | null | undefined);
    protected _createSocket(url: URL, authHeaders: Record<string, string>): NodeWebSocket;
}
//# sourceMappingURL=ws.d.mts.map