import { type Component, type TuiMouseDispatchResult, type TuiMouseEvent, type TuiMouseEventResult } from "../tui.ts";
export type MouseRegionHandler = (event: TuiMouseEvent) => TuiMouseEventResult | undefined;
/** Adds mouse handling to an existing component without changing its rendering. */
export declare class MouseRegion implements Component {
    private readonly child;
    private readonly onMouse;
    constructor(child: Component, onMouse: MouseRegionHandler);
    render(width: number): string[];
    handleMouse(event: TuiMouseEvent): TuiMouseDispatchResult | TuiMouseEventResult | undefined;
    invalidate(): void;
}
//# sourceMappingURL=mouse-region.d.ts.map