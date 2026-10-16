"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WebRTCConnection = void 0;
const data_channel_1 = require("./data-channel.js");
const errors_1 = require("./errors.js");
const subscriptions_1 = require("./subscriptions.js");
/** Browser-native WebRTC negotiation with application-owned SDP signaling. */
class WebRTCConnection {
    /** Creates native resources, but does not request media, contact a server, or begin negotiation. */
    constructor(configuration) {
        this.connectionEvents = new subscriptions_1.Subscriptions();
        this.currentState = 'new';
        this.onPeerState = () => {
            if (this.currentState === 'closed') {
                return;
            }
            if (this.peer.connectionState === 'failed' || this.peer.connectionState === 'closed') {
                const failed = this.peer.connectionState === 'failed';
                const error = new errors_1.WebRTCError(failed ? 'transport_failed' : 'connection_closed', 'transport', 'The WebRTC peer connection ended.');
                if (this.attempt) {
                    this.failSetup(error, failed ? 'failed' : 'remote');
                }
                else {
                    this.finish(failed ? 'failed' : 'remote', failed ? error : undefined);
                }
            }
            else {
                this.checkReady();
            }
        };
        this.onChannelEvent = (event) => {
            if (this.currentState === 'closed') {
                return;
            }
            if (event.type === 'closed') {
                if (this.attempt) {
                    this.failSetup(new errors_1.WebRTCError('connection_closed', 'transport', 'The data channel closed during setup.'), 'remote');
                }
                else {
                    this.finish('remote');
                }
            }
            else if (event.type === 'error') {
                if (event.error.phase === 'transport') {
                    if (this.attempt) {
                        this.failSetup(event.error, 'failed');
                    }
                    else {
                        this.finish('failed', event.error);
                    }
                }
                else {
                    this.connectionEvents.emit(event);
                }
            }
            else {
                this.checkReady();
            }
        };
        // SAFETY: RTCPeerConnection is an optional runtime constructor checked before resource creation; the view keeps browser ambient types optional.
        const host = globalThis;
        if (!host.RTCPeerConnection) {
            throw new errors_1.WebRTCError('unsupported_environment', 'transport', 'WebRTC requires a browser with RTCPeerConnection.');
        }
        const peer = new host.RTCPeerConnection(configuration);
        try {
            this.adapter = new data_channel_1.DataChannel(peer.createDataChannel('oai-events'));
        }
        catch (error) {
            peer.close();
            throw new errors_1.WebRTCError('negotiation_failed', 'transport', 'Could not create the WebRTC data channel.', error);
        }
        this.peer = peer;
        this.peerConnection = peer;
        this.dataChannel = this.adapter.dataChannel;
        peer.addEventListener('connectionstatechange', this.onPeerState);
        this.adapter.onConnectionEvent(this.onChannelEvent);
    }
    /** Current state, including before subscriptions are registered; notifications are not replayed. */
    get state() {
        return this.currentState;
    }
    /** Subscribes to one server event type with its generated payload; returns an independent unsubscribe function. */
    on(type, 
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    handler) {
        return this.adapter.on(type, handler);
    }
    /** Subscribes before connecting so initial server events are observable. API errors remain protocol data. */
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    onEvent(handler) {
        return this.adapter.onEvent(handler);
    }
    /** Subscribes to local diagnostics and lifecycle. Setup failures reject connect() instead of emitting errors here. */
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    onConnectionEvent(handler) {
        if (this.currentState === 'closed') {
            throw new errors_1.WebRTCError('invalid_state', 'transport', 'The WebRTC connection is closed.');
        }
        return this.connectionEvents.add(handler);
    }
    /** Sends without buffering; returning means local submission, not server acceptance. */
    send(event) {
        this.adapter.send(event);
    }
    /** Negotiates once and waits for both native connection and data-channel readiness. Defaults to a 30-second deadline. */
    connect(options) {
        if (this.currentState !== 'new') {
            return Promise.reject(new errors_1.WebRTCError('invalid_state', 'transport', 'connect() may only be called once per connection.'));
        }
        const timeoutMs = options.timeoutMs ?? 30000;
        if (!Number.isFinite(timeoutMs) || timeoutMs <= 0 || timeoutMs > 2147483647) {
            return Promise.reject(new errors_1.WebRTCError('invalid_state', 'transport', 'timeoutMs must be a positive finite timer duration.'));
        }
        const controller = new AbortController();
        // oxlint-disable-next-line promise/avoid-new -- Native readiness, timeout, and abort events settle one connection attempt.
        const result = new Promise((resolve, reject) => {
            const onAbort = () => this.failSetup(new errors_1.WebRTCError('aborted', this.attempt?.phase ?? 'offer', 'WebRTC setup was cancelled.', options.signal?.reason), 'aborted');
            const timer = setTimeout(() => this.failSetup(new errors_1.WebRTCError('timeout', this.attempt?.phase ?? 'offer', 'WebRTC setup timed out.'), 'timeout'), timeoutMs);
            this.attempt = {
                controller,
                phase: 'offer',
                answered: false,
                resolve,
                reject,
                cleanup: () => {
                    clearTimeout(timer);
                    options.signal?.removeEventListener('abort', onAbort);
                },
            };
            this.currentState = 'connecting';
            options.signal?.addEventListener('abort', onAbort, { once: true });
            if (options.signal?.aborted) {
                onAbort();
                return;
            }
            this.connectionEvents.emit({ type: 'state.changed', state: 'connecting' });
        });
        const { attempt } = this;
        if (attempt) {
            void this.negotiate(options, attempt);
        }
        return result;
    }
    /** Idempotently closes owned native resources. It never stops application-supplied media tracks. */
    close() {
        if (this.attempt) {
            this.failSetup(new errors_1.WebRTCError('aborted', this.attempt.phase, 'WebRTC setup was closed by the application.'), 'local');
        }
        else {
            this.finish('local');
        }
    }
    async negotiate(options, attempt) {
        try {
            const offer = await this.peer.createOffer();
            if (this.attempt !== attempt) {
                return;
            }
            await this.peer.setLocalDescription(offer);
            if (this.attempt !== attempt) {
                return;
            }
            const sdp = this.peer.localDescription?.sdp;
            if (!sdp) {
                throw new Error('The local description has no SDP.');
            }
            attempt.phase = 'signaling';
            const answer = await options.exchangeSdp(sdp, { signal: attempt.controller.signal });
            if (this.attempt !== attempt) {
                return;
            }
            if (typeof answer !== 'string' || answer.length === 0) {
                throw new TypeError('The SDP callback must return a nonempty string.');
            }
            attempt.phase = 'answer';
            await this.peer.setRemoteDescription({ type: 'answer', sdp: answer });
            if (this.attempt !== attempt) {
                return;
            }
            attempt.answered = true;
            attempt.phase = 'transport';
            this.checkReady();
        }
        catch (error) {
            if (this.attempt !== attempt) {
                return;
            }
            this.failSetup(new errors_1.WebRTCError(attempt.phase === 'signaling' ? 'signaling_failed' : 'negotiation_failed', attempt.phase, 'Could not establish the WebRTC connection.', error), 'failed');
        }
    }
    checkReady() {
        const { attempt } = this;
        if (!attempt?.answered ||
            this.peer.connectionState !== 'connected' ||
            this.dataChannel.readyState !== 'open') {
            return;
        }
        this.attempt = undefined;
        attempt.cleanup();
        this.currentState = 'connected';
        attempt.resolve();
        this.connectionEvents.emit({ type: 'state.changed', state: 'connected' });
    }
    failSetup(error, reason) {
        const { attempt } = this;
        if (!attempt) {
            return;
        }
        this.attempt = undefined;
        attempt.cleanup();
        attempt.reject(error);
        // Change state and detach first: abort callbacks cannot resurrect setup.
        this.finish(reason);
        attempt.controller.abort(error);
    }
    finish(reason, error) {
        if (this.currentState === 'closed') {
            return;
        }
        this.currentState = 'closed';
        this.peer.removeEventListener('connectionstatechange', this.onPeerState);
        this.adapter.dispose();
        this.peer.close();
        if (error) {
            this.connectionEvents.emit({ type: 'error', error, fatal: true });
        }
        this.connectionEvents.emit({ type: 'closed', reason });
        this.connectionEvents.clear();
    }
}
exports.WebRTCConnection = WebRTCConnection;
//# sourceMappingURL=connection.js.map