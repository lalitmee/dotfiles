/**
 * Presentation for the read tool.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `read.ts` spreads these into its
 * definition, so the tool's public shape is unchanged.
 */
import type { ToolDefinition } from "../../extensions/types.ts";
import type { ReadToolDetails } from "../read.ts";
export declare const readRenderers: Pick<ToolDefinition<any, ReadToolDetails | undefined>, "renderCall" | "renderResult">;
//# sourceMappingURL=read.d.ts.map