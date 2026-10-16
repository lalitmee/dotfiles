"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.defaultParseResponse = defaultParseResponse;
exports.addRequestID = addRequestID;
const streaming_1 = require("../core/streaming.js");
const errors_1 = require("./errors.js");
const log_1 = require("./utils/log.js");
async function defaultParseResponse(client, props) {
    const { response, requestLogID, retryOfRequestLogID, startTime } = props;
    let jsonBodyLength;
    const body = await (async () => {
        if (props.options.stream) {
            (0, log_1.loggerFor)(client).debug('response', response.status, response.url, response.headers, response.body);
            // Note: there is an invariant here that isn't represented in the type system
            // that if you set `stream: true` the response type must also be `Stream<T>`
            if (props.options.__streamClass) {
                return props.options.__streamClass.fromSSEResponse(response, props.controller, client, props.options.__synthesizeEventData);
            }
            return streaming_1.Stream.fromSSEResponse(response, props.controller, client, props.options.__synthesizeEventData);
        }
        // fetch refuses to read the body when the status code is 204.
        if (response.status === 204) {
            return null;
        }
        if (props.options.__binaryResponse) {
            return response;
        }
        const contentType = response.headers.get('content-type');
        const mediaType = contentType?.split(';')[0]?.trim().toLowerCase();
        const isJSON = mediaType?.includes('application/json') || mediaType?.endsWith('+json');
        if (isJSON) {
            const contentLength = response.headers.get('content-length');
            if (contentLength === '0') {
                // if there is no content we can't do anything
                return undefined;
            }
            const bodyText = await response.text();
            if (!bodyText) {
                // Some servers respond with an empty body and a JSON content-type but
                // without a `content-length: 0` header (e.g. over HTTP/2 or with chunked
                // transfer encoding). Treat this the same as an explicit `content-length: 0`
                // instead of letting `JSON.parse` throw an opaque `SyntaxError`.
                return undefined;
            }
            const json = JSON.parse(bodyText);
            jsonBodyLength = bodyText.length;
            return addRequestID(json, response);
        }
        const text = await response.text();
        return text;
    })().catch((error) => {
        throw asAbortError(error, props.controller.signal);
    });
    if (client.logLevel === 'debug') {
        (0, log_1.loggerFor)(client).debug(`[${requestLogID}] response parsed`, (0, log_1.formatRequestDetails)({
            retryOfRequestLogID,
            url: response.url,
            status: response.status,
            body: jsonBodyLength === undefined ? body : { type: 'json', length: jsonBodyLength },
            durationMs: Date.now() - startTime,
        }));
    }
    return body;
}
function asAbortError(error, signal) {
    if (!signal.aborted || error !== signal.reason || (0, errors_1.isAbortError)(error)) {
        return error;
    }
    const message = 'This operation was aborted';
    const DOMExceptionConstructor = globalThis.DOMException;
    return typeof DOMExceptionConstructor === 'function'
        ? new DOMExceptionConstructor(message, 'AbortError')
        : Object.assign(new Error(message), { name: 'AbortError' });
}
function addRequestID(value, response) {
    if (!value || typeof value !== 'object' || Array.isArray(value)) {
        return value;
    }
    return Object.defineProperty(value, '_request_id', {
        value: response.headers.get('x-request-id'),
        enumerable: false,
    });
}
//# sourceMappingURL=parse.js.map