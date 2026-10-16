import type { ImageContent, TextContent } from "@earendil-works/pi-ai";
import type { Theme } from "../../modes/interactive/theme/theme.ts";
import type { ToolRenderContext } from "../extensions/types.ts";
export declare function shortenPath(path: unknown): string;
export declare function linkPath(styledText: string, rawPath: string, cwd: string): string;
export declare function str(value: unknown): string | null;
/** Format finite numbers or numeric strings as a read line range, omitting malformed ranges. */
export declare function formatReadLineRange(offset: unknown, limit: unknown): string;
export declare function replaceTabs(text: string): string;
export declare function normalizeDisplayText(text: string): string;
export declare function getTextOutput(result: {
    content: Array<{
        type: string;
        text?: string;
        data?: string;
        mimeType?: string;
    }>;
} | undefined, showImages: boolean): string;
export type ToolRenderResultLike<TDetails> = {
    content: (TextContent | ImageContent)[];
    details: TDetails;
};
/**
 * Generic tool call header: the title followed by the arguments. Collapsed, they are `key=value`
 * pairs on the title line, cut to {@link COLLAPSED_ARGS_CHARS}. Expanded, each is a `key: value`
 * line below the title, with strings shown raw and continuation lines indented.
 */
export declare function formatToolCallWithArgs(title: string, args: unknown, theme: Theme, expanded: boolean): string;
/** Duration as `4.2s` below a minute, then `1m 30s` and `2h 3m 4s`. */
export declare function formatToolDuration(ms: number): string;
/** Renderer state of {@link startToolTimer} and {@link toolTimerText}, kept in `ToolRenderContext.state`. */
interface ToolTimerState {
    startedAt?: number;
    endedAt?: number;
    interval?: ReturnType<typeof setInterval>;
}
/** Start the row's clock once execution starts. Call from `renderCall`. */
export declare function startToolTimer(context: ToolRenderContext<ToolTimerState>): void;
/**
 * The row's timing line, from `renderResult`: `Elapsed 4.2s` while the result is partial, redrawn
 * every second, and `Took 4.2s` once it is final. Undefined when the row has no start time and no
 * recorded duration.
 */
export declare function toolTimerText(context: ToolRenderContext<ToolTimerState>, isPartial: boolean): string | undefined;
export declare function invalidArgText(theme: Theme): string;
export declare function renderToolPath(rawPath: string | null, theme: Theme, cwd: string, options?: {
    emptyFallback?: string;
}): string;
export {};
//# sourceMappingURL=render-utils.d.ts.map