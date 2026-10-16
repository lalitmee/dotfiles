import type { ScrollView } from "./components/scroll-view.ts";
import { type Component } from "./tui.ts";
export interface LayoutRect {
    x: number;
    y: number;
    width: number;
    height: number;
}
export interface LayoutBox {
    component: Component;
    rect: LayoutRect;
    clip: LayoutRect;
    children: LayoutBox[];
    parent?: LayoutBox;
    lines?: readonly string[];
    lineOffset?: number;
    scrollView?: ScrollView;
    scrollContentLines?: readonly string[];
    layer: number;
}
export interface LayoutFrame {
    root: LayoutBox;
    width: number;
    height: number;
    lines: string[];
    primaryScrollView?: ScrollView;
}
export interface ScrollbarGeometry {
    column: number;
    trackTop: number;
    trackHeight: number;
    thumbTop: number;
    thumbHeight: number;
    maxScrollTop: number;
}
export declare function getScrollbarGeometry(box: LayoutBox, includeHiddenAuto?: boolean): ScrollbarGeometry | undefined;
export declare function renderLayoutFrame(root: Component, width: number, height: number, requestRender: () => void): LayoutFrame;
/** Return the visual hit path from the deepest component to the layout root. */
export declare function getLayoutBoxesAt(frame: LayoutFrame, x: number, y: number): LayoutBox[];
export declare function getScrollViewBox(frame: LayoutFrame, scrollView: ScrollView): LayoutBox | undefined;
export declare function getScrollViewsAt(frame: LayoutFrame, x: number, y: number): ScrollView[];
//# sourceMappingURL=layout.d.ts.map