"use strict";
var _BetaToolRunner_instances, _BetaToolRunner_consumed, _BetaToolRunner_mutated, _BetaToolRunner_state, _BetaToolRunner_options, _BetaToolRunner_message, _BetaToolRunner_stream, _BetaToolRunner_toolResponse, _BetaToolRunner_completion, _BetaToolRunner_iterationCount, _BetaToolRunner_compaction, _BetaToolRunner_calls, _BetaToolRunner_lastStopReason, _BetaToolRunner_toolOverrides, _BetaToolRunner_pendingToolChanges, _BetaToolRunner_send, _BetaToolRunner_streamThatStartsTools, _BetaToolRunner_startedCallsSettled, _BetaToolRunner_compact, _BetaToolRunner_runnableTools, _BetaToolRunner_availableToolNames, _BetaToolRunner_recordRemovalsFromHistory, _BetaToolRunner_compactAfterFinalTurn, _BetaToolRunner_generateToolResponse, _BetaToolRunner_flushPendingToolChanges, _BetaToolRunner_pendingToolChangesMessage;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BetaToolRunner = void 0;
const tslib_1 = require("../../internal/tslib.js");
const ToolError_1 = require("./ToolError.js");
const error_1 = require("../../core/error.js");
const BetaToolRunnerStream_1 = require("../internal/BetaToolRunnerStream.js");
const headers_1 = require("../../internal/headers.js");
const promise_1 = require("../../internal/utils/promise.js");
const values_1 = require("../../internal/utils/values.js");
const log_1 = require("../../internal/utils/log.js");
const stainless_helper_header_1 = require("../../internal/stainless-helper-header.js");
var BetaToolRunner = /* @__PURE__ */ (() => {
    /**
     * A ToolRunner handles the automatic conversation loop between the assistant and tools.
     *
     * A ToolRunner is an async iterable that yields either BetaMessage or BetaMessageStream objects
     * depending on the streaming configuration. With `runToolsEagerly` it starts each tool call while the
     * reply is still streaming, unless `deferToolCall()` holds the call.
     */
    class BetaToolRunner {
        constructor(client, params, options) {
            _BetaToolRunner_instances.add(this);
            this.client = client;
            /** Whether the async iterator has been consumed */
            _BetaToolRunner_consumed.set(this, false);
            /** Whether parameters have been mutated since the last API call */
            _BetaToolRunner_mutated.set(this, false);
            /** Current state containing the request parameters */
            _BetaToolRunner_state.set(this, void 0);
            _BetaToolRunner_options.set(this, void 0);
            /** Promise for the last message received from the assistant */
            _BetaToolRunner_message.set(this, void 0);
            /** The stream of the request in progress, when streaming */
            _BetaToolRunner_stream.set(this, void 0);
            /** Cached tool response to avoid redundant executions */
            _BetaToolRunner_toolResponse.set(this, void 0);
            /** Promise resolvers for waiting on completion */
            _BetaToolRunner_completion.set(this, void 0);
            /** Number of iterations (API requests) made so far */
            _BetaToolRunner_iterationCount.set(this, 0);
            /** A compaction scheduled with `compactBeforeNextTurn()`, in flight until its response has been handled */
            _BetaToolRunner_compaction.set(this, { status: 'idle' });
            /** The tool calls of the current reply that are held or have started, by `tool_use` id. See `runToolsEagerly`. */
            _BetaToolRunner_calls.set(this, void 0);
            /** The last turn's stop reason, or `null` once the history has been replaced since */
            _BetaToolRunner_lastStopReason.set(this, null);
            /**
             * `addTools()` / `removeTools()` never edit `params.tools`, because a changed `tools` misses the prompt
             * cache, so what they change about which tool runs under a name is kept here instead: the runnable tool
             * added under that name, or `null` once the name was removed or taken by a raw definition. A tool call is
             * looked up here first, and in `params.tools` only when its name has no entry.
             */
            _BetaToolRunner_toolOverrides.set(this, new Map());
            /** Changes queued by `addTools()` / `removeTools()`, in call order, for the next request */
            _BetaToolRunner_pendingToolChanges.set(this, []);
            rejectCompactionParam(params);
            rejectCompactionControl(params);
            rejectRunToolsEagerlyWithoutStream(params);
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_state, {
                params: {
                    // You can't clone the entire params since there are functions as handlers.
                    // You also don't really need to clone params.messages, but it probably will prevent a foot gun
                    // somewhere.
                    ...params,
                    // Not structuredClone(): it throws on a function, and a runnable tool written by value into a
                    // `tool_addition` block has `run`. A JSON copy is the messages as they are sent, which drops it.
                    messages: JSON.parse(JSON.stringify(params.messages)),
                },
            }, "f");
            // Cloning drops symbol-keyed properties, so collect helper marks
            // from the original params here — the create()-side collector won't see
            // them on the cloned messages.
            const collected = (0, stainless_helper_header_1.collectStainlessHelpers)(params.tools, params.messages);
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_options, {
                ...options,
                headers: (0, headers_1.buildHeaders)([
                    (0, stainless_helper_header_1.helperHeader)('BetaToolRunner'),
                    collected.length ? { [stainless_helper_header_1.STAINLESS_HELPER_HEADER]: collected.join(', ') } : undefined,
                    options?.headers,
                ]),
            }, "f");
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_completion, (0, promise_1.promiseWithResolvers)(), "f");
        }
        async *[(_BetaToolRunner_consumed = new WeakMap(), _BetaToolRunner_mutated = new WeakMap(), _BetaToolRunner_state = new WeakMap(), _BetaToolRunner_options = new WeakMap(), _BetaToolRunner_message = new WeakMap(), _BetaToolRunner_stream = new WeakMap(), _BetaToolRunner_toolResponse = new WeakMap(), _BetaToolRunner_completion = new WeakMap(), _BetaToolRunner_iterationCount = new WeakMap(), _BetaToolRunner_compaction = new WeakMap(), _BetaToolRunner_calls = new WeakMap(), _BetaToolRunner_lastStopReason = new WeakMap(), _BetaToolRunner_toolOverrides = new WeakMap(), _BetaToolRunner_pendingToolChanges = new WeakMap(), _BetaToolRunner_instances = new WeakSet(), Symbol.asyncIterator)]() {
            var _a;
            if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_consumed, "f")) {
                throw new error_1.AnthropicError('Cannot iterate over a consumed stream');
            }
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_consumed, true, "f");
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_mutated, true, "f");
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_toolResponse, undefined, "f");
            try {
                while (true) {
                    try {
                        if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.max_iterations &&
                            tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_iterationCount, "f") >= tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.max_iterations) {
                            break;
                        }
                        tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_flushPendingToolChanges).call(this);
                        // The API can't compact a conversation that ends mid-turn, so a paused turn is resumed first.
                        if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").status === 'scheduled' &&
                            determineNextStepFromStopReason(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_lastStopReason, "f")) !== 'resume') {
                            yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_compact).call(this, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").config);
                            continue;
                        }
                        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_mutated, false, "f");
                        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_toolResponse, undefined, "f");
                        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_iterationCount, (_a = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_iterationCount, "f"), _a++, _a), "f");
                        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_message, undefined, "f");
                        const { max_iterations, runToolsEagerly, ...params } = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params;
                        yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_send).call(this, params);
                        if (!tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_mutated, "f")) {
                            const message = await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f");
                            const nextStep = determineNextStepFromStopReason(message.stop_reason);
                            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_lastStopReason, message.stop_reason, "f");
                            tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages.push({
                                role: message.role,
                                content: asContentParam(message.content),
                            });
                            // Container-bound server tools reject a follow-up request that omits the container the
                            // previous turn ran in, so carry its id forward unless the caller pinned one themselves.
                            const { container } = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params;
                            if (message.container) {
                                if (container == null) {
                                    tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.container = message.container.id;
                                }
                                else if (typeof container === 'object' && container.id == null) {
                                    tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.container = { ...container, id: message.container.id };
                                }
                            }
                            if (nextStep === 'stop') {
                                yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_compactAfterFinalTurn).call(this);
                                break;
                            }
                            if (nextStep === 'resume') {
                                continue;
                            }
                        }
                        else {
                            // The caller has taken over the history, so the last response no longer says how it ends.
                            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_lastStopReason, null, "f");
                        }
                        const toolMessage = await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_generateToolResponse).call(this, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages.at(-1));
                        if (toolMessage) {
                            tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages.push(toolMessage);
                        }
                        else if (!tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_mutated, "f")) {
                            yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_compactAfterFinalTurn).call(this);
                            break;
                        }
                    }
                    finally {
                        tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_stream, "f")?.abort();
                        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_stream, undefined, "f");
                    }
                }
                await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_startedCallsSettled).call(this);
                if (!tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f")) {
                    throw new error_1.AnthropicError('ToolRunner concluded without a message from the server');
                }
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_completion, "f").resolve(await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f"));
            }
            catch (error) {
                tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_consumed, false, "f");
                // Silence unhandled promise errors
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_completion, "f").promise.catch(() => { });
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_completion, "f").reject(error);
                tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_completion, (0, promise_1.promiseWithResolvers)(), "f");
                throw error;
            }
        }
        setMessagesParams(paramsOrMutator) {
            const params = typeof paramsOrMutator === 'function' ? paramsOrMutator(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params) : paramsOrMutator;
            rejectCompactionParam(params);
            rejectRunToolsEagerlyWithoutStream(params);
            if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").status !== 'idle') {
                rejectCompactionEdit(params);
            }
            if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").status === 'in_flight' && params.messages !== tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages) {
                throw new error_1.AnthropicError("Message params can't be changed while the conversation is being compacted, because the compaction " +
                    'response is about to replace them. Change them after this iteration instead.');
            }
            tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params = params;
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_mutated, true, "f");
            // Invalidate cached tool response since parameters changed
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_toolResponse, undefined, "f");
        }
        setRequestOptions(optionsOrMutator) {
            if (typeof optionsOrMutator === 'function') {
                tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_options, optionsOrMutator(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f")), "f");
            }
            else {
                tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_options, { ...tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f"), ...optionsOrMutator }, "f");
            }
        }
        /**
         * Get the tool response for the last message from the assistant.
         * Avoids redundant tool executions by caching results. With `runToolsEagerly`, it reuses the calls of
         * the reply that have started and runs the rest, including the ones `deferToolCall()` is holding, so that no
         * call runs twice.
         *
         * @returns A promise that resolves to a BetaMessageParam containing tool results, or null if no tools need to be executed
         *
         * @example
         * const toolResponse = await runner.generateToolResponse();
         * if (toolResponse) {
         *   console.log('Tool results:', toolResponse.content);
         * }
         */
        async generateToolResponse(signal = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f").signal) {
            const message = (await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f")) ?? this.params.messages.at(-1);
            if (!message) {
                return null;
            }
            return tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_generateToolResponse).call(this, message, signal);
        }
        /**
         * Hold a tool call of the current reply until you are done with the reply, which is when it runs without
         * streaming: at the end of the loop body, or when you call `generateToolResponse()`.
         *
         * With `runToolsEagerly` the runner otherwise starts each call while the reply streams, as soon as
         * the model has moved on from it: when the next block starts, or the reply stops with `tool_use`. A call
         * never starts before your stream listeners and any `for await` over the stream have handled that event, so
         * you can call this from either once you have seen the call. The other calls of the reply still start early.
         * It does nothing for a call that has started, outside the loop body, and without `runToolsEagerly`.
         *
         * @param toolUse - The `tool_use` block of the call, or its id
         *
         * @example
         * for await (const stream of runner) {
         *   stream.on('contentBlock', (block) => {
         *     if (block.type === 'tool_use' && block.name === 'delete_file') {
         *       runner.deferToolCall(block);
         *     }
         *   });
         *   await stream.finalMessage();
         *   // No `delete_file` call has started yet.
         * }
         */
        deferToolCall(toolUse) {
            const id = typeof toolUse === 'string' ? toolUse : toolUse.id;
            if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f") && !tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f").has(id)) {
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f").set(id, { status: 'held' });
            }
        }
        /**
         * The tool calls of the current reply that `deferToolCall()` is holding, in the model's order, as their
         * `tool_use` blocks. A call is in the list once its block has finished streaming, so read the list when you
         * are done with the stream. A call that has started is not in it. It is empty without
         * `runToolsEagerly`.
         *
         * Held calls are listed whatever the reply's `stop_reason`, because `generateToolResponse()` runs them
         * whatever it is. After `max_tokens` the input of the last call can be cut off.
         *
         * @example
         * for await (const stream of runner) {
         *   stream.on('contentBlock', (block) => {
         *     if (block.type === 'tool_use' && block.name === 'delete_file') {
         *       runner.deferToolCall(block);
         *     }
         *   });
         *   await stream.finalMessage();
         *
         *   const held = runner.deferredToolCalls;
         *   if (held.length > 0 && !(await confirm(held))) break;
         * }
         */
        get deferredToolCalls() {
            const stream = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_stream, "f");
            const calls = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f");
            if (!(stream instanceof BetaToolRunnerStream_1.BetaToolRunnerStream) || !calls) {
                return [];
            }
            return stream.toolCalls.filter((toolUse) => calls.get(toolUse.id)?.status === 'held');
        }
        /**
         * Wait for the async iterator to complete. This works even if the async iterator hasn't yet started, and
         * will wait for an instance to start and go to completion.
         *
         * @returns A promise that resolves to the final BetaMessage when the iterator completes
         *
         * @example
         * // Start consuming the iterator
         * for await (const message of runner) {
         *   console.log('Message:', message.content);
         * }
         *
         * // Meanwhile, wait for completion from another part of the code
         * const finalMessage = await runner.done();
         * console.log('Final response:', finalMessage.content);
         */
        done() {
            return tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_completion, "f").promise;
        }
        /**
         * Returns a promise indicating that the stream is done. Unlike .done(), this will eagerly read the stream:
         * * If the iterator has not been consumed, consume the entire iterator and return the final message from the
         * assistant.
         * * If the iterator has been consumed, waits for it to complete and returns the final message.
         *
         * @returns A promise that resolves to the final BetaMessage from the conversation
         * @throws {AnthropicError} If no messages were processed during the conversation
         *
         * @example
         * const finalMessage = await runner.runUntilDone();
         * console.log('Final response:', finalMessage.content);
         */
        async runUntilDone() {
            // If not yet consumed, start consuming and wait for completion
            if (!tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_consumed, "f")) {
                for await (const _ of this) {
                    // Iterator naturally populates this.#message
                }
            }
            // If consumed but not completed, wait for completion
            return this.done();
        }
        /**
         * Get the current parameters being used by the ToolRunner.
         *
         * @returns A readonly view of the current ToolRunnerParams
         *
         * @example
         * const currentParams = runner.params;
         * console.log('Current model:', currentParams.model);
         * console.log('Message count:', currentParams.messages.length);
         */
        get params() {
            return tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params;
        }
        /**
         * Add one or more messages to the conversation history.
         *
         * @param messages - One or more BetaMessageParam objects to add to the conversation
         *
         * @example
         * runner.pushMessages(
         *   { role: 'user', content: 'Also, what about the weather in NYC?' }
         * );
         *
         * @example
         * // Adding multiple messages
         * runner.pushMessages(
         *   { role: 'user', content: 'What about NYC?' },
         *   { role: 'user', content: 'And Boston?' }
         * );
         */
        pushMessages(...messages) {
            this.setMessagesParams((params) => ({
                ...params,
                messages: [...params.messages, ...messages],
            }));
        }
        /**
         * Schedule a compaction of the conversation. Once the current turn has finished, including any tool
         * calls, the runner requests a summary and replaces the message history with the compaction response,
         * which is yielded like any other message. Requires the `compact-2026-09-04` beta.
         *
         * @param compaction - The config to send, as `messages.create()` takes it. Defaults to `{ type: 'summarize' }`
         *
         * @example
         * for await (const message of runner) {
         *   if (message.usage.input_tokens > 100_000) {
         *     runner.compactBeforeNextTurn();
         *   }
         * }
         */
        compactBeforeNextTurn(compaction) {
            if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").status === 'in_flight') {
                return;
            }
            rejectCompactionEdit(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params);
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_compaction, { status: 'scheduled', config: compaction ?? { type: 'summarize' } }, "f");
        }
        /**
         * Give the model more tools without changing `params.tools`, which would miss the prompt cache.
         *
         * Each tool's whole definition is sent in a `tool_addition` block with the next request, and a
         * runnable tool replaces a runnable tool of the same name straight away, even for a call already in
         * the message being handled. A call that started while the reply streamed keeps the old one. A raw
         * definition is only sent: the runner never runs it, and stops running a tool of the same name.
         * Requires the `inline-tools-2026-09-15` beta, which the runner does not add for you.
         *
         * @param tools - Runnable tools (for example from `betaZodTool()`) or raw tool definitions
         *
         * @example
         * runner.addTools(queryDatabaseTool);
         */
        addTools(...tools) {
            for (const tool of tools) {
                // A definition without a `name` (an `mcp_toolset`) is nothing the runner runs or stops running.
                if ('name' in tool) {
                    tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolOverrides, "f").set(tool.name, 'run' in tool ? tool : null);
                }
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_pendingToolChanges, "f").push({ type: 'addition', tool });
            }
        }
        /**
         * Take tools away from the model without changing `params.tools`, which would miss the prompt cache.
         *
         * The tools stop being run straight away: a call to one of them, even one in the message being
         * handled, gets the same "not found" error result as a call to an unknown tool. A call that started
         * while the reply streamed finishes as usual. The model is told in a `tool_removal` block with the
         * next request. Use {@link addTools} to bring a tool back.
         * Requires the `inline-tools-2026-09-15` beta, which the runner does not add for you.
         *
         * @param tools - The tools to remove, or their names
         *
         * @example
         * runner.removeTools('query_database');
         */
        removeTools(...tools) {
            for (const tool of tools) {
                const name = typeof tool === 'string' ? tool : tool.name;
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolOverrides, "f").set(name, null);
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_pendingToolChanges, "f").push({ type: 'removal', name });
            }
        }
        /**
         * Makes the ToolRunner directly awaitable, equivalent to calling .runUntilDone()
         * This allows using `await runner` instead of `await runner.runUntilDone()`
         */
        then(onfulfilled, onrejected) {
            return this.runUntilDone().then(onfulfilled, onrejected);
        }
    }
    _BetaToolRunner_send = 
    /**
     * Sends one request and yields its message, or its stream when streaming. `#message` and `#stream` are set
     * before the yield, so they are there while the caller handles the item; the loop aborts the stream at the
     * end of the iteration.
     */
    async function* _BetaToolRunner_send(params) {
        await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_startedCallsSettled).call(this);
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_calls, undefined, "f");
        if (params.stream) {
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_stream, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.runToolsEagerly ?
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_streamThatStartsTools).call(this, params)
                : this.client.beta.messages.stream({ ...params }, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f")), "f");
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_message, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_stream, "f").finalMessage(), "f");
            // Make sure that this promise doesn't throw before we get the option to do something about it.
            // Error will be caught when we call await this.#message ultimately
            tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f").catch(() => { });
            yield tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_stream, "f");
        }
        else {
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_message, this.client.beta.messages.create({ ...params, stream: false }, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f")), "f");
            yield tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f");
        }
    }, _BetaToolRunner_streamThatStartsTools = function _BetaToolRunner_streamThatStartsTools(params) {
        const calls = new Map();
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_calls, calls, "f");
        return BetaToolRunnerStream_1.BetaToolRunnerStream.start(this.client.beta.messages, params, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f"), (toolUse) => {
            // Held, or started by `generateToolResponse()` before a reader that is behind got to the call.
            if (calls.has(toolUse.id)) {
                return;
            }
            // The call looks its tool up now, so a later `addTools()` or `removeTools()` doesn't change it.
            const result = runToolCall(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_runnableTools).call(this), tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_availableToolNames).call(this), toolUse, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f"));
            // Marks a rejection as handled until the results are collected.
            result.catch(() => { });
            calls.set(toolUse.id, { status: 'started', result });
        });
    }, _BetaToolRunner_startedCallsSettled = 
    /** Waits for the calls of the last streamed reply that have started, whether or not their results were sent. */
    async function _BetaToolRunner_startedCallsSettled() {
        const started = [...(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f")?.values() ?? [])].filter((call) => call.status === 'started');
        await Promise.allSettled(started.map((call) => call.result));
    }, _BetaToolRunner_compact = async function* _BetaToolRunner_compact(compaction) {
        rejectCompactionEdit(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params);
        const { max_iterations, runToolsEagerly, ...requestParams } = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params;
        const params = withoutCompactionIncompatibleParams(requestParams);
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_compaction, { status: 'in_flight' }, "f");
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_toolResponse, undefined, "f");
        const lastMessage = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f");
        try {
            yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_send).call(this, { ...params, compaction });
            const message = await tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_message, "f");
            if (message.content.some((block) => block.type === 'compaction' && block.content)) {
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_recordRemovalsFromHistory).call(this);
                // The response has to be sent back as it came, first, replacing the messages it summarizes.
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages = [{ role: message.role, content: message.content }];
            }
            else {
                (0, log_1.loggerFor)(this.client).warn('Compaction produced no summary; keeping the conversation as it is.');
                // If the run ends here, `done()` resolves to the last real message rather than this response.
                tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_message, lastMessage, "f");
            }
        }
        finally {
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_compaction, { status: 'idle' }, "f");
        }
    }, _BetaToolRunner_runnableTools = function _BetaToolRunner_runnableTools() {
        const runnable = new Map();
        for (const tool of tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.tools) {
            if ('run' in tool) {
                runnable.set(tool.name, tool);
            }
        }
        for (const [name, tool] of tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolOverrides, "f")) {
            if (tool) {
                runnable.set(name, tool);
            }
            else {
                runnable.delete(name);
            }
        }
        return runnable;
    }, _BetaToolRunner_availableToolNames = function _BetaToolRunner_availableToolNames() {
        const available = new Set(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_runnableTools).call(this).keys());
        for (const message of [...tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_pendingToolChangesMessage).call(this)]) {
            if (typeof message.content === 'string') {
                continue;
            }
            for (const block of message.content) {
                if (message.role === 'system') {
                    applyToolChange(block, available);
                }
                else if (message.role === 'assistant' && block.type === 'compaction') {
                    // A compaction block's tool_changes stand in for the system messages of the turns it summarized.
                    for (const change of block.tool_changes ?? []) {
                        applyToolChange(change, available);
                    }
                }
            }
        }
        return available;
    }, _BetaToolRunner_recordRemovalsFromHistory = function _BetaToolRunner_recordRemovalsFromHistory() {
        const available = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_availableToolNames).call(this);
        for (const name of tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_runnableTools).call(this).keys()) {
            if (!available.has(name)) {
                tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolOverrides, "f").set(name, null);
            }
        }
    }, _BetaToolRunner_compactAfterFinalTurn = async function* _BetaToolRunner_compactAfterFinalTurn() {
        if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").status !== 'scheduled') {
            return;
        }
        const lastContent = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages.at(-1)?.content;
        if (Array.isArray(lastContent) && lastContent.some((block) => block.type === 'tool_use')) {
            // A turn that was cut short can end with tool calls that are never run, and the API can't
            // compact a conversation whose last turn has an unanswered tool call.
            (0, log_1.loggerFor)(this.client).warn('The pending compaction was skipped because the last turn ended with tool calls that were not run. ' +
                'Call `compactBeforeNextTurn()` again if you continue the conversation.');
            tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_compaction, { status: 'idle' }, "f");
            return;
        }
        yield* tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_compact).call(this, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_compaction, "f").config);
    }, _BetaToolRunner_generateToolResponse = async function _BetaToolRunner_generateToolResponse(lastMessage, signal = tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f").signal) {
        if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolResponse, "f") !== undefined) {
            return tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolResponse, "f");
        }
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_toolResponse, generateToolResponse(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_runnableTools).call(this), tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_availableToolNames).call(this), lastMessage, { ...tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_options, "f"), signal }, tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_calls, "f")), "f");
        return tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_toolResponse, "f");
    }, _BetaToolRunner_flushPendingToolChanges = function _BetaToolRunner_flushPendingToolChanges() {
        // A paused turn has to go back as the last message, so the changes wait for the request after it.
        if (tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_lastStopReason, "f") === 'pause_turn' || tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_pendingToolChanges, "f").length === 0) {
            return;
        }
        // Not pushMessages(): that marks the params as changed by the caller, and the runner would then
        // leave this turn's assistant message and tool results for the caller to append.
        tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_state, "f").params.messages.push(tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_instances, "m", _BetaToolRunner_pendingToolChangesMessage).call(this));
        tslib_1.__classPrivateFieldSet(this, _BetaToolRunner_pendingToolChanges, [], "f");
    }, _BetaToolRunner_pendingToolChangesMessage = function _BetaToolRunner_pendingToolChangesMessage() {
        const content = [];
        for (const change of tslib_1.__classPrivateFieldGet(this, _BetaToolRunner_pendingToolChanges, "f")) {
            if (change.type === 'removal') {
                content.push({ type: 'tool_removal', tool: { type: 'tool_reference', name: change.name } });
                continue;
            }
            // The functions stay out of the definition that is sent.
            let definition = change.tool;
            if ('run' in change.tool) {
                const { run, parse, close, ...rest } = change.tool;
                definition = rest;
            }
            content.push({ type: 'tool_addition', tool: { type: 'tool_definition', definition } });
        }
        return { role: 'system', content };
    };
    return BetaToolRunner;
})();
exports.BetaToolRunner = BetaToolRunner;
function rejectCompactionParam(params) {
    if ('compaction' in params && params.compaction != null) {
        throw new error_1.AnthropicError('`compaction` cannot be set on a tool runner: every request in the loop would compact again. ' +
            'Call `runner.compactBeforeNextTurn()` when the conversation should be compacted instead.');
    }
}
function rejectCompactionControl(params) {
    // No longer in the params type, so only untyped callers reach this; forwarding it would be an opaque API 400.
    if ('compactionControl' in params && params.compactionControl != null) {
        throw new error_1.AnthropicError('`compactionControl` has been removed from the tool runner. Use server-side compaction instead: ' +
            'call `runner.compactBeforeNextTurn()` when the conversation should be compacted.');
    }
}
function rejectRunToolsEagerlyWithoutStream(params) {
    if (params.runToolsEagerly && !params.stream) {
        throw new TypeError("`runToolsEagerly: true` needs `stream: true` in the tool runner's params, because a reply that " +
            "isn't streamed arrives whole.");
    }
}
function rejectCompactionEdit(params) {
    // The compaction request is sent without `context_management`, so the API can't refuse the pair there:
    // it would run and bill the compaction, then refuse the next request.
    if (params.context_management?.edits?.some((edit) => edit.type.startsWith('compact_'))) {
        throw new error_1.AnthropicError("`compactBeforeNextTurn()` can't be used while `context_management` has a compaction edit, " +
            "because the API doesn't accept a compaction block together with one. Remove the edit first.");
    }
}
/**
 * A compaction request returns only the compaction block, never a reply, so the API rejects the params that
 * only shape a reply. The runner's later requests keep them.
 */
function withoutCompactionIncompatibleParams(params) {
    const { context_management, stop_sequences, output_format, ...kept } = params;
    const withoutFormat = ({ format, ...outputConfig }) => outputConfig;
    if (kept.tool_choice?.type === 'any' || kept.tool_choice?.type === 'tool') {
        delete kept.tool_choice;
    }
    if (kept.output_config) {
        kept.output_config = withoutFormat(kept.output_config);
    }
    if (Array.isArray(kept.fallbacks)) {
        kept.fallbacks = kept.fallbacks.map((fallback) => fallback.output_config ?
            { ...fallback, output_config: withoutFormat(fallback.output_config) }
            : fallback);
    }
    return kept;
}
async function generateToolResponse(runnable, available, lastMessage, requestOptions, calls) {
    // Only process if the last message is from the assistant and has tool use blocks
    if (!lastMessage ||
        lastMessage.role !== 'assistant' ||
        !lastMessage.content ||
        typeof lastMessage.content === 'string') {
        return null;
    }
    const toolUseBlocks = lastMessage.content.filter((content) => content.type === 'tool_use');
    if (toolUseBlocks.length === 0) {
        return null;
    }
    const toolResults = await Promise.all(toolUseBlocks.map((toolUse) => {
        const call = calls?.get(toolUse.id);
        if (call?.status === 'started') {
            return call.result;
        }
        const result = runToolCall(runnable, available, toolUse, requestOptions);
        calls?.set(toolUse.id, { status: 'started', result });
        return result;
    }));
    return {
        role: 'user',
        content: toolResults,
    };
}
async function runToolCall(runnable, available, toolUse, requestOptions) {
    // A `tool_removal` is only a hint to the model, which may still emit a tool_use for a
    // withdrawn tool — treat those exactly like a tool that was never defined.
    const tool = available.has(toolUse.name) ? runnable.get(toolUse.name) : undefined;
    if (!tool) {
        return toolNotFoundResult(toolUse);
    }
    try {
        let input = toolUse.input;
        if ('parse' in tool && tool.parse) {
            input = tool.parse(input);
        }
        const result = await tool.run(input, {
            toolUse: toolUse,
            toolUseBlock: toolUse,
            signal: requestOptions?.signal,
        });
        return {
            type: 'tool_result',
            tool_use_id: toolUse.id,
            content: result,
        };
    }
    catch (error) {
        return {
            type: 'tool_result',
            tool_use_id: toolUse.id,
            content: error instanceof ToolError_1.ToolError ?
                error.content
                : `Error: ${error instanceof Error ? error.message : String(error)}`,
            is_error: true,
        };
    }
}
/**
 * Response content is sent back as request content unchanged. The generated request type of the
 * `tool_listing` block is narrower than its response type, so this needs an assertion until the
 * two agree.
 */
function asContentParam(content) {
    return content;
}
function toolNotFoundResult(toolUse) {
    return {
        type: 'tool_result',
        tool_use_id: toolUse.id,
        content: `Error: Tool '${toolUse.name}' not found`,
        is_error: true,
    };
}
function applyToolChange(block, available) {
    switch (block.type) {
        case 'tool_removal':
        case 'tool_addition':
            applyToolReference(block, available);
            break;
    }
}
function applyToolReference(block, available) {
    const name = changedToolName(block.tool);
    if (name === undefined)
        return;
    if (block.type === 'tool_removal') {
        available.delete(name);
    }
    else {
        available.add(name);
    }
}
function changedToolName(tool) {
    switch (tool.type) {
        case 'tool_reference':
            return tool.name;
        case 'tool_definition':
            // Not every `tools[]` entry has a `name` (e.g. `mcp_toolset`); those are never locally runnable.
            return 'name' in tool.definition ? tool.definition.name : undefined;
        default:
            // mcp_tool_reference / mcp_toolset_reference run server-side; unknown types are ignored
            // rather than rejected.
            return undefined;
    }
}
/**
 * Sorts every stop reason into one of three buckets: `run_tools` turns run their client tool
 * calls and continue the loop; `resume` turns are sent back unchanged so the server continues
 * them; `stop` turns end the loop without running any tool calls.
 */
function determineNextStepFromStopReason(stopReason) {
    if (stopReason === null)
        return 'stop';
    switch (stopReason) {
        case 'tool_use':
            return 'run_tools';
        case 'pause_turn':
        // pause_after_compaction hands the turn back before the model answers; sending it back
        // unchanged continues it.
        case 'compaction':
            return 'resume';
        case 'end_turn':
        case 'stop_sequence':
        case 'max_tokens':
        case 'model_context_window_exceeded':
        case 'refusal':
            return 'stop';
        default:
            // The union is forward-compatible, so a stop reason this SDK doesn't know yet ends the
            // loop rather than throwing; the `never` check makes tsc reject an unclassified member.
            (0, values_1.checkNever)(stopReason);
            return 'stop';
    }
}
//# sourceMappingURL=BetaToolRunner.js.map