import type { ProgramStatus, Terminal } from "@earendil-works/pi-tui";
import type { AgentSessionEvent } from "../../core/agent-session.ts";
export type BlockedStatus = {
    kind: NonNullable<ProgramStatus["kind"]>;
    message: string;
};
/**
 * Reports interactive-mode state to the terminal (OSC 7501): `working` during agent runs and
 * compaction, `blocked` while a dialog waits for the user, then `done`, `error`, or `idle` once the run
 * settles. Messages are limited to the session name, dialog titles, and the first line of errors; prompts
 * and assistant output are never reported.
 */
export declare class ProgramStatusReporter {
    private readonly getTerminal;
    private readonly getSessionName;
    private runActive;
    private compacting;
    /** Outcome of the current run, reported once it settles. */
    private runResult;
    /** Status while no run is active. */
    private restingStatus;
    /** Open dialogs by source, in the order they opened. The most recent one is reported. */
    private readonly blocked;
    private lastReport;
    constructor(getTerminal: () => Terminal, getSessionName: () => string | undefined);
    handleEvent(event: AgentSessionEvent): void;
    /** Report `blocked` for a dialog until it is cleared with `undefined`. Reopening a source replaces it. */
    setBlocked(source: string, status: BlockedStatus | undefined): void;
    /** Forget the previous session's run, for example after switching sessions. */
    reset(): void;
    report(): void;
    private currentStatus;
}
//# sourceMappingURL=program-status-reporter.d.ts.map