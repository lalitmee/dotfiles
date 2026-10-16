import { Text } from "@earendil-works/pi-tui";
/**
 * Text whose content applies theme colors. Plain `Text` keeps the colors its string was built with, so
 * a theme change, or the system theme receiving the terminal's colors, would leave it stale. This
 * rebuilds the string from `build` after every invalidation, which the UI performs on theme changes.
 *
 * `build` must return the same content each time, apart from colors. Snapshot changing data before
 * creating the component, or call `invalidate()` after changing state that `build` reads.
 */
export declare class ThemedText extends Text {
    private readonly build;
    private stale;
    constructor(build: () => string, paddingX?: number, paddingY?: number);
    invalidate(): void;
    render(width: number): string[];
}
//# sourceMappingURL=themed-text.d.ts.map