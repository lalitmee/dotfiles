"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fontFinder = require("font-finder");
const fontLigatures = require("font-ligatures");
const parse_1 = require("./parse");
let fontsPromise = undefined;
/**
 * Loads the font ligature wrapper for the specified font family if it could be
 * resolved, throwing if it is unable to find a suitable match.
 * @param fontFamily The CSS font family definition to resolve
 * @param cacheSize The size of the ligature cache to maintain if the font is resolved
 */
async function load(fontFamily, cacheSize) {
    if (!fontsPromise) {
        fontsPromise = fontFinder.list();
    }
    const fonts = await fontsPromise;
    for (const family of parse_1.default(fontFamily)) {
        // If we reach one of the generic font families, the font resolution
        // will end for the browser and we can't determine the specific font
        // used. Throw.
        if (genericFontFamilies.includes(family)) {
            return undefined;
        }
        if (fonts.hasOwnProperty(family) && fonts[family].length > 0) {
            return await fontLigatures.loadFile(fonts[family][0].path, { cacheSize });
        }
    }
    // If none of the fonts could resolve, throw an error
    return undefined;
}
exports.default = load;
// https://drafts.csswg.org/css-fonts-4/#generic-font-families
const genericFontFamilies = [
    'serif',
    'sans-serif',
    'cursive',
    'fantasy',
    'monospace',
    'system-ui',
    'emoji',
    'math',
    'fangsong'
];
//# sourceMappingURL=font.js.map