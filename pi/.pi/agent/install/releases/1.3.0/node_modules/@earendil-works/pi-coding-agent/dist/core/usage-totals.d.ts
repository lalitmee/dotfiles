import type { Usage } from "@earendil-works/pi-ai/compat";
import type { SessionEntry } from "./session-manager.ts";
export interface UsageTotals {
    input: number;
    output: number;
    cacheRead: number;
    cacheWrite: number;
    cost: number;
}
export declare function createUsageTotals(): UsageTotals;
export declare function addUsageToTotals(totals: UsageTotals, usage: Usage): void;
/** Sum of two usages, keeping the optional token splits when either side reports them. */
export declare function combineUsage(first: Usage, second: Usage): Usage;
export interface UsageCostBreakdownEntry {
    key: string;
    cost: number;
    tokens: number;
}
/** Group model-attributed usage by model and all other usage into a separate bucket. */
export declare function getUsageCostBreakdown(entries: SessionEntry[]): UsageCostBreakdownEntry[];
//# sourceMappingURL=usage-totals.d.ts.map