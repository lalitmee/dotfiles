/**
 * Presentation for the ls tool.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `ls.ts` spreads these into its
 * definition, so the tool's public shape is unchanged.
 */
import type { ToolDefinition } from "../../extensions/types.ts";
export declare const lsRenderers: Pick<ToolDefinition<any, any>, "renderCall" | "renderResult">;
//# sourceMappingURL=ls.d.ts.map