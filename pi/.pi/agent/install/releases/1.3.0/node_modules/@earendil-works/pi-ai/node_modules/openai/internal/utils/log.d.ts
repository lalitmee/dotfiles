import { type OpenAI } from "../../client.js";
import { RequestOptions } from "../request-options.js";
type LogFn = (message: string, ...rest: unknown[]) => void;
export type Logger = {
    error: LogFn;
    warn: LogFn;
    info: LogFn;
    debug: LogFn;
};
export type LogLevel = 'off' | 'error' | 'warn' | 'info' | 'debug';
export declare const parseLogLevel: (maybeLevel: string | undefined, sourceName: string, client: OpenAI) => LogLevel | undefined;
export declare function loggerFor(client: OpenAI): Logger;
/** Recognizes credential-bearing query names across ordinary and provider authentication. */
export declare function isSensitiveQueryParameter(name: string): boolean;
/** Recognizes credential-bearing request headers across provider and workload authentication. */
export declare function isSensitiveHeader(name: string): boolean;
/** Removes credential-valued query parameters before a request URL reaches any logger. */
export declare function redactURL(value: string): string;
export declare const formatRequestDetails: (details: {
    options?: RequestOptions | undefined;
    headers?: Headers | Record<string, string> | undefined;
    retryOfRequestLogID?: string | undefined;
    retryOf?: string | undefined;
    url?: string | undefined;
    status?: number | undefined;
    method?: string | undefined;
    durationMs?: number | undefined;
    message?: unknown;
    body?: unknown;
}) => {
    options?: RequestOptions | undefined;
    headers?: Headers | Record<string, string> | undefined;
    retryOfRequestLogID?: string | undefined;
    retryOf?: string | undefined;
    url?: string | undefined;
    status?: number | undefined;
    method?: string | undefined;
    durationMs?: number | undefined;
    message?: unknown;
    body?: unknown;
};
export {};
//# sourceMappingURL=log.d.ts.map