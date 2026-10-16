/**
 * A provider factory such as `bedrock(options)` captures configuration in a
 * definition, while every OpenAI client receives a fresh runtime from
 * `definition.configure()`. Keeping definitions out of the provider object
 * makes providers opaque and prevents arbitrary objects from imitating one.
 * It also leaves provider-specific dependencies outside the core SDK.
 *
 * The registry lives on `globalThis` under a global symbol so a provider made
 * by one copy of the package still works with another copy, including mixed
 * CommonJS and ESM installations. The WeakMap avoids retaining discarded
 * provider configurations.
 */
const providerDefinitionsKey = Symbol.for('openai.node.providerDefinitions.v1');
// SAFETY: This versioned global symbol is the SDK-owned cross-copy WeakMap registry; no provider object fields are trusted through it.
const providerGlobal = globalThis;
// SAFETY: This versioned global symbol is the SDK-owned cross-copy WeakMap registry; no provider object fields are trusted through it.
const existingProviderDefinitions = providerGlobal[providerDefinitionsKey];
const providerDefinitions = existingProviderDefinitions ?? new WeakMap();
if (!existingProviderDefinitions) {
    Object.defineProperty(providerGlobal, providerDefinitionsKey, { value: providerDefinitions });
}
/**
 * Creates an opaque, immutable provider handle for a runtime definition.
 *
 * The definition is registered out of band and can be resolved by another
 * installed copy of the SDK in the same JavaScript realm.
 */
export function createProvider(definition) {
    // SAFETY: This function creates the opaque handle and immediately registers its identity in the private WeakMap, which is the runtime brand check.
    const provider = Object.freeze({});
    providerDefinitions.set(provider, definition);
    return provider;
}
/**
 * Creates a new client-specific runtime from a previously registered provider.
 *
 * @throws {Error} If the value was not created with {@link createProvider}.
 */
export function configureProvider(provider) {
    const definition = providerDefinitions.get(provider);
    if (!definition) {
        throw new Error('Invalid provider. Providers must be created with createProvider().');
    }
    return definition.configure();
}
//# sourceMappingURL=provider.mjs.map