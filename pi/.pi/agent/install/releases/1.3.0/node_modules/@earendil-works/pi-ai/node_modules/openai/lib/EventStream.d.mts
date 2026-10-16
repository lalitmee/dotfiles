import { APIUserAbortError, OpenAIError } from "../error.mjs";
import type { EmittedEventResult } from "./EventEmitter.mjs";
/** An abortable event stream with typed listeners, asynchronous iteration, and lifecycle state. */
export declare class EventStream<EventTypes extends BaseEvents> {
    #private;
    /** Controls the underlying request; aborting this controller cancels the stream. */
    controller: AbortController;
    /** Creates an unstarted stream with independent connection and completion lifecycle promises. */
    constructor();
    protected _run(this: EventStream<EventTypes>, executor: () => Promise<any>): void;
    protected _connected(this: EventStream<EventTypes>): void;
    /** Whether the stream has finished successfully, failed, or been aborted. */
    get ended(): boolean;
    /** Whether an error or user cancellation has been observed. */
    get errored(): boolean;
    /** Whether the stream ended because its request was cancelled. */
    get aborted(): boolean;
    /**
     * Cancels the underlying request; {@link done} and {@link events} observe cancellation.
     * Promises returned by {@link emitted} for other events may remain pending.
     */
    abort(): void;
    /** Creates a user-abort error retaining this runner's cancellation reason. */
    protected _userAbortError(): APIUserAbortError;
    protected _listenForAbort(signal: AbortSignal | null | undefined): void;
    /**
     * Adds the listener function to the end of the listeners array for the event.
     * No checks are made to see if the listener has already been added. Multiple calls passing
     * the same combination of event and listener will result in the listener being added, and
     * called, multiple times.
     * @returns This stream, so that listener registration calls can be chained.
     */
    on<Event extends keyof EventTypes>(event: Event, listener: EventListener<EventTypes, Event>): this;
    /**
     * Removes the specified listener from the listener array for the event.
     * off() will remove, at most, one instance of a listener from the listener array. If any single
     * listener has been added multiple times to the listener array for the specified event, then
     * off() must be called multiple times to remove each instance.
     * @returns This stream, so that listener registration calls can be chained.
     */
    off<Event extends keyof EventTypes>(event: Event, listener: EventListener<EventTypes, Event>): this;
    /**
     * Adds a one-time listener function for the event. The next time the event is triggered,
     * this listener is removed and then invoked.
     * @returns This stream, so that listener registration calls can be chained.
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
    /**
     * Returns an async iterator that yields every time the event is triggered.
     * The iterator ends when the stream ends and rejects if the stream errors
     * or is aborted. If you request the 'error' or 'abort' event, the iterator
     * yields that event instead of rejecting.
     *
     * Example:
     *
     *   for await (const [message] of stream.events('message')) {
     *     await processMessage(message);
     *   }
     */
    events<Event extends keyof EventTypes>(event: Event): AsyncIterableIterator<EventParameters<EventTypes, Event>>;
    /**
     * Shared buffered async-iterator adapter over this stream's events.
     *
     * `attach` registers the producer listener(s) with the given `push` and
     * returns a cleanup function that removes them. Termination is handled
     * here: the iterator ends when the stream ends, listeners are removed on
     * end/return, and a terminal error is retained until buffered values have
     * drained so it is surfaced even when no reader was waiting when it fired.
     * Detached consumers have bounded event and byte queues; exceeding either
     * limit fails the stream and aborts its underlying request. Detached queues
     * also reject accessor-backed payloads because getter closures cannot be
     * safely sized without executing untrusted code.
     */
    protected _createIterator<T>(attach: (push: (value: T) => void) => () => void, { rejectOnError, rejectOnAbort, onReturn, }?: {
        rejectOnError?: boolean;
        rejectOnAbort?: boolean;
        onReturn?: () => void;
    }): AsyncIterableIterator<T>;
    /** Resolves when the stream ends successfully or rejects when it fails or is aborted. */
    done(): Promise<void>;
    /** Returns whether an event currently has one or more registered listeners. */
    protected _hasListeners<Event extends keyof EventTypes>(event: Event): boolean;
    /** Dispatches a connection, failure, cancellation, or completion lifecycle event. */
    _emit<Event extends keyof BaseEvents>(event: Event, ...args: EventParameters<BaseEvents, Event>): void;
    /** Dispatches a typed stream event to all listeners registered for that event. */
    _emit<Event extends keyof EventTypes>(event: Event, ...args: EventParameters<EventTypes, Event>): void;
    protected _emitFinal(): void;
}
/** The listener callback associated with one event name in a stream event map. */
type EventListener<Events, EventType extends keyof Events> = Events[EventType];
/** The positional listener arguments associated with a named event. */
export type EventParameters<Events, EventType extends keyof Events> = Record<EventType, EventListener<Events, EventType> extends (...args: infer P) => any ? P : never>[EventType];
/** Lifecycle events shared by all SDK streaming helpers. */
export interface BaseEvents {
    /** Called when the underlying request or readable stream is ready to produce events. */
    connect: () => void;
    /** Called when the stream fails for a reason other than user cancellation. */
    error: (error: OpenAIError) => void;
    /** Called when the underlying request is cancelled. */
    abort: (error: APIUserAbortError) => void;
    /** Called after a successful completion, failure, or cancellation. */
    end: () => void;
}
export {};
//# sourceMappingURL=EventStream.d.mts.map