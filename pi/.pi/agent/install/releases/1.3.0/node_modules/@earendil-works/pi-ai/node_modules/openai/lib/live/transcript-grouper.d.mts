import { EventEmitter } from "../../core/EventEmitter.mjs";
import type { ServerEvent } from "../../resources/live/live.mjs";
/** Options for the speaker-based transcript grouping policy. */
export interface TranscriptGrouperOptions {
    /** Minimum source-time gap before promoting buffered assistant text. Default: 500 ms. */
    minTurnSeparationMs?: number;
    /** Assistant transcript inactivity before closing a segment. Default: 2000 ms; not an audio/VAD signal. */
    assistantSilenceMs?: number;
    /** Acknowledgments shorter than this may be suppressed as backchannels. Default: 1000 ms; zero disables suppression. */
    backchannelMaxDurationMs?: number;
    /** Isolation window used to distinguish backchannels from assistant replies. Default: 2000 ms. */
    backchannelIsolationMs?: number;
    /** Extra phrases eligible for backchannel suppression, in addition to the built-in acknowledgments.
     * Normalized like transcript text (case, hyphens, whitespace, and surrounding punctuation).
     * Copied when the grouper is created; the same timing thresholds apply.
     */
    additionalAcknowledgments?: readonly string[];
}
/** An immutable SDK projection of spoken text, not a server conversation item. */
export interface TranscriptSegment {
    /** Stable ID local to this SDK projection; not a server turn or item ID. */
    readonly id: string;
    /** ID of the preceding emitted segment, or null for the first segment. */
    readonly previousId: string | null;
    /** Speaker whose transcript text was grouped. */
    readonly speaker: 'user' | 'assistant';
    /** Complete append-only text; replace the displayed text on each update. */
    readonly text: string;
    /** Start of the first contributing public transcript interval, in session milliseconds. */
    readonly startMs: number;
    /** Latest end of the contributing public transcript intervals; never a playback completion time. */
    readonly endMs: number;
}
/** Why a display segment was finalized; none of these proves audible speech completed. */
export type TranscriptSegmentCloseReason = 'speaker_change' | 'inactivity' | 'timestamp_reset' | 'session_closed' | 'manual';
/** A final segment snapshot and the reason it will receive no further updates. */
export interface TranscriptSegmentClosedEvent {
    /** The final immutable segment, including all previously emitted text. */
    readonly segment: TranscriptSegment;
    /** The local grouping decision that finalized the segment. */
    readonly reason: TranscriptSegmentCloseReason;
}
/** Events emitted by a TranscriptGrouper. */
export type TranscriptGrouperEvents = {
    /** First and subsequent complete snapshots of an emitted segment. */
    'segment.updated': (segment: TranscriptSegment) => void;
    /** Exactly one final snapshot per emitted segment; closed segments are never reopened. */
    'segment.closed': (event: TranscriptSegmentClosedEvent) => void;
};
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
export declare class TranscriptGrouper extends EventEmitter<TranscriptGrouperEvents> {
    private readonly grouping;
    private readonly seenIds;
    private pending;
    private timer;
    private anchor;
    private lastStartMs;
    private closed;
    private dispatching;
    private readonly updates;
    /** Create a grouper with speaker-based defaults. Invalid timing options throw OpenAIError. */
    constructor(options?: TranscriptGrouperOptions);
    /**
     * Consume one public Live event. Duplicate transcript event IDs and unrelated
     * event types are ignored. Empty text does not count as speech activity.
     * Malformed transcript fields or use after close() throw OpenAIError.
     */
    push(event: ServerEvent): void;
    /**
     * Flush buffered text according to the grouping policy, finalize all emitted
     * segments, and cancel timers. Idempotent; further push() calls fail. Does not
     * close the transport. Invoke before discarding the grouper at session teardown.
     */
    close(): void;
    private finish;
    private commit;
    private flushPending;
    private sourceNow;
    private clearTimer;
    private schedule;
    private dispatch;
}
//# sourceMappingURL=transcript-grouper.d.mts.map