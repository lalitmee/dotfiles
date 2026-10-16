"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TranscriptGrouper = void 0;
const EventEmitter_1 = require("../../core/EventEmitter.js");
const error_1 = require("../../core/error.js");
const transcript_grouping_1 = require("./transcript-grouping.js");
const SETTLE_MS = 50;
const MAX_TIMEOUT_MS = 2147483647;
let nextGrouperId = 0;
function normalizeTranscript(event) {
    const { event_id: id, delta: text, start_ms: startMs, end_ms: endMs } = event;
    const speaker = event.type === 'session.input_transcript.delta' ? 'user' : 'assistant';
    if (
    // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate streamed transcript identifiers and text before grouping, and probe optional timer capabilities.
    typeof id !== 'string' ||
        !id ||
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate streamed transcript identifiers and text before grouping, and probe optional timer capabilities.
        typeof text !== 'string' ||
        !Number.isSafeInteger(startMs) ||
        startMs < 0 ||
        !Number.isSafeInteger(endMs) ||
        endMs < startMs) {
        throw new error_1.OpenAIError('Invalid Live transcript delta: expected an event ID, text, and a nonnegative timed interval');
    }
    return { id, speaker, text, startMs, endMs, receivedAt: performance.now() };
}
function optionsWithDefaults(options) {
    const resolved = {
        minTurnSeparationMs: options.minTurnSeparationMs ?? 500,
        assistantSilenceMs: options.assistantSilenceMs ?? 2000,
        backchannelMaxDurationMs: options.backchannelMaxDurationMs ?? 1000,
        backchannelIsolationMs: options.backchannelIsolationMs ?? 2000,
    };
    for (const [name, value] of Object.entries(resolved)) {
        if (!Number.isFinite(value) || value < 0 || value > MAX_TIMEOUT_MS) {
            throw new error_1.OpenAIError(`${name} must be a finite number between 0 and ${MAX_TIMEOUT_MS}`);
        }
    }
    return { ...resolved, additionalAcknowledgments: options.additionalAcknowledgments ?? [] };
}
/**
 * Groups public Live transcript events using speaker and
 * backchannel heuristics. Raw events remain available on your transport.
 *
 * Only session.input_transcript.delta, session.output_transcript.delta and session.closed are
 * consumed. No audio, engine frames, server turn events or internal end markers
 * are required. Ambiguous speaker changes settle for at most 50 ms. When source
 * time stops arriving, a monotonic local clock supplies a best-effort inactivity
 * fallback. Delayed delivery can therefore change grouping; this is not VAD,
 * playback tracking, or a lossless transcript (some backchannels are suppressed).
 *
 * Create one instance per session. Call close() on transport loss or teardown;
 * the grouper never owns or closes your transport and does not reconnect it.
 */
// oxlint-disable-next-line unicorn/prefer-event-target -- This is the SDK's browser-compatible typed emitter, not node:events.
class TranscriptGrouper extends EventEmitter_1.EventEmitter {
    /** Create a grouper with speaker-based defaults. Invalid timing options throw OpenAIError. */
    constructor(options = {}) {
        super();
        this.seenIds = new Set();
        this.pending = [];
        this.closed = false;
        this.dispatching = false;
        this.updates = [];
        this.grouping = new transcript_grouping_1.TranscriptGrouping(optionsWithDefaults(options), `segment_${nextGrouperId}`);
        nextGrouperId += 1;
    }
    /**
     * Consume one public Live event. Duplicate transcript event IDs and unrelated
     * event types are ignored. Empty text does not count as speech activity.
     * Malformed transcript fields or use after close() throw OpenAIError.
     */
    push(event) {
        if (this.closed) {
            throw new error_1.OpenAIError('Cannot push events after closing the transcript grouper');
        }
        if (event.type === 'session.closed') {
            this.finish('session_closed');
            return;
        }
        if (event.type !== 'session.input_transcript.delta' && event.type !== 'session.output_transcript.delta') {
            return;
        }
        const fragment = normalizeTranscript(event);
        const { id, startMs, endMs, speaker } = fragment;
        if (this.seenIds.has(id)) {
            return;
        }
        this.seenIds.add(id);
        if (!fragment.text) {
            return;
        }
        const updates = [];
        const [pending] = this.pending;
        if (pending && pending.startMs === startMs && pending.endMs === endMs) {
            this.pending.push(fragment);
            if (this.pending.some((part) => part.speaker !== speaker)) {
                updates.push(...this.flushPending());
            }
        }
        else {
            updates.push(...this.flushPending());
            if (this.grouping.speaker === speaker) {
                updates.push(...this.commit([fragment]));
            }
            else {
                this.pending.push(fragment);
            }
        }
        this.schedule();
        this.dispatch(updates);
    }
    /**
     * Flush buffered text according to the grouping policy, finalize all emitted
     * segments, and cancel timers. Idempotent; further push() calls fail. Does not
     * close the transport. Invoke before discarding the grouper at session teardown.
     */
    close() {
        this.finish('manual');
    }
    finish(reason) {
        if (this.closed) {
            return;
        }
        this.closed = true;
        this.clearTimer();
        const updates = this.flushPending();
        updates.push(...this.grouping.close(this.sourceNow(), reason));
        this.seenIds.clear();
        this.dispatch(updates);
    }
    commit(fragments) {
        const [first] = fragments;
        if (!first) {
            return [];
        }
        const updates = [];
        if (this.lastStartMs !== undefined && first.startMs < this.lastStartMs) {
            updates.push(...this.grouping.close(this.sourceNow(), 'timestamp_reset'));
            this.anchor = undefined;
        }
        this.lastStartMs = first.startMs;
        // Overlapping intervals can end before earlier ones. Preserve the source
        // high-water mark while restarting local inactivity on newly received text.
        this.anchor = {
            sourceMs: Math.max(this.anchor?.sourceMs ?? 0, first.endMs),
            receivedAt: first.receivedAt,
        };
        for (const part of fragments) {
            this.anchor.sourceMs = Math.max(this.anchor.sourceMs, part.endMs);
            this.anchor.receivedAt = Math.max(this.anchor.receivedAt, part.receivedAt);
        }
        updates.push(...this.grouping.process(fragments));
        return updates;
    }
    flushPending() {
        const { pending } = this;
        this.pending = [];
        return this.commit(pending);
    }
    sourceNow() {
        return this.anchor ? this.anchor.sourceMs + Math.max(0, performance.now() - this.anchor.receivedAt) : 0;
    }
    clearTimer() {
        if (this.timer !== undefined) {
            clearTimeout(this.timer);
        }
        this.timer = undefined;
    }
    schedule() {
        this.clearTimer();
        if (this.closed) {
            return;
        }
        const [pending] = this.pending;
        const deadline = this.grouping.deadline();
        // Settle newly arrived text before applying an older inactivity deadline.
        let delay;
        if (pending) {
            delay = pending.receivedAt + SETTLE_MS - performance.now();
        }
        else if (deadline !== undefined) {
            delay = deadline - this.sourceNow();
        }
        if (delay === undefined) {
            return;
        }
        this.timer = setTimeout(() => {
            this.timer = undefined;
            const updates = this.flushPending();
            updates.push(...this.grouping.advance(this.sourceNow()));
            this.schedule();
            this.dispatch(updates);
        }, Math.min(MAX_TIMEOUT_MS, Math.max(0, Math.ceil(delay))));
        const timer = this.timer;
        if (
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate streamed transcript identifiers and text before grouping, and probe optional timer capabilities.
        typeof timer === 'object' &&
            timer !== null &&
            'unref' in timer &&
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate streamed transcript identifiers and text before grouping, and probe optional timer capabilities.
            typeof timer.unref === 'function') {
            timer.unref();
        }
    }
    dispatch(updates) {
        this.updates.push(...updates);
        if (this.dispatching) {
            return;
        }
        this.dispatching = true;
        try {
            while (this.updates.length) {
                const update = this.updates.shift();
                if (update?.type === 'updated') {
                    this._emit('segment.updated', update.segment);
                }
                else if (update) {
                    this._emit('segment.closed', { segment: update.segment, reason: update.reason });
                }
            }
        }
        finally {
            this.dispatching = false;
        }
    }
}
exports.TranscriptGrouper = TranscriptGrouper;
//# sourceMappingURL=transcript-grouper.js.map