export const zodDef = (zodSchema) => '_def' in zodSchema ? zodSchema._def : zodSchema;
// oxlint-disable-next-line anti-slop/no-object-parameters -- Preserve the upstream utility contract: any object can have enumerable own or inherited keys.
export function isEmptyObj(obj) {
    if (!obj) {
        return true;
    }
    // oxlint-disable-next-line guard-for-in -- inherited enumerable properties make the object non-empty
    for (const _k in obj) {
        return false;
    }
    return true;
}
//# sourceMappingURL=util.mjs.map