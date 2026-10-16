import type { TerminalColors, TUI } from "@earendil-works/pi-tui";
import type { SettingsManager } from "../../../core/settings-manager.ts";
import { type TerminalTheme, type Theme } from "./theme.ts";
type ThemeResult = {
    success: boolean;
    error?: string;
};
/**
 * Query the terminal's colors and pass them to `apply` when the query completes or times out, and again
 * if the terminal answers after the timeout. A failed query applies no colors. Settles after the first apply.
 */
export declare function requestTerminalColors(ui: TUI, apply: (colors: TerminalColors) => void): Promise<void>;
/**
 * Applies the theme setting and keeps it in sync with the terminal. The theme applies immediately, and the
 * terminal's colors update it when they arrive; the system theme renders in grayscale until then. Callers
 * that bake theme colors into content can wait for the colors with `waitForTerminalColors()`.
 */
export declare class InteractiveThemeController {
    private readonly ui;
    private readonly getSettingsManager;
    private readonly showError;
    private readonly onChanged;
    private currentThemeSetting;
    private terminalColors;
    private activeThemeName;
    private autoSyncEnabled;
    private terminalColorSchemeUnsubscribe;
    private terminalColorQuery;
    constructor(ui: TUI, options: {
        getSettingsManager: () => SettingsManager;
        showError: (message: string) => void;
        onChanged: () => void;
        initialThemeSetting?: string;
    });
    rebindTui(): void;
    /**
     * Apply the theme setting now and query the terminal's colors, which update the theme when they arrive.
     * Theme pairs and the system theme follow terminal appearance changes.
     */
    applyFromSettings(): void;
    /**
     * Wait until the latest color query completed or timed out. Content that bakes theme colors into
     * strings, such as the startup header, should be built after this. Terminals answer the DA1 request
     * right after the color replies, so this only takes the full timeout when a terminal answers nothing.
     */
    waitForTerminalColors(): Promise<void>;
    getThemeSelection(): string | undefined;
    setThemeName(themeName: string, showError?: boolean): ThemeResult;
    setThemeSetting(themeSetting: string): void;
    setThemeInstance(themeInstance: Theme): ThemeResult;
    preview(themeSettingOrName: string): void;
    disableAutoSync(): void;
    dispose(): void;
    getTerminalTheme(): TerminalTheme;
    private getThemeSetting;
    /** The theme for the current setting and terminal appearance. Without a setting, pi uses the system theme. */
    private resolveThemeName;
    private applyThemeName;
    /** Query the terminal's colors without waiting for them; `waitForTerminalColors()` waits for this query. */
    private queryTerminalColors;
    /**
     * Record reported colors: themes use the default colors for tokens set to "", the system theme is
     * generated from all of them, and light/dark detection uses them. Re-renders only when they changed.
     */
    private applyTerminalColors;
    /**
     * Re-apply the setting after the terminal's colors or appearance changed: regenerate the system theme,
     * or switch the theme of a pair. Themes set through extensions or previews are left alone.
     */
    private reapplyForTerminal;
    private setAutoSync;
    private bindTerminalColorSchemeListener;
    /**
     * The terminal reported a light/dark switch. Its colors changed too, so query them again: they decide
     * the appearance. The reported scheme only matters for terminals that do not report their background.
     */
    private applyTerminalColorSchemeChange;
    private notifyChanged;
}
export {};
//# sourceMappingURL=theme-controller.d.ts.map