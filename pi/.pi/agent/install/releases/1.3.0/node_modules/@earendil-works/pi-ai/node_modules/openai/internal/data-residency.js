"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.resolveDataResidency = resolveDataResidency;
exports.assertNoDataResidency = assertNoDataResidency;
const error_1 = require("../core/error.js");
const values_1 = require("./utils/values.js");
const endpoints = new Map([
    ['global', 'https://api.openai.com/v1'],
    ['us', 'https://us.api.openai.com/v1'],
    ['eu', 'https://eu.api.openai.com/v1'],
    ['ae', 'https://ae.api.openai.com/v1'],
]);
/** Resolves an explicit residency selection before client options are inherited. */
function resolveDataResidency(options) {
    if (options.dataResidency === null || options.dataResidency === undefined) {
        return undefined;
    }
    if ((0, values_1.hasOwn)(options, 'baseURL')) {
        throw new error_1.OpenAIError('The `dataResidency` and `baseURL` options are mutually exclusive.');
    }
    const endpoint = endpoints.get(options.dataResidency);
    if (endpoint === undefined) {
        throw new error_1.OpenAIError('Invalid `dataResidency`; expected one of: global, us, eu, ae.');
    }
    return endpoint;
}
/** Prevents legacy provider clients from selecting an OpenAI endpoint. */
function assertNoDataResidency(dataResidency, clientName) {
    if (dataResidency !== null && dataResidency !== undefined) {
        throw new error_1.OpenAIError(`${clientName} does not support \`dataResidency\`.`);
    }
}
//# sourceMappingURL=data-residency.js.map