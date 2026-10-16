import type { RequestOptions } from "../internal/request-options.js";
import type { Run, RunRetrieveParams, Runs } from "../resources/beta/threads/runs/runs.js";
/**
 * Polls an assistant run through the resource's retrieve method, preserving the
 * original params object, request-header merge, and terminal run states.
 *
 * @internal
 */
export declare function pollAssistantRun(resource: Pick<Runs, 'retrieve'>, runID: string, params: RunRetrieveParams, options?: RequestOptions & {
    pollIntervalMs?: number;
}): Promise<Run>;
//# sourceMappingURL=assistant-run-polling.d.ts.map