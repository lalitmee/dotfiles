"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseOptionalDef = void 0;
const parseDef_1 = require("../parseDef.js");
const parseOptionalDef = (def, refs, forceResolution) => {
    if (refs.propertyPath &&
        refs.currentPath.slice(0, refs.propertyPath.length).toString() === refs.propertyPath.toString()) {
        return (0, parseDef_1.parseDef)(def.innerType._def, { ...refs, currentPath: refs.currentPath }, forceResolution);
    }
    // `not: {}` accepts no JSON values and is unsupported by strict Structured Outputs.
    // Keep the wrapper, but generate only its real branch at the correct reference path.
    // Override callbacks retain their existing output and path contract.
    const omitNeverBranch = refs.openaiStrictMode && !refs.override;
    const innerSchema = (0, parseDef_1.parseDef)(def.innerType._def, {
        ...refs,
        currentPath: [...refs.currentPath, 'anyOf', omitNeverBranch ? '0' : '1'],
    }, forceResolution);
    return innerSchema
        ? {
            anyOf: omitNeverBranch ? [innerSchema] : [{ not: {} }, innerSchema],
        }
        : {};
};
exports.parseOptionalDef = parseOptionalDef;
//# sourceMappingURL=optional.js.map