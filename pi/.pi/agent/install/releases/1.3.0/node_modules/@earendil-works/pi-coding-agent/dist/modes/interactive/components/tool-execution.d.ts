import { Container, type TUI, type TuiMouseEvent } from "@earendil-works/pi-tui";
import type { ToolDefinition, ToolRenderers } from "../../../core/extensions/types.ts";
/** What this component needs from a tool: how to draw it, without executing it. */
export type { ToolRenderers };
export interface ToolExecutionOptions {
    showImages?: boolean;
    imageWidthCells?: number;
    outputPad?: number;
}
export declare class ToolExecutionComponent extends Container {
    private contentBox;
    private contentText;
    private contentTextRegion;
    private selfRenderContainer;
    private selfRenderHeight;
    private callRendererComponent?;
    private resultRendererComponent?;
    private rendererState;
    private imageComponents;
    /** Inputs of imageComponents, so updateDisplay can reuse images and keep their converted PNG data. */
    private imageSources;
    private imageSpacers;
    private toolName;
    private toolCallId;
    private args;
    private expanded;
    private showImages;
    private imageWidthCells;
    private outputPad;
    private isPartial;
    private toolDefinition?;
    private ui;
    private cwd;
    private executionStarted;
    private argsComplete;
    private result?;
    private hideComponent;
    constructor(toolName: string, toolCallId: string, args: any, options: ToolExecutionOptions | undefined, toolDefinition: ToolRenderers | ToolDefinition<any, any, any> | undefined, ui: TUI, cwd: string);
    private getCallRenderer;
    private getResultRenderer;
    private hasRendererDefinition;
    private getRenderShell;
    private getRenderContext;
    private createCallFallback;
    private createResultFallback;
    private createResultRegion;
    updateArgs(args: any): void;
    markExecutionStarted(): void;
    setArgsComplete(): void;
    updateResult(result: {
        content: Array<{
            type: string;
            text?: string;
            data?: string;
            mimeType?: string;
        }>;
        details?: any;
        isError: boolean;
        /** Execution time of a final result. */
        durationMs?: number;
    }, isPartial?: boolean): void;
    setExpanded(expanded: boolean): void;
    setOutputPad(outputPad: number): void;
    setShowImages(show: boolean): void;
    setImageWidthCells(width: number): void;
    invalidate(): void;
    render(width: number): string[];
    handleMouse(event: TuiMouseEvent): ReturnType<Container["handleMouse"]>;
    private updateDisplay;
    private getTextOutput;
    private formatToolExecution;
}
//# sourceMappingURL=tool-execution.d.ts.map