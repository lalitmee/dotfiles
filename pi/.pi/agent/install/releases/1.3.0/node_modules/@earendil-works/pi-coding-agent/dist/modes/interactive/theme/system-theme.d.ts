/**
 * The `system` theme: pi's colors derived from the terminal's own theme.
 *
 * Every token belongs to a color family (its hue) and has contrast rules: it must reach a contrast level
 * on the background and on the panels it is drawn on. Hue and saturation come from the terminal's palette
 * color for the family's ANSI slot, or from the family's own hue when the terminal reports no palette.
 * Lightness comes from the rules alone. Colors are built in OKHSL, whose saturation is relative to the
 * sRGB gamut, and fade toward gray near black and white. A palette color never gains OKLCH chroma when it
 * moves to another lightness, so pastel palettes stay pastel.
 *
 * A contrast level is a target-lightness curve: the OKLab lightness a token needs, given the lightness of
 * the surface below it. The curves were fitted to the reference theme design from the "Pi themes: system
 * and light/dark" review. On dark backgrounds they aim for nearly fixed lightness; on light backgrounds the
 * required difference grows as the background darkens.
 *
 * Depending on what the terminal reports, the theme is generated in one of three tiers:
 * - background and palette: hues from the palette, lightness from the background;
 * - background only: the families' own hues, lightness from the background;
 * - nothing: ANSI palette indices and the default colors, which the terminal renders itself.
 */
import { type RgbColor } from "@earendil-works/pi-tui";
import type { ThemeAppearance, ThemeColor, ThemeToken } from "./theme.ts";
export declare const SYSTEM_THEME_NAME = "system";
export interface SystemThemeInput {
    foreground?: RgbColor;
    background?: RgbColor;
    /** ANSI colors 0-15. */
    palette?: RgbColor[];
    /** Saturation multiplier from 0 (grayscale) to 1. The first frame renders in grayscale until colors arrive. */
    saturation?: number;
    /** Appearance when the terminal did not report its background, e.g. from its light/dark report or COLORFGBG. */
    appearanceHint?: ThemeAppearance;
}
export interface SystemThemeColors {
    /** Hex colors, ANSI palette indices, or "" for the terminal default. */
    colors: Record<ThemeToken, string | number>;
    /** Foreground tokens rendered faint (SGR 2), for terminals that did not report colors. */
    dim: ThemeColor[];
    appearance: ThemeAppearance | undefined;
}
/** WCAG 2 relative luminance. */
export declare function relativeLuminance({ r, g, b }: RgbColor): number;
/** WCAG 2 contrast ratio, 1-21. */
export declare function wcagContrast(first: RgbColor, second: RgbColor): number;
/**
 * Whether a terminal is dark or light, from its reported colors: the direction of its own foreground
 * when text can be readable that way, otherwise dark when white text has more contrast on the
 * background than black text.
 */
export declare function terminalAppearance(background: RgbColor, foreground?: RgbColor): ThemeAppearance;
/**
 * Generate the system theme's colors from the terminal's reported colors.
 */
export declare function generateSystemThemeColors(input: SystemThemeInput): SystemThemeColors;
//# sourceMappingURL=system-theme.d.ts.map