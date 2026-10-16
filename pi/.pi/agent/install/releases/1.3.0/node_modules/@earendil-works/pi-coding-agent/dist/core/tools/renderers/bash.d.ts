/**
 * Presentation for the shell tools.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `bash.ts` spreads these into the shell
 * tool definition, so the tool's public shape is unchanged.
 */
import type { ToolDefinition } from "../../extensions/types.ts";
export declare const BASH_UPDATE_THROTTLE_MS = 100;
/** Shell renderers are shared by bash and powershell, which differ only in the prompt they display. */
export declare function createShellRenderers(prompt: string): Pick<ToolDefinition<any, any>, "renderCall" | "renderResult">;
//# sourceMappingURL=bash.d.ts.map