import type { RgbColor } from "./terminal-colors.ts";
export interface IndexedColor {
    readonly kind: "indexed";
    readonly index: number;
}
export interface RgbColorValue {
    readonly kind: "rgb";
    readonly r: number;
    readonly g: number;
    readonly b: number;
}
export interface OklchColorValue {
    readonly kind: "oklch";
    readonly l: number;
    readonly c: number;
    readonly h: number;
}
/** A concrete color. Every color can be converted to sRGB, so color math never fails. */
export type Color = IndexedColor | RgbColorValue | OklchColorValue;
export type TerminalColorMode = "256color" | "truecolor";
export type ColorMixSpace = "oklch" | "srgb";
export interface OklchChannels {
    l: number;
    c: number;
    h: number;
}
/**
 * OKHSL channels: hue in degrees, saturation and lightness 0-1. Saturation is relative to the most the
 * sRGB gamut allows at that hue and lightness, so every value is in gamut.
 */
export interface OkhslChannels {
    h: number;
    s: number;
    l: number;
}
export interface TextAttributes {
    bold?: boolean;
    dim?: boolean;
    italic?: boolean;
    underline?: boolean;
    inverse?: boolean;
    strikethrough?: boolean;
}
export interface TextStyle extends TextAttributes {
    fg?: Color;
    bg?: Color;
}
export declare function indexedColor(index: number): IndexedColor;
export declare function rgbColor(r: number, g: number, b: number): RgbColorValue;
export declare function oklchColor(l: number, c: number, h: number): OklchColorValue;
/**
 * An OKHSL color, converted to sRGB. Saturation is relative to the sRGB gamut at the hue and lightness,
 * so equal saturation looks equally colorful across hues and lightness.
 * @param h Hue in degrees.
 * @param s Saturation, 0-1.
 * @param l Lightness, 0-1.
 */
export declare function okhslColor(h: number, s: number, l: number): RgbColorValue;
export declare function colorToOkhsl(color: Color): OkhslChannels;
export declare function parseColor(value: string | number): Color;
export declare function colorToRgb(color: Color): RgbColor;
export declare function colorToOklch(color: Color): OklchChannels;
export declare function colorToHex(color: Color): string;
export declare function mixColors(first: Color, second: Color, amount: number, space?: ColorMixSpace): Color;
export declare function foregroundAnsi(color: Color, mode: TerminalColorMode): string;
export declare function backgroundAnsi(color: Color, mode: TerminalColorMode): string;
export declare function styleText(text: string, options: TextStyle, mode: TerminalColorMode): string;
/**
 * Like `styleText()`, but with precomputed color escape sequences, e.g. cached theme colors.
 * Colors in `options` are ignored.
 */
export declare function styleTextWithAnsi(text: string, fgAnsi: string | undefined, bgAnsi: string | undefined, options: TextAttributes): string;
//# sourceMappingURL=colors.d.ts.map