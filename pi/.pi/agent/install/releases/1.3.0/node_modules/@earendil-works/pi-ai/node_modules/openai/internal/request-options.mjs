const jsonRequestBodyObservers = new WeakMap();
/** Observes values produced by the actual JSON request serializer without changing them. */
export function observeJSONRequestBody(body, observer) {
    let observers = jsonRequestBodyObservers.get(body);
    if (!observers) {
        observers = new Set();
        jsonRequestBodyObservers.set(body, observers);
    }
    observers.add(observer);
    return () => {
        const active = jsonRequestBodyObservers.get(body);
        if (!active) {
            return;
        }
        active.delete(observer);
        if (active.size === 0) {
            jsonRequestBodyObservers.delete(body);
        }
    };
}
export const FallbackEncoder = ({ headers, body }) => {
    const observers = typeof body === 'object' && body !== null ? jsonRequestBodyObservers.get(body) : undefined;
    let encoded;
    if (!observers || observers.size === 0) {
        encoded = JSON.stringify(body);
    }
    else {
        const active = [...observers];
        encoded = JSON.stringify(body, function (key, value) {
            let observed = value;
            for (const observer of active) {
                const replacement = observer.value(this, key, observed);
                if (replacement !== undefined) {
                    observed = replacement;
                }
            }
            return observed;
        });
        for (const observer of active) {
            observer.complete();
        }
    }
    return {
        bodyHeaders: {
            'content-type': 'application/json',
        },
        body: encoded,
    };
};
//# sourceMappingURL=request-options.mjs.map