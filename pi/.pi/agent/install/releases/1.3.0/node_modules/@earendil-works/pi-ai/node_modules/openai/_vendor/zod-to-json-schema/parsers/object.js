"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseObjectDef = parseObjectDef;
const parseDef_1 = require("../parseDef.js");
function decideAdditionalProperties(def, refs) {
    if (refs.removeAdditionalStrategy === 'strict') {
        return def.catchall._def.typeName === 'ZodNever'
            ? def.unknownKeys !== 'strict'
            : ((0, parseDef_1.parseDef)(def.catchall._def, {
                ...refs,
                currentPath: [...refs.currentPath, 'additionalProperties'],
            }) ?? true);
    }
    return def.catchall._def.typeName === 'ZodNever'
        ? def.unknownKeys === 'passthrough'
        : ((0, parseDef_1.parseDef)(def.catchall._def, {
            ...refs,
            currentPath: [...refs.currentPath, 'additionalProperties'],
        }) ?? true);
}
function parseObjectDef(def, refs) {
    const properties = {};
    const required = [];
    for (const [propName, propDef] of Object.entries(def.shape())) {
        if (propDef === undefined || propDef._def === undefined) {
            continue;
        }
        const propertyPath = [...refs.currentPath, 'properties', propName];
        if (propName === '__proto__') {
            throw new Error(`Zod field at \`${propertyPath.join('/')}\` uses unsupported property name \`__proto__\`, which Zod omits from parsed output.`);
        }
        const parsedDef = (0, parseDef_1.parseDef)(propDef._def, {
            ...refs,
            currentPath: propertyPath,
            propertyPath,
        });
        if (parsedDef === undefined) {
            continue;
        }
        if (refs.openaiStrictMode &&
            propDef.isOptional() &&
            !propDef.isNullable() &&
            propDef._def?.defaultValue === undefined) {
            throw new Error(`Zod field at \`${propertyPath.join('/')}\` uses \`.optional()\` without \`.nullable()\` which is not supported by the API. See: https://platform.openai.com/docs/guides/structured-outputs?api-mode=responses#all-fields-must-be-required`);
        }
        properties[propName] = parsedDef;
        if (!propDef.isOptional() || refs.openaiStrictMode) {
            required.push(propName);
        }
    }
    const result = {
        type: 'object',
        properties,
        required,
        additionalProperties: decideAdditionalProperties(def, refs),
    };
    if (!result.required.length) {
        delete result.required;
    }
    return result;
}
//# sourceMappingURL=object.js.map