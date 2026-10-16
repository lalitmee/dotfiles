"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.pollAssistantRun = pollAssistantRun;
const polling_1 = require("./polling.js");
/**
 * Polls an assistant run through the resource's retrieve method, preserving the
 * original params object, request-header merge, and terminal run states.
 *
 * @internal
 */
function pollAssistantRun(resource, runID, params, options) {
    return (0, polling_1.pollWithResponse)((headers) => resource.retrieve(runID, params, {
        ...options,
        headers: { ...options?.headers, ...headers },
    }), ['queued', 'in_progress', 'cancelling'], ['requires_action', 'incomplete', 'cancelled', 'completed', 'failed', 'expired'], options);
}
//# sourceMappingURL=assistant-run-polling.js.map