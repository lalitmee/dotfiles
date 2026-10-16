import { pollWithResponse } from "./polling.mjs";
/**
 * Polls an assistant run through the resource's retrieve method, preserving the
 * original params object, request-header merge, and terminal run states.
 *
 * @internal
 */
export function pollAssistantRun(resource, runID, params, options) {
    return pollWithResponse((headers) => resource.retrieve(runID, params, {
        ...options,
        headers: { ...options?.headers, ...headers },
    }), ['queued', 'in_progress', 'cancelling'], ['requires_action', 'incomplete', 'cancelled', 'completed', 'failed', 'expired'], options);
}
//# sourceMappingURL=assistant-run-polling.mjs.map