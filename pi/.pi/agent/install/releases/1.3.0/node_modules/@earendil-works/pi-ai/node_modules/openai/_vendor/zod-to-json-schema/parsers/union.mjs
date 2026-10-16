import { parseDef } from "../parseDef.mjs";
export const primitiveMappings = {
    ZodString: 'string',
    ZodNumber: 'number',
    ZodBigInt: 'integer',
    ZodBoolean: 'boolean',
    ZodNull: 'null',
};
export function parseUnionDef(def, refs) {
    if (refs.target === 'openApi3') {
        return asAnyOf(def, refs);
    }
    const options = def.options instanceof Map ? [...def.options.values()] : def.options;
    // This blocks tries to look ahead a bit to produce nicer looking schemas with type array instead of anyOf.
    if (options.every((x) => x._def.typeName in primitiveMappings && (!x._def.checks || !x._def.checks.length))) {
        // all types in union are primitive and lack checks, so might as well squash into {type: [...]}
        const types = [];
        for (const x of options) {
            // SAFETY: The preceding every check restricts each option to a primitive mapping key with no additional checks.
            const type = primitiveMappings[x._def.typeName]; //Can be safely casted due to row 43
            if (type && !types.includes(type)) {
                types.push(type);
            }
        }
        return {
            type: types.length > 1 ? types : types[0],
        };
    }
    else if (options.every((x) => x._def.typeName === 'ZodLiteral' && !x.description)) {
        // all options literals
        const types = [];
        // SAFETY: The preceding every check establishes that every union option is a Zod literal definition.
        for (const x of options) {
            const type = typeof x._def.value;
            switch (type) {
                case 'string':
                case 'number':
                case 'boolean': {
                    types.push(type);
                    break;
                }
                case 'bigint': {
                    types.push('integer');
                    break;
                }
                case 'object': {
                    if (x._def.value === null) {
                        types.push('null');
                    }
                    break;
                }
            }
        }
        if (types.length === options.length) {
            // all the literals are primitive, as far as null can be considered primitive
            const uniqueTypes = types.filter((x, i, a) => a.indexOf(x) === i);
            const enumValues = [];
            for (const x of options) {
                if (!enumValues.includes(x._def.value)) {
                    enumValues.push(x._def.value);
                }
            }
            return {
                type: uniqueTypes.length > 1 ? uniqueTypes : uniqueTypes[0],
                enum: enumValues,
            };
        }
    }
    else if (options.every((x) => x._def.typeName === 'ZodEnum')) {
        const enumValues = [];
        for (const x of options) {
            for (const value of x._def.values) {
                if (!enumValues.includes(value)) {
                    enumValues.push(value);
                }
            }
        }
        return {
            type: 'string',
            enum: enumValues,
        };
    }
    return asAnyOf(def, refs);
}
const asAnyOf = (def, refs) => {
    // SAFETY: Zod union options are either the discriminated-union map values or the ordinary option array; both contain schema definitions for parseDef.
    const anyOf = (def.options instanceof Map ? [...def.options.values()] : def.options)
        .map((x, i) => parseDef(x._def, {
        ...refs,
        currentPath: [...refs.currentPath, 'anyOf', `${i}`],
    }))
        .filter((x) => !!x && (!refs.strictUnions || (typeof x === 'object' && Object.keys(x).length > 0)));
    return anyOf.length ? { anyOf } : undefined;
};
//# sourceMappingURL=union.mjs.map