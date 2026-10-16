export interface OAuthCallback {
    code: string;
    state: string;
    iss?: string;
}
/** Outcome shown on the browser page after the redirect. */
export type OAuthCallbackPage = {
    ok: true;
} | {
    ok: false;
    message: string;
    details?: string;
};
export interface OAuthCallbackServerOptions {
    /** Address to listen on. Default: `127.0.0.1`. */
    host?: string;
    /**
     * Host name in `redirectUrl`, for example `localhost` for a client registered with it while
     * listening on `127.0.0.1`. Default: `host`.
     */
    redirectHost?: string;
    port?: number;
    path?: string;
    /** More paths that receive the callback, for example a server-specific path of a redirect URI. */
    extraPaths?: string[];
    timeoutMs?: number;
    /** Render the browser page as HTML. Default: a plain-text message. */
    renderPage?: (page: OAuthCallbackPage) => string;
}
export declare class OAuthCallbackServer {
    readonly redirectUrl: string;
    private server;
    private paths;
    private timeoutMs;
    private renderPage;
    private pending;
    private constructor();
    static listen(options?: OAuthCallbackServerOptions): Promise<OAuthCallbackServer>;
    /**
     * Wait for the authorization response with `state`. With `path`, a response on another path fails, so
     * a server-specific redirect URI can tell authorization servers apart (RFC 9700 section 4.4.2.2).
     */
    waitForCallback(state: string, path?: string): Promise<OAuthCallback>;
    close(): Promise<void>;
    private reply;
    private handle;
}
//# sourceMappingURL=callback.d.ts.map