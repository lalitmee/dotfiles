/**
 * Minimal TUI implementation with differential rendering
 */
import type { Terminal } from "./terminal.ts";
import { type TerminalColorScheme, type TerminalColors } from "./terminal-colors.ts";
import { visibleWidth } from "./utils.ts";
/**
 * Component interface - all components must implement this
 */
export type TuiMouseEventType = "press" | "release" | "move" | "drag" | "click" | "wheel";
export type TuiMouseButton = "left" | "middle" | "right" | "none";
/** Normalized cell-based mouse event. Coordinates are zero-based. */
export interface TuiMouseEvent {
    type: TuiMouseEventType;
    button: TuiMouseButton;
    /** Coordinates local to the receiving component. */
    x: number;
    y: number;
    /** Absolute terminal coordinates. */
    screenX: number;
    screenY: number;
    /** Current component bounds. */
    width: number;
    height: number;
    shift: boolean;
    alt: boolean;
    ctrl: boolean;
    /** Logical lines. Negative values scroll up. */
    wheelDelta?: number;
    /** Consecutive click count when type is click. */
    clickCount?: number;
}
export interface TuiMouseEventResult {
    /** Stop propagation and suppress renderer-level fallback behavior. */
    handled?: boolean;
    /** Route subsequent drag/release events to this component. Implies handled. */
    capture?: boolean;
    /** Give keyboard focus to this component. Implies handled. */
    focus?: boolean;
    /**
     * Explicitly request or suppress a render. Move and release default to false;
     * press, click, drag, and wheel default to true.
     */
    render?: boolean;
}
/** Internal target metadata used by containers and alternate-screen dispatch. */
export interface TuiMouseDispatchTarget {
    component: Component;
    originX: number;
    originY: number;
    width: number;
    height: number;
}
/** Result of dispatching to a concrete component. */
export interface TuiMouseDispatchResult extends TuiMouseEventResult {
    handled: true;
    target: TuiMouseDispatchTarget;
    /** Keyboard focus target, which may be a delegating parent container. */
    focusTarget?: Component;
}
/**
 * Dispatch an event to a component and retain the exact target and coordinate
 * transform. Containers use this when forwarding events to nested children.
 */
export declare function dispatchMouseEvent(component: Component, event: TuiMouseEvent): TuiMouseDispatchResult | undefined;
/** Recreate local coordinates for a previously dispatched mouse target. */
export declare function retargetMouseEvent(event: TuiMouseEvent, target: TuiMouseDispatchTarget): TuiMouseEvent;
export interface Component {
    /**
     * Render the component to lines for the given viewport width
     * @param width - Current viewport width
     * @returns Array of strings, each representing a line
     */
    render(width: number): string[];
    /** Optional handler for keyboard input when component has focus. */
    handleInput?(data: string): void;
    /** Optional normalized mouse handler. */
    handleMouse?(event: TuiMouseEvent): TuiMouseEventResult | undefined;
    /**
     * If true, component receives key release events (Kitty protocol).
     * Default is false - release events are filtered out.
     */
    wantsKeyRelease?: boolean;
    /**
     * Invalidate any cached rendering state.
     * Called when theme changes or when component needs to re-render from scratch.
     */
    invalidate(): void;
}
export type TuiInputListenerResult = {
    consume?: boolean;
    data?: string;
} | undefined;
export type TuiInputListener = (data: string) => TuiInputListenerResult;
/**
 * Interface for components that can receive focus and display a hardware cursor.
 * When focused, the component should emit CURSOR_MARKER at the cursor position
 * in its render output. TUI will find this marker and position the hardware
 * cursor there for proper IME candidate window positioning.
 */
export interface Focusable {
    /** Set by TUI when focus changes. Component should emit CURSOR_MARKER when true. */
    focused: boolean;
}
/** Type guard to check if a component implements Focusable */
export declare function isFocusable(component: Component | null): component is Component & Focusable;
/**
 * Cursor position marker - APC (Application Program Command) sequence.
 * This is a zero-width escape sequence that terminals ignore.
 * Components emit this at the cursor position when focused.
 * TUI finds and strips this marker, then positions the hardware cursor there.
 */
export declare const CURSOR_MARKER = "\u001B_pi:c\u0007";
/** Fake cursor markers - zero-width APC sequences around the text drawn as the cursor. See resolveFakeCursors(). */
export declare const FAKE_CURSOR_START = "\u001B_pi:fc\u0007";
export declare const FAKE_CURSOR_END = "\u001B_pi:/fc\u0007";
/** Wrap text in fake cursor markers. */
export declare function renderFakeCursor(text: string): string;
export { visibleWidth };
/**
 * Anchor position for overlays
 */
export type OverlayAnchor = "center" | "top-left" | "top-right" | "bottom-left" | "bottom-right" | "top-center" | "bottom-center" | "left-center" | "right-center";
/**
 * Margin configuration for overlays
 */
export interface OverlayMargin {
    top?: number;
    right?: number;
    bottom?: number;
    left?: number;
}
/** Value that can be absolute (number) or percentage (string like "50%") */
export type SizeValue = number | `${number}%`;
/**
 * Options for overlay positioning and sizing.
 * Values can be absolute numbers or percentage strings (e.g., "50%").
 */
export interface OverlayOptions {
    /** Width in columns, or percentage of terminal width (e.g., "50%") */
    width?: SizeValue;
    /** Minimum width in columns */
    minWidth?: number;
    /** Maximum height in rows, or percentage of terminal height (e.g., "50%") */
    maxHeight?: SizeValue;
    /** Anchor point for positioning (default: 'center') */
    anchor?: OverlayAnchor;
    /** Horizontal offset from anchor position (positive = right) */
    offsetX?: number;
    /** Vertical offset from anchor position (positive = down) */
    offsetY?: number;
    /** Row position: absolute number, or percentage (e.g., "25%" = 25% from top) */
    row?: SizeValue;
    /** Column position: absolute number, or percentage (e.g., "50%" = centered horizontally) */
    col?: SizeValue;
    /** Margin from terminal edges. Number applies to all sides. */
    margin?: OverlayMargin | number;
    /**
     * Control overlay visibility based on terminal dimensions.
     * If provided, overlay is only rendered when this returns true.
     * Called each render cycle with current terminal dimensions.
     */
    visible?: (termWidth: number, termHeight: number) => boolean;
    /** If true, don't capture keyboard focus when shown */
    nonCapturing?: boolean;
}
/** Options for {@link OverlayHandle.unfocus}. */
export interface OverlayUnfocusOptions {
    /** Explicit target to focus after releasing this overlay. */
    target: Component | null;
}
/** Last rendered terminal-relative overlay rectangle. */
export interface OverlayBounds {
    row: number;
    col: number;
    width: number;
    height: number;
}
/**
 * Handle returned by showOverlay for controlling the overlay
 */
export interface OverlayHandle {
    /** Permanently remove the overlay (cannot be shown again) */
    hide(): void;
    /** Temporarily hide or show the overlay */
    setHidden(hidden: boolean): void;
    /** Check if overlay is temporarily hidden */
    isHidden(): boolean;
    /** Focus this overlay and bring it to the visual front */
    focus(): void;
    /** Release focus to the next visible capturing overlay or previous target, or to an explicit target when provided */
    unfocus(options?: OverlayUnfocusOptions): void;
    /** Check if this overlay currently has focus */
    isFocused(): boolean;
    /** Get the most recent rendered bounds for a visible overlay. */
    getBounds(): OverlayBounds | undefined;
}
/**
 * Container - a component that contains other components
 */
export declare class Container implements Component {
    children: Component[];
    private mouseLayout?;
    addChild(component: Component): void;
    removeChild(component: Component): void;
    clear(): void;
    invalidate(): void;
    handleMouse(event: TuiMouseEvent): TuiMouseDispatchResult | undefined;
    render(width: number): string[];
}
/** Composite overlay content into a terminal line at a fixed column. */
export declare function compositeTuiLine(baseLine: string, overlayLine: string, startCol: number, overlayWidth: number, totalWidth: number): string;
export type TuiMode = "regular" | "fullscreen";
export interface TuiStopOptions {
    /** Leave renderer output in place for another TUI taking over the same terminal. */
    preserveScreen?: boolean;
}
export interface TUI extends Component {
    readonly mode: TuiMode;
    children: Component[];
    terminal: Terminal;
    onDebug?: () => void;
    readonly fullRedraws: number;
    addChild(component: Component): void;
    removeChild(component: Component): void;
    clear(): void;
    getShowHardwareCursor(): boolean;
    setShowHardwareCursor(enabled: boolean): void;
    getClearOnShrink(): boolean;
    setClearOnShrink(enabled: boolean): void;
    setFocus(component: Component | null): void;
    showOverlay(component: Component, options?: OverlayOptions): OverlayHandle;
    hideOverlay(): void;
    hasOverlay(): boolean;
    start(): void;
    stop(options?: TuiStopOptions): void;
    renderNow(force?: boolean): void;
    requestRender(force?: boolean): void;
    addInputListener(listener: TuiInputListener): () => void;
    removeInputListener(listener: TuiInputListener): void;
    onTerminalColorSchemeChange(listener: (scheme: TerminalColorScheme) => void): () => void;
    setTerminalColorSchemeNotifications(enabled: boolean): void;
    queryTerminalColors(options: {
        timeoutMs: number;
        onLateReply?: (colors: TerminalColors) => void;
    }): Promise<TerminalColors>;
}
export declare const VIEWPORT_TUI: unique symbol;
export interface ViewportTUI extends TUI {
    readonly [VIEWPORT_TUI]: true;
    setLayoutRoot(component: Component | undefined): void;
}
export declare function isViewportTUI(tui: TUI): tui is ViewportTUI;
export declare abstract class TuiBase extends Container implements TUI {
    abstract readonly mode: TuiMode;
    terminal: Terminal;
    private focusedComponent;
    private inputListeners;
    /** Global callback for debug key (Shift+Ctrl+D). Called before input is forwarded to focused component. */
    onDebug?: () => void;
    private renderRequested;
    private immediateRenderScheduled;
    private renderTimer;
    private lastRenderAt;
    private static readonly MIN_RENDER_INTERVAL_MS;
    private showHardwareCursor;
    private clearOnShrink;
    protected fullRedrawCount: number;
    protected stopped: boolean;
    /**
     * Color queries waiting for their DA1 reply, oldest first. Terminals answer in order, so color
     * replies belong to the oldest one. Queries stay here after a timeout to collect late replies.
     */
    private pendingTerminalColorQueries;
    private terminalColorSchemeListeners;
    private terminalColorSchemeNotificationsEnabled;
    /** Directory for debug/crash logs. When undefined, debug logging is disabled and crash dumps fall back to the OS temp directory. */
    protected readonly logDirectory: string | undefined;
    private focusOrderCounter;
    private overlayStack;
    private renderedOverlayLayouts;
    get hasOverlayEntries(): boolean;
    private overlayFocusRestore;
    constructor(terminal: Terminal, showHardwareCursor?: boolean, logDirectory?: string);
    protected abstract doRender(): void;
    protected resetRenderState(): void;
    protected beforeTerminalStart(): void;
    protected afterTerminalStart(): void;
    protected beforeTerminalStop(_options: TuiStopOptions): void;
    protected afterTerminalStop(_options: TuiStopOptions): void;
    get fullRedraws(): number;
    getShowHardwareCursor(): boolean;
    setShowHardwareCursor(enabled: boolean): void;
    getClearOnShrink(): boolean;
    /**
     * Set whether to trigger full re-render when content shrinks.
     * When true, empty rows are cleared when content shrinks.
     * When false (default), empty rows remain (reduces redraws on slower terminals).
     */
    setClearOnShrink(enabled: boolean): void;
    getFocusedComponent(): Component | null;
    setFocus(component: Component | null): void;
    private setFocusInternal;
    private clearOverlayFocusRestore;
    private clearOverlayFocusRestoreFor;
    private resolveBlockedOverlayFocusResume;
    private getVisibleOverlayFocusRestore;
    private isOverlayFocusAncestor;
    private retargetOverlayPreFocus;
    protected getMountedRoots(): readonly Component[];
    private isComponentMounted;
    private containsComponent;
    /**
     * Show an overlay component with configurable positioning and sizing.
     * Returns a handle to control the overlay's visibility.
     */
    showOverlay(component: Component, options?: OverlayOptions): OverlayHandle;
    /** Hide the topmost overlay and restore previous focus. */
    hideOverlay(): void;
    /** Hide the cursor while running. After stop(), the shell owns the cursor and it must stay visible. */
    private hideTerminalCursor;
    /** Check if there are any visible overlays */
    hasOverlay(): boolean;
    /** Check if the focused component is a visible overlay */
    protected isOverlayFocused(): boolean;
    /** Keep overlay containers as keyboard focus owners when a nested control is clicked. */
    protected resolveMouseFocusTarget(component: Component): Component;
    /** Dispatch to the visually topmost overlay under the pointer. */
    protected dispatchMouseToOverlay(event: TuiMouseEvent): {
        hit: boolean;
        result?: TuiMouseDispatchResult;
    };
    /** Check if an overlay entry is currently visible */
    private isOverlayVisible;
    /** Find the visual-frontmost visible capturing overlay, if any */
    private getTopmostVisibleOverlay;
    invalidate(): void;
    start(): void;
    addInputListener(listener: TuiInputListener): () => void;
    removeInputListener(listener: TuiInputListener): void;
    onTerminalColorSchemeChange(listener: (scheme: TerminalColorScheme) => void): () => void;
    setTerminalColorSchemeNotifications(enabled: boolean): void;
    private queryCellSize;
    stop(options?: TuiStopOptions): void;
    renderNow(force?: boolean): void;
    requestRender(force?: boolean): void;
    private requestImmediateRender;
    private cancelRenderTimer;
    private scheduleRender;
    private handleTerminalInput;
    private consumeTerminalColorResponse;
    private terminalColorQueryResult;
    private completeTerminalColorQuery;
    private consumeTerminalColorSchemeReport;
    private consumeCellSizeResponse;
    /**
     * Resolve overlay layout from options.
     * Returns { width, row, col, maxHeight } for rendering.
     */
    private resolveOverlayLayout;
    private resolveAnchorRow;
    private resolveAnchorCol;
    /** Composite all overlays into content lines (sorted by focusOrder, higher = on top). */
    protected compositeOverlays(lines: string[], termWidth: number, termHeight: number): string[];
    protected applyLineResets(lines: string[]): string[];
    private compositeLineAt;
    /**
     * Find and extract cursor position from rendered lines.
     * Searches for CURSOR_MARKER, calculates its position, and strips it from the output.
     * Only scans the bottom terminal height lines (visible viewport).
     * @param lines - Rendered lines to search
     * @param height - Terminal height (visible viewport size)
     * @returns Cursor position { row, col } or null if no marker found
     */
    protected extractCursorPosition(lines: string[], height: number): {
        row: number;
        col: number;
    } | null;
    /**
     * Resolve fake cursor markers to reverse video. When the hardware cursor is shown, a fake cursor
     * directly after CURSOR_MARKER is dropped because the terminal cursor is drawn there. Fake cursors
     * of components without focus have no CURSOR_MARKER and stay visible.
     */
    protected resolveFakeCursors(lines: string[]): string[];
    /**
     * Query the terminal's theme colors: the default foreground (OSC 10), the default background
     * (OSC 11), and ANSI colors 0-15 (OSC 4), followed by a DA1 request that marks the end of the
     * replies. Resolves when the DA1 reply or all color replies arrive, or when the timeout expires.
     * Colors the terminal did not report are undefined; the palette is only set when all 16 arrived.
     * @param timeoutMs Query timeout in milliseconds, for terminals that do not answer DA1 either.
     * @param onLateReply Receives the replies if the query completes after the timeout, e.g. over slow links.
     */
    queryTerminalColors({ timeoutMs, onLateReply, }: {
        timeoutMs: number;
        onLateReply?: (colors: TerminalColors) => void;
    }): Promise<TerminalColors>;
}
//# sourceMappingURL=tui.d.ts.map