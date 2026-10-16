var _AssistantStream_instances, _AssistantStream_runStepSnapshots, _AssistantStream_runStepIDOwners, _AssistantStream_activeRunStepID, _AssistantStream_messageSnapshots, _AssistantStream_messageIDOwners, _AssistantStream_messageSnapshot, _AssistantStream_activeMessageID, _AssistantStream_finalRun, _AssistantStream_currentContentIndex, _AssistantStream_currentContent, _AssistantStream_currentToolCallIndex, _AssistantStream_currentToolCall, _AssistantStream_currentEvent, _AssistantStream_currentRunSnapshot, _AssistantStream_currentRunStepSnapshot, _AssistantStream_addEvent, _AssistantStream_endRequest, _AssistantStream_validateRunStepEvent, _AssistantStream_reserveRunStepAlias, _AssistantStream_validateMessageEvent, _AssistantStream_reserveMessageAlias, _AssistantStream_handleMessage, _AssistantStream_handleRunStep, _AssistantStream_emitExposed, _AssistantStream_handleEvent, _AssistantStream_accumulateRunStep, _AssistantStream_accumulateMessage, _AssistantStream_accumulateContent, _AssistantStream_handleRun;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../internal/tslib.mjs";
import { Stream } from "../streaming.mjs";
import { APIError, OpenAIError } from "../error.mjs";
import { EventStream } from "./EventStream.mjs";
import { hasOwn } from "../internal/utils.mjs";
import { accumulateAssistantStreamDelta, assertSafeAssistantStreamDelta, createAssistantStreamArrayDeltaCommit, defineAssistantStreamArrayEntry, isAssistantStreamValueExternallyMutable, markAssistantStreamValueExternallyMutable, } from "../internal/assistant-stream-delta.mjs";
function stabilizeAssistantStreamEvent(event) {
    const eventDescriptor = Object.getOwnPropertyDescriptor(event, 'event');
    const dataDescriptor = Object.getOwnPropertyDescriptor(event, 'data');
    // oxlint-disable-next-line anti-slop/no-reflect-get -- Reflective wire reads reject primitive frames and preserve the original event receiver.
    const eventType = Reflect.get(event, 'event', event);
    // oxlint-disable-next-line anti-slop/no-reflect-get -- Keep the paired wire-data read on the original receiver after reading the event discriminator.
    const data = Reflect.get(event, 'data', event);
    let stableData = data;
    if (eventType === 'thread.message.created' ||
        eventType === 'thread.message.in_progress' ||
        eventType === 'thread.message.delta' ||
        eventType === 'thread.message.completed' ||
        eventType === 'thread.message.incomplete' ||
        eventType === 'thread.run.step.created' ||
        eventType === 'thread.run.step.in_progress' ||
        eventType === 'thread.run.step.delta' ||
        eventType === 'thread.run.step.completed' ||
        eventType === 'thread.run.step.failed' ||
        eventType === 'thread.run.step.cancelled' ||
        eventType === 'thread.run.step.expired') {
        const messageID = Object.getOwnPropertyDescriptor(data, 'id');
        if (messageID &&
            'value' in messageID &&
            // SAFETY: The own id descriptor was found above; keep its live read unknown while comparing it with the captured descriptor value.
            data.id !== messageID.value) {
            // SAFETY: Descriptor values are untyped; retaining this value as unknown avoids trusting a mutable message identifier.
            const canonicalID = messageID.value;
            // SAFETY: The proxy retains the event data and substitutes only its captured own id; all other properties forward to the original receiver.
            stableData = new Proxy(data, {
                get(target, property) {
                    // oxlint-disable-next-line anti-slop/no-reflect-get -- Proxy forwarding must preserve arbitrary keys with the original target as accessor receiver.
                    return property === 'id' ? canonicalID : Reflect.get(target, property, target);
                },
            });
        }
    }
    // SAFETY: The captured event discriminator and data originate from the same event; TypeScript loses their correlation when constructing the stabilized copy.
    const stableEvent = Object.freeze({ event: eventType, data: stableData });
    const ordinaryEvent = eventDescriptor !== undefined &&
        'value' in eventDescriptor &&
        eventDescriptor.value === eventType &&
        dataDescriptor !== undefined &&
        'value' in dataDescriptor &&
        dataDescriptor.value === data &&
        stableData === data;
    // SAFETY: The captured event discriminator and data originate from the same event; TypeScript loses their correlation when constructing the stabilized copy.
    return {
        event: stableEvent,
        exposedEvent: ordinaryEvent ? event : { event: eventType, data: stableData },
    };
}
/** Streams assistant-run events while accumulating messages, run steps, and tool-call snapshots. */
export class AssistantStream extends EventStream {
    constructor() {
        super(...arguments);
        _AssistantStream_instances.add(this);
        //Used to accumulate deltas
        //We are accumulating many types so the value here is not strict
        _AssistantStream_runStepSnapshots.set(this, Object.create(null));
        _AssistantStream_runStepIDOwners.set(this, new Map());
        _AssistantStream_activeRunStepID.set(this, void 0);
        _AssistantStream_messageSnapshots.set(this, Object.create(null));
        _AssistantStream_messageIDOwners.set(this, new Map());
        _AssistantStream_messageSnapshot.set(this, void 0);
        _AssistantStream_activeMessageID.set(this, void 0);
        _AssistantStream_finalRun.set(this, void 0);
        _AssistantStream_currentContentIndex.set(this, void 0);
        _AssistantStream_currentContent.set(this, void 0);
        _AssistantStream_currentToolCallIndex.set(this, void 0);
        _AssistantStream_currentToolCall.set(this, void 0);
        //For current snapshot methods
        _AssistantStream_currentEvent.set(this, void 0);
        _AssistantStream_currentRunSnapshot.set(this, void 0);
        _AssistantStream_currentRunStepSnapshot.set(this, void 0);
    }
    /** Iterates over cloned raw assistant events; stopping early aborts the underlying request. */
    [(_AssistantStream_runStepSnapshots = new WeakMap(), _AssistantStream_runStepIDOwners = new WeakMap(), _AssistantStream_activeRunStepID = new WeakMap(), _AssistantStream_messageSnapshots = new WeakMap(), _AssistantStream_messageIDOwners = new WeakMap(), _AssistantStream_messageSnapshot = new WeakMap(), _AssistantStream_activeMessageID = new WeakMap(), _AssistantStream_finalRun = new WeakMap(), _AssistantStream_currentContentIndex = new WeakMap(), _AssistantStream_currentContent = new WeakMap(), _AssistantStream_currentToolCallIndex = new WeakMap(), _AssistantStream_currentToolCall = new WeakMap(), _AssistantStream_currentEvent = new WeakMap(), _AssistantStream_currentRunSnapshot = new WeakMap(), _AssistantStream_currentRunStepSnapshot = new WeakMap(), _AssistantStream_instances = new WeakSet(), Symbol.asyncIterator)]() {
        return this._createIterator((push) => {
            //Catch all for passing along all events
            const onEvent = (event) => push(structuredClone(event));
            this.on('event', onEvent);
            return () => this.off('event', onEvent);
        }, { onReturn: () => this.abort() });
    }
    /** Restores an assistant stream from events serialized by `toReadableStream()`. */
    static fromReadableStream(stream) {
        const runner = new AssistantStream();
        runner._run(() => runner._fromReadableStream(stream));
        return runner;
    }
    async _fromReadableStream(readableStream, options) {
        this._listenForAbort(options?.signal);
        this._connected();
        const stream = Stream.fromReadableStream(readableStream, this.controller);
        for await (const event of stream) {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_addEvent).call(this, event);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return this._addRun(__classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_endRequest).call(this));
    }
    /** Serializes assistant events into a readable stream for transfer to another runtime. */
    toReadableStream() {
        const stream = new Stream(this[Symbol.asyncIterator].bind(this), this.controller);
        return stream.toReadableStream();
    }
    /** Submits tool outputs and starts streaming the continuation of an existing assistant run. */
    static createToolAssistantStream(runId, runs, params, options) {
        const runner = new AssistantStream();
        runner._run(() => runner._runToolAssistantStream(runId, runs, params, {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'stream' },
        }));
        return runner;
    }
    async _createToolAssistantStream(run, runId, params, options) {
        this._listenForAbort(options?.signal);
        const body = { ...params, stream: true };
        const stream = await run.submitToolOutputs(runId, body, {
            ...options,
            signal: this.controller.signal,
        });
        this._connected();
        for await (const event of stream) {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_addEvent).call(this, event);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return this._addRun(__classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_endRequest).call(this));
    }
    /** Creates an assistant thread and starts streaming its newly created run. */
    static createThreadAssistantStream(params, thread, options) {
        const runner = new AssistantStream();
        runner._run(() => runner._threadAssistantStream(params, thread, {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'stream' },
        }));
        return runner;
    }
    /** Creates a run on an existing assistant thread and starts streaming its events. */
    static createAssistantStream(threadId, runs, params, options) {
        const runner = new AssistantStream();
        runner._run(() => runner._runAssistantStream(threadId, runs, params, {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'stream' },
        }));
        return runner;
    }
    /** Returns the most recent raw event, or `undefined` before any event arrives. */
    currentEvent() {
        markAssistantStreamValueExternallyMutable(__classPrivateFieldGet(this, _AssistantStream_currentEvent, "f"));
        return __classPrivateFieldGet(this, _AssistantStream_currentEvent, "f");
    }
    /** Returns the latest run snapshot, or `undefined` before a run event arrives. */
    currentRun() {
        markAssistantStreamValueExternallyMutable(__classPrivateFieldGet(this, _AssistantStream_currentRunSnapshot, "f"));
        return __classPrivateFieldGet(this, _AssistantStream_currentRunSnapshot, "f");
    }
    /** Returns the message currently being accumulated, or `undefined` before message creation. */
    currentMessageSnapshot() {
        markAssistantStreamValueExternallyMutable(__classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
        return __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f");
    }
    /** Returns the run step currently being accumulated, or `undefined` before a step begins. */
    currentRunStepSnapshot() {
        markAssistantStreamValueExternallyMutable(__classPrivateFieldGet(this, _AssistantStream_currentRunStepSnapshot, "f"));
        return __classPrivateFieldGet(this, _AssistantStream_currentRunStepSnapshot, "f");
    }
    /** Waits for successful completion and returns the final snapshot of every observed run step. */
    async finalRunSteps() {
        await this.done();
        return Object.values(__classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f"));
    }
    /**
     * Waits for successful completion and returns the final snapshot of every observed message.
     * Terminal message events replace accumulated snapshots without mutating earlier snapshots.
     */
    async finalMessages() {
        await this.done();
        return Object.values(__classPrivateFieldGet(this, _AssistantStream_messageSnapshots, "f"));
    }
    /** Waits for completion and returns the final run, or rejects if no terminal run was received. */
    async finalRun() {
        await this.done();
        if (!__classPrivateFieldGet(this, _AssistantStream_finalRun, "f")) {
            throw new Error('Final run was not received.');
        }
        return __classPrivateFieldGet(this, _AssistantStream_finalRun, "f");
    }
    async _createThreadAssistantStream(thread, params, options) {
        this._listenForAbort(options?.signal);
        const body = { ...params, stream: true };
        const stream = await thread.createAndRun(body, { ...options, signal: this.controller.signal });
        this._connected();
        for await (const event of stream) {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_addEvent).call(this, event);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return this._addRun(__classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_endRequest).call(this));
    }
    async _createAssistantStream(run, threadId, params, options) {
        this._listenForAbort(options?.signal);
        const body = { ...params, stream: true };
        const stream = await run.create(threadId, body, { ...options, signal: this.controller.signal });
        this._connected();
        for await (const event of stream) {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_addEvent).call(this, event);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return this._addRun(__classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_endRequest).call(this));
    }
    /**
     * Applies an assistant delta to its mutable snapshot, concatenating text and
     * merging nested objects and indexed array entries.
     */
    static accumulateDelta(acc, delta) {
        return accumulateAssistantStreamDelta(acc, delta);
    }
    _addRun(run) {
        __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'run', run);
        return run;
    }
    async _threadAssistantStream(params, thread, options) {
        return await this._createThreadAssistantStream(thread, params, options);
    }
    async _runAssistantStream(threadId, runs, params, options) {
        return await this._createAssistantStream(runs, threadId, params, options);
    }
    async _runToolAssistantStream(runId, runs, params, options) {
        return await this._createToolAssistantStream(runs, runId, params, options);
    }
}
_AssistantStream_addEvent = function _AssistantStream_addEvent(event) {
    if (this.ended) {
        return;
    }
    const { event: stableEvent, exposedEvent } = stabilizeAssistantStreamEvent(event);
    let messageID;
    let messageData;
    let runStepID;
    let runStepData;
    switch (stableEvent.event) {
        case 'thread.message.created':
        case 'thread.message.in_progress':
        case 'thread.message.delta':
        case 'thread.message.completed':
        case 'thread.message.incomplete': {
            messageID = __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_validateMessageEvent).call(this, stableEvent);
            messageData = stableEvent.data;
            break;
        }
        case 'thread.run.step.created':
        case 'thread.run.step.in_progress':
        case 'thread.run.step.delta':
        case 'thread.run.step.completed':
        case 'thread.run.step.failed':
        case 'thread.run.step.cancelled':
        case 'thread.run.step.expired': {
            runStepID = __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_validateRunStepEvent).call(this, stableEvent);
            runStepData = stableEvent.data;
            break;
        }
    }
    __classPrivateFieldSet(this, _AssistantStream_currentEvent, exposedEvent, "f");
    __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_handleEvent).call(this, exposedEvent);
    if (messageID !== undefined && messageData !== undefined) {
        __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveMessageAlias).call(this, messageData, messageID);
    }
    if (runStepID !== undefined && runStepData !== undefined) {
        __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveRunStepAlias).call(this, runStepData, runStepID);
    }
    if (runStepID === undefined && __classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f") !== undefined && __classPrivateFieldGet(this, _AssistantStream_currentRunStepSnapshot, "f")) {
        __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveRunStepAlias).call(this, __classPrivateFieldGet(this, _AssistantStream_currentRunStepSnapshot, "f"), __classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f"));
    }
    switch (stableEvent.event) {
        case 'thread.created': {
            //No action on this event.
            break;
        }
        case 'thread.run.created':
        case 'thread.run.queued':
        case 'thread.run.in_progress':
        case 'thread.run.requires_action':
        case 'thread.run.completed':
        case 'thread.run.incomplete':
        case 'thread.run.failed':
        case 'thread.run.cancelling':
        case 'thread.run.cancelled':
        case 'thread.run.expired': {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_handleRun).call(this, stableEvent);
            break;
        }
        case 'thread.run.step.created':
        case 'thread.run.step.in_progress':
        case 'thread.run.step.delta':
        case 'thread.run.step.completed':
        case 'thread.run.step.failed':
        case 'thread.run.step.cancelled':
        case 'thread.run.step.expired': {
            if (runStepID === undefined) {
                throw new OpenAIError('Received assistant run-step event without a canonical run-step ID');
            }
            const activeRunStep = __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID];
            if (activeRunStep) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveRunStepAlias).call(this, activeRunStep, runStepID);
            }
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_handleRunStep).call(this, stableEvent, runStepID);
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveRunStepAlias).call(this, stableEvent.data, runStepID);
            const retainedRunStep = __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID];
            if (retainedRunStep) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveRunStepAlias).call(this, retainedRunStep, runStepID);
            }
            break;
        }
        case 'thread.message.created':
        case 'thread.message.in_progress':
        case 'thread.message.delta':
        case 'thread.message.completed':
        case 'thread.message.incomplete': {
            if (messageID !== undefined && __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f")) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveMessageAlias).call(this, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"), messageID);
            }
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_handleMessage).call(this, stableEvent);
            if (messageID !== undefined) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveMessageAlias).call(this, stableEvent.data, messageID);
                const retainedMessage = __classPrivateFieldGet(this, _AssistantStream_messageSnapshots, "f")[messageID];
                if (retainedMessage) {
                    __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_reserveMessageAlias).call(this, retainedMessage, messageID);
                }
            }
            break;
        }
        case 'error': {
            throw new APIError(undefined, stableEvent.data, undefined, undefined);
        }
        default: {
            assertNever(stableEvent);
        }
    }
}, _AssistantStream_endRequest = function _AssistantStream_endRequest() {
    if (this.ended) {
        throw new OpenAIError(`stream has ended, this shouldn't happen`);
    }
    if (!__classPrivateFieldGet(this, _AssistantStream_finalRun, "f")) {
        throw new Error('Final run has not been received');
    }
    return __classPrivateFieldGet(this, _AssistantStream_finalRun, "f");
}, _AssistantStream_validateRunStepEvent = function _AssistantStream_validateRunStepEvent(event) {
    const descriptor = Object.getOwnPropertyDescriptor(event.data, 'id');
    const runStepID = descriptor && 'value' in descriptor ? descriptor.value : undefined;
    if (typeof runStepID !== 'string' || runStepID.length === 0) {
        throw new OpenAIError('Received assistant run-step event with an invalid run-step ID');
    }
    if (event.event === 'thread.run.step.delta') {
        const delta = event.data.delta;
        if (delta && hasOwn(delta, 'id')) {
            throw new OpenAIError('Run-step deltas must not contain an id field');
        }
    }
    if (event.event === 'thread.run.step.created') {
        if (__classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f") !== undefined) {
            throw new OpenAIError(`Received run-step creation for "${runStepID}" before the active run step "${__classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f")}" reached a terminal state`);
        }
        if (hasOwn(__classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f"), runStepID) || __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").has(runStepID)) {
            throw new OpenAIError(`Received run-step creation for run step "${runStepID}", which has already been created`);
        }
        __classPrivateFieldSet(this, _AssistantStream_activeRunStepID, runStepID, "f");
        __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").set(runStepID, runStepID);
        return runStepID;
    }
    if (__classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f") !== undefined) {
        if (runStepID !== __classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f")) {
            throw new OpenAIError(`Received ${event.event} for run step "${runStepID}", which does not match the active run step "${__classPrivateFieldGet(this, _AssistantStream_activeRunStepID, "f")}"`);
        }
        return runStepID;
    }
    if (event.event === 'thread.run.step.delta') {
        if (!hasOwn(__classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f"), runStepID)) {
            throw new OpenAIError('Received a RunStepDelta before creation of a snapshot');
        }
        throw new OpenAIError(`Received run-step delta for "${runStepID}" with no active run step`);
    }
    if (hasOwn(__classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f"), runStepID) || __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").has(runStepID)) {
        throw new OpenAIError(`Received run-step event for run step "${runStepID}", which has already been created`);
    }
    __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").set(runStepID, runStepID);
    if (event.event === 'thread.run.step.in_progress') {
        __classPrivateFieldSet(this, _AssistantStream_activeRunStepID, runStepID, "f");
    }
    return runStepID;
}, _AssistantStream_reserveRunStepAlias = function _AssistantStream_reserveRunStepAlias(data, canonicalID) {
    const descriptor = Object.getOwnPropertyDescriptor(data, 'id');
    const runStepID = descriptor && 'value' in descriptor ? descriptor.value : undefined;
    if (typeof runStepID !== 'string' || runStepID.length === 0) {
        throw new OpenAIError('Received assistant run-step event with an invalid run-step ID');
    }
    const owner = __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").get(runStepID);
    if (owner !== undefined && owner !== canonicalID) {
        throw new OpenAIError(`Received run-step creation for run step "${runStepID}", which has already been created`);
    }
    __classPrivateFieldGet(this, _AssistantStream_runStepIDOwners, "f").set(runStepID, canonicalID);
}, _AssistantStream_validateMessageEvent = function _AssistantStream_validateMessageEvent(event) {
    const descriptor = Object.getOwnPropertyDescriptor(event.data, 'id');
    const messageID = descriptor && 'value' in descriptor ? descriptor.value : undefined;
    if (typeof messageID !== 'string' || messageID.length === 0) {
        throw new OpenAIError('Received assistant message event with an invalid message ID');
    }
    if (event.event === 'thread.message.created') {
        if (__classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f")) {
            throw new OpenAIError(`Received message creation for "${messageID}" before the active message "${__classPrivateFieldGet(this, _AssistantStream_activeMessageID, "f")}" reached a terminal state`);
        }
        if (hasOwn(__classPrivateFieldGet(this, _AssistantStream_messageSnapshots, "f"), messageID) || __classPrivateFieldGet(this, _AssistantStream_messageIDOwners, "f").has(messageID)) {
            throw new OpenAIError(`Received message creation for message "${messageID}", which has already been created`);
        }
        __classPrivateFieldSet(this, _AssistantStream_activeMessageID, messageID, "f");
        __classPrivateFieldGet(this, _AssistantStream_messageIDOwners, "f").set(messageID, messageID);
        return messageID;
    }
    if (!__classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f")) {
        if (event.event === 'thread.message.delta') {
            throw new OpenAIError('Received a delta with no existing snapshot (there should be one from message creation)');
        }
        throw new OpenAIError('Received thread message event with no existing snapshot');
    }
    if (messageID !== __classPrivateFieldGet(this, _AssistantStream_activeMessageID, "f")) {
        throw new OpenAIError(`Received ${event.event} for message "${messageID}", which does not match the active message "${__classPrivateFieldGet(this, _AssistantStream_activeMessageID, "f")}"`);
    }
    return messageID;
}, _AssistantStream_reserveMessageAlias = function _AssistantStream_reserveMessageAlias(data, canonicalID) {
    const descriptor = Object.getOwnPropertyDescriptor(data, 'id');
    const messageID = descriptor && 'value' in descriptor ? descriptor.value : undefined;
    if (typeof messageID !== 'string' || messageID.length === 0) {
        throw new OpenAIError('Received assistant message event with an invalid message ID');
    }
    const owner = __classPrivateFieldGet(this, _AssistantStream_messageIDOwners, "f").get(messageID);
    if (owner !== undefined && owner !== canonicalID) {
        throw new OpenAIError(`Received message creation for message "${messageID}", which has already been created`);
    }
    __classPrivateFieldGet(this, _AssistantStream_messageIDOwners, "f").set(messageID, canonicalID);
}, _AssistantStream_handleMessage = function _AssistantStream_handleMessage(event) {
    const [accumulatedMessage, newContent] = __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_accumulateMessage).call(this, event, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
    __classPrivateFieldSet(this, _AssistantStream_messageSnapshot, accumulatedMessage, "f");
    if (!__classPrivateFieldGet(this, _AssistantStream_activeMessageID, "f")) {
        throw new OpenAIError('Received thread message event with no active message ID');
    }
    __classPrivateFieldGet(this, _AssistantStream_messageSnapshots, "f")[__classPrivateFieldGet(this, _AssistantStream_activeMessageID, "f")] = accumulatedMessage;
    for (const content of newContent) {
        const snapshotContent = accumulatedMessage.content[content.index];
        if (snapshotContent?.type === 'text') {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'textCreated', snapshotContent.text);
        }
    }
    switch (event.event) {
        case 'thread.message.created': {
            __classPrivateFieldSet(this, _AssistantStream_currentContentIndex, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_currentContent, undefined, "f");
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'messageCreated', event.data);
            break;
        }
        case 'thread.message.in_progress': {
            break;
        }
        case 'thread.message.delta': {
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'messageDelta', event.data.delta, accumulatedMessage);
            if (event.data.delta.content) {
                for (const content of event.data.delta.content) {
                    //If it is text delta, emit a text delta event
                    if (content.type === 'text' && content.text) {
                        const textDelta = content.text;
                        const snapshot = accumulatedMessage.content[content.index];
                        if (snapshot && snapshot.type === 'text') {
                            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'textDelta', textDelta, snapshot.text);
                        }
                        else {
                            throw new Error('The snapshot associated with this text delta is not text or missing');
                        }
                    }
                    if (content.index !== __classPrivateFieldGet(this, _AssistantStream_currentContentIndex, "f")) {
                        //See if we have in progress content
                        if (__classPrivateFieldGet(this, _AssistantStream_currentContent, "f")) {
                            switch (__classPrivateFieldGet(this, _AssistantStream_currentContent, "f").type) {
                                case 'text': {
                                    __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'textDone', __classPrivateFieldGet(this, _AssistantStream_currentContent, "f").text, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
                                    break;
                                }
                                case 'image_file': {
                                    __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'imageFileDone', __classPrivateFieldGet(this, _AssistantStream_currentContent, "f").image_file, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
                                    break;
                                }
                            }
                        }
                        __classPrivateFieldSet(this, _AssistantStream_currentContentIndex, content.index, "f");
                    }
                    __classPrivateFieldSet(this, _AssistantStream_currentContent, accumulatedMessage.content[content.index], "f");
                }
            }
            break;
        }
        case 'thread.message.completed':
        case 'thread.message.incomplete': {
            //We emit the latest content we were working on on completion (including incomplete)
            if (__classPrivateFieldGet(this, _AssistantStream_currentContentIndex, "f") !== undefined) {
                const currentContent = event.data.content[__classPrivateFieldGet(this, _AssistantStream_currentContentIndex, "f")];
                if (currentContent) {
                    switch (currentContent.type) {
                        case 'image_file': {
                            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'imageFileDone', currentContent.image_file, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
                            break;
                        }
                        case 'text': {
                            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'textDone', currentContent.text, __classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f"));
                            break;
                        }
                    }
                }
            }
            if (__classPrivateFieldGet(this, _AssistantStream_messageSnapshot, "f")) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'messageDone', event.data);
            }
            __classPrivateFieldSet(this, _AssistantStream_currentContentIndex, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_currentContent, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_messageSnapshot, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_activeMessageID, undefined, "f");
        }
    }
}, _AssistantStream_handleRunStep = function _AssistantStream_handleRunStep(event, runStepID) {
    const accumulatedRunStep = __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_accumulateRunStep).call(this, event, runStepID);
    __classPrivateFieldSet(this, _AssistantStream_currentRunStepSnapshot, accumulatedRunStep, "f");
    switch (event.event) {
        case 'thread.run.step.created': {
            __classPrivateFieldSet(this, _AssistantStream_currentToolCallIndex, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_currentToolCall, undefined, "f");
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'runStepCreated', event.data);
            break;
        }
        case 'thread.run.step.delta': {
            const delta = event.data.delta;
            if (delta.step_details &&
                delta.step_details.type === 'tool_calls' &&
                delta.step_details.tool_calls &&
                accumulatedRunStep.step_details.type === 'tool_calls') {
                for (const toolCall of delta.step_details.tool_calls) {
                    if (toolCall.index === __classPrivateFieldGet(this, _AssistantStream_currentToolCallIndex, "f")) {
                        // SAFETY: The indexed tool call comes from this run-step snapshot after applying the delta for the same tool-call index.
                        __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'toolCallDelta', toolCall, accumulatedRunStep.step_details.tool_calls[toolCall.index]);
                    }
                    else {
                        if (__classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f")) {
                            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'toolCallDone', __classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f"));
                        }
                        __classPrivateFieldSet(this, _AssistantStream_currentToolCallIndex, toolCall.index, "f");
                        __classPrivateFieldSet(this, _AssistantStream_currentToolCall, accumulatedRunStep.step_details.tool_calls[toolCall.index], "f");
                        if (__classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f")) {
                            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'toolCallCreated', __classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f"));
                        }
                    }
                }
            }
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'runStepDelta', event.data.delta, accumulatedRunStep);
            break;
        }
        case 'thread.run.step.completed':
        case 'thread.run.step.failed':
        case 'thread.run.step.cancelled':
        case 'thread.run.step.expired': {
            __classPrivateFieldSet(this, _AssistantStream_currentRunStepSnapshot, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_activeRunStepID, undefined, "f");
            const details = event.data.step_details;
            if (details.type === 'tool_calls' && __classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f")) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'toolCallDone', __classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f"));
            }
            __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'runStepDone', event.data, accumulatedRunStep);
            __classPrivateFieldSet(this, _AssistantStream_currentToolCallIndex, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_currentToolCall, undefined, "f");
            break;
        }
        case 'thread.run.step.in_progress': {
            break;
        }
    }
}, _AssistantStream_emitExposed = function _AssistantStream_emitExposed(event, ...args) {
    if (this._hasListeners(event)) {
        for (const value of args) {
            markAssistantStreamValueExternallyMutable(value);
        }
    }
    this._emit(event, ...args);
}, _AssistantStream_handleEvent = function _AssistantStream_handleEvent(event) {
    __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'event', event);
}, _AssistantStream_accumulateRunStep = function _AssistantStream_accumulateRunStep(event, runStepID) {
    switch (event.event) {
        case 'thread.run.step.created': {
            __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID] = event.data;
            return event.data;
        }
        case 'thread.run.step.delta': {
            // SAFETY: Run-step snapshots are stored by their canonical run-step id; the delta path checks that the snapshot exists before updating it.
            const snapshot = __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID];
            if (!snapshot) {
                throw new Error('Received a RunStepDelta before creation of a snapshot');
            }
            const delta = event.data.delta;
            if (delta) {
                // Raw-event listeners can replace or modify the delta after initial validation.
                if (hasOwn(delta, 'id')) {
                    throw new OpenAIError('Run-step deltas must not contain an id field');
                }
                const accumulated = accumulateAssistantStreamDelta(snapshot, delta, true);
                __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID] = accumulated;
            }
            // SAFETY: Run-step snapshots are stored by their canonical run-step id; the delta path checks that the snapshot exists before updating it.
            return __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID];
        }
        case 'thread.run.step.completed':
        case 'thread.run.step.failed':
        case 'thread.run.step.cancelled':
        case 'thread.run.step.expired':
        case 'thread.run.step.in_progress': {
            __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID] = event.data;
            break;
        }
    }
    if (__classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID]) {
        return __classPrivateFieldGet(this, _AssistantStream_runStepSnapshots, "f")[runStepID];
    }
    throw new Error('No snapshot available');
}, _AssistantStream_accumulateMessage = function _AssistantStream_accumulateMessage(event, snapshot) {
    const newContent = [];
    switch (event.event) {
        case 'thread.message.created': {
            //On creation the snapshot is just the initial message
            return [event.data, newContent];
        }
        case 'thread.message.delta': {
            if (!snapshot) {
                throw new Error('Received a delta with no existing snapshot (there should be one from message creation)');
            }
            const data = event.data;
            //If this delta does not have content, nothing to process
            if (data.delta.content) {
                assertSafeAssistantStreamDelta(data.delta);
                const cacheArrays = !isAssistantStreamValueExternallyMutable(snapshot);
                const commitProjection = createAssistantStreamArrayDeltaCommit(snapshot.content, data.delta.content, 'content', cacheArrays);
                for (const contentElement of data.delta.content) {
                    if (hasOwn(snapshot.content, contentElement.index)) {
                        const currentContent = snapshot.content[contentElement.index];
                        snapshot.content[contentElement.index] = __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_accumulateContent).call(this, contentElement, currentContent, cacheArrays);
                    }
                    else {
                        defineAssistantStreamArrayEntry(snapshot.content, contentElement.index, contentElement);
                        // This is a new element
                        newContent.push(contentElement);
                    }
                }
                commitProjection();
            }
            return [snapshot, newContent];
        }
        case 'thread.message.in_progress':
        case 'thread.message.completed':
        case 'thread.message.incomplete': {
            //Terminal events provide the authoritative message snapshot.
            if (snapshot) {
                return [event.event === 'thread.message.in_progress' ? snapshot : event.data, newContent];
            }
            throw new Error('Received thread message event with no existing snapshot');
        }
    }
    throw new Error('Tried to accumulate a non-message event');
}, _AssistantStream_accumulateContent = function _AssistantStream_accumulateContent(contentElement, currentContent, cacheArrays) {
    // SAFETY: The accumulator merges the matching message-content delta into its existing block; the public return remains the text/image block union.
    return accumulateAssistantStreamDelta(currentContent, contentElement, cacheArrays);
}, _AssistantStream_handleRun = function _AssistantStream_handleRun(event) {
    __classPrivateFieldSet(this, _AssistantStream_currentRunSnapshot, event.data, "f");
    switch (event.event) {
        case 'thread.run.created': {
            break;
        }
        case 'thread.run.queued': {
            break;
        }
        case 'thread.run.in_progress': {
            break;
        }
        case 'thread.run.requires_action':
        case 'thread.run.cancelled':
        case 'thread.run.failed':
        case 'thread.run.completed':
        case 'thread.run.expired':
        case 'thread.run.incomplete': {
            __classPrivateFieldSet(this, _AssistantStream_finalRun, event.data, "f");
            if (__classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f")) {
                __classPrivateFieldGet(this, _AssistantStream_instances, "m", _AssistantStream_emitExposed).call(this, 'toolCallDone', __classPrivateFieldGet(this, _AssistantStream_currentToolCall, "f"));
            }
            __classPrivateFieldSet(this, _AssistantStream_currentToolCallIndex, undefined, "f");
            __classPrivateFieldSet(this, _AssistantStream_currentToolCall, undefined, "f");
            break;
        }
        case 'thread.run.cancelling': {
            break;
        }
    }
};
function assertNever(_x) {
    return _x;
}
//# sourceMappingURL=AssistantStream.mjs.map