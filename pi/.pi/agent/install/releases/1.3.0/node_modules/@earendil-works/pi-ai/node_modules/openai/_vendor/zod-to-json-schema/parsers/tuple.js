"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseTupleDef = parseTupleDef;
const parseDef_1 = require("../parseDef.js");
/**
 * `items` is positional and `minItems`/`maxItems` come from `def.items.length`, so the
 * array has to carry one entry per declared element. A parser may legitimately return
 * `undefined` -- a wrapper whose inner type produces no schema, for instance -- and
 * dropping that entry shifts every later element onto the wrong index while the length
 * constraints still claim the original arity, so the document accepts and rejects the
 * opposite arrays from the Zod schema it was generated from.
 *
 * An unconstrained `{}` keeps the positions aligned and constrains nothing, which is
 * what the element was already saying.
 */
function parseTupleItems(items, refs) {
    return items.map((x, i) => (0, parseDef_1.parseDef)(x._def, {
        ...refs,
        currentPath: [...refs.currentPath, 'items', `${i}`],
    }) ?? {});
}
function parseTupleDef(def, refs) {
    if (def.rest) {
        return {
            type: 'array',
            minItems: def.items.length,
            items: parseTupleItems(def.items, refs),
            additionalItems: (0, parseDef_1.parseDef)(def.rest._def, {
                ...refs,
                currentPath: [...refs.currentPath, 'additionalItems'],
            }),
        };
    }
    return {
        type: 'array',
        minItems: def.items.length,
        maxItems: def.items.length,
        items: parseTupleItems(def.items, refs),
    };
}
//# sourceMappingURL=tuple.js.map