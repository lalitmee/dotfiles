/** Lines moved per mouse-wheel event, or `"auto"` to accelerate fast wheel spins. */
export type WheelScrollLines = number | "auto";
/**
 * Converts wheel events into line counts.
 *
 * In `"auto"` mode on terminals that do not accelerate wheel input, the count follows event
 * velocity: an isolated notch moves one line, while a fast spin moves up to six lines per event.
 * For example, notches 100 ms apart move 1 line each, 50 ms apart move 2, and 20 ms apart move 5.
 */
export declare class WheelScrollAccelerator {
    private lines;
    private readonly accelerate;
    private lastTime;
    private lastDirection;
    private averageGap;
    private carry;
    constructor(lines?: WheelScrollLines, accelerate?: boolean);
    setLines(lines: WheelScrollLines): void;
    /** Return the positive line count for a wheel event in `direction` at time `now` (milliseconds). */
    next(direction: -1 | 1, now: number): number;
    private reset;
}
//# sourceMappingURL=wheel-scroll.d.ts.map