import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import { type Color, type EditorTheme, type MarkdownTheme, type SelectListTheme, type SettingsListTheme, type TerminalColorMode, type TerminalColors, type TextAttributes } from "@earendil-works/pi-tui";
import type { SourceInfo } from "../../../core/source-info.ts";
import { type ThemeBg, type ThemeColor, type ThemeColorValues, type ThemeToken } from "./theme-tokens.ts";
export { SYSTEM_THEME_NAME } from "./system-theme.ts";
/** The schema that validates this shape lives in `theme-schema.ts`; importing the type is free. */
import type { ValidatedThemeJson as ThemeJson } from "./theme-schema.ts";
export type { ValidatedThemeJson as ThemeJson } from "./theme-schema.ts";
export type { ThemeBg, ThemeColor, ThemeToken } from "./theme-tokens.ts";
/**
 * Tokens are only accepted in their own slot, because "" (terminal default) means the default foreground
 * or background depending on the slot. Use `theme.colors[token]` to use a token's color in the other slot.
 */
export interface ThemeStyle extends TextAttributes {
    fg?: ThemeColor | Color;
    bg?: ThemeBg | Color;
}
export type ThemeJsonValidator = (label: string, json: unknown) => ThemeJson;
/**
 * Install full theme validation. Without it, documents are accepted as-is, which is what built-in
 * themes already do: validating user-authored JSON needs typebox, and a presentation that only uses
 * built-in themes should not pay ~17 MB of module graph for it.
 */
export declare function setThemeJsonValidator(validator: ThemeJsonValidator): void;
/** The background a theme is designed for. */
export type ThemeAppearance = TerminalTheme;
/**
 * Record the terminal's reported colors. Themes use the default colors for tokens set to "" (terminal
 * default); the system theme is generated from all of them. Ends the pending state.
 */
export declare function setTerminalColors(colors: TerminalColors): void;
/** Record the terminal's light/dark report, the fallback for terminals that do not report their background. */
export declare function setTerminalColorScheme(scheme: TerminalTheme | undefined): void;
/** Render the system theme in grayscale until `setTerminalColors()` reports the terminal's colors. */
export declare function markTerminalColorsPending(): void;
export declare class Theme {
    readonly name?: string;
    readonly sourcePath?: string;
    sourceInfo?: SourceInfo;
    private mode;
    private readonly fgAnsi;
    private readonly bgAnsi;
    private readonly concreteColors;
    private readonly defaultForegroundTokens;
    private readonly defaultBackgroundTokens;
    private readonly dimTokens;
    private readonly ownAppearance;
    private resolvedColors;
    constructor(fgColors: Pick<ThemeColorValues<string | number>, ThemeColor>, bgColors: Pick<ThemeColorValues<string | number>, ThemeBg>, mode: TerminalColorMode, options?: {
        name?: string;
        sourcePath?: string;
        sourceInfo?: SourceInfo;
        appearance?: ThemeAppearance;
        /** Foreground tokens to render faint (SGR 2). */
        dim?: readonly ThemeColor[];
    });
    /**
     * The background the theme is designed for: declared in the theme JSON, detected from its colors,
     * or, for themes without usable colors, the terminal's appearance.
     */
    get appearance(): ThemeAppearance;
    /**
     * Concrete colors for all tokens. Tokens set to "" (terminal default) use the terminal's reported
     * default colors, or a guess based on `appearance` when the terminal did not report them. Faint
     * tokens are approximated by mixing their color toward the background.
     */
    get colors(): Readonly<Record<ThemeToken, Color>>;
    style(text: string, options: ThemeStyle): string;
    fg(color: ThemeColor, text: string): string;
    bg(color: ThemeBg, text: string): string;
    private tokenAnsi;
    bold(text: string): string;
    italic(text: string): string;
    underline(text: string): string;
    inverse(text: string): string;
    strikethrough(text: string): string;
    /** Opening escape sequence for a foreground token. Faint tokens include SGR 2, which `\x1b[22m` closes. */
    getFgAnsi(color: ThemeColor): string;
    getBgAnsi(color: ThemeBg): string;
    getColorMode(): TerminalColorMode;
    getThinkingBorderColor(level: ThinkingLevel): (str: string) => string;
    getBashModeBorderColor(): (str: string) => string;
}
export declare function getAvailableThemes(): string[];
export interface ThemeInfo {
    name: string;
    path: string | undefined;
}
export declare function getAvailableThemesWithPaths(): ThemeInfo[];
export declare function loadThemeFromPath(themePath: string, mode?: TerminalColorMode): Theme;
export declare function getThemeByName(name: string): Theme | undefined;
export type TerminalTheme = "dark" | "light";
export declare function parseAutoThemeSetting(themeSetting: string | undefined): {
    lightTheme: string;
    darkTheme: string;
} | undefined;
export declare function resolveThemeSetting(themeSetting: string | undefined, terminalTheme: TerminalTheme): string | undefined;
/**
 * Dark or light from the `COLORFGBG` environment variable some terminals set, or undefined without a
 * usable background index. The value is `fg;bg` or `fg;xpm;bg` (rxvt), where a field is an ANSI color
 * index or `default` when the color is not in the palette. The index refers to the terminal's own palette,
 * whose colors are unknown here, so it is classified by index like Vim does: 0-6 and 8 (bright black, e.g.
 * Solarized Dark's background) are dark, 7 and 9-15 are light.
 */
export declare function detectColorFgBgTheme(env?: NodeJS.ProcessEnv): TerminalTheme | undefined;
/**
 * Whether the terminal is dark or light. The background it renders decides, classified the same way the
 * system theme does. Without a reported background: the terminal's light/dark report, then COLORFGBG,
 * then dark.
 */
export declare function detectTerminalTheme(colors?: TerminalColors, reportedScheme?: TerminalTheme, env?: NodeJS.ProcessEnv): TerminalTheme;
/** Whether the terminal is dark or light, from everything it reported so far. See `detectTerminalTheme()`. */
export declare function getTerminalTheme(): TerminalTheme;
export declare const theme: Theme;
export declare function setRegisteredThemes(themes: Theme[]): void;
export declare function initTheme(themeName?: string, enableWatcher?: boolean): void;
export declare function setTheme(name: string, enableWatcher?: boolean): {
    success: boolean;
    error?: string;
};
export declare function setThemeInstance(themeInstance: Theme): void;
export declare function onThemeChange(callback: () => void): void;
export declare function stopThemeWatcher(): void;
/**
 * Get resolved theme colors as CSS-compatible hex strings.
 * Used by HTML export to generate CSS custom properties.
 */
export declare function getResolvedThemeColors(themeName?: string): Record<string, string>;
/**
 * Check if a theme is a "light" theme (for CSS that needs light/dark variants).
 */
export declare function isLightTheme(themeName?: string): boolean;
/**
 * Get explicit export colors from theme JSON, if specified.
 * Returns undefined for each color that isn't explicitly set.
 */
export declare function getThemeExportColors(themeName?: string): {
    pageBg?: string;
    cardBg?: string;
    infoBg?: string;
};
/**
 * Highlight code with syntax coloring based on file extension or language.
 * Returns array of highlighted lines.
 */
export declare function highlightCode(code: string, lang?: string): string[];
/**
 * Get language identifier from file path extension.
 */
export declare function getLanguageFromPath(filePath: string): string | undefined;
export declare function getMarkdownTheme(): MarkdownTheme;
export declare function getSelectListTheme(): SelectListTheme;
export declare function getEditorTheme(): EditorTheme;
export declare function getSettingsListTheme(): SettingsListTheme;
//# sourceMappingURL=theme.d.ts.map