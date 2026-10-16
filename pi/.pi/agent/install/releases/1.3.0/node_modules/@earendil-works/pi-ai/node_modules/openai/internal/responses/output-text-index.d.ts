/**
 * Stores output text lengths in a complete binary segment tree.
 *
 * Leaves begin at `capacity`; each parent contains the sum of its children.
 * Rebuilding when capacity doubles preserves every existing contribution and
 * makes growth linear in the total number of appended outputs.
 */
export declare class OutputTextIndex {
    private capacity;
    private values;
    private size;
    get length(): number;
    append(value: number): void;
    update(index: number, value: number): void;
    prefixSum(end: number): number;
    private grow;
}
//# sourceMappingURL=output-text-index.d.ts.map