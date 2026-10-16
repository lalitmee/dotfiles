import * as WS from 'ws';
import { NodeWebSocket } from "../../../internal/ws-adapter-node.js";
import { ForksWSBase, type ForksWSBaseOptions, type ForksWSParameters } from "./ws-base.js";
import { OpenAI } from "../../../client.js";
export type { WebSocketStreamOptions } from "../../../internal/ws.js";
export type { ForksWSParameters, ForksWSReconnectOptions } from "./ws-base.js";
export interface ForksWSClientOptions extends WS.ClientOptions, ForksWSBaseOptions {
}
export declare class ForksWS extends ForksWSBase<NodeWebSocket> {
    private _wsOptions;
    constructor(client: OpenAI, parameters: ForksWSParameters, options?: ForksWSClientOptions | null | undefined);
    protected _createSocket(url: URL, authHeaders: Record<string, string>): NodeWebSocket;
}
//# sourceMappingURL=ws.d.ts.map