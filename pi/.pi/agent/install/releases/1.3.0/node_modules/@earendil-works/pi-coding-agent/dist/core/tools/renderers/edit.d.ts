/**
 * Presentation for the edit tool.
 *
 * Renderers live apart from the implementation so a process that only displays tool output does not
 * load the execution path or its typebox parameter schema. `edit.ts` spreads these into its
 * definition, so the tool's public shape is unchanged.
 */
import { Box } from "@earendil-works/pi-tui";
import type { ToolDefinition } from "../../extensions/types.ts";
import { type EditDiffError, type EditDiffResult } from "../edit-diff.ts";
type EditPreview = EditDiffResult | EditDiffError;
export type EditRenderState = {
    callComponent?: EditCallRenderComponent;
};
type EditCallRenderComponent = Box & {
    preview?: EditPreview;
    previewArgsKey?: string;
    previewPending?: boolean;
    settledError?: boolean;
};
export declare const editRenderers: Pick<ToolDefinition<any, any>, "renderCall" | "renderResult">;
export {};
//# sourceMappingURL=edit.d.ts.map