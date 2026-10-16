export type JsonRpcId = string | number;
export interface JsonRpcRequest {
    jsonrpc: "2.0";
    id: JsonRpcId;
    method: string;
    params?: unknown;
}
export interface JsonRpcNotification {
    jsonrpc: "2.0";
    method: string;
    params?: unknown;
}
export interface JsonRpcErrorObject {
    code: number;
    message: string;
    data?: unknown;
}
export interface JsonRpcSuccessResponse {
    jsonrpc: "2.0";
    id: JsonRpcId;
    result: unknown;
}
export interface JsonRpcErrorResponse {
    jsonrpc: "2.0";
    id: JsonRpcId;
    error: JsonRpcErrorObject;
}
export type JsonRpcResponse = JsonRpcSuccessResponse | JsonRpcErrorResponse;
export type JsonRpcMessage = JsonRpcRequest | JsonRpcNotification | JsonRpcResponse;
export declare const JSON_RPC_ERROR_CODES: {
    readonly parseError: -32700;
    readonly invalidRequest: -32600;
    readonly methodNotFound: -32601;
    readonly invalidParams: -32602;
    readonly internalError: -32603;
};
export declare class McpError extends Error {
    readonly code: number;
    readonly data: unknown;
    constructor(code: number, message: string, data?: unknown);
}
export declare class McpConnectionClosedError extends Error {
    constructor(message?: string);
}
export declare class McpTimeoutError extends Error {
    readonly timeoutMs: number;
    constructor(timeoutMs: number);
}
export declare class McpAbortError extends Error {
    constructor(message?: string);
}
export declare function isObject(value: unknown): value is Record<string, unknown>;
export declare function toError(value: unknown): Error;
export declare function isJsonRpcId(value: unknown): value is JsonRpcId;
export declare function isJsonRpcRequest(message: unknown): message is JsonRpcRequest;
export declare function isJsonRpcNotification(message: unknown): message is JsonRpcNotification;
export declare function isJsonRpcResponse(message: unknown): message is JsonRpcResponse;
export declare function parseJsonRpcMessage(value: unknown): JsonRpcMessage;
//# sourceMappingURL=jsonrpc.d.ts.map