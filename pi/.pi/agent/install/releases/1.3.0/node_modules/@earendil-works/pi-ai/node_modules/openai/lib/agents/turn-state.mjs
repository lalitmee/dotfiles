var _TurnState_turnID, _TurnState_turnEnded, _TurnState_eventIDs, _TurnState_calls;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../../internal/tslib.mjs";
/** Tracks one helper invocation's coordinator turn and duplicate deliveries.
 * @internal
 */
export class TurnState {
    constructor() {
        _TurnState_turnID.set(this, void 0);
        _TurnState_turnEnded.set(this, false);
        _TurnState_eventIDs.set(this, new Set());
        _TurnState_calls.set(this, new Set());
    }
    /** Records a delivery unless its event ID is in the bounded recent window. */
    accept(event) {
        if (__classPrivateFieldGet(this, _TurnState_eventIDs, "f").has(event.event_id)) {
            return false;
        }
        if (__classPrivateFieldGet(this, _TurnState_eventIDs, "f").size === 1024) {
            const oldest = __classPrivateFieldGet(this, _TurnState_eventIDs, "f").values().next();
            if (!oldest.done) {
                __classPrivateFieldGet(this, _TurnState_eventIDs, "f").delete(oldest.value);
            }
        }
        __classPrivateFieldGet(this, _TurnState_eventIDs, "f").add(event.event_id);
        if (event.type === 'agent.session.turn.created' &&
            event.turn.subagent_id === null &&
            __classPrivateFieldGet(this, _TurnState_turnID, "f") === undefined) {
            __classPrivateFieldSet(this, _TurnState_turnID, event.turn_id, "f");
        }
        if ((event.type === 'agent.session.turn.completed' ||
            event.type === 'agent.session.turn.failed' ||
            event.type === 'agent.session.turn.cancelled') &&
            __classPrivateFieldGet(this, _TurnState_turnID, "f") !== undefined &&
            event.turn_id === __classPrivateFieldGet(this, _TurnState_turnID, "f")) {
            __classPrivateFieldSet(this, _TurnState_turnEnded, true, "f");
        }
        return true;
    }
    /** Checks session termination after updating the selected turn state. */
    terminal(event) {
        return event.type === 'agent.session.failed' || (event.type === 'agent.session.idle' && __classPrivateFieldGet(this, _TurnState_turnEnded, "f"));
    }
    /** Returns each tool call once for the full invocation, including subagent turns. */
    call(event) {
        if (event.type !== 'agent.session.turn.item.added' || event.item.type !== 'function_call') {
            return;
        }
        const call = event.item;
        const key = JSON.stringify([call.turn_id, call.call_id]);
        if (__classPrivateFieldGet(this, _TurnState_calls, "f").has(key)) {
            return;
        }
        __classPrivateFieldGet(this, _TurnState_calls, "f").add(key);
        return call;
    }
}
_TurnState_turnID = new WeakMap(), _TurnState_turnEnded = new WeakMap(), _TurnState_eventIDs = new WeakMap(), _TurnState_calls = new WeakMap();
//# sourceMappingURL=turn-state.mjs.map