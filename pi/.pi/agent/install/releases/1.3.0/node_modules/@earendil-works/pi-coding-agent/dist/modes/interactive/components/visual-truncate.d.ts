/**
 * Shared utility for truncating text to visual lines (accounting for line wrapping).
 * Used by tool renderers and bash-execution.ts for consistent behavior.
 */
import { type Component } from "@earendil-works/pi-tui";
export interface VisualTruncateResult {
    /** The visual lines to display */
    visualLines: string[];
    /** Number of visual lines that were skipped (hidden) */
    skippedCount: number;
}
/**
 * Truncate text to a maximum number of visual lines.
 * This accounts for line wrapping based on terminal width.
 *
 * @param text - The text content (may contain newlines)
 * @param maxVisualLines - Maximum number of visual lines to show
 * @param width - Terminal/render width
 * @param paddingX - Horizontal padding for Text component (default 0).
 *                   Use 0 when result will be placed in a Box (Box adds its own padding).
 *                   Use 1 when result will be placed in a plain Container.
 * @param keep - Which visual lines to keep: the last ones (default) or the first ones.
 * @returns The truncated visual lines and count of skipped lines
 */
export declare function truncateToVisualLines(text: string, maxVisualLines: number, width: number, paddingX?: number, keep?: "start" | "end"): VisualTruncateResult;
export interface VisualLinePreviewOptions {
    /** Styled text; may contain newlines. */
    text: string;
    maxVisualLines: number;
    /** Which visual lines to keep. The hint goes before kept end lines and after kept start lines. */
    keep: "start" | "end";
    /** Styled hint line for the given number of hidden visual lines. */
    formatHint: (hidden: number) => string;
}
/**
 * Collapsed tool output limited to a number of visual lines, like bash output. Limiting logical
 * lines instead lets a single long line (such as minified JSON) wrap across the whole screen.
 * Caches its lines per width, since it renders on every frame for every result in the transcript.
 */
export declare class VisualLinePreview implements Component {
    private options;
    private cachedWidth;
    private cachedLines;
    constructor(options: VisualLinePreviewOptions);
    render(width: number): string[];
    invalidate(): void;
}
//# sourceMappingURL=visual-truncate.d.ts.map