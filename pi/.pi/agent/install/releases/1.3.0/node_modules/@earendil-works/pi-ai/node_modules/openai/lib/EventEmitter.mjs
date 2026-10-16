var _EventEmitter_instances, _EventEmitter_listeners, _EventEmitter_emittedListenerRegistrations, _EventEmitter_pendingListenerCleanup, _EventEmitter_listenerDispatchDepth, _EventEmitter_onceForEmitted, _EventEmitter_removeEmittedListener, _EventEmitter_cleanupEmittedListeners;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../internal/tslib.mjs";
/** A lightweight event emitter with type-safe listeners and promise-based event waiting. */
export class EventEmitter {
    constructor() {
        _EventEmitter_instances.add(this);
        _EventEmitter_listeners.set(this, Object.create(null));
        _EventEmitter_emittedListenerRegistrations.set(this, new WeakMap());
        _EventEmitter_pendingListenerCleanup.set(this, new Set());
        _EventEmitter_listenerDispatchDepth.set(this, 0);
    }
    /**
     * Adds the listener function to the end of the listeners array for the event.
     * No checks are made to see if the listener has already been added. Multiple calls passing
     * the same combination of event and listener will result in the listener being added, and
     * called, multiple times.
     * @returns this, so that calls can be chained
     */
    on(event, listener) {
        var _a;
        const listeners = ((_a = __classPrivateFieldGet(this, _EventEmitter_listeners, "f"))[event] || (_a[event] = []));
        listeners.push({ listener });
        return this;
    }
    /**
     * Removes the specified listener from the listener array for the event.
     * off() will remove, at most, one instance of a listener from the listener array. If any single
     * listener has been added multiple times to the listener array for the specified event, then
     * off() must be called multiple times to remove each instance.
     * @returns this, so that calls can be chained
     */
    off(event, listener) {
        const listeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event];
        if (!listeners) {
            return this;
        }
        // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
        const emittedRegistration = __classPrivateFieldGet(this, _EventEmitter_emittedListenerRegistrations, "f").get(listener);
        if (emittedRegistration?.event === event &&
            !emittedRegistration.registration.removed &&
            !emittedRegistration.registration.detached) {
            // SAFETY: The stored registration event was compared with this event above, preserving the event/listener type correlation.
            __classPrivateFieldGet(this, _EventEmitter_instances, "m", _EventEmitter_removeEmittedListener).call(this, event, emittedRegistration.registration);
            return this;
        }
        const index = listeners.findIndex((registration) => !registration.removed && registration.listener === listener);
        if (index !== -1) {
            listeners.splice(index, 1);
        }
        return this;
    }
    /**
     * Adds a one-time listener function for the event. The next time the event is triggered,
     * this listener is removed and then invoked.
     * @returns this, so that calls can be chained
     */
    once(event, listener) {
        var _a;
        const listeners = ((_a = __classPrivateFieldGet(this, _EventEmitter_listeners, "f"))[event] || (_a[event] = []));
        listeners.push({ listener, once: true });
        return this;
    }
    /**
     * This is similar to `.once()`, but returns a Promise that resolves the next time
     * the event is triggered, instead of calling a listener callback.
     * Events without arguments resolve to `undefined`, single-argument events resolve
     * to that argument, and events with multiple arguments resolve to an argument tuple.
     *
     * @returns A promise for the next event, or a rejection if an error occurs first.
     * Requesting the `error` event resolves with the emitted error instead.
     *
     * Example:
     *
     *   const message = await stream.emitted('message') // rejects if the stream errors
     */
    emitted(event) {
        return new Promise((resolve, reject) => {
            // oxlint-disable-next-line anti-slop/no-unknown-parameters -- Failures and rejection reasons can be arbitrary JavaScript values; preserve them until inspection or forwarding.
            const onError = (error) => {
                // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
                this.off(event, onEvent);
                reject(error);
            };
            const onEvent = (...values) => {
                if (event !== 'error') {
                    // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
                    this.off('error', onError);
                }
                // SAFETY: The emitted API returns the sole argument or the full tuple according to its existing EventTypes-dependent result contract.
                resolve((values.length > 1 ? values : values[0]));
            };
            if (event !== 'error') {
                // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
                __classPrivateFieldGet(this, _EventEmitter_instances, "m", _EventEmitter_onceForEmitted).call(this, 'error', onError);
            }
            // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
            __classPrivateFieldGet(this, _EventEmitter_instances, "m", _EventEmitter_onceForEmitted).call(this, event, onEvent);
        });
    }
    _emit(event, ...args) {
        const listeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event];
        if (listeners) {
            // SAFETY: Filtering only removes registrations from the same event bucket and preserves the listener signatures for that event.
            __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event] = listeners.filter((listener) => {
                if (listener.once) {
                    listener.detached = true;
                }
                return !listener.once && !listener.removed;
            });
            let listenerThrew = false;
            let firstListenerError;
            __classPrivateFieldSet(this, _EventEmitter_listenerDispatchDepth, __classPrivateFieldGet(this, _EventEmitter_listenerDispatchDepth, "f") + 1, "f");
            try {
                // SAFETY: The listener bucket and argument tuple come from the same EventTypes key; this bridges TypeScript generic indexed-access correlation.
                for (const registration of listeners) {
                    if (!registration.removed) {
                        try {
                            const { listener } = registration;
                            // SAFETY: The listener bucket and argument tuple come from the same EventTypes key; this bridges TypeScript generic indexed-access correlation.
                            listener(...args);
                        }
                        catch (error) {
                            if (!listenerThrew) {
                                listenerThrew = true;
                                firstListenerError = error;
                            }
                        }
                    }
                }
            }
            finally {
                __classPrivateFieldSet(this, _EventEmitter_listenerDispatchDepth, __classPrivateFieldGet(this, _EventEmitter_listenerDispatchDepth, "f") - 1, "f");
                if (__classPrivateFieldGet(this, _EventEmitter_listenerDispatchDepth, "f") === 0) {
                    __classPrivateFieldGet(this, _EventEmitter_instances, "m", _EventEmitter_cleanupEmittedListeners).call(this);
                }
            }
            if (listenerThrew) {
                throw firstListenerError;
            }
        }
    }
    _hasListener(event) {
        const listeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event];
        return listeners && listeners.some((listener) => !listener.removed);
    }
}
_EventEmitter_listeners = new WeakMap(), _EventEmitter_emittedListenerRegistrations = new WeakMap(), _EventEmitter_pendingListenerCleanup = new WeakMap(), _EventEmitter_listenerDispatchDepth = new WeakMap(), _EventEmitter_instances = new WeakSet(), _EventEmitter_onceForEmitted = function _EventEmitter_onceForEmitted(event, listener) {
    const previousListeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event];
    const previousLength = previousListeners?.length ?? 0;
    this.once(event, listener);
    const listeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[event];
    const [registration] = listeners?.slice(-1) ?? [];
    if ((previousListeners === undefined || listeners === previousListeners) &&
        listeners?.length === previousLength + 1 &&
        registration?.listener === listener &&
        registration.once) {
        // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
        __classPrivateFieldGet(this, _EventEmitter_emittedListenerRegistrations, "f").set(listener, { event, registration });
    }
}, _EventEmitter_removeEmittedListener = function _EventEmitter_removeEmittedListener(event, registration) {
    if (registration.removed) {
        return;
    }
    registration.removed = true;
    // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
    __classPrivateFieldGet(this, _EventEmitter_emittedListenerRegistrations, "f").delete(registration.listener);
    __classPrivateFieldGet(this, _EventEmitter_pendingListenerCleanup, "f").add(event);
    if (__classPrivateFieldGet(this, _EventEmitter_listenerDispatchDepth, "f") === 0) {
        __classPrivateFieldGet(this, _EventEmitter_instances, "m", _EventEmitter_cleanupEmittedListeners).call(this);
    }
}, _EventEmitter_cleanupEmittedListeners = function _EventEmitter_cleanupEmittedListeners() {
    for (const event of __classPrivateFieldGet(this, _EventEmitter_pendingListenerCleanup, "f")) {
        // SAFETY: Pending cleanup keys are added only from registered EventTypes events; the key retains its event-map membership.
        const eventType = event;
        const listeners = __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[eventType];
        if (listeners) {
            // SAFETY: Filtering only removes registrations from the same event bucket and preserves the listener signatures for that event.
            __classPrivateFieldGet(this, _EventEmitter_listeners, "f")[eventType] = listeners.filter((listener) => !listener.removed);
        }
    }
    __classPrivateFieldGet(this, _EventEmitter_pendingListenerCleanup, "f").clear();
};
//# sourceMappingURL=EventEmitter.mjs.map