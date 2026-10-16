import { Container, type SelectItem, type SelectListLayoutOptions } from "@earendil-works/pi-tui";
export interface SelectSubmenuOptions {
    /** Enable type-to-search fuzzy filtering. */
    searchable?: boolean;
    /** Override the select list layout (column widths). */
    layout?: SelectListLayoutOptions;
}
/**
 * Single-step submenu that shows a titled select list.
 * With `searchable: true`, typing filters the list using fuzzy matching.
 */
export declare class SelectSubmenu extends Container {
    private selectList;
    private listChildIndex;
    private allOptions;
    private listLayout;
    private searchInput;
    private onSelectCb;
    private onCancelCb;
    private onSelectionChangeCb?;
    constructor(title: string, description: string, options: SelectItem[], currentValue: string, onSelect: (value: string) => void, onCancel: () => void, onSelectionChange?: (value: string) => void, submenuOptions?: SelectSubmenuOptions);
    private buildSelectList;
    private applyFilter;
    handleInput(data: string): void;
}
/** One step in a {@link SteppedSubmenu}. */
export interface SteppedSubmenuStep {
    /** Unique key \u2014 the selected value is stored in the result context under this key. */
    key: string;
    /** Title shown at the top of the step. Receives prior selections. */
    title: string | ((context: Record<string, string>) => string);
    /** Description shown below the title. Receives prior selections. */
    description: string | ((context: Record<string, string>) => string);
    /** Build the option list for this step. Called fresh each time the step is shown. */
    options: (context: Record<string, string>) => SelectItem[];
    /** Optionally pre-select a value when entering this step. */
    preselect?: (context: Record<string, string>) => string | undefined;
    /** Enable type-to-search fuzzy filtering for this step. */
    searchable?: boolean;
    /** Override the select list layout (column widths) for this step. */
    layout?: SelectListLayoutOptions;
}
interface SteppedSubmenuOptions {
    /** Start at this step index (0-based), skipping earlier steps. Requires initialContext for skipped keys. */
    startAtStep?: number;
    /** Pre-fill selections for skipped steps. */
    initialContext?: Record<string, string>;
    /** After completing the last step, loop back to step 0 instead of closing. */
    loop?: boolean;
}
/**
 * Generic N-step submenu built on top of {@link SelectSubmenu}.
 *
 * Each step's options can depend on prior selections via the shared context.
 * Esc goes back one step; Esc at step 0 cancels.
 * With `loop: true`, completing the final step invokes `onComplete` then returns to step 0.
 */
export declare class SteppedSubmenu extends Container {
    private readonly steps;
    private readonly onComplete;
    private readonly onCancel;
    private readonly opts;
    private activeComponent;
    private context;
    constructor(steps: SteppedSubmenuStep[], onComplete: (context: Record<string, string>) => void, onCancel: () => void, opts?: SteppedSubmenuOptions);
    private buildStep;
    render(width: number): string[];
    handleInput(data: string): void;
    invalidate(): void;
}
export {};
//# sourceMappingURL=settings-submenu.d.ts.map