import type { Terminal } from "./terminal.ts";
import { type Component, TuiBase, type TuiStopOptions, VIEWPORT_TUI, type ViewportTUI } from "./tui.ts";
import { type WheelScrollLines } from "./wheel-scroll.ts";
export interface TuiAltScreenOptions {
    /**
     * Logical lines moved for each mouse-wheel event (default: 1). `"auto"` accelerates fast wheel
     * spins on terminals that send one event per notch. Alt+wheel moves five times as far.
     */
    wheelScrollLines?: WheelScrollLines;
    /** Capture mouse events for viewport scrolling and application-owned text selection. */
    mouse?: boolean;
    /** Style a non-current transcript search match. */
    searchMatchStyle?: (text: string) => string;
    /** Style the current transcript search match. */
    searchCurrentMatchStyle?: (text: string) => string;
    /** Style a transcript search navigation button. */
    searchNavigationButtonStyle?: (text: string, hovered: boolean) => string;
    /**
     * Render a clickable jump-to-end label. It is centered on the last row of a follow-end
     * primary scroll view while that view is scrolled away from its end.
     */
    scrollToEndIndicator?: () => string;
    /** Open an OSC 8 hyperlink activated with a primary-button click. */
    openUrl?: (url: string) => void;
    /** Handle an unmodified secondary-button press for clipboard paste. Currently enabled on Windows only. */
    onRightClickPaste?: () => void;
    /** Automatically copy selected text to the clipboard on mouse release (default: true). */
    copyOnSelect?: boolean;
    /**
     * Copy selected text to the system clipboard. Return `true` on success, an error message to
     * display on failure, or `false` for a generic error. When omitted, the selection is copied
     * via an OSC 52 write.
     */
    copySelection?: (text: string) => Promise<boolean | string>;
}
/** Alternate-screen TUI with a scrollable, application-owned viewport. */
export declare class TuiAltScreen extends TuiBase implements ViewportTUI {
    readonly mode: "fullscreen";
    readonly [VIEWPORT_TUI]: true;
    private previousScreen;
    private lastDocument;
    private previousScreenWidth;
    private previousScreenHeight;
    private layoutRoot;
    private currentLayout;
    private readonly implicitDocument;
    private readonly implicitScrollView;
    private readonly flashes;
    private altScreenActive;
    private imageProtocol;
    private savedCapabilities?;
    private readonly uploadedKittyImages;
    private selectionAnchor?;
    private selectionFocus?;
    private selectionGranularity;
    private selectionInitialRange?;
    private lastClick?;
    private selectionDragPointer?;
    private selectionAutoScrollDirection;
    private selectionAutoScrollTimer?;
    private selectionPressActive;
    private scrollbarDrag?;
    private scrollbarHover?;
    private scrollToEndIndicatorRect?;
    private activeSearch?;
    private pressedUrl?;
    private selectionDragged;
    private mouseCapture?;
    private mousePressTarget?;
    private mousePressPoint?;
    private mousePressMoved;
    private lastComponentClick?;
    private readonly wheelScroll;
    private readonly mouseEnabled;
    private readonly searchMatchStyle;
    private readonly searchCurrentMatchStyle;
    private readonly searchNavigationButtonStyle;
    private readonly scrollToEndIndicator?;
    private readonly openUrl?;
    private readonly onRightClickPaste?;
    private copyOnSelect;
    private readonly copySelection?;
    constructor(terminal: Terminal, showHardwareCursor?: boolean, logDirectory?: string, options?: TuiAltScreenOptions);
    get viewportTop(): number;
    get isFollowingOutput(): boolean;
    setWheelScrollLines(lines: WheelScrollLines): void;
    getCopyOnSelect(): boolean;
    setCopyOnSelect(enabled: boolean): void;
    /** Whether the fullscreen viewport has a non-empty active text selection. */
    hasActiveSelection(): boolean;
    /** Copy the active fullscreen text selection, if any, using the configured selection clipboard path. */
    copyActiveSelectionToClipboard(): Promise<boolean>;
    /** Drop the text selection and multi-click history, e.g. before the host replaces the transcript. */
    resetTextSelection(): void;
    /** The lines of the last rendered frame, one per terminal row, as written to the terminal. */
    getScreenLines(): string[];
    setLayoutRoot(component: Component | undefined): void;
    render(width: number): string[];
    protected getMountedRoots(): readonly Component[];
    private getPrimaryScrollView;
    protected beforeTerminalStart(): void;
    protected beforeTerminalStop(_options: TuiStopOptions): void;
    protected afterTerminalStop(options: TuiStopOptions): void;
    private deleteKittyImages;
    private prepareKittyScreen;
    protected resetRenderState(): void;
    scrollBy(lines: number): void;
    scrollToTop(): void;
    scrollToBottom(): void;
    private scrollToPrompt;
    private toggleSearch;
    private closeSearch;
    private updateSearchQuery;
    private navigateSearch;
    private getSearchNavigationDirectionAt;
    private handleSearchMouseEvent;
    private refreshSearch;
    /** Show a transient message in the alternate-screen flash stack. */
    flash(message: string, durationMs?: number): void;
    private shouldDeferViewportInputToOverlay;
    private clearComponentMouseGesture;
    private handleViewportInput;
    private decodeMouseButton;
    private createMouseEvent;
    private dispatchMouseToLayout;
    private applyMouseDispatchResult;
    private dispatchMouseToTarget;
    private getComponentClickCount;
    private clearTextSelection;
    private handleMouseEvent;
    private parseWheelEvent;
    private routeWheel;
    private parseSgrMouseEvent;
    private handleRightClickPaste;
    private handleScrollToEndIndicatorMouseEvent;
    private getScrollbarTargetAt;
    private setScrollbarHover;
    private updateScrollbarHover;
    private stopScrollbarHover;
    private scrollScrollbarToPointer;
    private handleScrollbarMouseEvent;
    private stopScrollbarDrag;
    private getScrollSelectionPoint;
    private getSelectionPoint;
    private getSelectionSourceLine;
    private getWordSelection;
    private getLineSelection;
    private updateSelectionFocus;
    private getClickCount;
    private updateSelectionAutoScroll;
    private autoScrollSelection;
    private stopSelectionAutoScroll;
    private handleSelectionMouseEvent;
    private getSelectionBounds;
    private getSelectionColumns;
    private getActiveSelectionText;
    private copySelectionToClipboard;
    private copyTextToClipboard;
    private applySearchTextHighlight;
    private applySearchHighlights;
    private applySelectionHighlight;
    private applySelection;
    private isMouseSequence;
    private compositeScrollToEndIndicator;
    private compositeFlashes;
    protected doRender(): void;
}
//# sourceMappingURL=tui-alt-screen.d.ts.map