"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseLiteralDef = parseLiteralDef;
const null_1 = require("./null.js");
function parseLiteralDef(def, refs) {
    if (def.value === null) {
        return refs.target === 'openApi3' ? (0, null_1.parseNullDef)(refs) : { type: 'null', const: null };
    }
    const parsedType = typeof def.value;
    if (parsedType !== 'bigint' &&
        parsedType !== 'number' &&
        parsedType !== 'boolean' &&
        parsedType !== 'string') {
        return {
            type: Array.isArray(def.value) ? 'array' : 'object',
        };
    }
    if (refs.target === 'openApi3') {
        // SAFETY: The OpenAPI branch represents a primitive literal with enum instead of const, retaining the vendored converter's target compatibility.
        return {
            type: parsedType === 'bigint' ? 'integer' : parsedType,
            enum: [def.value],
        };
    }
    return {
        type: parsedType === 'bigint' ? 'integer' : parsedType,
        const: def.value,
    };
}
//# sourceMappingURL=literal.js.map