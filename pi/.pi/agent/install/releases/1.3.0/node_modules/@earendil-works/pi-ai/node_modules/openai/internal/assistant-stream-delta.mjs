import { OpenAIError } from "../error.mjs";
import { hasOwn, isObj } from "./utils.mjs";
const MAX_ASSISTANT_STREAM_ARRAY_GROWTH = 1024;
const MAX_EXTERNALLY_MUTABLE_ASSISTANT_STREAM_ARRAY_LENGTH = 65536;
function getAssistantStreamDiagnosticProperty(property) {
    switch (property) {
        case 'value':
        case 'arguments':
        case 'input':
        case 'text':
        case 'content':
        case 'annotations':
        case 'metadata':
        case 'name':
        case 'role':
        case 'status':
        case 'tool_calls':
        case 'step_details': {
            return property;
        }
        default: {
            return 'unknown';
        }
    }
}
const assistantStreamArrayStates = new WeakMap();
const externallyMutableAssistantStreamValues = new WeakSet();
function createAssistantStreamDeltaProjection(cacheArrays) {
    return { arrays: new Map(), cacheArrays, records: new WeakMap() };
}
function commitAssistantStreamArrayProjection(projection) {
    for (const [array, projected] of projection.arrays) {
        if (projected.cacheable && !externallyMutableAssistantStreamValues.has(array)) {
            assistantStreamArrayStates.set(array, {
                length: projected.length,
                ownEntryCount: projected.ownEntryCount,
            });
        }
        else {
            assistantStreamArrayStates.delete(array);
        }
    }
}
function isPrimitiveAssistantStreamValue(value) {
    return typeof value === 'string' || typeof value === 'number';
}
function isPrimitiveAssistantStreamArrayDelta(accumulator, delta) {
    return delta.every(isPrimitiveAssistantStreamValue) && accumulator.every(isPrimitiveAssistantStreamValue);
}
function countOwnAssistantStreamArrayEntries(accumulator) {
    let count = 0;
    for (const key of Object.keys(accumulator)) {
        const index = Number(key);
        if (Number.isSafeInteger(index) && index >= 0 && index < accumulator.length && String(index) === key) {
            count += 1;
        }
    }
    return count;
}
function getAssistantStreamArrayOwnEntryCount(accumulator, enforceSparseHoleBudget, cachedState) {
    if (!enforceSparseHoleBudget) {
        return 0;
    }
    if (cachedState?.length === accumulator.length) {
        return cachedState.ownEntryCount;
    }
    return countOwnAssistantStreamArrayEntries(accumulator);
}
function getAssistantStreamDeltaIndex(deltaEntry, kind, baselineLength) {
    const { index } = deltaEntry;
    if (kind === 'array' && (index === null || index === undefined)) {
        throw new Error('Expected array delta entry to have an `index` property');
    }
    if (kind === 'array' && typeof index !== 'number') {
        throw new TypeError('Expected array delta entry `index` property to be a number but got an invalid value');
    }
    // SAFETY: Number.isSafeInteger rejects non-numbers before numeric comparisons; the remaining checks enforce the permitted index range.
    if (!Number.isSafeInteger(index) ||
        index < 0 ||
        index >= baselineLength + MAX_ASSISTANT_STREAM_ARRAY_GROWTH ||
        index >= MAX_EXTERNALLY_MUTABLE_ASSISTANT_STREAM_ARRAY_LENGTH) {
        const safeIndex = typeof index === 'number' ? index : 'unknown';
        throw new OpenAIError(`Assistant stream delta contains an invalid ${kind} index: ${safeIndex}`);
    }
    // SAFETY: Number.isSafeInteger rejects non-numbers before numeric comparisons; the remaining checks enforce the permitted index range.
    return index;
}
function assertValidAssistantStreamArrayDelta(accumulator, delta, kind, projection, validateRecord) {
    let projectedArray = projection.arrays.get(accumulator);
    if (!projectedArray) {
        const enforceSparseHoleBudget = projection.cacheArrays && !externallyMutableAssistantStreamValues.has(accumulator);
        const cachedState = enforceSparseHoleBudget ? assistantStreamArrayStates.get(accumulator) : undefined;
        projectedArray = {
            baselineLength: accumulator.length,
            cacheable: enforceSparseHoleBudget,
            enforceSparseHoleBudget,
            entries: new Map(),
            length: accumulator.length,
            ownEntryCount: getAssistantStreamArrayOwnEntryCount(accumulator, enforceSparseHoleBudget, cachedState),
        };
        projection.arrays.set(accumulator, projectedArray);
    }
    for (const deltaEntry of delta) {
        if (!isObj(deltaEntry)) {
            throw new Error('Expected array delta entry to be an object but got an invalid value');
        }
        const validatedIndex = getAssistantStreamDeltaIndex(deltaEntry, kind, projectedArray.baselineLength);
        let accumulatedEntry;
        if (projectedArray.entries.has(validatedIndex)) {
            accumulatedEntry = projectedArray.entries.get(validatedIndex);
        }
        else if (hasOwn(accumulator, validatedIndex)) {
            accumulatedEntry = accumulator[validatedIndex];
            if (accumulatedEntry === null || accumulatedEntry === undefined) {
                projectedArray.entries.set(validatedIndex, deltaEntry);
            }
        }
        else {
            projectedArray.entries.set(validatedIndex, deltaEntry);
            projectedArray.ownEntryCount += 1;
        }
        const projectedLength = Math.max(projectedArray.length, validatedIndex + 1);
        if (projectedArray.enforceSparseHoleBudget &&
            projectedLength - projectedArray.ownEntryCount > MAX_ASSISTANT_STREAM_ARRAY_GROWTH) {
            throw new OpenAIError(`Assistant stream delta contains an invalid ${kind} index: ${validatedIndex}`);
        }
        if (isObj(accumulatedEntry)) {
            validateRecord(accumulatedEntry, deltaEntry, projection);
        }
        projectedArray.length = projectedLength;
    }
}
function assertValidAssistantStreamDeltaIndices(accumulator, delta, projection) {
    let projectedValues = projection.records.get(accumulator);
    for (const [key, deltaValue] of Object.entries(delta)) {
        if (key === 'index' || key === 'type') {
            continue;
        }
        let accumulatedValue;
        if (projectedValues?.has(key)) {
            accumulatedValue = projectedValues.get(key);
        }
        else if (hasOwn(accumulator, key)) {
            accumulatedValue = accumulator[key];
        }
        if (accumulatedValue === null || accumulatedValue === undefined) {
            if (!projectedValues) {
                projectedValues = new Map();
                projection.records.set(accumulator, projectedValues);
            }
            projectedValues.set(key, deltaValue);
            continue;
        }
        if (isObj(accumulatedValue) && isObj(deltaValue)) {
            assertValidAssistantStreamDeltaIndices(accumulatedValue, deltaValue, projection);
        }
        else if (Array.isArray(accumulatedValue) &&
            Array.isArray(deltaValue) &&
            !isPrimitiveAssistantStreamArrayDelta(accumulatedValue, deltaValue)) {
            assertValidAssistantStreamArrayDelta(accumulatedValue, deltaValue, 'array', projection, assertValidAssistantStreamDeltaIndices);
        }
    }
}
export function isAssistantStreamValueExternallyMutable(value) {
    return (isObj(value) || Array.isArray(value)) && externallyMutableAssistantStreamValues.has(value);
}
export function markAssistantStreamValueExternallyMutable(value) {
    if ((!isObj(value) && !Array.isArray(value)) || externallyMutableAssistantStreamValues.has(value)) {
        return;
    }
    externallyMutableAssistantStreamValues.add(value);
    if (Array.isArray(value)) {
        assistantStreamArrayStates.delete(value);
    }
    for (const key of Reflect.ownKeys(value)) {
        const descriptor = Object.getOwnPropertyDescriptor(value, key);
        if (descriptor && 'value' in descriptor) {
            markAssistantStreamValueExternallyMutable(descriptor.value);
        }
    }
}
export function defineAssistantStreamArrayEntry(accumulator, index, value) {
    if (externallyMutableAssistantStreamValues.has(accumulator)) {
        markAssistantStreamValueExternallyMutable(value);
    }
    Object.defineProperty(accumulator, index, {
        configurable: true,
        enumerable: true,
        value,
        writable: true,
    });
}
function getRequiredAssistantStreamArrayIndex(deltaEntry) {
    const { index } = deltaEntry;
    if (index === null || index === undefined) {
        throw new Error('Expected array delta entry to have an `index` property');
    }
    if (typeof index !== 'number') {
        throw new TypeError('Expected array delta entry `index` property to be a number but got an invalid value');
    }
    return index;
}
function applyAssistantStreamArrayDelta(accumulator, delta, applyRecord) {
    if (isPrimitiveAssistantStreamArrayDelta(accumulator, delta)) {
        accumulator.push(...delta);
        assistantStreamArrayStates.delete(accumulator);
        return;
    }
    for (const deltaEntry of delta) {
        if (!isObj(deltaEntry)) {
            throw new Error('Expected array delta entry to be an object but got an invalid value');
        }
        const index = getRequiredAssistantStreamArrayIndex(deltaEntry);
        if (hasOwn(accumulator, index)) {
            const accumulatedEntry = accumulator[index];
            if (accumulatedEntry === null || accumulatedEntry === undefined) {
                if (externallyMutableAssistantStreamValues.has(accumulator)) {
                    markAssistantStreamValueExternallyMutable(deltaEntry);
                }
                accumulator[index] = deltaEntry;
            }
            else {
                // SAFETY: The preceding validation accepts this accumulated record before recursively merging the matching delta entry.
                accumulator[index] = applyRecord(accumulatedEntry, deltaEntry);
            }
        }
        else {
            defineAssistantStreamArrayEntry(accumulator, index, deltaEntry);
        }
    }
}
function applyAssistantStreamDelta(accumulator, delta) {
    const externallyMutable = externallyMutableAssistantStreamValues.has(accumulator);
    for (const [key, deltaValue] of Object.entries(delta)) {
        if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
            throw new OpenAIError(`Assistant stream delta contains an unsafe property: ${key}`);
        }
        if (!hasOwn(accumulator, key)) {
            if (externallyMutable) {
                markAssistantStreamValueExternallyMutable(deltaValue);
            }
            accumulator[key] = deltaValue;
            continue;
        }
        let accumulatedValue = accumulator[key];
        if (accumulatedValue === null || accumulatedValue === undefined) {
            if (externallyMutable) {
                markAssistantStreamValueExternallyMutable(deltaValue);
            }
            accumulator[key] = deltaValue;
            continue;
        }
        if (key === 'index' || key === 'type') {
            accumulator[key] = deltaValue;
            continue;
        }
        if (typeof accumulatedValue === 'string' && typeof deltaValue === 'string') {
            accumulatedValue += deltaValue;
        }
        else if (typeof accumulatedValue === 'number' && typeof deltaValue === 'number') {
            accumulatedValue += deltaValue;
        }
        else if (isObj(accumulatedValue) && isObj(deltaValue)) {
            accumulatedValue = applyAssistantStreamDelta(accumulatedValue, deltaValue);
        }
        else if (Array.isArray(accumulatedValue) && Array.isArray(deltaValue)) {
            applyAssistantStreamArrayDelta(accumulatedValue, deltaValue, applyAssistantStreamDelta);
            continue;
        }
        else {
            throw new TypeError(`Unhandled record type: ${getAssistantStreamDiagnosticProperty(key)}`);
        }
        accumulator[key] = accumulatedValue;
    }
    return accumulator;
}
export function assertSafeAssistantStreamDelta(value) {
    if (!isObj(value) && !Array.isArray(value)) {
        return;
    }
    for (const [key, nestedValue] of Object.entries(value)) {
        if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
            throw new OpenAIError(`Assistant stream delta contains an unsafe property: ${key}`);
        }
        assertSafeAssistantStreamDelta(nestedValue);
    }
}
export function accumulateAssistantStreamDelta(accumulator, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- This exported accumulator accepts heterogeneous partial SDK deltas and validates their properties at runtime.
delta, cacheArrays = false) {
    assertSafeAssistantStreamDelta(delta);
    // SAFETY: The generic accumulator uses record entries after delta validation; recursive merge retains the original accumulator's public type.
    const accumulatorRecord = accumulator;
    // SAFETY: The generic accumulator uses record entries after delta validation; recursive merge retains the original accumulator's public type.
    const deltaRecord = delta;
    const projection = createAssistantStreamDeltaProjection(cacheArrays && !isAssistantStreamValueExternallyMutable(accumulator));
    assertValidAssistantStreamDeltaIndices(accumulatorRecord, deltaRecord, projection);
    applyAssistantStreamDelta(accumulatorRecord, deltaRecord);
    commitAssistantStreamArrayProjection(projection);
    return accumulator;
}
export function createAssistantStreamArrayDeltaCommit(accumulator, delta, kind, cacheArrays = true) {
    assertSafeAssistantStreamDelta(delta);
    const projection = createAssistantStreamDeltaProjection(cacheArrays && !isAssistantStreamValueExternallyMutable(accumulator));
    assertValidAssistantStreamArrayDelta(accumulator, delta, kind, projection, assertValidAssistantStreamDeltaIndices);
    return () => commitAssistantStreamArrayProjection(projection);
}
//# sourceMappingURL=assistant-stream-delta.mjs.map