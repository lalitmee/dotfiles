"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.zodDef = void 0;
exports.isEmptyObj = isEmptyObj;
const zodDef = (zodSchema) => '_def' in zodSchema ? zodSchema._def : zodSchema;
exports.zodDef = zodDef;
// oxlint-disable-next-line anti-slop/no-object-parameters -- Preserve the upstream utility contract: any object can have enumerable own or inherited keys.
function isEmptyObj(obj) {
    if (!obj) {
        return true;
    }
    // oxlint-disable-next-line guard-for-in -- inherited enumerable properties make the object non-empty
    for (const _k in obj) {
        return false;
    }
    return true;
}
//# sourceMappingURL=util.js.map