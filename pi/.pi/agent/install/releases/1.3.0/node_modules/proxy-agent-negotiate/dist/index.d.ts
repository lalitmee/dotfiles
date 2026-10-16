import type { OutgoingHttpHeaders, IncomingHttpHeaders } from 'http';
export interface ProxyAuthResponse {
    headers: OutgoingHttpHeaders;
}
export interface ProxyAuthParams {
    response: {
        statusCode: number;
        headers: IncomingHttpHeaders;
    };
    scheme: string;
}
export type OnProxyAuthCallback = (params: ProxyAuthParams) => Promise<ProxyAuthResponse>;
export declare function createNegotiateAuth(): OnProxyAuthCallback;
//# sourceMappingURL=index.d.ts.map