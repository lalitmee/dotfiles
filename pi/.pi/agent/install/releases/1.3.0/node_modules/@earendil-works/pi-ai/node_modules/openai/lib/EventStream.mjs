var _EventStream_instances, _EventStream_connectedPromise, _EventStream_resolveConnectedPromise, _EventStream_rejectConnectedPromise, _EventStream_endPromise, _EventStream_resolveEndPromise, _EventStream_rejectEndPromise, _EventStream_listeners, _EventStream_abortListeners, _EventStream_emittedListenerRegistrations, _EventStream_pendingListenerCleanup, _EventStream_pendingBufferedEventChecks, _EventStream_listenerDispatchDepth, _EventStream_ended, _EventStream_errored, _EventStream_aborted, _EventStream_catchingPromiseCreated, _EventStream_terminalFailure, _EventStream_abortFromSignal, _EventStream_removeAbortListeners, _EventStream_onceForEmitted, _EventStream_removeEmittedListener, _EventStream_cleanupEmittedListeners, _EventStream_handleError, _EventStream_settleTerminalEvent;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../internal/tslib.mjs";
import { APIConnectionError, APIConnectionTimeoutError, APIError, APIUserAbortError, AuthenticationError, BadRequestError, ConflictError, ContentFilterFinishReasonError, InternalServerError, InvalidWebhookSignatureError, LengthFinishReasonError, NotFoundError, OAuthError, OpenAIError, PermissionDeniedError, RateLimitError, SubjectTokenProviderError, UnprocessableEntityError, } from "../error.mjs";
const MAX_BUFFERED_ITERATOR_EVENTS = 4096;
const MAX_BUFFERED_ITERATOR_BYTES = 8 * 1024 * 1024;
// Typed-array own-key enumeration materializes every dense index before custom keys.
const MAX_INSPECTABLE_TYPED_ARRAY_ELEMENTS = 4096;
// Structured JSON may nest 128 levels before stream-event wrappers are added.
const MAX_BUFFERED_EVENT_DEPTH = 256;
const bufferedJSONStringify = JSON.stringify;
const bufferedJSONParse = JSON.parse;
const sdkOwnedBufferedEventArguments = new WeakSet();
// SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
const typedArrayBufferGetter = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(Uint8Array.prototype), 'buffer')?.get;
// SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
const typedArrayLengthGetter = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(Uint8Array.prototype), 'length')?.get;
const dataViewBufferGetter = Object.getOwnPropertyDescriptor(DataView.prototype, 'buffer')?.get;
const symbolDescriptionGetter = Object.getOwnPropertyDescriptor(Symbol.prototype, 'description')?.get;
const dateTimestampGetter = Date.prototype.getTime;
const arrayBufferByteLengthGetter = Object.getOwnPropertyDescriptor(ArrayBuffer.prototype, 'byteLength')?.get;
const sharedArrayBufferByteLengthGetter = typeof SharedArrayBuffer === 'function'
    ? Object.getOwnPropertyDescriptor(SharedArrayBuffer.prototype, 'byteLength')?.get
    : undefined;
// V8 uses the same trusted lazy-stack accessor pair for native Error instances.
const errorStackDescriptor = Object.getOwnPropertyDescriptor(new Error('native stack descriptor'), 'stack');
const functionToString = Function.prototype.toString;
const objectToString = Object.prototype.toString;
const errorBrandDescriptor = Object.getOwnPropertyDescriptor(Error, 'isError');
// The native Error.isError predicate brands arbitrary values before an Error contract can be assumed.
// SAFETY: The captured native Error.isError property was checked to be a function before it is used as a brand predicate.
const nativeErrorBrand = errorBrandDescriptor && 'value' in errorBrandDescriptor && typeof errorBrandDescriptor.value === 'function'
    ? errorBrandDescriptor.value
    : undefined;
const nativeErrorConstructorSource = functionToString.call(Error);
const nativeDateConstructorSource = functionToString.call(Date);
const nativeFunctionConstructorSource = functionToString.call(Function);
const trustedIntrinsicPrototypes = new Set([
    APIConnectionError.prototype,
    APIConnectionTimeoutError.prototype,
    APIError.prototype,
    OpenAIError.prototype,
    APIUserAbortError.prototype,
    AuthenticationError.prototype,
    BadRequestError.prototype,
    ConflictError.prototype,
    ContentFilterFinishReasonError.prototype,
    InternalServerError.prototype,
    InvalidWebhookSignatureError.prototype,
    LengthFinishReasonError.prototype,
    NotFoundError.prototype,
    OAuthError.prototype,
    PermissionDeniedError.prototype,
    RateLimitError.prototype,
    SubjectTokenProviderError.prototype,
    UnprocessableEntityError.prototype,
]);
const trustedNativeConstructorSources = new Set();
const canonicalIntrinsicDescriptors = new Map();
const foreignErrorStackDescriptors = new WeakMap();
// oxlint-disable-next-line anti-slop/no-object-parameters -- The native proxy predicate accepts arbitrary object identities without invoking their handlers.
function captureNativeProxyDetector() {
    if (typeof process === 'undefined') {
        return undefined;
    }
    try {
        const loader = Object.getOwnPropertyDescriptor(process, 'getBuiltinModule');
        if (!loader || !('value' in loader) || typeof loader.value !== 'function') {
            return undefined;
        }
        // oxlint-disable-next-line anti-slop/no-reflect-apply -- Invoke the descriptor value without reading a potentially overridden call property.
        const util = Reflect.apply(loader.value, process, ['node:util']);
        if (typeof util !== 'object' || util === null) {
            return undefined;
        }
        const types = Object.getOwnPropertyDescriptor(util, 'types');
        if (!types || !('value' in types) || typeof types.value !== 'object' || types.value === null) {
            return undefined;
        }
        const detector = Object.getOwnPropertyDescriptor(types.value, 'isProxy');
        if (!detector || !('value' in detector) || typeof detector.value !== 'function') {
            return undefined;
        }
        // SAFETY: The native detector data property was checked to be callable; it is invoked only to test the corresponding intrinsic object brand.
        // oxlint-disable-next-line anti-slop/no-object-parameters -- The captured native predicate is called only for objects, before their properties are inspected.
        return detector.value;
    }
    catch {
        return undefined;
    }
}
// Transparent proxies have no portable ECMAScript brand. Newer Node runtimes
// expose one without adding a Node-only import to browser-compatible bundles.
const nativeProxyDetector = captureNativeProxyDetector();
function rememberTrustedIntrinsic(constructor) {
    if (typeof constructor !== 'function') {
        return;
    }
    const prototypeDescriptor = Object.getOwnPropertyDescriptor(constructor, 'prototype');
    if (!prototypeDescriptor ||
        !('value' in prototypeDescriptor) ||
        (typeof prototypeDescriptor.value !== 'object' && typeof prototypeDescriptor.value !== 'function')) {
        return;
    }
    // SAFETY: The prototype data descriptor was checked as a non-null object before adding its identity to the trusted-intrinsic set.
    trustedIntrinsicPrototypes.add(prototypeDescriptor.value);
    const source = functionToString.call(constructor);
    if (/^function [A-Za-z_$][\w$]*\(\) \{ \[native code\] \}$/u.test(source) &&
        prototypeDescriptor.configurable === false &&
        prototypeDescriptor.writable === false) {
        trustedNativeConstructorSources.add(source);
        const descriptors = new Map();
        for (const key of Reflect.ownKeys(prototypeDescriptor.value)) {
            const descriptor = Object.getOwnPropertyDescriptor(prototypeDescriptor.value, key);
            if (descriptor) {
                descriptors.set(key, descriptor);
            }
        }
        canonicalIntrinsicDescriptors.set(source, descriptors);
    }
}
for (const constructor of [
    Object,
    Function,
    Array,
    Date,
    Map,
    Set,
    ArrayBuffer,
    DataView,
    Error,
    EvalError,
    RangeError,
    ReferenceError,
    SyntaxError,
    TypeError,
    URIError,
    Uint8Array,
    Uint8ClampedArray,
    Uint16Array,
    Uint32Array,
    Int8Array,
    Int16Array,
    Int32Array,
    Float32Array,
    Float64Array,
]) {
    rememberTrustedIntrinsic(constructor);
}
for (const name of [
    'SharedArrayBuffer',
    'AggregateError',
    'Float16Array',
    'BigInt64Array',
    'BigUint64Array',
    'Blob',
    'File',
    'Headers',
]) {
    const descriptor = Object.getOwnPropertyDescriptor(globalThis, name);
    if (descriptor && 'value' in descriptor) {
        rememberTrustedIntrinsic(descriptor.value);
    }
}
// SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
const typedArrayConstructorDescriptor = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(Uint8Array.prototype), 'constructor');
if (typedArrayConstructorDescriptor && 'value' in typedArrayConstructorDescriptor) {
    rememberTrustedIntrinsic(typedArrayConstructorDescriptor.value);
}
if (typeof Buffer === 'function') {
    rememberTrustedIntrinsic(Buffer);
}
const blobInternalHandlePrototype = (() => {
    if (typeof Blob !== 'function') {
        return undefined;
    }
    try {
        const blob = new Blob([]);
        for (const key of Object.getOwnPropertySymbols(blob)) {
            const descriptor = Object.getOwnPropertyDescriptor(blob, key);
            if (descriptor && 'value' in descriptor && typeof descriptor.value === 'object' && descriptor.value) {
                // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
                return Object.getPrototypeOf(descriptor.value);
            }
        }
    }
    catch {
        return undefined;
    }
    return undefined;
})();
const mapEntries = Map.prototype.entries;
const setValues = Set.prototype.values;
const headersEntriesDescriptor = typeof Headers === 'function' ? Object.getOwnPropertyDescriptor(Headers.prototype, 'entries') : undefined;
// SAFETY: The own Headers entries data property was checked to be callable and retains the native method signature.
const headersEntries = headersEntriesDescriptor &&
    'value' in headersEntriesDescriptor &&
    typeof headersEntriesDescriptor.value === 'function'
    ? headersEntriesDescriptor.value
    : undefined;
const retainedStorageBrands = new Set([
    'ArrayBuffer',
    'SharedArrayBuffer',
    'Blob',
    'File',
    'Map',
    'Date',
    'Set',
    'Headers',
]);
// oxlint-disable-next-line anti-slop/no-object-parameters -- Foreign prototypes are untrusted objects until their constructor descriptors are verified.
function getTrustedForeignIntrinsic(prototype) {
    const descriptor = Object.getOwnPropertyDescriptor(prototype, 'constructor');
    if (!descriptor || !('value' in descriptor) || typeof descriptor.value !== 'function') {
        return undefined;
    }
    // SAFETY: The descriptor contains a function; the following native-source and prototype checks verify the Error constructor before use.
    const constructor = descriptor.value;
    const source = functionToString.call(constructor);
    const descriptors = canonicalIntrinsicDescriptors.get(source);
    if (!trustedNativeConstructorSources.has(source) || !descriptors) {
        return undefined;
    }
    const constructorPrototype = Object.getOwnPropertyDescriptor(constructor, 'prototype');
    if (!constructorPrototype ||
        !('value' in constructorPrototype) ||
        constructorPrototype.value !== prototype ||
        constructorPrototype.configurable !== false ||
        constructorPrototype.writable !== false) {
        return undefined;
    }
    // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
    return { constructor, descriptors, functionPrototype: Object.getPrototypeOf(constructor) };
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Intrinsic trust is established by object identity or verified cross-realm descriptors.
function isTrustedIntrinsicPrototype(prototype) {
    return trustedIntrinsicPrototypes.has(prototype) || getTrustedForeignIntrinsic(prototype) !== undefined;
}
function isCanonicalIntrinsicFunction(value, canonical, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- Cross-realm function prototypes are compared by identity without trusting a callable signature.
functionPrototype) {
    if (canonical === undefined) {
        return value === undefined;
    }
    if (typeof value !== 'function' || typeof canonical !== 'function') {
        return false;
    }
    const source = functionToString.call(canonical);
    if (functionToString.call(value) !== source) {
        return false;
    }
    // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
    const actualFunctionPrototype = Object.getPrototypeOf(value);
    if (actualFunctionPrototype === functionPrototype) {
        return true;
    }
    if (!/^function [A-Za-z_$][\w$]*\(\) \{ \[native code\] \}$/u.test(source)) {
        return false;
    }
    const intrinsic = getTrustedForeignIntrinsic(actualFunctionPrototype);
    return (intrinsic !== undefined &&
        functionToString.call(intrinsic.constructor) === nativeFunctionConstructorSource);
}
function isCanonicalIntrinsicDescriptor(descriptor, canonical, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- Descriptor validation compares the verified function-prototype identity without reading its fields.
functionPrototype) {
    if (!canonical ||
        descriptor.configurable !== canonical.configurable ||
        descriptor.enumerable !== canonical.enumerable ||
        'value' in descriptor !== 'value' in canonical) {
        return false;
    }
    if ('value' in descriptor && 'value' in canonical) {
        if (descriptor.writable !== canonical.writable) {
            return false;
        }
        if (typeof canonical.value === 'function') {
            return isCanonicalIntrinsicFunction(descriptor.value, canonical.value, functionPrototype);
        }
        if (canonical.value !== null && typeof canonical.value === 'object') {
            return false;
        }
        return Object.is(descriptor.value, canonical.value);
    }
    return (isCanonicalIntrinsicFunction(descriptor.get, canonical.get, functionPrototype) &&
        isCanonicalIntrinsicFunction(descriptor.set, canonical.set, functionPrototype));
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Native error branding must inspect arbitrary objects before assuming an Error contract.
function hasNativeErrorBrand(current) {
    if (nativeErrorBrand) {
        return nativeErrorBrand.call(Error, current);
    }
    let prototype = current;
    for (let depth = 0; prototype !== null && depth < MAX_BUFFERED_EVENT_DEPTH; depth += 1) {
        if (Object.getOwnPropertyDescriptor(prototype, Symbol.toStringTag)) {
            return false;
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
        prototype = Object.getPrototypeOf(prototype);
    }
    return prototype === null && objectToString.call(current) === '[object Error]';
}
function getVerifiedForeignErrorConstructor(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Foreign error constructors are verified from descriptors of an otherwise untrusted object.
current, stackDescriptor) {
    if (typeof stackDescriptor.get !== 'function' || typeof stackDescriptor.set !== 'function') {
        return undefined;
    }
    // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
    let prototype = Object.getPrototypeOf(current);
    for (let depth = 0; prototype !== null && depth < MAX_BUFFERED_EVENT_DEPTH; depth += 1) {
        const descriptor = Object.getOwnPropertyDescriptor(prototype, 'constructor');
        if (descriptor && 'value' in descriptor && typeof descriptor.value === 'function') {
            // SAFETY: The descriptor contains a function; the following intrinsic and constructor-prototype checks decide whether it is a trusted Error constructor.
            const constructor = descriptor.value;
            if (functionToString.call(constructor) === nativeErrorConstructorSource &&
                isTrustedIntrinsicPrototype(prototype)) {
                // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
                const functionPrototype = Object.getPrototypeOf(constructor);
                if (Object.getPrototypeOf(stackDescriptor.get) === functionPrototype &&
                    Object.getPrototypeOf(stackDescriptor.set) === functionPrototype) {
                    return { constructor, prototype };
                }
                return undefined;
            }
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
        prototype = Object.getPrototypeOf(prototype);
    }
    return undefined;
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Stack accessors are trusted only after the object passes native error branding.
function isTrustedNativeErrorStack(current, descriptor) {
    if (!hasNativeErrorBrand(current)) {
        return false;
    }
    if (errorStackDescriptor &&
        !('value' in errorStackDescriptor) &&
        typeof errorStackDescriptor.get === 'function' &&
        Object.prototype.isPrototypeOf.call(Error.prototype, current) &&
        descriptor.get === errorStackDescriptor.get &&
        descriptor.set === errorStackDescriptor.set) {
        return true;
    }
    const verified = getVerifiedForeignErrorConstructor(current, descriptor);
    if (!verified) {
        return false;
    }
    let canonicalDescriptor = foreignErrorStackDescriptors.get(verified.prototype);
    if (!canonicalDescriptor) {
        // SAFETY: Reflect.construct returns an untyped value; unknown preserves that uncertainty for the descriptor checks below.
        const canonical = Reflect.construct(verified.constructor, []);
        if (typeof canonical !== 'object' ||
            canonical === null ||
            !hasNativeErrorBrand(canonical) ||
            Object.getPrototypeOf(canonical) !== verified.prototype) {
            return false;
        }
        canonicalDescriptor = Object.getOwnPropertyDescriptor(canonical, 'stack');
        if (!canonicalDescriptor ||
            'value' in canonicalDescriptor ||
            typeof canonicalDescriptor.get !== 'function' ||
            typeof canonicalDescriptor.set !== 'function') {
            return false;
        }
        foreignErrorStackDescriptors.set(verified.prototype, canonicalDescriptor);
    }
    return descriptor.get === canonicalDescriptor.get && descriptor.set === canonicalDescriptor.set;
}
function createEventQueue() {
    let entries = [];
    let head = 0;
    return {
        get length() {
            return entries.length - head;
        },
        enqueue(value) {
            entries.push(value);
        },
        dequeue() {
            if (head === entries.length) {
                return undefined;
            }
            const value = entries[head];
            entries[head] = undefined;
            head += 1;
            if (head === entries.length) {
                entries = [];
                head = 0;
            }
            else if (head >= 1024 && head * 2 >= entries.length) {
                entries = entries.slice(head);
                head = 0;
            }
            return value;
        },
        clear() {
            entries = [];
            head = 0;
        },
    };
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- Retained storage branding walks arbitrary object prototypes without assuming their native type.
function getRetainedStorageBrand(current) {
    // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
    let prototype = Object.getPrototypeOf(current);
    for (let depth = 0; prototype !== null && depth < MAX_BUFFERED_EVENT_DEPTH; depth += 1) {
        if (prototype === Date.prototype) {
            return 'Date';
        }
        if (!trustedIntrinsicPrototypes.has(prototype)) {
            const constructor = Object.getOwnPropertyDescriptor(prototype, 'constructor');
            if (constructor &&
                'value' in constructor &&
                typeof constructor.value === 'function' &&
                functionToString.call(constructor.value) === nativeDateConstructorSource &&
                getTrustedForeignIntrinsic(prototype)) {
                return 'Date';
            }
        }
        const descriptor = Object.getOwnPropertyDescriptor(prototype, Symbol.toStringTag);
        if (descriptor &&
            'value' in descriptor &&
            typeof descriptor.value === 'string' &&
            retainedStorageBrands.has(descriptor.value)) {
            return descriptor.value;
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
        prototype = Object.getPrototypeOf(prototype);
    }
    return undefined;
}
function estimateRetainedBufferBytes(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Memory accounting inspects arbitrary retained objects and detects native backing storage at runtime.
current, visit, depth) {
    if (ArrayBuffer.isView(current)) {
        let buffer;
        let kind = 'typed-array';
        try {
            // SAFETY: The captured intrinsic getter performs its own receiver brand check; its result stays unknown until the ArrayBuffer validation below.
            buffer = typedArrayBufferGetter?.call(current);
        }
        catch {
            kind = 'data-view';
            // SAFETY: The DataView intrinsic getter performs its receiver brand check; its result stays unknown until the ArrayBuffer validation below.
            buffer = dataViewBufferGetter?.call(current);
        }
        if (typeof buffer !== 'object' || buffer === null) {
            return { bytes: Number.POSITIVE_INFINITY, kind };
        }
        // Even a one-byte cross-realm view retains its complete backing allocation.
        visit(buffer, depth + 1);
        return { bytes: 0, kind };
    }
    const brand = getRetainedStorageBrand(current);
    if (!brand) {
        return undefined;
    }
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- Captured native accessors are checked for a finite numeric result before retained-size accounting.
    let getter;
    const kind = 'buffer';
    switch (brand) {
        case 'ArrayBuffer': {
            getter = arrayBufferByteLengthGetter;
            break;
        }
        case 'SharedArrayBuffer': {
            getter = sharedArrayBufferByteLengthGetter;
            break;
        }
        case 'Blob':
        case 'File': {
            // Blob slices can retain an arbitrarily larger native backing allocation,
            // and neither browser nor Node exposes its extent or ownership. Detached
            // queues must fail closed; waiting readers bypass retained-size inspection.
            return { bytes: Number.POSITIVE_INFINITY, kind: 'blob' };
        }
        case 'Map': {
            return { bytes: 0, kind: 'map' };
        }
        case 'Date': {
            // oxlint-disable-next-line anti-slop/no-reflect-apply -- Invoke the captured intrinsic without reading its mutable call property.
            Reflect.apply(dateTimestampGetter, current, []);
            return { bytes: 8, kind: 'date' };
        }
        case 'Set': {
            return { bytes: 0, kind: 'set' };
        }
        case 'Headers': {
            return { bytes: 0, kind: 'headers' };
        }
        default: {
            return undefined;
        }
    }
    const bytes = getter?.call(current);
    return {
        bytes: typeof bytes === 'number' && Number.isSafeInteger(bytes) && bytes >= 0
            ? bytes
            : Number.POSITIVE_INFINITY,
        kind,
    };
}
function visitHiddenEventValues(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Native collection contents are inspected only after storage branding, without trusting structural fields.
current, kind, visit) {
    if (kind === 'map') {
        for (const [key, entry] of mapEntries.call(current)) {
            if (!visit(key, 8) || !visit(entry, 8)) {
                return false;
            }
        }
    }
    if (kind === 'set') {
        for (const entry of setValues.call(current)) {
            if (!visit(entry, 8)) {
                return false;
            }
        }
    }
    if (kind === 'headers') {
        if (!headersEntries) {
            return false;
        }
        // SAFETY: The captured native Headers.entries method performs its receiver brand check inside the enclosing try/catch.
        for (const [name, value] of headersEntries.call(current)) {
            if (!visit(name, 8) || !visit(value, 8)) {
                return false;
            }
        }
    }
    return true;
}
function getInspectableEventKeys(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Event key inspection must accept arbitrary retained objects, arrays, and native storage views.
current, kind, availableBytes) {
    if (Array.isArray(current)) {
        const descriptor = Object.getOwnPropertyDescriptor(current, 'length');
        const length = descriptor && 'value' in descriptor ? descriptor.value : undefined;
        if (typeof length !== 'number' ||
            !Number.isSafeInteger(length) ||
            length < 0 ||
            length > Math.floor(availableBytes / 16)) {
            return undefined;
        }
    }
    if (kind !== 'typed-array') {
        return Reflect.ownKeys(current);
    }
    const length = typedArrayLengthGetter?.call(current);
    if (typeof length !== 'number' ||
        !Number.isSafeInteger(length) ||
        length < 0 ||
        length > MAX_INSPECTABLE_TYPED_ARRAY_ELEMENTS) {
        return undefined;
    }
    return Reflect.ownKeys(current).filter((key) => {
        if (typeof key !== 'string') {
            return true;
        }
        const index = Number(key);
        return !Number.isInteger(index) || index < 0 || index >= length || String(index) !== key;
    });
}
function visitInspectableEventProperties(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Retained event properties are inspected through descriptors on arbitrary object identities.
current, kind, depth, availableBytes, charge, visit) {
    const keys = getInspectableEventKeys(current, kind, availableBytes());
    if (keys === undefined) {
        return false;
    }
    for (const key of keys) {
        if (!charge(typeof key === 'string' ? key.length * 2 + 8 : 8)) {
            return false;
        }
        if (typeof key === 'symbol') {
            visit(key, depth + 1);
        }
        const descriptor = Object.getOwnPropertyDescriptor(current, key);
        if (!descriptor) {
            return false;
        }
        if (!('value' in descriptor)) {
            if (key === 'stack' && isTrustedNativeErrorStack(current, descriptor)) {
                continue;
            }
            return false;
        }
        visit(descriptor.value, depth + 1, kind === 'blob');
    }
    return true;
}
function visitRetainedEventPrototypes(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Retention accounting follows arbitrary object prototypes without assuming their properties.
current, depth, isBlobInternalHandle, visited, availableBytes, charge, visit, 
// oxlint-disable-next-line anti-slop/no-object-parameters -- The retention callback records prototype identity before inspecting its descriptors.
retainPrototype) {
    // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
    let prototype = Object.getPrototypeOf(current);
    for (let prototypeDepth = depth + 1; prototype !== null; prototypeDepth += 1) {
        if (prototypeDepth >= MAX_BUFFERED_EVENT_DEPTH) {
            return false;
        }
        if (trustedIntrinsicPrototypes.has(prototype) ||
            (isBlobInternalHandle && prototype === blobInternalHandlePrototype)) {
            return true;
        }
        if (visited.has(prototype)) {
            visit(prototype, prototypeDepth);
            return availableBytes() >= 0;
        }
        visited.add(prototype);
        const retainedPrototype = prototype;
        const retained = retainPrototype(retainedPrototype, () => {
            if (!charge(16)) {
                return false;
            }
            const intrinsic = getTrustedForeignIntrinsic(retainedPrototype);
            if (!intrinsic) {
                return visitInspectableEventProperties(retainedPrototype, undefined, prototypeDepth, availableBytes, charge, visit);
            }
            for (const key of Reflect.ownKeys(retainedPrototype)) {
                const descriptor = Object.getOwnPropertyDescriptor(retainedPrototype, key);
                if (!descriptor) {
                    return false;
                }
                if (isCanonicalIntrinsicDescriptor(descriptor, intrinsic.descriptors.get(key), intrinsic.functionPrototype)) {
                    continue;
                }
                if (!charge(typeof key === 'string' ? key.length * 2 + 8 : 8) || !('value' in descriptor)) {
                    return false;
                }
                if (typeof key === 'symbol') {
                    visit(key, prototypeDepth + 1);
                }
                visit(descriptor.value, prototypeDepth + 1);
            }
            return availableBytes() >= 0;
        });
        if (!retained) {
            return false;
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; this native-prototype inspection does not assume an application-specific instance type.
        prototype = Object.getPrototypeOf(retainedPrototype);
    }
    return true;
}
const BUFFERED_LEDGER_ENTRY_BYTES = 32;
const BUFFERED_LEDGER_NODE_BYTES = 32;
const BUFFERED_LEDGER_EDGE_BYTES = 8;
const BUFFERED_LEDGER_OWNER_BYTES = 16;
const MAX_BUFFERED_LEDGER_RECONCILIATION_WORK = 128 * 1024;
function inspectBufferedEventGraph(value, remainingBytes) {
    let bytes = 0;
    let scalarBytes = 0;
    const visited = new WeakSet();
    const visitedSymbols = new Set();
    const roots = new Set();
    const nodes = new Map();
    let activeNode;
    const availableBytes = () => remainingBytes - bytes;
    const charge = (amount) => {
        if (!Number.isSafeInteger(amount) || amount < 0) {
            bytes = remainingBytes + 1;
            return false;
        }
        bytes += amount;
        if (activeNode) {
            activeNode.bytes += amount;
        }
        else {
            scalarBytes += amount;
        }
        return bytes <= remainingBytes;
    };
    // oxlint-disable-next-line anti-slop/no-object-parameters -- The ledger records object and symbol identities, which have no shared structural contract.
    const addIdentity = (identity) => {
        if (activeNode) {
            activeNode.edges.add(identity);
        }
        else {
            roots.add(identity);
        }
    };
    // oxlint-disable-next-line anti-slop/no-object-parameters -- Retained graph nodes are identified by object or symbol identity independently of their fields.
    const retainIdentity = (identity, inspect) => {
        addIdentity(identity);
        const node = { bytes: 0, edges: new Set() };
        nodes.set(identity, node);
        const previous = activeNode;
        activeNode = node;
        try {
            return inspect();
        }
        finally {
            activeNode = previous;
        }
    };
    const visitSymbol = (current) => {
        if (visitedSymbols.has(current)) {
            addIdentity(current);
            charge(8);
            return;
        }
        visitedSymbols.add(current);
        if (!retainIdentity(current, () => {
            if (!symbolDescriptionGetter) {
                return false;
            }
            // SAFETY: The captured Symbol description getter is called after the symbol branch and returns a string or undefined by its native contract.
            // oxlint-disable-next-line anti-slop/no-reflect-apply -- Invoke the captured intrinsic without reading its mutable call property.
            const description = Reflect.apply(symbolDescriptionGetter, current, []);
            return charge(8 + (description?.length ?? 0) * 2);
        })) {
            bytes = remainingBytes + 1;
        }
    };
    const visit = (current, depth, isBlobInternalHandle = false) => {
        if (bytes > remainingBytes) {
            return;
        }
        if (typeof current === 'string') {
            charge(current.length * 2);
            return;
        }
        if (typeof current === 'symbol') {
            visitSymbol(current);
            return;
        }
        if (typeof current === 'function') {
            bytes = remainingBytes + 1;
            return;
        }
        if (current === null || typeof current !== 'object') {
            charge(8);
            return;
        }
        if (nativeProxyDetector?.(current)) {
            bytes = remainingBytes + 1;
            return;
        }
        if (depth >= MAX_BUFFERED_EVENT_DEPTH) {
            bytes = remainingBytes + 1;
            return;
        }
        if (visited.has(current)) {
            addIdentity(current);
            charge(8);
            return;
        }
        visited.add(current);
        if (!retainIdentity(current, () => {
            if (!charge(16)) {
                return false;
            }
            const retainedStorage = estimateRetainedBufferBytes(current, visit, depth);
            if (!visitRetainedEventPrototypes(current, depth, isBlobInternalHandle, visited, availableBytes, charge, visit, retainIdentity)) {
                return false;
            }
            if (retainedStorage !== undefined && !charge(retainedStorage.bytes)) {
                return false;
            }
            if (!visitHiddenEventValues(current, retainedStorage?.kind, (hiddenValue, overhead) => {
                if (!charge(overhead)) {
                    return false;
                }
                visit(hiddenValue, depth + 1);
                return bytes <= remainingBytes;
            })) {
                return false;
            }
            return visitInspectableEventProperties(current, retainedStorage?.kind, depth, availableBytes, charge, visit);
        })) {
            bytes = remainingBytes + 1;
        }
    };
    try {
        visit(value, 0);
    }
    catch {
        return undefined;
    }
    return bytes <= remainingBytes ? { scalarBytes, roots, nodes } : undefined;
}
function areBufferedRetainedEdgesEqual(first, second) {
    if (first.size !== second.size) {
        return false;
    }
    for (const identity of first) {
        if (!second.has(identity)) {
            return false;
        }
    }
    return true;
}
function getBufferedLedgerNodeBytes(node, owners) {
    return (node.bytes +
        BUFFERED_LEDGER_NODE_BYTES +
        node.edges.size * BUFFERED_LEDGER_EDGE_BYTES +
        owners * BUFFERED_LEDGER_OWNER_BYTES);
}
function getBufferedLedgerEntryBytes(entry) {
    return BUFFERED_LEDGER_ENTRY_BYTES + entry.scalarBytes + entry.roots.size * BUFFERED_LEDGER_EDGE_BYTES;
}
function collectBufferedLedgerIdentities(roots, candidate, records, work) {
    const identities = new Set();
    const pending = [...roots];
    while (pending.length) {
        work.remaining -= 1;
        if (work.remaining < 0) {
            return undefined;
        }
        const identity = pending.pop();
        if (identities.has(identity)) {
            continue;
        }
        const node = candidate.get(identity) ?? records.get(identity);
        if (!node) {
            return undefined;
        }
        identities.add(identity);
        for (const edge of node.edges) {
            pending.push(edge);
        }
    }
    return identities;
}
function getBufferedLedgerChange(
// oxlint-disable-next-line anti-slop/no-object-parameters -- Ledger changes are keyed by object or symbol identity, not a structural event type.
identity, graph, records, changes, node) {
    const existing = changes.get(identity);
    if (existing) {
        if (node) {
            existing.node = node;
        }
        return existing;
    }
    const current = node ?? graph.nodes.get(identity) ?? records.get(identity);
    if (!current) {
        return undefined;
    }
    const update = { node: current, ownerDelta: 0 };
    changes.set(identity, update);
    return update;
}
function findBufferedLedgerAffectedOwners(entry, graph, records, changes, work) {
    const affected = new Set([entry]);
    for (const [identity, node] of graph.nodes) {
        work.remaining -= 1;
        if (work.remaining < 0) {
            return undefined;
        }
        const previous = records.get(identity);
        if (!previous) {
            continue;
        }
        const changedEdges = !areBufferedRetainedEdgesEqual(previous.edges, node.edges);
        if (previous.bytes !== node.bytes || changedEdges) {
            getBufferedLedgerChange(identity, graph, records, changes, node);
        }
        if (!changedEdges) {
            continue;
        }
        for (const owner of previous.owners) {
            work.remaining -= 1;
            if (work.remaining < 0) {
                return undefined;
            }
            affected.add(owner);
        }
    }
    return affected;
}
function updateBufferedLedgerMembershipChanges(owner, next, graph, records, changes, work) {
    for (const identity of owner.identities) {
        work.remaining -= 1;
        if (work.remaining < 0) {
            return false;
        }
        if (!next.has(identity)) {
            const update = getBufferedLedgerChange(identity, graph, records, changes);
            if (!update) {
                return false;
            }
            update.ownerDelta -= 1;
        }
    }
    for (const identity of next) {
        work.remaining -= 1;
        if (work.remaining < 0) {
            return false;
        }
        if (!owner.identities.has(identity)) {
            const update = getBufferedLedgerChange(identity, graph, records, changes);
            if (!update) {
                return false;
            }
            update.ownerDelta += 1;
        }
    }
    return true;
}
function collectBufferedLedgerMemberships(entry, graph, affected, records, changes, work) {
    const memberships = new Map();
    for (const owner of affected) {
        const roots = owner === entry ? graph.roots : owner.roots;
        const next = collectBufferedLedgerIdentities(roots, graph.nodes, records, work);
        if (!next || !updateBufferedLedgerMembershipChanges(owner, next, graph, records, changes, work)) {
            return undefined;
        }
        memberships.set(owner, next);
    }
    return memberships;
}
function projectBufferedLedgerBytes(currentBytes, entry, graph, isNew, changes, records) {
    let projected = currentBytes - (isNew ? 0 : getBufferedLedgerEntryBytes(entry)) + getBufferedLedgerEntryBytes(graph);
    for (const [identity, update] of changes) {
        const previous = records.get(identity);
        const owners = (previous?.owners.size ?? 0) + update.ownerDelta;
        if (owners < 0) {
            return undefined;
        }
        if (previous) {
            projected -= getBufferedLedgerNodeBytes(previous, previous.owners.size);
        }
        if (owners) {
            projected += getBufferedLedgerNodeBytes(update.node, owners);
        }
    }
    return Number.isSafeInteger(projected) && projected >= 0 && projected <= MAX_BUFFERED_ITERATOR_BYTES
        ? projected
        : undefined;
}
function applyBufferedLedgerChanges(records, changes, memberships) {
    for (const [identity, update] of changes) {
        const previous = records.get(identity);
        const owners = (previous?.owners.size ?? 0) + update.ownerDelta;
        if (!owners) {
            continue;
        }
        if (previous) {
            previous.bytes = update.node.bytes;
            previous.edges = update.node.edges;
        }
        else {
            records.set(identity, {
                bytes: update.node.bytes,
                edges: update.node.edges,
                owners: new Set(),
            });
        }
    }
    for (const [owner, next] of memberships) {
        for (const identity of owner.identities) {
            if (!next.has(identity)) {
                records.get(identity)?.owners.delete(owner);
            }
        }
        for (const identity of next) {
            if (!owner.identities.has(identity)) {
                records.get(identity).owners.add(owner);
            }
        }
        owner.identities = next;
    }
    for (const identity of changes.keys()) {
        if (records.get(identity)?.owners.size === 0) {
            records.delete(identity);
        }
    }
}
/**
 * Account for queue-owned identities once while charging bounded ownership and
 * edge metadata. Shared topology changes are reconciled for every queued owner.
 */
function createBufferedEventLedger() {
    const records = new Map();
    let bytes = 0;
    const reconcile = (entry, graph, isNew) => {
        const work = { remaining: MAX_BUFFERED_LEDGER_RECONCILIATION_WORK };
        const changes = new Map();
        const affected = findBufferedLedgerAffectedOwners(entry, graph, records, changes, work);
        if (!affected) {
            return false;
        }
        const memberships = collectBufferedLedgerMemberships(entry, graph, affected, records, changes, work);
        if (!memberships) {
            return false;
        }
        const projectedBytes = projectBufferedLedgerBytes(bytes, entry, graph, isNew, changes, records);
        if (projectedBytes === undefined) {
            return false;
        }
        applyBufferedLedgerChanges(records, changes, memberships);
        entry.scalarBytes = graph.scalarBytes;
        entry.roots = graph.roots;
        bytes = projectedBytes;
        return true;
    };
    const release = (entry) => {
        bytes -= getBufferedLedgerEntryBytes(entry);
        for (const identity of entry.identities) {
            const record = records.get(identity);
            if (!record?.owners.delete(entry)) {
                continue;
            }
            bytes -= BUFFERED_LEDGER_OWNER_BYTES;
            if (record.owners.size === 0) {
                bytes -= getBufferedLedgerNodeBytes(record, 0);
                records.delete(identity);
            }
        }
        entry.identities.clear();
    };
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The ledger contract contextually types its callbacks and keeps retained-identity internals private.
    return {
        retain(graph) {
            const entry = { scalarBytes: 0, roots: new Set(), identities: new Set() };
            return reconcile(entry, graph, true) ? entry : undefined;
        },
        refresh(entry, graph) {
            return reconcile(entry, graph, false);
        },
        release,
        clear() {
            records.clear();
            bytes = 0;
        },
    };
}
/** An abortable event stream with typed listeners, asynchronous iteration, and lifecycle state. */
export class EventStream {
    /** Creates an unstarted stream with independent connection and completion lifecycle promises. */
    constructor() {
        _EventStream_instances.add(this);
        /** Controls the underlying request; aborting this controller cancels the stream. */
        this.controller = new AbortController();
        _EventStream_connectedPromise.set(this, void 0);
        // oxlint-disable class-methods-use-this -- Deferred promise resolvers are intentionally per-instance mutable callbacks.
        _EventStream_resolveConnectedPromise.set(this, () => undefined);
        _EventStream_rejectConnectedPromise.set(this, () => undefined);
        _EventStream_endPromise.set(this, void 0);
        _EventStream_resolveEndPromise.set(this, () => undefined);
        _EventStream_rejectEndPromise.set(this, () => undefined);
        // oxlint-enable class-methods-use-this
        _EventStream_listeners.set(this, Object.create(null));
        _EventStream_abortListeners.set(this, []);
        _EventStream_emittedListenerRegistrations.set(this, new WeakMap());
        _EventStream_pendingListenerCleanup.set(this, new Set());
        _EventStream_pendingBufferedEventChecks.set(this, new Set());
        _EventStream_listenerDispatchDepth.set(this, 0);
        _EventStream_ended.set(this, false);
        _EventStream_errored.set(this, false);
        _EventStream_aborted.set(this, false);
        _EventStream_catchingPromiseCreated.set(this, false);
        // Terminal failure recorded during settlement, before `end` is emitted, so
        // iterators can surface it even when a throwing user listener prevented
        // their internal failure listeners from running.
        _EventStream_terminalFailure.set(this, void 0);
        __classPrivateFieldSet(this, _EventStream_connectedPromise, new Promise((resolve, reject) => {
            __classPrivateFieldSet(this, _EventStream_resolveConnectedPromise, resolve, "f");
            __classPrivateFieldSet(this, _EventStream_rejectConnectedPromise, reject, "f");
        }), "f");
        __classPrivateFieldSet(this, _EventStream_endPromise, new Promise((resolve, reject) => {
            __classPrivateFieldSet(this, _EventStream_resolveEndPromise, resolve, "f");
            __classPrivateFieldSet(this, _EventStream_rejectEndPromise, reject, "f");
        }), "f");
        // Don't let these promises cause unhandled rejection errors.
        // we will manually cause an unhandled rejection error later
        // if the user hasn't registered any error listener or called
        // any promise-returning method.
        __classPrivateFieldGet(this, _EventStream_connectedPromise, "f").catch(() => undefined);
        __classPrivateFieldGet(this, _EventStream_endPromise, "f").catch(() => undefined);
    }
    _run(executor) {
        // Unfortunately if we call `executor()` immediately we get runtime errors about
        // references to `this` before the `super()` constructor call returns.
        setTimeout(() => {
            let failed = false;
            Promise.resolve()
                .then(executor)
                .catch((error) => {
                failed = true;
                __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_handleError).call(this, error);
            })
                .then(() => {
                if (failed) {
                    return;
                }
                try {
                    this._emitFinal();
                }
                catch (error) {
                    __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_handleError).call(this, error);
                    return;
                }
                this._emit('end');
            });
        }, 0);
    }
    _connected() {
        if (this.ended) {
            return;
        }
        __classPrivateFieldGet(this, _EventStream_resolveConnectedPromise, "f").call(this);
        this._emit('connect');
    }
    /** Whether the stream has finished successfully, failed, or been aborted. */
    get ended() {
        return __classPrivateFieldGet(this, _EventStream_ended, "f");
    }
    /** Whether an error or user cancellation has been observed. */
    get errored() {
        return __classPrivateFieldGet(this, _EventStream_errored, "f");
    }
    /** Whether the stream ended because its request was cancelled. */
    get aborted() {
        return __classPrivateFieldGet(this, _EventStream_aborted, "f");
    }
    /**
     * Cancels the underlying request; {@link done} and {@link events} observe cancellation.
     * Promises returned by {@link emitted} for other events may remain pending.
     */
    abort() {
        this.controller.abort();
    }
    /** Creates a user-abort error retaining this runner's cancellation reason. */
    _userAbortError() {
        const error = new APIUserAbortError();
        Object.defineProperty(error, 'cause', {
            value: this.controller.signal.reason,
            writable: true,
            configurable: true,
        });
        return error;
    }
    _listenForAbort(signal) {
        if (!signal || this.ended) {
            return;
        }
        if (signal.aborted) {
            __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_abortFromSignal).call(this, signal);
            return;
        }
        if (__classPrivateFieldGet(this, _EventStream_abortListeners, "f").some((registration) => registration.signal === signal)) {
            return;
        }
        const listener = () => __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_abortFromSignal).call(this, signal);
        signal.addEventListener('abort', listener, { once: true });
        __classPrivateFieldGet(this, _EventStream_abortListeners, "f").push({ signal, listener });
    }
    /**
     * Adds the listener function to the end of the listeners array for the event.
     * No checks are made to see if the listener has already been added. Multiple calls passing
     * the same combination of event and listener will result in the listener being added, and
     * called, multiple times.
     * @returns This stream, so that listener registration calls can be chained.
     */
    on(event, listener) {
        var _a;
        const listeners = ((_a = __classPrivateFieldGet(this, _EventStream_listeners, "f"))[event] || (_a[event] = []));
        listeners.push({ listener });
        return this;
    }
    /**
     * Removes the specified listener from the listener array for the event.
     * off() will remove, at most, one instance of a listener from the listener array. If any single
     * listener has been added multiple times to the listener array for the specified event, then
     * off() must be called multiple times to remove each instance.
     * @returns This stream, so that listener registration calls can be chained.
     */
    off(event, listener) {
        const listeners = __classPrivateFieldGet(this, _EventStream_listeners, "f")[event];
        if (!listeners) {
            return this;
        }
        // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
        const emittedRegistration = __classPrivateFieldGet(this, _EventStream_emittedListenerRegistrations, "f").get(listener);
        if (emittedRegistration?.event === event &&
            !emittedRegistration.registration.removed &&
            !emittedRegistration.registration.detached) {
            // SAFETY: The stored registration event was compared with this event above, preserving the event/listener type correlation.
            __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_removeEmittedListener).call(this, event, emittedRegistration.registration);
            return this;
        }
        const index = listeners.findIndex((l) => !l.removed && l.listener === listener);
        if (index !== -1) {
            listeners.splice(index, 1);
        }
        return this;
    }
    /**
     * Adds a one-time listener function for the event. The next time the event is triggered,
     * this listener is removed and then invoked.
     * @returns This stream, so that listener registration calls can be chained.
     */
    once(event, listener) {
        var _a;
        const listeners = ((_a = __classPrivateFieldGet(this, _EventStream_listeners, "f"))[event] || (_a[event] = []));
        listeners.push({ listener, once: true });
        return this;
    }
    /**
     * This is similar to `.once()`, but returns a Promise that resolves the next time
     * the event is triggered, instead of calling a listener callback.
     * Events without arguments resolve to `undefined`, single-argument events resolve
     * to that argument, and events with multiple arguments resolve to an argument tuple.
     *
     * @returns A promise for the next event, or a rejection if an error occurs first.
     * Requesting the `error` event resolves with the emitted error instead.
     *
     * Example:
     *
     *   const message = await stream.emitted('message') // rejects if the stream errors
     */
    emitted(event) {
        return new Promise((resolve, reject) => {
            __classPrivateFieldSet(this, _EventStream_catchingPromiseCreated, true, "f");
            const onError = (error) => {
                // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
                this.off(event, onEvent);
                reject(error);
            };
            const onEvent = (...values) => {
                if (event !== 'error') {
                    this.off('error', onError);
                }
                // SAFETY: The emitted API returns the sole argument or the full tuple according to its existing EventTypes-dependent result contract.
                resolve((values.length > 1 ? values : values[0]));
            };
            if (event !== 'error') {
                // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
                __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_onceForEmitted).call(this, 'error', onError);
            }
            // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
            __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_onceForEmitted).call(this, event, onEvent);
        });
    }
    /**
     * Returns an async iterator that yields every time the event is triggered.
     * The iterator ends when the stream ends and rejects if the stream errors
     * or is aborted. If you request the 'error' or 'abort' event, the iterator
     * yields that event instead of rejecting.
     *
     * Example:
     *
     *   for await (const [message] of stream.events('message')) {
     *     await processMessage(message);
     *   }
     */
    events(event) {
        return this._createIterator((push) => {
            const onEvent = (...args) => {
                sdkOwnedBufferedEventArguments.add(args);
                try {
                    push(args);
                }
                finally {
                    sdkOwnedBufferedEventArguments.delete(args);
                }
            };
            // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
            this.on(event, onEvent);
            // SAFETY: This callback is paired with the same event when registered and removed; its variadic body forwards the event tuple or captured error.
            return () => this.off(event, onEvent);
        }, {
            // When iterating the 'error' or 'abort' event itself, yield it as a
            // value instead of rejecting the iterator.
            rejectOnError: event !== 'error',
            rejectOnAbort: event !== 'abort',
        });
    }
    /**
     * Shared buffered async-iterator adapter over this stream's events.
     *
     * `attach` registers the producer listener(s) with the given `push` and
     * returns a cleanup function that removes them. Termination is handled
     * here: the iterator ends when the stream ends, listeners are removed on
     * end/return, and a terminal error is retained until buffered values have
     * drained so it is surfaced even when no reader was waiting when it fired.
     * Detached consumers have bounded event and byte queues; exceeding either
     * limit fails the stream and aborts its underlying request. Detached queues
     * also reject accessor-backed payloads because getter closures cannot be
     * safely sized without executing untrusted code.
     */
    _createIterator(attach, { rejectOnError = true, rejectOnAbort = true, onReturn, } = {}) {
        const pushQueue = createEventQueue();
        const bufferedEventSizes = createEventQueue();
        const readQueue = createEventQueue();
        const bufferedLedger = createBufferedEventLedger();
        let ended = this.ended;
        let failure;
        let failureDelivered = false;
        let detach = () => undefined;
        // SAFETY: A completed iterator result has no yielded value; never preserves the iterator public result type for done: true.
        const doneResult = () => ({ value: undefined, done: true });
        const finishReaders = () => {
            while (readQueue.length) {
                readQueue.dequeue().resolve(doneResult());
            }
        };
        const rejectReader = () => {
            if (!failure || failureDelivered || !readQueue.length) {
                return;
            }
            failureDelivered = true;
            readQueue.dequeue().reject(failure);
        };
        const cleanup = () => {
            detach();
            this.off('end', onEnd);
            if (rejectOnError) {
                this.off('error', onFailure);
            }
            if (rejectOnAbort) {
                this.off('abort', onFailure);
            }
        };
        const deactivateBufferedEvent = (entry) => {
            entry.active = false;
            if (entry.check) {
                __classPrivateFieldGet(this, _EventStream_pendingBufferedEventChecks, "f").delete(entry.check);
                entry.check = undefined;
            }
        };
        const failBufferedEvents = (discardRetained = false) => {
            if (discardRetained) {
                while (bufferedEventSizes.length) {
                    deactivateBufferedEvent(bufferedEventSizes.dequeue());
                }
                pushQueue.clear();
                bufferedLedger.clear();
            }
            const error = new OpenAIError(`Event stream iterator buffer limit exceeded (${MAX_BUFFERED_ITERATOR_EVENTS} events or ${MAX_BUFFERED_ITERATOR_BYTES} bytes); consume events as they arrive.`);
            try {
                __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_handleError).call(this, error);
            }
            finally {
                this.controller.abort();
            }
            return error;
        };
        const revalidateBufferedEvent = (value, entry) => {
            if (!entry.active || __classPrivateFieldGet(this, _EventStream_ended, "f")) {
                return;
            }
            const graph = inspectBufferedEventGraph(value, MAX_BUFFERED_ITERATOR_BYTES);
            if (!graph || !bufferedLedger.refresh(entry.retention, graph)) {
                failBufferedEvents(true);
            }
        };
        const push = (value) => {
            if (ended) {
                return;
            }
            const reader = readQueue.dequeue();
            if (reader) {
                reader.resolve({ value, done: false });
            }
            else {
                if (pushQueue.length >= MAX_BUFFERED_ITERATOR_EVENTS) {
                    failBufferedEvents();
                    return;
                }
                const graph = inspectBufferedEventGraph(value, MAX_BUFFERED_ITERATOR_BYTES);
                const retention = graph && bufferedLedger.retain(graph);
                if (!retention) {
                    failBufferedEvents();
                    return;
                }
                if (typeof value === 'object' && value !== null && sdkOwnedBufferedEventArguments.has(value)) {
                    // SAFETY: Only SDK-created argument tuples are inserted into this private WeakSet, so membership establishes the array identity.
                    const argumentsTuple = value;
                    for (let index = 0; index < argumentsTuple.length; index += 1) {
                        const argument = argumentsTuple[index];
                        if (typeof argument === 'string') {
                            // SAFETY: The branch checked argument is a string; JSON stringify/parse returns that same string value while detaching retained storage.
                            argumentsTuple[index] = bufferedJSONParse(bufferedJSONStringify(argument));
                        }
                    }
                }
                const entry = { retention, active: true, check: undefined };
                pushQueue.enqueue(value);
                bufferedEventSizes.enqueue(entry);
                const check = () => {
                    entry.check = undefined;
                    revalidateBufferedEvent(value, entry);
                };
                entry.check = check;
                __classPrivateFieldGet(this, _EventStream_pendingBufferedEventChecks, "f").add(check);
            }
        };
        const onFailure = (error) => {
            failure = error;
            if (!pushQueue.length) {
                rejectReader();
            }
        };
        // A throwing user listener registered before this iterator stops dispatch
        // before onFailure runs; adopt the failure the stream recorded during
        // settlement so terminal errors are never converted into clean completion.
        const adoptTerminalFailure = () => {
            if (failure) {
                return;
            }
            const terminal = __classPrivateFieldGet(this, _EventStream_terminalFailure, "f");
            if (!terminal) {
                return;
            }
            if (terminal.kind === 'error' ? rejectOnError : rejectOnAbort) {
                failure = terminal.error;
            }
        };
        const onEnd = () => {
            ended = true;
            adoptTerminalFailure();
            cleanup();
            if (!pushQueue.length) {
                rejectReader();
                finishReaders();
            }
        };
        if (!ended) {
            detach = attach(push);
            this.on('end', onEnd);
            if (rejectOnError) {
                this.on('error', onFailure);
            }
            if (rejectOnAbort) {
                this.on('abort', onFailure);
            }
        }
        return {
            next: () => {
                if (pushQueue.length) {
                    const value = pushQueue.dequeue();
                    const entry = bufferedEventSizes.dequeue();
                    deactivateBufferedEvent(entry);
                    const graph = inspectBufferedEventGraph(value, MAX_BUFFERED_ITERATOR_BYTES);
                    if (!graph || !bufferedLedger.refresh(entry.retention, graph)) {
                        const error = failBufferedEvents(true);
                        failureDelivered = true;
                        return Promise.reject(error);
                    }
                    bufferedLedger.release(entry.retention);
                    return Promise.resolve({ value, done: false });
                }
                if (ended || this.ended) {
                    adoptTerminalFailure();
                }
                if (failure && !failureDelivered) {
                    failureDelivered = true;
                    return Promise.reject(failure);
                }
                if (ended) {
                    return Promise.resolve(doneResult());
                }
                return new Promise((resolve, reject) => {
                    readQueue.enqueue({ resolve, reject });
                });
            },
            return: () => {
                ended = true;
                // The consumer walked away; terminal failures recorded later must not
                // resurface through this iterator.
                failureDelivered = true;
                while (bufferedEventSizes.length) {
                    deactivateBufferedEvent(bufferedEventSizes.dequeue());
                }
                pushQueue.clear();
                bufferedLedger.clear();
                cleanup();
                finishReaders();
                if (onReturn) {
                    // The consumer explicitly ended iteration, so any failure the
                    // onReturn callback triggers (e.g. aborting the stream) is
                    // self-inflicted; mark the stream's terminal promise as handled so
                    // it does not surface as an unhandled rejection.
                    void this.done().catch(() => undefined);
                    onReturn();
                }
                return Promise.resolve(doneResult());
            },
            [Symbol.asyncIterator]() {
                return this;
            },
        };
    }
    /** Resolves when the stream ends successfully or rejects when it fails or is aborted. */
    async done() {
        __classPrivateFieldSet(this, _EventStream_catchingPromiseCreated, true, "f");
        await __classPrivateFieldGet(this, _EventStream_endPromise, "f");
    }
    /** Returns whether an event currently has one or more registered listeners. */
    _hasListeners(event) {
        return Boolean(__classPrivateFieldGet(this, _EventStream_listeners, "f")[event]?.some((listener) => !listener.removed));
    }
    /** Dispatches a stream event and performs the associated lifecycle transitions. */
    _emit(event, ...args) {
        // make sure we don't emit any events after end
        if (__classPrivateFieldGet(this, _EventStream_ended, "f")) {
            return;
        }
        if (event === 'end') {
            __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_removeAbortListeners).call(this);
            __classPrivateFieldSet(this, _EventStream_ended, true, "f");
            __classPrivateFieldGet(this, _EventStream_resolveEndPromise, "f").call(this);
        }
        const listeners = __classPrivateFieldGet(this, _EventStream_listeners, "f")[event];
        let dispatchError;
        let dispatchThrew = false;
        try {
            if (listeners) {
                // SAFETY: Filtering only removes registrations from the same event bucket and preserves the listener signatures for that event.
                __classPrivateFieldGet(this, _EventStream_listeners, "f")[event] = listeners.filter((listener) => {
                    if (listener.once) {
                        listener.detached = true;
                    }
                    return !listener.once && !listener.removed;
                });
                __classPrivateFieldSet(this, _EventStream_listenerDispatchDepth, __classPrivateFieldGet(this, _EventStream_listenerDispatchDepth, "f") + 1, "f");
                try {
                    // SAFETY: The listener bucket and argument tuple come from the same EventTypes key; this bridges TypeScript generic indexed-access correlation.
                    for (const registration of listeners) {
                        if (!registration.removed) {
                            const { listener } = registration;
                            // SAFETY: The listener bucket and argument tuple come from the same EventTypes key; this bridges TypeScript generic indexed-access correlation.
                            listener(...args);
                        }
                    }
                }
                finally {
                    __classPrivateFieldSet(this, _EventStream_listenerDispatchDepth, __classPrivateFieldGet(this, _EventStream_listenerDispatchDepth, "f") - 1, "f");
                    if (__classPrivateFieldGet(this, _EventStream_listenerDispatchDepth, "f") === 0) {
                        __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_cleanupEmittedListeners).call(this);
                        for (const check of __classPrivateFieldGet(this, _EventStream_pendingBufferedEventChecks, "f")) {
                            __classPrivateFieldGet(this, _EventStream_pendingBufferedEventChecks, "f").delete(check);
                            if (!__classPrivateFieldGet(this, _EventStream_ended, "f")) {
                                check();
                            }
                        }
                    }
                }
            }
        }
        catch (error) {
            dispatchError = error;
            dispatchThrew = true;
        }
        try {
            __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_settleTerminalEvent).call(this, event, args, Boolean(listeners?.length));
        }
        catch (error) {
            if (!dispatchThrew) {
                dispatchError = error;
                dispatchThrew = true;
            }
        }
        if (dispatchThrew) {
            throw dispatchError;
        }
    }
    // oxlint-disable-next-line class-methods-use-this -- Subclasses override this instance hook.
    _emitFinal() {
        // Hook for subclasses.
    }
}
_EventStream_connectedPromise = new WeakMap(), _EventStream_resolveConnectedPromise = new WeakMap(), _EventStream_rejectConnectedPromise = new WeakMap(), _EventStream_endPromise = new WeakMap(), _EventStream_resolveEndPromise = new WeakMap(), _EventStream_rejectEndPromise = new WeakMap(), _EventStream_listeners = new WeakMap(), _EventStream_abortListeners = new WeakMap(), _EventStream_emittedListenerRegistrations = new WeakMap(), _EventStream_pendingListenerCleanup = new WeakMap(), _EventStream_pendingBufferedEventChecks = new WeakMap(), _EventStream_listenerDispatchDepth = new WeakMap(), _EventStream_ended = new WeakMap(), _EventStream_errored = new WeakMap(), _EventStream_aborted = new WeakMap(), _EventStream_catchingPromiseCreated = new WeakMap(), _EventStream_terminalFailure = new WeakMap(), _EventStream_instances = new WeakSet(), _EventStream_abortFromSignal = function _EventStream_abortFromSignal(signal) {
    try {
        this.controller.abort(signal.reason);
    }
    catch {
        this.controller.abort();
    }
}, _EventStream_removeAbortListeners = function _EventStream_removeAbortListeners() {
    for (const { signal, listener } of __classPrivateFieldGet(this, _EventStream_abortListeners, "f").splice(0)) {
        signal.removeEventListener('abort', listener);
    }
}, _EventStream_onceForEmitted = function _EventStream_onceForEmitted(event, listener) {
    const previousListeners = __classPrivateFieldGet(this, _EventStream_listeners, "f")[event];
    const previousLength = previousListeners?.length ?? 0;
    this.once(event, listener);
    const listeners = __classPrivateFieldGet(this, _EventStream_listeners, "f")[event];
    const [registration] = listeners?.slice(-1) ?? [];
    if ((previousListeners === undefined || listeners === previousListeners) &&
        listeners?.length === previousLength + 1 &&
        registration?.listener === listener &&
        registration.once) {
        // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
        __classPrivateFieldGet(this, _EventStream_emittedListenerRegistrations, "f").set(listener, { event, registration });
    }
}, _EventStream_removeEmittedListener = function _EventStream_removeEmittedListener(event, registration) {
    if (registration.removed) {
        return;
    }
    registration.removed = true;
    // SAFETY: Listener functions are object identities used as WeakMap keys; registration and removal use the same function instance.
    __classPrivateFieldGet(this, _EventStream_emittedListenerRegistrations, "f").delete(registration.listener);
    __classPrivateFieldGet(this, _EventStream_pendingListenerCleanup, "f").add(event);
    if (__classPrivateFieldGet(this, _EventStream_listenerDispatchDepth, "f") === 0) {
        __classPrivateFieldGet(this, _EventStream_instances, "m", _EventStream_cleanupEmittedListeners).call(this);
    }
}, _EventStream_cleanupEmittedListeners = function _EventStream_cleanupEmittedListeners() {
    for (const event of __classPrivateFieldGet(this, _EventStream_pendingListenerCleanup, "f")) {
        // SAFETY: Pending cleanup keys are added only from registered EventTypes events; the key retains its event-map membership.
        const eventType = event;
        const listeners = __classPrivateFieldGet(this, _EventStream_listeners, "f")[eventType];
        if (listeners) {
            // SAFETY: Filtering only removes registrations from the same event bucket and preserves the listener signatures for that event.
            __classPrivateFieldGet(this, _EventStream_listeners, "f")[eventType] = listeners.filter((listener) => !listener.removed);
        }
    }
    __classPrivateFieldGet(this, _EventStream_pendingListenerCleanup, "f").clear();
}, _EventStream_handleError = function _EventStream_handleError(error) {
    __classPrivateFieldSet(this, _EventStream_errored, true, "f");
    if (error instanceof Error && error.name === 'AbortError') {
        error = this._userAbortError();
    }
    if (error instanceof APIUserAbortError) {
        __classPrivateFieldSet(this, _EventStream_aborted, true, "f");
        return this._emit('abort', error);
    }
    if (error instanceof OpenAIError) {
        return this._emit('error', error);
    }
    if (error instanceof Error) {
        const openAIError = new OpenAIError(error.message);
        // @ts-ignore
        openAIError.cause = error;
        return this._emit('error', openAIError);
    }
    return this._emit('error', new OpenAIError(String(error)));
}, _EventStream_settleTerminalEvent = function _EventStream_settleTerminalEvent(event, args, hasListeners) {
    if (event === 'abort') {
        // SAFETY: The abort event key selects the APIUserAbortError argument tuple established by the typed emit contract.
        const error = args[0];
        __classPrivateFieldSet(this, _EventStream_terminalFailure, __classPrivateFieldGet(this, _EventStream_terminalFailure, "f") ?? { kind: 'abort', error }, "f");
        if (!__classPrivateFieldGet(this, _EventStream_catchingPromiseCreated, "f") && !hasListeners) {
            Promise.reject(error);
        }
        __classPrivateFieldGet(this, _EventStream_rejectConnectedPromise, "f").call(this, error);
        __classPrivateFieldGet(this, _EventStream_rejectEndPromise, "f").call(this, error);
        this._emit('end');
        return;
    }
    if (event === 'error') {
        // NOTE: _emit('error', error) should only be called from #handleError().
        // SAFETY: The error event is emitted by the error-normalization path, which supplies an OpenAIError as its first argument.
        const error = args[0];
        __classPrivateFieldSet(this, _EventStream_terminalFailure, __classPrivateFieldGet(this, _EventStream_terminalFailure, "f") ?? { kind: 'error', error }, "f");
        if (!__classPrivateFieldGet(this, _EventStream_catchingPromiseCreated, "f") && !hasListeners) {
            // Trigger an unhandled rejection if the user hasn't registered any error handlers.
            // If you are seeing stack traces here, make sure to handle errors via either:
            // - runner.on('error', () => ...)
            // - await runner.done()
            // - await runner.finalChatCompletion()
            // - etc.
            Promise.reject(error);
        }
        __classPrivateFieldGet(this, _EventStream_rejectConnectedPromise, "f").call(this, error);
        __classPrivateFieldGet(this, _EventStream_rejectEndPromise, "f").call(this, error);
        this._emit('end');
    }
};
//# sourceMappingURL=EventStream.mjs.map