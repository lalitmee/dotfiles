"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const font_1 = require("./font");
// Caches 100K characters worth of ligatures. In practice this works out to
// about 650 KB worth of cache, when a moderate number of ligatures are present.
const CACHE_SIZE = 100000;
/**
 * Enable ligature support for the provided Terminal instance. To function
 * properly, this must be called after `open()` is called on the therminal. If
 * the font currently in use supports ligatures, the terminal will automatically
 * start to render them.
 * @param term Terminal instance from xterm.js
 */
function enableLigatures(term) {
    let currentFontName = undefined;
    let font = undefined;
    let loadingState = 0 /* UNLOADED */;
    let loadError = undefined;
    // TODO: remove any once 3.6.0 is published
    term.registerCharacterJoiner((text) => {
        // If the font hasn't been loaded yet, load it and return an empty result
        const termFont = term.getOption('fontFamily');
        if (termFont &&
            (loadingState === 0 /* UNLOADED */ || currentFontName !== termFont)) {
            font = undefined;
            loadingState = 1 /* LOADING */;
            currentFontName = termFont;
            const currentCallFontName = currentFontName;
            font_1.default(currentCallFontName, CACHE_SIZE)
                .then(f => {
                // Another request may have come in while we were waiting, so make
                // sure our font is still vaild.
                if (currentCallFontName === term.getOption('fontFamily')) {
                    loadingState = 2 /* LOADED */;
                    font = f;
                    // Only refresh things if we actually found a font
                    if (f) {
                        term.refresh(0, term.getOption('rows') - 1);
                    }
                }
            })
                .catch(e => {
                // Another request may have come in while we were waiting, so make
                // sure our font is still vaild.
                if (currentCallFontName === term.getOption('fontFamily')) {
                    loadingState = 3 /* FAILED */;
                    font = undefined;
                    loadError = e;
                }
            });
        }
        if (font && loadingState === 2 /* LOADED */) {
            // We clone the entries to avoid the internal cache of the ligature finder
            // getting messed up.
            return font.findLigatureRanges(text).map(range => [range[0], range[1]]);
        }
        else if (loadingState === 3 /* FAILED */) {
            throw loadError || new Error('Failure while loading font');
        }
        return [];
    });
}
exports.enableLigatures = enableLigatures;
/**
 * Add capabilities to the provided terminal class for enabling ligature
 * support. After calling this function, an `enableLigatures()` method is
 * available on the terminal class, which will enable ligature support when
 * called.
 * @param terminalConstructor Terminal class from xterm.js
 */
function apply(terminalConstructor) {
    terminalConstructor.prototype.enableLigatures = function () {
        enableLigatures(this);
    };
}
exports.apply = apply;
//# sourceMappingURL=index.js.map