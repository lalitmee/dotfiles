"use strict";
var _TurnState_turnID, _TurnState_turnEnded, _TurnState_eventIDs, _TurnState_calls;
Object.defineProperty(exports, "__esModule", { value: true });
exports.TurnState = void 0;
const tslib_1 = require("../../internal/tslib.js");
/** Tracks one helper invocation's coordinator turn and duplicate deliveries.
 * @internal
 */
class TurnState {
    constructor() {
        _TurnState_turnID.set(this, void 0);
        _TurnState_turnEnded.set(this, false);
        _TurnState_eventIDs.set(this, new Set());
        _TurnState_calls.set(this, new Set());
    }
    /** Records a delivery unless its event ID is in the bounded recent window. */
    accept(event) {
        if (tslib_1.__classPrivateFieldGet(this, _TurnState_eventIDs, "f").has(event.event_id)) {
            return false;
        }
        if (tslib_1.__classPrivateFieldGet(this, _TurnState_eventIDs, "f").size === 1024) {
            const oldest = tslib_1.__classPrivateFieldGet(this, _TurnState_eventIDs, "f").values().next();
            if (!oldest.done) {
                tslib_1.__classPrivateFieldGet(this, _TurnState_eventIDs, "f").delete(oldest.value);
            }
        }
        tslib_1.__classPrivateFieldGet(this, _TurnState_eventIDs, "f").add(event.event_id);
        if (event.type === 'agent.session.turn.created' &&
            event.turn.subagent_id === null &&
            tslib_1.__classPrivateFieldGet(this, _TurnState_turnID, "f") === undefined) {
            tslib_1.__classPrivateFieldSet(this, _TurnState_turnID, event.turn_id, "f");
        }
        if ((event.type === 'agent.session.turn.completed' ||
            event.type === 'agent.session.turn.failed' ||
            event.type === 'agent.session.turn.cancelled') &&
            tslib_1.__classPrivateFieldGet(this, _TurnState_turnID, "f") !== undefined &&
            event.turn_id === tslib_1.__classPrivateFieldGet(this, _TurnState_turnID, "f")) {
            tslib_1.__classPrivateFieldSet(this, _TurnState_turnEnded, true, "f");
        }
        return true;
    }
    /** Checks session termination after updating the selected turn state. */
    terminal(event) {
        return event.type === 'agent.session.failed' || (event.type === 'agent.session.idle' && tslib_1.__classPrivateFieldGet(this, _TurnState_turnEnded, "f"));
    }
    /** Returns each tool call once for the full invocation, including subagent turns. */
    call(event) {
        if (event.type !== 'agent.session.turn.item.added' || event.item.type !== 'function_call') {
            return;
        }
        const call = event.item;
        const key = JSON.stringify([call.turn_id, call.call_id]);
        if (tslib_1.__classPrivateFieldGet(this, _TurnState_calls, "f").has(key)) {
            return;
        }
        tslib_1.__classPrivateFieldGet(this, _TurnState_calls, "f").add(key);
        return call;
    }
}
exports.TurnState = TurnState;
_TurnState_turnID = new WeakMap(), _TurnState_turnEnded = new WeakMap(), _TurnState_eventIDs = new WeakMap(), _TurnState_calls = new WeakMap();
//# sourceMappingURL=turn-state.js.map