import { LAYOUT_NODE, type LayoutViewport, type StackLayoutEntry, type StackLayoutNode } from "../layout-node.ts";
import { type Component, Container } from "../tui.ts";
export interface StackEntryOptions {
    basis?: number | "auto";
    grow?: number;
    shrink?: number;
    minSize?: number;
    maxSize?: number;
    visible?: (viewport: LayoutViewport) => boolean;
}
export interface StackEntry extends StackEntryOptions {
    component: Component;
}
export type StackChild = Component | StackEntry;
export interface StackOptions {
    gap?: number;
    align?: "stretch" | "start" | "center" | "end";
}
export declare abstract class Stack extends Container {
    protected readonly entries: StackLayoutEntry[];
    protected readonly gap: number;
    protected readonly align: "stretch" | "start" | "center" | "end";
    protected abstract readonly layoutType: "vstack" | "hstack";
    constructor(children?: StackChild[], options?: StackOptions);
    addChild(component: Component, options?: StackEntryOptions): void;
    removeChild(component: Component): void;
    clear(): void;
    [LAYOUT_NODE](): StackLayoutNode;
}
export declare function visibleStackEntries(entries: readonly StackLayoutEntry[], viewport: LayoutViewport): StackLayoutEntry[];
export declare function allocateStackSizes(entries: readonly StackLayoutEntry[], intrinsicSizes: readonly number[], availableSize: number | undefined, gap: number): number[];
//# sourceMappingURL=stack.d.ts.map