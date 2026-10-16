import { type TUI, TuiBase, type TuiStopOptions } from "./tui.ts";
export interface TuiMainScreenRenderState {
    previousLines: string[];
    previousWidth: number;
    previousHeight: number;
    cursorRow: number;
    hardwareCursorRow: number;
    maxLinesRendered: number;
    previousViewportTop: number;
}
/** TUI implementation that renders into the terminal's main screen and scrollback. */
export declare class TuiMainScreen extends TuiBase implements TUI {
    readonly mode: "regular";
    private previousLines;
    private previousKittyImageIds;
    private previousWidth;
    private previousHeight;
    private cursorRow;
    private hardwareCursorRow;
    private maxLinesRendered;
    private previousViewportTop;
    captureRenderState(): TuiMainScreenRenderState;
    restoreRenderState(state: TuiMainScreenRenderState): void;
    protected resetRenderState(): void;
    protected beforeTerminalStop(options: TuiStopOptions): void;
    private collectKittyImageIds;
    private deleteKittyImages;
    private getKittyImageReservedRows;
    private expandChangedRangeForKittyImages;
    private deleteChangedKittyImages;
    protected doRender(): void;
    /**
     * Position the hardware cursor for IME candidate window.
     * @param cursorPos The cursor position extracted from rendered output, or null
     * @param totalLines Total number of rendered lines
     */
    private positionHardwareCursor;
}
//# sourceMappingURL=tui-main-screen.d.ts.map