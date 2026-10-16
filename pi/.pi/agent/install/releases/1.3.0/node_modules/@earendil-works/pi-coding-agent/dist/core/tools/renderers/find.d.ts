/**
 * Presentation for the find tool.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `find.ts` spreads these into its
 * definition, so the tool's public shape is unchanged.
 */
import type { ToolDefinition } from "../../extensions/types.ts";
export declare const findRenderers: Pick<ToolDefinition<any, any>, "renderCall" | "renderResult">;
//# sourceMappingURL=find.d.ts.map