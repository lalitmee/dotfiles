/**
 * Presentation for the codemode tool.
 *
 * The call shows the script; the result lists the nested tool calls with their status as they
 * run and the cost of its model calls, followed by the script output without the "Script completed"
 * header, and the time the script has been running (`Elapsed`) or took (`Took`), like bash rows.
 * Nested calls are not separate tool rows because they never reach the model as tool calls.
 */
import type { ToolDefinition } from "../../core/extensions/types.ts";
import type { CodemodeToolDetails } from "./tool.ts";
export declare const codemodeRenderers: Pick<ToolDefinition<any, CodemodeToolDetails | undefined>, "renderCall" | "renderResult">;
//# sourceMappingURL=renderer.d.ts.map