import { parseDef } from "../parseDef.mjs";
import { primitiveMappings } from "./union.mjs";
export function parseNullableDef(def, refs, forceResolution) {
    if (['ZodString', 'ZodNumber', 'ZodBigInt', 'ZodBoolean', 'ZodNull'].includes(def.innerType._def.typeName) &&
        (!def.innerType._def.checks || !def.innerType._def.checks.length)) {
        if (refs.target === 'openApi3' || refs.nullableStrategy === 'property') {
            // SAFETY: The preceding primitive discriminator check permits the mapping lookup; the nullable-property target uses its existing extension representation.
            return {
                type: primitiveMappings[def.innerType._def.typeName],
                nullable: true,
            };
        }
        // SAFETY: The preceding primitive discriminator check permits the mapping lookup; the nullable-property target uses its existing extension representation.
        return {
            type: [primitiveMappings[def.innerType._def.typeName], 'null'],
        };
    }
    if (refs.target === 'openApi3') {
        const base = parseDef(def.innerType._def, {
            ...refs,
            currentPath: [...refs.currentPath],
        }, forceResolution);
        if (base && '$ref' in base) {
            // SAFETY: The OpenAPI branch adds nullable to the converted base schema, an extension not represented by the shared JSON Schema union.
            return { allOf: [base], nullable: true };
        }
        // SAFETY: The OpenAPI branch adds nullable to the converted base schema, an extension not represented by the shared JSON Schema union.
        return base && { ...base, nullable: true };
    }
    const base = parseDef(def.innerType._def, {
        ...refs,
        currentPath: [...refs.currentPath, 'anyOf', '0'],
    });
    return base && { anyOf: [base, { type: 'null' }] };
}
//# sourceMappingURL=nullable.mjs.map