/** Selects a captured credential without treating an explicit null as absent. @internal */
export function getRealtimeAPIKey(client, captured) {
    return captured === undefined ? client?.apiKey : captured;
}
/**
 * Captures the key belonging to this request or factory invocation while retaining the
 * existing boolean credential-hook contract. Legacy overrides that do not
 * capture a key keep their shared-property behavior and remain responsible for
 * synchronizing concurrent credential updates.
 * @internal
 */
export async function resolveRealtimeAPIKey(client) {
    let apiKey;
    const isProvider = await client._callApiKey((resolved) => {
        apiKey = resolved;
    });
    return { apiKey: apiKey === undefined ? client.apiKey : apiKey, isProvider };
}
//# sourceMappingURL=realtime-credentials.mjs.map