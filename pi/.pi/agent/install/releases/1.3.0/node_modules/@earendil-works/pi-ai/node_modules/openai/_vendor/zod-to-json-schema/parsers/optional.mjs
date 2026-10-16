import { parseDef } from "../parseDef.mjs";
export const parseOptionalDef = (def, refs, forceResolution) => {
    if (refs.propertyPath &&
        refs.currentPath.slice(0, refs.propertyPath.length).toString() === refs.propertyPath.toString()) {
        return parseDef(def.innerType._def, { ...refs, currentPath: refs.currentPath }, forceResolution);
    }
    // `not: {}` accepts no JSON values and is unsupported by strict Structured Outputs.
    // Keep the wrapper, but generate only its real branch at the correct reference path.
    // Override callbacks retain their existing output and path contract.
    const omitNeverBranch = refs.openaiStrictMode && !refs.override;
    const innerSchema = parseDef(def.innerType._def, {
        ...refs,
        currentPath: [...refs.currentPath, 'anyOf', omitNeverBranch ? '0' : '1'],
    }, forceResolution);
    return innerSchema
        ? {
            anyOf: omitNeverBranch ? [innerSchema] : [{ not: {} }, innerSchema],
        }
        : {};
};
//# sourceMappingURL=optional.mjs.map