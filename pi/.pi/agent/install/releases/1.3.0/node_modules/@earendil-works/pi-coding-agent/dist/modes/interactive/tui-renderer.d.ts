import type { Terminal, WheelScrollLines } from "@earendil-works/pi-tui";
import { type TUI, TuiAltScreen, TuiMainScreen } from "@earendil-works/pi-tui";
export interface InteractiveTuiOptions {
    readonly tuiMode: "regular" | "fullscreen";
    readonly showHardwareCursor: boolean;
    readonly logDirectory: string;
    readonly terminal?: Terminal;
    readonly onRightClickPaste?: () => void;
    readonly fullscreenCopyOnSelect?: boolean;
    readonly fullscreenWheelScrollLines?: WheelScrollLines;
}
/** Composition root shared by coding-agent presentations. */
export declare function createInteractiveTui(options: InteractiveTuiOptions & {
    readonly tuiMode: "fullscreen";
}): TuiAltScreen;
export declare function createInteractiveTui(options: InteractiveTuiOptions & {
    readonly tuiMode: "regular";
}): TuiMainScreen;
export declare function createInteractiveTui(options: InteractiveTuiOptions): TuiMainScreen | TuiAltScreen;
/** Stable reference for components while InteractiveMode replaces the active renderer. */
export declare function createInteractiveTuiReference(getTui: () => TUI): TUI;
//# sourceMappingURL=tui-renderer.d.ts.map