/**
 * Presentation for the write tool.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `write.ts` spreads these into its
 * definition, so the tool's public shape is unchanged.
 */
import type { ToolDefinition } from "../../extensions/types.ts";
export declare const writeRenderers: Pick<ToolDefinition<any, any>, "renderCall" | "renderResult">;
//# sourceMappingURL=write.d.ts.map