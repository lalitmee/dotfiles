"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseNativeEnumDef = parseNativeEnumDef;
function parseNativeEnumDef(def) {
    const object = def.values;
    const actualKeys = Object.keys(def.values).filter((key) => typeof object[object[key]] !== 'number');
    const actualValues = actualKeys.map((key) => object[key]);
    const parsedTypes = [...new Set(actualValues.map((values) => typeof values))];
    let type = ['string', 'number'];
    if (parsedTypes.length === 1) {
        type = parsedTypes[0] === 'string' ? 'string' : 'number';
    }
    return {
        type,
        enum: actualValues,
    };
}
//# sourceMappingURL=nativeEnum.js.map