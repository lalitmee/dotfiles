import type { Component } from "../tui.ts";
/** Transient messages composited by the alternate-screen renderer. */
export declare class AltScreenFlashContainer implements Component {
    private readonly entries;
    private nextId;
    private readonly requestRender;
    constructor(requestRender: () => void);
    flash(message: string, durationMs?: number): void;
    dispose(): void;
    invalidate(): void;
    render(width: number): string[];
}
//# sourceMappingURL=alt-screen-flash.d.ts.map