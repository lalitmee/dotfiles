import { ZodFirstPartyTypeKind } from 'zod/v3';
import { parseDef } from "../parseDef.mjs";
import { parseStringDef } from "./string.mjs";
export function parseRecordDef(def, refs) {
    if (refs.target === 'openApi3' && def.keyType?._def.typeName === ZodFirstPartyTypeKind.ZodEnum) {
        // SAFETY: The OpenAPI enum-key path emits an explicitly checked object schema while preserving the vendored record parser's public return type.
        return {
            type: 'object',
            required: def.keyType._def.values,
            properties: Object.fromEntries(def.keyType._def.values.map((key) => [
                key,
                parseDef(def.valueType._def, {
                    ...refs,
                    currentPath: [...refs.currentPath, 'properties', key],
                }) ?? {},
            ])),
            additionalProperties: false,
        };
    }
    const schema = {
        type: 'object',
        additionalProperties: parseDef(def.valueType._def, {
            ...refs,
            currentPath: [...refs.currentPath, 'additionalProperties'],
        }) ?? {},
    };
    if (refs.target === 'openApi3') {
        return schema;
    }
    if (def.keyType?._def.typeName === ZodFirstPartyTypeKind.ZodString && def.keyType._def.checks?.length) {
        // SAFETY: Removing only type from the parsed string schema leaves the keyword subset allowed in propertyNames.
        const keyType = Object.fromEntries(Object.entries(parseStringDef(def.keyType._def, refs)).filter(([key]) => key !== 'type'));
        return {
            ...schema,
            propertyNames: keyType,
        };
    }
    else if (def.keyType?._def.typeName === ZodFirstPartyTypeKind.ZodEnum) {
        return {
            ...schema,
            propertyNames: {
                enum: def.keyType._def.values,
            },
        };
    }
    return schema;
}
//# sourceMappingURL=record.mjs.map