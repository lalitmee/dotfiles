/** The listener callback associated with one event name in an event map. */
type EventListener<Events, EventType extends keyof Events> = Events[EventType];
/** The positional listener arguments associated with a named event. */
export type EventParameters<Events, EventType extends keyof Events> = Record<EventType, EventListener<Events, EventType> extends (...args: infer P) => any ? P : never>[EventType];
/** Result of awaiting an event: no value, one unwrapped value, or its argument tuple. */
export type EmittedEventResult<Args extends unknown[]> = [Args] extends [[infer Param]] ? Param : [Args] extends [[]] ? void : [Args] extends [[unknown?]] ? Args[0] : [Args] extends [[unknown, unknown, ...unknown[]]] ? Args : Args | ([] extends Args ? undefined : never) | (Args extends [...infer Prefix, infer Last] ? ([] extends Prefix ? Last : never) : Args[0]);
/** A lightweight event emitter with type-safe listeners and promise-based event waiting. */
export declare class EventEmitter<EventTypes extends Record<string, (...args: any) => any>> {
    #private;
    /**
     * Adds the listener function to the end of the listeners array for the event.
     * No checks are made to see if the listener has already been added. Multiple calls passing
     * the same combination of event and listener will result in the listener being added, and
     * called, multiple times.
     * @returns this, so that calls can be chained
     */
    on<Event extends keyof EventTypes>(event: Event, listener: EventListener<EventTypes, Event>): this;
    /**
     * Removes the specified listener from the listener array for the event.
     * off() will remove, at most, one instance of a listener from the listener array. If any single
     * listener has been added multiple times to the listener array for the specified event, then
     * off() must be called multiple times to remove each instance.
     * @returns this, so that calls can be chained
     */
    off<Event extends keyof EventTypes>(event: Event, listener: EventListener<EventTypes, Event>): this;
    /**
     * Adds a one-time listener function for the event. The next time the event is triggered,
     * this listener is removed and then invoked.
     * @returns this, so that calls can be chained
     */
    once<Event extends keyof EventTypes>(event: Event, listener: EventListener<EventTypes, Event>): this;
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
    emitted<Event extends keyof EventTypes>(event: Event): Promise<EmittedEventResult<EventParameters<EventTypes, Event>>>;
    protected _emit<Event extends keyof EventTypes>(this: EventEmitter<EventTypes>, event: Event, ...args: EventParameters<EventTypes, Event>): void;
    protected _hasListener(event: keyof EventTypes): boolean;
}
export {};
//# sourceMappingURL=EventEmitter.d.ts.map