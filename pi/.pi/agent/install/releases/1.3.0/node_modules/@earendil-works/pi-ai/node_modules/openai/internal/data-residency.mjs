// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { OpenAIError } from "../core/error.mjs";
import { hasOwn } from "./utils/values.mjs";
const endpoints = new Map([
    ['global', 'https://api.openai.com/v1'],
    ['us', 'https://us.api.openai.com/v1'],
    ['eu', 'https://eu.api.openai.com/v1'],
    ['ae', 'https://ae.api.openai.com/v1'],
]);
/** Resolves an explicit residency selection before client options are inherited. */
export function resolveDataResidency(options) {
    if (options.dataResidency === null || options.dataResidency === undefined) {
        return undefined;
    }
    if (hasOwn(options, 'baseURL')) {
        throw new OpenAIError('The `dataResidency` and `baseURL` options are mutually exclusive.');
    }
    const endpoint = endpoints.get(options.dataResidency);
    if (endpoint === undefined) {
        throw new OpenAIError('Invalid `dataResidency`; expected one of: global, us, eu, ae.');
    }
    return endpoint;
}
/** Prevents legacy provider clients from selecting an OpenAI endpoint. */
export function assertNoDataResidency(dataResidency, clientName) {
    if (dataResidency !== null && dataResidency !== undefined) {
        throw new OpenAIError(`${clientName} does not support \`dataResidency\`.`);
    }
}
//# sourceMappingURL=data-residency.mjs.map