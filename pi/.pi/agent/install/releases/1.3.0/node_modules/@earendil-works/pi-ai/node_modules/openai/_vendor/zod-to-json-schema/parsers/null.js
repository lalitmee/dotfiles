"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseNullDef = parseNullDef;
function parseNullDef(refs) {
    // SAFETY: The OpenAPI target uses nullable plus enum because its null representation differs from the JSON Schema return type.
    return refs.target === 'openApi3'
        ? {
            enum: ['null'],
            nullable: true,
        }
        : {
            type: 'null',
        };
}
//# sourceMappingURL=null.js.map