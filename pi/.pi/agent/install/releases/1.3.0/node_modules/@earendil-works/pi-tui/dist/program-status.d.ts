/**
 * Program Status Protocol (OSC 7501): a program tells the terminal whether it is idle, working,
 * blocked on the user, done, or failed. Only the root record is supported.
 *
 * Spec: https://www.superlogical.com/rex/docs/build/program-status
 */
export interface ProgramStatus {
    /** `clear` removes the status instead of reporting one. */
    state: "idle" | "working" | "blocked" | "done" | "error" | "clear";
    /** Stable program name, `[A-Za-z0-9_.+-]{1,32}`. Other values are omitted. */
    app?: string;
    /** What a blocked program waits for. Omitted for other states. */
    kind?: "permission" | "question" | "auth";
    /** One human-readable line. Control characters become spaces; longer text is cut to the spec limit. */
    message?: string;
}
/** Feature detection query. A supporting terminal replies with the same body. */
export declare const PROGRAM_STATUS_QUERY = "\u001B]7501;?\u001B\\";
/** The reply to {@link PROGRAM_STATUS_QUERY}. Later spec revisions may add pairs after the `?`. */
export declare function isProgramStatusReply(sequence: string): boolean;
/** Encode a status report. Terminals discard reports whose text contains control characters, so they are replaced. */
export declare function formatProgramStatus(status: ProgramStatus): string;
//# sourceMappingURL=program-status.d.ts.map