/**
 * The `/mcp` manager view: menus that rebuild while servers connect, a read-only status screen, and
 * the sign-in screen that accepts a pasted redirect URL.
 */
import { type Component, type Focusable, type SelectItem, type TUI } from "@earendil-works/pi-tui";
import type { ExtensionCommandContext } from "../../core/extensions/types.ts";
import type { KeybindingsManager } from "../../core/keybindings.ts";
import { type Theme } from "../../modes/interactive/theme/theme.ts";
export interface McpMenu {
    title: string;
    /** Shown below the title. */
    details?: string;
    /** Shown below the details in the error color. */
    error?: string;
    items: SelectItem[];
    /** Shown when there are no items. */
    empty?: string;
    /** Value of the item selected when the menu opens. */
    selected?: string;
    /** What the confirm key does, for the key hint. */
    confirmLabel: string;
    /** What the cancel key does, for the key hint. */
    cancelLabel: string;
}
export interface McpUi {
    /**
     * Show a menu and resolve to the chosen item's value, or undefined when cancelled. `subscribe`
     * rebuilds the menu on every change, keeping the selected item.
     */
    menu(build: () => McpMenu, subscribe?: (listener: () => void) => () => void): Promise<string | undefined>;
    /** Show a message while an operation runs. With `onCancel`, the cancel key calls it. */
    status(title: string, message: string, onCancel?: () => void): void;
    /**
     * Show the authorization URL and wait for a pasted redirect URL. Resolves to undefined when
     * cancelled or when `signal` aborts (the browser reached the callback).
     */
    redirectUrl(title: string, authorizationUrl: string, signal: AbortSignal): Promise<string | undefined>;
}
export declare class McpManagerView implements McpUi, Component, Focusable {
    private readonly tui;
    private readonly theme;
    private readonly keybindings;
    private content;
    private inputHandler;
    private inputTarget;
    private _focused;
    constructor(tui: TUI, theme: Theme, keybindings: KeybindingsManager);
    get focused(): boolean;
    set focused(value: boolean);
    private setContent;
    menu(build: () => McpMenu, subscribe?: (listener: () => void) => () => void): Promise<string | undefined>;
    status(title: string, message: string, onCancel?: () => void): void;
    redirectUrl(title: string, authorizationUrl: string, signal: AbortSignal): Promise<string | undefined>;
    handleInput(data: string): void;
    render(width: number): string[];
    invalidate(): void;
}
/** Run `manage` in the manager view until it returns. */
export declare function showMcpManager(ctx: ExtensionCommandContext, manage: (ui: McpUi) => Promise<void>): Promise<void>;
//# sourceMappingURL=ui.d.ts.map