/**
 * Oklab and OKHSL <-> sRGB conversion. `colors.ts` builds its OKLCH, OKHSL, and color mixing on it.
 *
 * Oklab and OKHSL are Björn Ottosson's color spaces; OKHSL's saturation is relative to the sRGB gamut at
 * each hue and lightness. This is a port of his reference implementation (https://bottosson.github.io/posts/colorpicker/),
 * Copyright (c) 2021 Björn Ottosson, used under the MIT license:
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
 * following conditions: The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
 * KIND, EXPRESS OR IMPLIED.
 */
import type { RgbColor } from "./terminal-colors.ts";
type Vector = [number, number, number];
/** Oklab lightness to OKHSL lightness. */
export declare const oklabToOkhslLightness: (x: number) => number;
/** Oklab [L, a, b] to linear sRGB [r, g, b] (0-1, may leave the gamut). */
export declare function oklabToLinearSrgb(lab: Vector): Vector;
/** sRGB channels (0-255) to Oklab [L, a, b]. */
export declare function rgbToOklab({ r, g, b }: RgbColor): Vector;
/** Linear sRGB [r, g, b] to sRGB channels (0-255, rounded), clipping out-of-gamut channels. */
export declare function linearSrgbToRgb(linear: Vector): RgbColor;
/**
 * Convert OKHSL to sRGB channels (0-255, rounded), clipping out-of-gamut channels.
 * @param hue Hue in degrees.
 * @param saturation Saturation, 0-1.
 * @param lightness Lightness, 0-1.
 */
export declare function okhslToRgb(hue: number, saturation: number, lightness: number): RgbColor;
/**
 * Convert sRGB channels (0-255) to OKHSL.
 * @returns Hue `h` in degrees (0 for grays), saturation `s` and lightness `l` 0-1.
 */
export declare function rgbToOkhsl(rgb: RgbColor): {
    h: number;
    s: number;
    l: number;
};
export {};
//# sourceMappingURL=oklab.d.ts.map