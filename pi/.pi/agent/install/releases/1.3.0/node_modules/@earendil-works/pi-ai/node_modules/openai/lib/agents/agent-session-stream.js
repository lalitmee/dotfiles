"use strict";
var _AgentSessionStream_instances, _AgentSessionStream_consumed, _AgentSessionStream_stream, _AgentSessionStream_response, _AgentSessionStream_reading, _AgentSessionStream_sessions, _AgentSessionStream_sessionID, _AgentSessionStream_input, _AgentSessionStream_handlers, _AgentSessionStream_inputKey, _AgentSessionStream_options, _AgentSessionStream_iterate, _AgentSessionStream_result, _AgentSessionStream_checkAbort, _AgentSessionStream_abortError, _AgentSessionStream_wait, _AgentSessionStream_submit;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AgentSessionStream = void 0;
const tslib_1 = require("../../internal/tslib.js");
const turn_state_1 = require("./turn-state.js");
const error_1 = require("../../core/error.js");
const headers_1 = require("../../internal/headers.js");
const uuid_1 = require("../../internal/utils/uuid.js");
const values_1 = require("../../internal/utils/values.js");
function isInputContent(value) {
    if (!(0, values_1.isObj)(value)) {
        return false;
    }
    const content = value;
    let field;
    if (content['type'] === 'input_text') {
        field = 'text';
    }
    else if (content['type'] === 'input_image') {
        field = 'image_url';
    }
    else {
        return false;
    }
    return (0, values_1.hasOwn)(content, 'type') && (0, values_1.hasOwn)(content, field) && typeof content[field] === 'string';
}
function normalizedOutput(value) {
    if (value === null) {
        return null;
    }
    if (typeof value === 'string' || (Array.isArray(value) && value.every(isInputContent))) {
        return value;
    }
    throw new error_1.OpenAIError('Tool output must be text, content, a JSON object, or null');
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- The public AgentToolOutput contract accepts arbitrary JSON-serializable object results.
function toolResult(call, value) {
    const output = (0, values_1.isObj)(value) ? JSON.stringify(value) : value;
    // Detect unserializable callback results inside the redacted failure boundary.
    const serialized = JSON.stringify(output);
    if (serialized === undefined) {
        throw new error_1.OpenAIError('Tool output must be JSON serializable');
    }
    return {
        type: 'agent.session.input.tool_result',
        turn_id: call.turn_id,
        call_id: call.call_id,
        success: true,
        output: normalizedOutput(typeof output === 'string' ? output : JSON.parse(serialized)),
    };
}
async function cancelBody(response) {
    try {
        await response?.body?.cancel();
    }
    catch {
        // The response may already be cancelled or owned by its stream reader.
    }
}
/**
 * A single-use, lazy async iterable of original session events for one turn.
 * Requires an idle session and a single input writer: the input endpoint does not
 * return a turn ID. Subscribe-before-input avoids losing events; the first
 * coordinator turn selects the turn to follow. Initial idle events and subagent
 * completion do not end iteration. A selected turn's terminal event followed by
 * session.idle, or session.failed, ends iteration. Unexpected EOF throws.
 *
 * Tool handlers run sequentially during iteration. Handler failures submit a
 * generic error without exception text. Each submission has a distinct retry-safe
 * idempotency key. Breaking iteration or calling abort closes local requests;
 * neither cancels the backend turn. No work starts until iteration begins.
 */
class AgentSessionStream {
    /** Creates an unstarted helper. Prefer client.beta.agents.sessions.stream(). */
    constructor(sessions, sessionID, params, options) {
        _AgentSessionStream_instances.add(this);
        /** Aborts local requests and iteration without cancelling the backend turn. */
        this.controller = new AbortController();
        _AgentSessionStream_consumed.set(this, false);
        _AgentSessionStream_stream.set(this, void 0);
        _AgentSessionStream_response.set(this, void 0);
        _AgentSessionStream_reading.set(this, false);
        _AgentSessionStream_sessions.set(this, void 0);
        _AgentSessionStream_sessionID.set(this, void 0);
        _AgentSessionStream_input.set(this, void 0);
        _AgentSessionStream_handlers.set(this, void 0);
        _AgentSessionStream_inputKey.set(this, void 0);
        _AgentSessionStream_options.set(this, void 0);
        const input = typeof params.input === 'string'
            ? [{ role: 'user', content: [{ type: 'input_text', text: params.input }] }]
            : params.input;
        if (params.input.length === 0) {
            throw new error_1.OpenAIError('input must not be empty');
        }
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_sessions, sessions, "f");
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_sessionID, sessionID, "f");
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_input, { type: 'agent.session.input.message', input }, "f");
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_handlers, new Map(Object.entries(params.toolHandlers ?? {})), "f");
        const headers = (0, headers_1.buildHeaders)([options?.headers]);
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_inputKey, headers.nulls.has('idempotency-key')
            ? undefined
            : (headers.values.get('idempotency-key') ??
                params.idempotencyKey ??
                options?.idempotencyKey ??
                (0, uuid_1.uuid4)()), "f");
        headers.values.delete('idempotency-key');
        headers.nulls.delete('idempotency-key');
        const { idempotencyKey: _key, ...rest } = options ?? {};
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_options, { ...rest, headers }, "f");
    }
    /** Closes local requests without cancelling the turn; an optional reason becomes the abort error's cause. */
    abort(reason) {
        this.controller.abort(reason);
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_stream, "f")?.controller.abort(this.controller.signal.reason);
        if (!tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_reading, "f")) {
            void cancelBody(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_response, "f"));
        }
    }
    /** Starts iteration once; use for await to ensure early exits close the connection. */
    [(_AgentSessionStream_consumed = new WeakMap(), _AgentSessionStream_stream = new WeakMap(), _AgentSessionStream_response = new WeakMap(), _AgentSessionStream_reading = new WeakMap(), _AgentSessionStream_sessions = new WeakMap(), _AgentSessionStream_sessionID = new WeakMap(), _AgentSessionStream_input = new WeakMap(), _AgentSessionStream_handlers = new WeakMap(), _AgentSessionStream_inputKey = new WeakMap(), _AgentSessionStream_options = new WeakMap(), _AgentSessionStream_instances = new WeakSet(), Symbol.asyncIterator)]() {
        if (tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_consumed, "f")) {
            throw new error_1.OpenAIError('An AgentSessionStream can only be consumed once');
        }
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_consumed, true, "f");
        return tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_iterate).call(this);
    }
}
exports.AgentSessionStream = AgentSessionStream;
_AgentSessionStream_iterate = async function* _AgentSessionStream_iterate() {
    const externalSignal = tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_options, "f").signal;
    const abort = () => this.abort(externalSignal?.aborted ? externalSignal.reason : this.controller.signal.reason);
    externalSignal?.addEventListener('abort', abort, { once: true });
    this.controller.signal.addEventListener('abort', abort, { once: true });
    const options = { ...tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_options, "f"), signal: this.controller.signal };
    const state = new turn_state_1.TurnState();
    try {
        if (externalSignal?.aborted) {
            this.abort(externalSignal.reason);
        }
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        const session = await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessions, "f").retrieve(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessionID, "f"), options);
        if (session.status !== 'idle') {
            throw new error_1.OpenAIError('sessions.stream requires an idle session; use sessions.events.stream for active sessions');
        }
        const subscription = await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessions, "f").events.stream(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessionID, "f"), options).withResponse();
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_stream, subscription.data, "f");
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_response, subscription.response, "f");
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessions, "f").events.create(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessionID, "f"), {
            events: [tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_input, "f")],
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_inputKey, "f") === undefined ? {} : { 'Idempotency-Key': tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_inputKey, "f") }),
        }, {
            ...options,
            headers: (0, headers_1.buildHeaders)([options.headers, { 'Idempotency-Key': tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_inputKey, "f") ?? null }]),
        });
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        tslib_1.__classPrivateFieldSet(this, _AgentSessionStream_reading, true, "f");
        for await (const event of tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_stream, "f")) {
            tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
            if (!state.accept(event)) {
                continue;
            }
            const terminal = state.terminal(event);
            const pendingCall = state.call(event);
            const handler = pendingCall && tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_handlers, "f").get(pendingCall.name);
            // Freeze dispatch identity and arguments before exposing the original event.
            const call = pendingCall && handler ? structuredClone(pendingCall) : undefined;
            if (terminal) {
                tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_stream, "f").controller.abort();
            }
            yield event;
            if (terminal) {
                return;
            }
            tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
            if (!call || !handler) {
                continue;
            }
            const result = await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_result).call(this, call, handler);
            tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
            await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_submit).call(this, result, options);
        }
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        throw new error_1.OpenAIError('Session event stream ended before the turn reached idle or failed');
    }
    finally {
        externalSignal?.removeEventListener('abort', abort);
        this.controller.signal.removeEventListener('abort', abort);
        this.abort();
    }
}, _AgentSessionStream_result = async function _AgentSessionStream_result(call, handler) {
    try {
        const args = typeof call.arguments === 'string' ? JSON.parse(call.arguments) : call.arguments;
        if (!(0, values_1.isObj)(args)) {
            throw new error_1.OpenAIError('Function arguments must be a JSON object');
        }
        // SAFETY: Arguments were parsed as JSON and checked to be a non-null non-array object before invoking the handler.
        return toolResult(call, await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_wait).call(this, () => handler(args)));
    }
    catch {
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        return {
            type: 'agent.session.input.tool_result',
            turn_id: call.turn_id,
            call_id: call.call_id,
            success: false,
            error: 'Tool handler failed.',
        };
    }
}, _AgentSessionStream_checkAbort = function _AgentSessionStream_checkAbort() {
    if (this.controller.signal.aborted) {
        throw tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_abortError).call(this);
    }
}, _AgentSessionStream_abortError = function _AgentSessionStream_abortError() {
    const error = new error_1.APIUserAbortError();
    Object.defineProperty(error, 'cause', {
        value: this.controller.signal.reason,
        writable: true,
        configurable: true,
    });
    return error;
}, _AgentSessionStream_wait = async function _AgentSessionStream_wait(action) {
    let onAbort;
    // oxlint-disable-next-line promise/avoid-new -- Bridge the caller's AbortSignal while a handler or registration delay is pending.
    const aborted = new Promise((_resolve, reject) => {
        onAbort = () => reject(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_abortError).call(this));
        this.controller.signal.addEventListener('abort', onAbort, { once: true });
    });
    try {
        tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
        // Capture synchronous throws before racing cancellation, so both promises
        // always have rejection handlers even if the callback aborts and throws.
        const invoke = async () => await action();
        return await Promise.race([invoke(), aborted]);
    }
    finally {
        if (onAbort) {
            this.controller.signal.removeEventListener('abort', onAbort);
        }
    }
}, _AgentSessionStream_submit = async function _AgentSessionStream_submit(result, options, key = (0, uuid_1.uuid4)(), attempt = 0) {
    tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_checkAbort).call(this);
    try {
        await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessions, "f").events.create(tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_sessionID, "f"), { events: [result], 'Idempotency-Key': key }, options);
    }
    catch (error) {
        const delay = [100, 300, 600][attempt];
        if (delay === undefined ||
            !(error instanceof error_1.BadRequestError) ||
            error.code !== 'invalid_request_error' ||
            !error.error ||
            !('message' in error.error) ||
            error.error.message !== `Unknown pending tool call: ${result.call_id}`) {
            throw error;
        }
        let timer;
        try {
            await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_wait).call(this, () => 
            // oxlint-disable-next-line promise/avoid-new -- Own the registration timer so cancellation clears it promptly.
            new Promise((resolve) => {
                timer = setTimeout(resolve, delay);
            }));
        }
        finally {
            if (timer !== undefined) {
                clearTimeout(timer);
            }
        }
        await tslib_1.__classPrivateFieldGet(this, _AgentSessionStream_instances, "m", _AgentSessionStream_submit).call(this, result, options, key, attempt + 1);
    }
};
//# sourceMappingURL=agent-session-stream.js.map