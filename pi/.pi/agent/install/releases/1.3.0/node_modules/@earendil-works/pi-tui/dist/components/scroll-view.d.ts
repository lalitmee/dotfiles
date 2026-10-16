import { LAYOUT_NODE, type ScrollLayoutNode } from "../layout-node.ts";
import { type Component, Container } from "../tui.ts";
export type ScrollViewScrollbar = "hidden" | "auto" | "always";
export interface ScrollViewOptions {
    axis?: "vertical";
    follow?: "none" | "end";
    primary?: boolean;
    overscroll?: "chain" | "contain";
    scrollbar?: ScrollViewScrollbar;
    scrollbarTrackStyle?: (text: string) => string;
    scrollbarThumbStyle?: (text: string) => string;
    scrollbarHideDelayMs?: number;
}
export interface ScrollViewScrollToOptions {
    /** Keep follow-end disabled even when the target is the current content end. */
    disableFollow?: boolean;
}
export declare class ScrollView extends Container {
    private readonly child;
    readonly followEnd: boolean;
    readonly primary: boolean;
    readonly overscroll: "chain" | "contain";
    readonly scrollbarTrackStyle: (text: string) => string;
    readonly scrollbarThumbStyle: (text: string) => string;
    private currentScrollbar;
    private readonly scrollbarHideDelayMs;
    private currentScrollTop;
    private contentHeight;
    private currentViewportHeight;
    private followingEnd;
    private followSuppressedAtEnd;
    private requestRenderCallback;
    private transientScrollbarVisible;
    private scrollbarActive;
    private scrollbarHideTimer;
    constructor(component: Component, options?: ScrollViewOptions);
    get scrollTop(): number;
    get isFollowingEnd(): boolean;
    get viewportHeight(): number;
    get scrollbar(): ScrollViewScrollbar;
    get isScrollbarVisible(): boolean;
    get isScrollbarActive(): boolean;
    setScrollbar(scrollbar: ScrollViewScrollbar): void;
    getContentWidth(width: number): number;
    private markScrollbarActivity;
    private hideTransientScrollbar;
    setScrollbarActive(active: boolean): void;
    scrollTo(scrollTop: number, options?: ScrollViewScrollToOptions): void;
    scrollBy(lines: number): number;
    scrollToStart(): void;
    scrollToEnd(): void;
    updateLayout(contentHeight: number, viewportHeight: number, requestRender: () => void): void;
    addChild(_component: Component): void;
    removeChild(_component: Component): void;
    clear(): void;
    render(width: number): string[];
    [LAYOUT_NODE](): ScrollLayoutNode;
}
//# sourceMappingURL=scroll-view.d.ts.map