"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.encode = exports.has = void 0;
exports.merge = merge;
exports.assign_single_source = assign_single_source;
exports.decode = decode;
exports.compact = compact;
exports.is_regexp = is_regexp;
exports.is_buffer = is_buffer;
exports.combine = combine;
exports.maybe_map = maybe_map;
const formats_1 = require("./formats.js");
const values_1 = require("../utils/values.js");
// oxlint-disable-next-line anti-slop/no-object-parameters -- The cached own-property predicate accepts arrays, callable objects, and records.
let cachedHas;
// oxlint-disable-next-line anti-slop/no-object-parameters -- Own-property lookup is a generic object primitive and must preserve array and callable inputs.
const has = (obj, key) => {
    // SAFETY: Object.hasOwn is an optional native capability; older runtimes use the bound hasOwnProperty fallback with the same own-key semantics.
    // oxlint-disable-next-line anti-slop/no-object-parameters -- The native or compatibility own-property predicate has the same generic object contract.
    const resolvedHas = cachedHas ?? Object.hasOwn ?? Function.prototype.call.bind(Object.prototype.hasOwnProperty);
    cachedHas = resolvedHas;
    return resolvedHas(obj, key);
};
exports.has = has;
function isUnsafePropertyKey(key) {
    return key === '__proto__' || key === 'constructor' || key === 'prototype';
}
const maxAdoptedRecords = 10000;
function isIntrinsicFunctionPrototype(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Prototype descriptors are inspected before deciding whether an arbitrary adopted value is callable.
value, key, descriptor) {
    return (typeof value === 'function' && key === 'prototype' && !descriptor.enumerable && !descriptor.configurable);
}
function isObjectLike(value) {
    return value !== null && (typeof value === 'object' || typeof value === 'function');
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Adoption records retain arbitrary merge-target identities for later descriptor validation.
function rememberAdoption(state, target, key, value) {
    if (!isObjectLike(value)) {
        return;
    }
    if (state.adopted.length >= maxAdoptedRecords) {
        throw new Error('Adopted record traversal exceeds the supported safety limit.');
    }
    state.adopted.push({ target, key });
}
function sanitizeAdoptions(state) {
    if (state.adopted.length === 0) {
        return;
    }
    const records = new WeakMap();
    const visited = [];
    const locations = [];
    let inspectedProperties = 0;
    // oxlint-disable-next-line anti-slop/no-object-parameters -- Adoption validation inspects arbitrary objects, including arrays and functions, before trusting their structure.
    function inspect(value) {
        const known = records.get(value);
        if (known) {
            return known;
        }
        if (visited.length >= maxAdoptedRecords) {
            throw new Error('Adopted record traversal exceeds the supported safety limit.');
        }
        const keys = Reflect.ownKeys(value);
        if (keys.length > maxAdoptedRecords - inspectedProperties) {
            throw new Error('Adopted record traversal exceeds the supported safety limit.');
        }
        inspectedProperties += keys.length;
        const descriptors = Object.create(null);
        for (const key of keys) {
            const descriptor = Object.getOwnPropertyDescriptor(value, key);
            if (descriptor) {
                Reflect.set(descriptors, key, descriptor);
            }
        }
        const prototype = Object.getPrototypeOf(value);
        const array = (0, values_1.isArray)(value);
        const extensible = Object.isExtensible(value);
        const ordinary = typeof value !== 'function' &&
            (array ? prototype === Array.prototype : prototype === Object.prototype || prototype === null);
        const record = {
            value,
            descriptors,
            keys,
            prototype,
            parents: new Set(),
            ordinary,
            array,
            detached: ordinary && (extensible || !Object.isFrozen(value)),
            unsafe: false,
            extensible,
        };
        records.set(value, record);
        visited.push(record);
        return record;
    }
    for (const { target, key } of state.adopted) {
        const descriptor = Object.getOwnPropertyDescriptor(target, key);
        if (descriptor && 'value' in descriptor && isObjectLike(descriptor.value)) {
            locations.push({ target, key, descriptor, record: inspect(descriptor.value) });
        }
    }
    const detached = [];
    for (const record of visited) {
        for (const key of record.keys) {
            const descriptor = record.descriptors[key];
            if (!descriptor) {
                continue;
            }
            if (isUnsafePropertyKey(key)) {
                if (record.ordinary) {
                    record.detached = true;
                    record.unsafe = true;
                }
                else if (!isIntrinsicFunctionPrototype(record.value, key, descriptor)) {
                    throw new TypeError('Cannot safely sanitize an adopted callable or unsupported prototype.');
                }
                continue;
            }
            if (!record.ordinary && !descriptor.enumerable) {
                continue;
            }
            if ('value' in descriptor && isObjectLike(descriptor.value)) {
                inspect(descriptor.value).parents.add(record);
            }
        }
        if (record.detached) {
            detached.push(record);
        }
    }
    for (let index = visited.length - 1; index >= 0; index -= 1) {
        const record = visited[index];
        if (record.ordinary) {
            continue;
        }
        for (const key of ['__proto__', 'constructor', 'prototype']) {
            const descriptor = Object.getOwnPropertyDescriptor(record.value, key);
            if (descriptor && !isIntrinsicFunctionPrototype(record.value, key, descriptor)) {
                throw new TypeError('Cannot safely sanitize an adopted callable or unsupported prototype.');
            }
        }
    }
    const unsafe = visited.filter((record) => record.unsafe);
    for (const record of unsafe) {
        for (const parent of record.parents) {
            if (!parent.ordinary) {
                throw new TypeError('Cannot safely sanitize an adopted callable or unsupported prototype.');
            }
            if (!parent.unsafe) {
                parent.unsafe = true;
                unsafe.push(parent);
            }
        }
    }
    for (const record of detached) {
        for (const parent of record.parents) {
            if (!parent.ordinary) {
                continue;
            }
            if (!parent.detached) {
                parent.detached = true;
                detached.push(parent);
            }
        }
    }
    const copies = new WeakMap();
    for (const record of detached) {
        copies.set(record.value, record.array ? [] : Object.create(record.prototype));
    }
    for (const record of detached) {
        const copy = copies.get(record.value);
        for (const key of record.keys) {
            if (isUnsafePropertyKey(key)) {
                continue;
            }
            const descriptor = record.descriptors[key];
            if (!descriptor) {
                continue;
            }
            if ('value' in descriptor && isObjectLike(descriptor.value) && copies.has(descriptor.value)) {
                descriptor.value = copies.get(descriptor.value);
            }
            Object.defineProperty(copy, key, descriptor);
        }
    }
    for (const { target, key, descriptor, record } of locations) {
        const value = copies.get(record.value) ?? record.value;
        if (value !== descriptor.value) {
            Object.defineProperty(copies.get(target) ?? target, key, { ...descriptor, value });
        }
    }
    for (const record of detached) {
        if (!record.extensible) {
            Object.preventExtensions(copies.get(record.value));
        }
    }
}
function readPreparedTarget(state, target, key) {
    const prepared = state.preparedTargets.get(target);
    if (prepared?.has(key)) {
        const value = prepared.get(key);
        prepared.delete(key);
        return value;
    }
    return target[key];
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Merge targets may contain accessors or custom prototypes, so the preview preserves the generic object boundary.
function previewTarget(state, target, key) {
    const descriptor = Object.getOwnPropertyDescriptor(target, key);
    if (descriptor && 'value' in descriptor) {
        return descriptor.value;
    }
    // oxlint-disable-next-line anti-slop/no-reflect-get -- Generic query merging snapshots arbitrary inherited/accessor keys before mutation.
    const value = Reflect.get(target, key, target);
    let prepared = state.preparedTargets.get(target);
    if (!prepared) {
        prepared = new Map();
        state.preparedTargets.set(target, prepared);
    }
    prepared.set(key, value);
    return value;
}
function prepareMergeSource(target, source, state, assign = false) {
    if (!source || typeof source !== 'object' || !target || typeof target !== 'object') {
        return source;
    }
    let preparedTargets = state.preparedSources.get(source);
    if (!preparedTargets) {
        preparedTargets = new WeakMap();
        state.preparedSources.set(source, preparedTargets);
    }
    const existing = preparedTargets.get(target);
    if (existing) {
        return existing;
    }
    state.inspectedSources += 1;
    if (state.inspectedSources > maxAdoptedRecords) {
        throw new Error('Adopted record traversal exceeds the supported safety limit.');
    }
    const sourceKeys = Reflect.ownKeys(source);
    if (sourceKeys.length > maxAdoptedRecords - state.inspectedSourceProperties) {
        throw new Error('Adopted record traversal exceeds the supported safety limit.');
    }
    state.inspectedSourceProperties += sourceKeys.length;
    const sourceIsArray = (0, values_1.isArray)(source);
    // oxlint-disable-next-line anti-slop/no-unsafe-dictionary-type -- The query merge graph preserves heterogeneous scalar, array, and object values under its existing merge contract.
    const prepared = sourceIsArray ? [] : Object.create(null);
    preparedTargets.set(target, prepared);
    if ((0, values_1.isArray)(target) && sourceIsArray && !assign) {
        const sourceLength = source.length;
        // SAFETY: prepared was constructed as an array when sourceIsArray is true, which this branch requires.
        prepared.length = sourceLength;
        for (let index = 0; index < sourceLength; index += 1) {
            if (!(index in source)) {
                continue;
            }
            const value = source[index];
            if ((0, exports.has)(target, index)) {
                const targetValue = previewTarget(state, target, index);
                prepared[index] =
                    targetValue && typeof targetValue === 'object' && value && typeof value === 'object'
                        ? prepareMergeSource(targetValue, value, state)
                        : value;
            }
            else {
                prepared[index] = value;
            }
        }
        return prepared;
    }
    const enumerableKeys = [];
    for (const key of sourceKeys) {
        if (typeof key === 'string' && Object.getOwnPropertyDescriptor(source, key)?.enumerable) {
            enumerableKeys.push(key);
        }
    }
    for (const key of enumerableKeys) {
        if (isUnsafePropertyKey(key)) {
            continue;
        }
        const value = source[key];
        prepared[key] =
            !assign && (0, exports.has)(target, key) && value && typeof value === 'object'
                ? prepareMergeSource(previewTarget(state, target, key), value, state)
                : value;
    }
    return prepared;
}
function prepareSource(target, source, state, assign = false) {
    const holder = { value: prepareMergeSource(target, source, state, assign) };
    rememberAdoption(state, holder, 'value', holder.value);
    sanitizeAdoptions(state);
    return holder.value;
}
const hex_table = /* @__PURE__ */ (() => {
    const array = [];
    for (let i = 0; i < 256; ++i) {
        array.push('%' + ((i < 16 ? '0' : '') + i.toString(16)).toUpperCase());
    }
    return array;
})();
function compact_queue(queue) {
    while (queue.length > 1) {
        const item = queue.pop();
        if (!item) {
            continue;
        }
        const obj = item.obj[item.prop];
        if ((0, values_1.isArray)(obj)) {
            const compacted = [];
            for (const value of obj) {
                if (value !== undefined) {
                    compacted.push(value);
                }
            }
            // @ts-ignore
            item.obj[item.prop] = compacted;
        }
    }
}
function array_to_object(source, options) {
    const obj = options && options.plainObjects ? Object.create(null) : {};
    for (let i = 0; i < source.length; ++i) {
        if (source[i] !== undefined) {
            obj[i] = source[i];
        }
    }
    return obj;
}
function mergeWithState(target, source, options, state) {
    if (!source) {
        return target;
    }
    if (typeof source !== 'object') {
        if ((0, values_1.isArray)(target)) {
            target.push(source);
        }
        else if (target && typeof target === 'object') {
            const propertyKey = typeof source === 'string' || typeof source === 'symbol'
                ? source
                : Reflect.ownKeys({ [source]: true })[0];
            if (!isUnsafePropertyKey(propertyKey) &&
                ((options && (options.plainObjects || options.allowPrototypes)) ||
                    !(0, exports.has)(Object.prototype, propertyKey))) {
                target[propertyKey] = true;
            }
        }
        else {
            return [target, source];
        }
        return target;
    }
    if (!target || typeof target !== 'object') {
        // oxlint-disable-next-line unicorn/prefer-spread -- concat intentionally preserves one-level flattening and sparse-array behavior.
        return [target].concat(source);
    }
    let mergeTarget = target;
    if ((0, values_1.isArray)(target) && !(0, values_1.isArray)(source)) {
        // @ts-ignore
        mergeTarget = array_to_object(target, options);
    }
    if ((0, values_1.isArray)(target) && (0, values_1.isArray)(source)) {
        const sourceLength = source.length;
        for (let i = 0; i < sourceLength; i += 1) {
            if (i in source) {
                const item = source[i];
                if ((0, exports.has)(target, i)) {
                    const targetItem = readPreparedTarget(state, target, i);
                    if (targetItem && typeof targetItem === 'object' && item && typeof item === 'object') {
                        const merged = mergeWithState(targetItem, item, options, state);
                        target[i] = merged;
                    }
                    else {
                        const adopted = item;
                        target.push(adopted);
                    }
                }
                else {
                    const adopted = item;
                    target[i] = adopted;
                }
            }
        }
        return target;
    }
    for (const key of Object.keys(source)) {
        if (isUnsafePropertyKey(key)) {
            continue;
        }
        const value = source[key];
        const adopted = (0, exports.has)(mergeTarget, key)
            ? mergeWithState(readPreparedTarget(state, mergeTarget, key), value, options, state)
            : value;
        mergeTarget[key] = adopted;
    }
    return mergeTarget;
}
function merge(target, source, options = {}) {
    const state = {
        adopted: [],
        preparedTargets: new WeakMap(),
        preparedSources: new WeakMap(),
        inspectedSources: 0,
        inspectedSourceProperties: 0,
    };
    return mergeWithState(target, prepareSource(target, source, state), options, state);
}
function assign_single_source(target, source) {
    const state = {
        adopted: [],
        preparedTargets: new WeakMap(),
        preparedSources: new WeakMap(),
        inspectedSources: 0,
        inspectedSourceProperties: 0,
    };
    const prepared = prepareSource(target, source, state, true);
    for (const key of Object.keys(prepared)) {
        if (isUnsafePropertyKey(key)) {
            continue;
        }
        target[key] = prepared[key];
    }
    return target;
}
function decode(str, _, charset) {
    const strWithoutPlus = str.replace(/\+/g, ' ');
    if (charset === 'iso-8859-1') {
        // unescape never throws, no try...catch needed:
        return strWithoutPlus.replace(/%[0-9a-f]{2}/gi, unescape);
    }
    // utf-8
    try {
        return decodeURIComponent(strWithoutPlus);
    }
    catch {
        return strWithoutPlus;
    }
}
const limit = 1024;
const encode = (str, _defaultEncoder, charset, _kind, format) => {
    // This code was originally written by Brian White for the io.js core querystring library.
    // It has been adapted here for stricter adherence to RFC 3986
    if (str.length === 0) {
        return str;
    }
    let string = str;
    if (typeof str === 'symbol') {
        string = Symbol.prototype.toString.call(str);
    }
    else if (typeof str !== 'string') {
        string = String(str);
    }
    if (charset === 'iso-8859-1') {
        return escape(string).replace(/%u[0-9a-f]{4}/gi, ($0) => '%26%23' + Number.parseInt($0.slice(2), 16) + '%3B');
    }
    let out = '';
    for (let j = 0; j < string.length;) {
        let segmentEnd = Math.min((Math.floor(j / limit) + 1) * limit, string.length);
        if (segmentEnd < string.length && string.codePointAt(segmentEnd - 1) > 65535) {
            segmentEnd += 1;
        }
        const segment = string.length >= limit ? string.slice(j, segmentEnd) : string;
        const arr = [];
        for (let i = 0; i < segment.length; ++i) {
            // oxlint-disable-next-line unicorn/prefer-code-point -- combine UTF-16 surrogate code units below
            let c = segment.charCodeAt(i);
            if (c === 0x2d || // -
                c === 0x2e || // .
                c === 0x5f || // _
                c === 0x7e || // ~
                (c >= 0x30 && c <= 0x39) || // 0-9
                (c >= 0x41 && c <= 0x5a) || // a-z
                (c >= 0x61 && c <= 0x7a) || // A-Z
                (format === formats_1.RFC1738 && (c === 0x28 || c === 0x29)) // ( )
            ) {
                arr[arr.length] = segment.charAt(i);
                continue;
            }
            if (c < 0x80) {
                arr[arr.length] = hex_table[c];
                continue;
            }
            if (c < 2048) {
                arr[arr.length] = hex_table[0xc0 | (c >> 6)] + hex_table[0x80 | (c & 0x3f)];
                continue;
            }
            if (c < 55296 || c >= 57344) {
                arr[arr.length] =
                    hex_table[0xe0 | (c >> 12)] + hex_table[0x80 | ((c >> 6) & 0x3f)] + hex_table[0x80 | (c & 0x3f)];
                continue;
            }
            i += 1;
            // oxlint-disable-next-line unicorn/prefer-code-point -- combine UTF-16 surrogate code units manually
            c = 65536 + (((c & 1023) << 10) | (segment.charCodeAt(i) & 1023));
            arr[arr.length] =
                hex_table[0xf0 | (c >> 18)] +
                    hex_table[0x80 | ((c >> 12) & 0x3f)] +
                    hex_table[0x80 | ((c >> 6) & 0x3f)] +
                    hex_table[0x80 | (c & 0x3f)];
        }
        out += arr.join('');
        j = segmentEnd;
    }
    return out;
};
exports.encode = encode;
function compact(value) {
    const queue = [{ obj: { o: value }, prop: 'o' }];
    const refs = [];
    for (const item of queue) {
        // @ts-ignore
        const obj = item.obj[item.prop];
        const keys = Object.keys(obj);
        for (const key of keys) {
            const val = obj[key];
            if (typeof val === 'object' && val !== null && !refs.includes(val)) {
                queue.push({ obj, prop: key });
                refs.push(val);
            }
        }
    }
    compact_queue(queue);
    return value;
}
function is_regexp(obj) {
    return Object.prototype.toString.call(obj) === '[object RegExp]';
}
function is_buffer(obj) {
    if (!obj || typeof obj !== 'object') {
        return false;
    }
    return !!(obj.constructor && obj.constructor.isBuffer && obj.constructor.isBuffer(obj));
}
function combine(a, b) {
    // oxlint-disable-next-line unicorn/prefer-spread -- concat intentionally preserves one-level flattening and sparse-array behavior.
    return [].concat(a, b);
}
function maybe_map(val, fn) {
    if ((0, values_1.isArray)(val)) {
        const mapped = [];
        for (const item of val) {
            mapped.push(fn(item));
        }
        return mapped;
    }
    return fn(val);
}
//# sourceMappingURL=utils.js.map