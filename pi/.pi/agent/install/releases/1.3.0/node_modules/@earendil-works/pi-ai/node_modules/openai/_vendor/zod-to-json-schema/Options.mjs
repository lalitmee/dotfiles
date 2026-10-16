export const ignoreOverride = Symbol('Let zodToJsonSchema decide on which parser to use');
const defaultOptions = {
    name: undefined,
    $refStrategy: 'root',
    effectStrategy: 'input',
    pipeStrategy: 'all',
    dateStrategy: 'format:date-time',
    mapStrategy: 'entries',
    nullableStrategy: 'from-target',
    removeAdditionalStrategy: 'passthrough',
    definitionPath: 'definitions',
    target: 'jsonSchema7',
    strictUnions: false,
    errorMessages: false,
    markdownDescription: false,
    patternStrategy: 'escape',
    applyRegexFlags: false,
    emailStrategy: 'format:email',
    base64Strategy: 'contentEncoding:base64',
    nameStrategy: 'ref',
};
export const getDefaultOptions = (options) => {
    // We need to add `definitions` here as we may mutate it
    // Preserve the public string-name overload alongside object options.
    // SAFETY: Defaults and the supplied options are merged into the vendored converter's target-specific options contract, with fresh mutable definitions.
    const resolvedOptions = (typeof options === 'string'
        ? {
            ...defaultOptions,
            basePath: ['#'],
            definitions: {},
            name: options,
        }
        : {
            ...defaultOptions,
            basePath: ['#'],
            definitions: {},
            ...options,
        });
    if (typeof options !== 'string' &&
        options?.definitions &&
        resolvedOptions.$refStrategy === 'extract-to-root' &&
        resolvedOptions.nameStrategy === 'duplicate-ref') {
        resolvedOptions.definitions = { ...options.definitions };
    }
    return resolvedOptions;
};
//# sourceMappingURL=Options.mjs.map