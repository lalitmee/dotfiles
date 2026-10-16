"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataChannel = void 0;
const errors_1 = require("./errors.js");
const subscriptions_1 = require("./subscriptions.js");
/** Typed protocol messages on an application-owned native RTCDataChannel. */
class DataChannel {
    /** Attaches listeners without negotiating, opening, or taking ownership of the channel. */
    constructor(channel) {
        this.events = new subscriptions_1.Subscriptions();
        this.connectionEvents = new subscriptions_1.Subscriptions();
        this.disposed = false;
        this.onMessage = (message) => {
            if (this.disposed) {
                return;
            }
            let event;
            try {
                // SAFETY: The message event boundary reads only optional data and then checks it is a string before parsing.
                const { data } = message;
                if (typeof data !== 'string') {
                    throw new TypeError('Invalid protocol message.');
                }
                event = JSON.parse(data);
                if (typeof event !== 'object' ||
                    event === null ||
                    Array.isArray(event) ||
                    typeof Object.getOwnPropertyDescriptor(event, 'type')?.value !== 'string') {
                    throw new TypeError('Invalid protocol message.');
                }
            }
            catch {
                // JSON SyntaxErrors can contain the payload. Do not retain their cause.
                this.connectionEvents.emit({
                    type: 'error',
                    fatal: false,
                    error: new errors_1.WebRTCError('invalid_message', 'message', 'Received an invalid WebRTC protocol message.'),
                });
                return;
            }
            // Like the generated SDK, accept future event types without a runtime schema registry.
            // SAFETY: The parsed event passed the object and string-discriminator checks; future server event types remain intentionally accepted.
            this.events.emit(event);
        };
        this.onError = (cause) => {
            if (this.disposed) {
                return;
            }
            this.connectionEvents.emit({
                type: 'error',
                fatal: false,
                error: new errors_1.WebRTCError('transport_failed', 'transport', 'The WebRTC data channel reported an error.', cause),
            });
        };
        this.onOpen = () => {
            if (!this.disposed) {
                this.connectionEvents.emit({ type: 'state.changed', state: 'connected' });
            }
        };
        this.onClose = () => {
            if (this.disposed) {
                return;
            }
            this.connectionEvents.emit({ type: 'closed', reason: 'remote' });
            this.dispose();
        };
        this.channel = channel;
        // SAFETY: Expose the supplied channel unchanged through the public alias, which uses native browser typings when DOM globals are present.
        this.dataChannel = channel;
        channel.addEventListener('message', this.onMessage);
        channel.addEventListener('error', this.onError);
        channel.addEventListener('open', this.onOpen);
        channel.addEventListener('close', this.onClose);
    }
    /** Subscribes to one server event type with its generated payload; returns an independent unsubscribe function. */
    on(type, 
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    handler) {
        this.assertActive();
        // The shared dispatcher matches the original discriminator before invoking this callback.
        // SAFETY: The dispatcher checks the event discriminator against type before invoking this handler, preserving the corresponding union member.
        return this.events.add((event) => handler(event), type);
    }
    /** Subscribes to future server events, including raw API errors; returns an unsubscribe function. */
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    onEvent(handler) {
        this.assertActive();
        return this.events.add(handler);
    }
    /** Observes only this channel's local errors and lifecycle, not its owning peer connection. */
    // oxlint-disable-next-line anti-slop/no-unknown-returns -- The existing public listener contract accepts any callback result; subscriptions discard it.
    onConnectionEvent(handler) {
        this.assertActive();
        return this.connectionEvents.add(handler);
    }
    /** Sends immediately on an open channel. Throws on local failure; API acceptance is reported by server events. */
    send(event) {
        this.assertActive();
        if (this.channel.readyState !== 'open') {
            throw new errors_1.WebRTCError('not_open', 'send', 'The WebRTC data channel is not open.');
        }
        try {
            const data = JSON.stringify(event);
            if (data === undefined) {
                throw new TypeError('The event is not JSON serializable.');
            }
            this.channel.send(data);
        }
        catch (error) {
            throw new errors_1.WebRTCError('send_failed', 'send', 'Could not send the WebRTC event.', error);
        }
    }
    /** Detaches all SDK listeners and subscriptions, without closing the channel or stopping tracks. */
    dispose() {
        if (this.disposed) {
            return;
        }
        this.disposed = true;
        this.channel.removeEventListener('message', this.onMessage);
        this.channel.removeEventListener('error', this.onError);
        this.channel.removeEventListener('open', this.onOpen);
        this.channel.removeEventListener('close', this.onClose);
        this.events.clear();
        this.connectionEvents.clear();
    }
    assertActive() {
        if (this.disposed) {
            throw new errors_1.WebRTCError('invalid_state', 'transport', 'The WebRTC data-channel adapter is disposed.');
        }
    }
}
exports.DataChannel = DataChannel;
//# sourceMappingURL=data-channel.js.map