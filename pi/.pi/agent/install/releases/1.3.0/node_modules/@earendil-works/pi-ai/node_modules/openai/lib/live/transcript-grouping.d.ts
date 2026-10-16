import type { TranscriptGrouperOptions, TranscriptSegment, TranscriptSegmentCloseReason } from "./transcript-grouper.js";
export interface TranscriptFragment {
    speaker: 'user' | 'assistant';
    text: string;
    startMs: number;
    endMs: number;
}
export type GroupingUpdate = {
    type: 'updated';
    segment: TranscriptSegment;
} | {
    type: 'closed';
    segment: TranscriptSegment;
    reason: TranscriptSegmentCloseReason;
};
/** The v2 grouping policy, driven by timed public text rather than engine frames. */
export declare class TranscriptGrouping {
    private current;
    private buffered;
    private lastId;
    private nextId;
    private lastAssistantEnd;
    private readonly options;
    private readonly idPrefix;
    private readonly acknowledgments;
    private readonly maxAcknowledgmentLength;
    constructor(options: Required<TranscriptGrouperOptions>, idPrefix: string);
    get speaker(): TranscriptFragment['speaker'] | undefined;
    process(fragments: readonly TranscriptFragment[]): GroupingUpdate[];
    advance(timeMs: number, hasIncomingUser?: boolean): GroupingUpdate[];
    deadline(): number | undefined;
    close(timeMs: number, reason: TranscriptSegmentCloseReason): GroupingUpdate[];
    private ingest;
    private newTurn;
    private static append;
    private buffer;
    private promote;
    private finishCurrent;
    private finish;
    private emit;
    private static snapshot;
    private mightBeBackchannel;
    private userContinued;
    private recentAssistant;
    private keepBackchannel;
    private maybeDropBackchannel;
    private acknowledgment;
}
//# sourceMappingURL=transcript-grouping.d.ts.map