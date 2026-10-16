import type { AgentSessionEvent, AgentFunctionCallItem } from "../../resources/beta/agents/agents.js";
/** Tracks one helper invocation's coordinator turn and duplicate deliveries.
 * @internal
 */
export declare class TurnState {
    #private;
    /** Records a delivery unless its event ID is in the bounded recent window. */
    accept(event: AgentSessionEvent): boolean;
    /** Checks session termination after updating the selected turn state. */
    terminal(event: AgentSessionEvent): boolean;
    /** Returns each tool call once for the full invocation, including subagent turns. */
    call(event: AgentSessionEvent): AgentFunctionCallItem | undefined;
}
//# sourceMappingURL=turn-state.d.ts.map