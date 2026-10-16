export interface RgbColor {
    r: number;
    g: number;
    b: number;
}
export type TerminalColorScheme = "dark" | "light";
/** Colors the terminal reports for its current theme. */
export interface TerminalColors {
    /** Default foreground (OSC 10). */
    foreground?: RgbColor;
    /** Default background (OSC 11). */
    background?: RgbColor;
    /** ANSI colors 0-15 (OSC 4). Only set when the terminal reported all 16. */
    palette?: RgbColor[];
}
/** What an OSC color reply reports: the default foreground (OSC 10), background (OSC 11), or a palette index (OSC 4). */
export type OscColorTarget = "foreground" | "background" | number;
/**
 * Parse an OSC 10, 11, or 4 color reply. Returns undefined when `data` is not such a reply;
 * `rgb` is undefined when it is a reply with an unparseable color.
 */
export declare function parseOscColorResponse(data: string): {
    target: OscColorTarget;
    rgb: RgbColor | undefined;
} | undefined;
export declare function parseTerminalColorSchemeReport(data: string): TerminalColorScheme | undefined;
//# sourceMappingURL=terminal-colors.d.ts.map