import type { OpenAI } from "../client.js";
/** Selects a captured credential without treating an explicit null as absent. @internal */
export declare function getRealtimeAPIKey(client: Pick<OpenAI, 'apiKey'> | undefined, captured: string | null | undefined): string | null | undefined;
/**
 * Captures the key belonging to this request or factory invocation while retaining the
 * existing boolean credential-hook contract. Legacy overrides that do not
 * capture a key keep their shared-property behavior and remain responsible for
 * synchronizing concurrent credential updates.
 * @internal
 */
export declare function resolveRealtimeAPIKey(client: Pick<OpenAI, 'apiKey' | '_callApiKey'>): Promise<{
    apiKey: string | null;
    isProvider: boolean;
}>;
//# sourceMappingURL=realtime-credentials.d.ts.map