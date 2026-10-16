import type { Component } from "./tui.ts";
export declare const LAYOUT_NODE: unique symbol;
export interface LayoutViewport {
    width: number;
    height: number;
}
export interface StackLayoutEntry {
    component: Component;
    basis?: number | "auto";
    grow?: number;
    shrink?: number;
    minSize?: number;
    maxSize?: number;
    visible?: (viewport: LayoutViewport) => boolean;
}
export interface StackLayoutNode {
    type: "vstack" | "hstack";
    entries: readonly StackLayoutEntry[];
    gap: number;
    align: "stretch" | "start" | "center" | "end";
}
export interface ScrollLayoutState {
    readonly scrollTop: number;
    readonly primary: boolean;
    readonly overscroll: "chain" | "contain";
    readonly viewportHeight: number;
    getContentWidth(width: number): number;
    updateLayout(contentHeight: number, viewportHeight: number, requestRender: () => void): void;
}
export interface ScrollLayoutNode {
    type: "scroll";
    component: Component;
    state: ScrollLayoutState;
}
export type LayoutNode = StackLayoutNode | ScrollLayoutNode;
export interface LayoutComponent extends Component {
    [LAYOUT_NODE](): LayoutNode;
}
export declare function getLayoutNode(component: Component): LayoutNode | undefined;
//# sourceMappingURL=layout-node.d.ts.map