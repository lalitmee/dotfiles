"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * Parses a CSS font family value, returning the component font families
 * contained within.
 *
 * @param family The CSS font family input string to parse
 */
function parse(family) {
    if (typeof family !== 'string') {
        throw new Error('Font family must be a string');
    }
    const context = {
        input: family,
        offset: 0
    };
    const families = [];
    let currentFamily = '';
    // Work through the input character by character until there are none left.
    // This lexing and parsing in one pass.
    while (context.offset < context.input.length) {
        const char = context.input[context.offset++];
        switch (char) {
            // String
            case '\'':
            case '"':
                currentFamily += parseString(context, char);
                break;
            // End of family
            case ',':
                families.push(currentFamily);
                currentFamily = '';
                break;
            default:
                // Identifiers (whitespace between families is swallowed)
                if (!/\s/.test(char)) {
                    context.offset--;
                    currentFamily += parseIdentifier(context);
                    families.push(currentFamily);
                    currentFamily = '';
                }
        }
    }
    return families;
}
exports.default = parse;
/**
 * Parse a CSS string.
 *
 * @param context Parsing input and offset
 * @param quoteChar The quote character for the string (' or ")
 */
function parseString(context, quoteChar) {
    let str = '';
    let escaped = false;
    while (context.offset < context.input.length) {
        const char = context.input[context.offset++];
        if (escaped) {
            if (/[0-9a-fA-F]/.test(char)) {
                // Unicode escape
                context.offset--;
                str += parseUnicode(context);
            }
            else if (char !== '\n') {
                // Newlines are ignored if escaped. Other characters are used as is.
                str += char;
            }
            escaped = false;
        }
        else {
            switch (char) {
                // Terminated quote
                case quoteChar:
                    return str;
                // Begin escape
                case '\\':
                    escaped = true;
                    break;
                // Add character to string
                default:
                    str += char;
            }
        }
    }
    throw new Error('Unterminated string');
}
/**
 * Parse a CSS custom identifier.
 *
 * @param context Parsing input and offset
 */
function parseIdentifier(context) {
    let str = '';
    let escaped = false;
    while (context.offset < context.input.length) {
        const char = context.input[context.offset++];
        if (escaped) {
            if (/[0-9a-fA-F]/.test(char)) {
                // Unicode escape
                context.offset--;
                str += parseUnicode(context);
            }
            else {
                // Everything else is used as is
                str += char;
            }
            escaped = false;
        }
        else {
            switch (char) {
                // Begin escape
                case '\\':
                    escaped = true;
                    break;
                // Terminate identifier
                case ',':
                    return str;
                default:
                    if (/\s/.test(char)) {
                        // Whitespace is collapsed into a single space within an identifier
                        if (!str.endsWith(' ')) {
                            str += ' ';
                        }
                    }
                    else {
                        // Add other characters directly
                        str += char;
                    }
            }
        }
    }
    return str;
}
/**
 * Parse a CSS unicode escape.
 *
 * @param context Parsing input and offset
 */
function parseUnicode(context) {
    let str = '';
    while (context.offset < context.input.length) {
        const char = context.input[context.offset++];
        if (/\s/.test(char)) {
            // The first whitespace character after a unicode escape indicates the end
            // of the escape and is swallowed.
            return unicodeToString(str);
        }
        else if (str.length >= 6 || !/[0-9a-fA-F]/.test(char)) {
            // If the next character is not a valid hex digit or we have reached the
            // maximum of 6 digits in the escape, terminate the escape.
            context.offset--;
            return unicodeToString(str);
        }
        // Otherwise, just add it to the escape
        str += char;
    }
    return unicodeToString(str);
}
/**
 * Convert a unicode code point from a hex string to a utf8 string.
 *
 * @param codePoint Unicode code point represented as a hex string
 */
function unicodeToString(codePoint) {
    return String.fromCodePoint(parseInt(codePoint, 16));
}
//# sourceMappingURL=parse.js.map