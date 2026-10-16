import type { Component, Focusable } from "./tui.ts";
export interface AltScreenSearchSegment {
    row: number;
    startCol: number;
    endCol: number;
}
export interface AltScreenSearchMatch {
    segments: AltScreenSearchSegment[];
}
export interface AltScreenSearchResult {
    matches: AltScreenSearchMatch[];
    changed: boolean;
}
/** Cache the searchable corpus and matches while rendered transcript lines remain unchanged. */
export declare class AltScreenSearchIndex {
    private sourceLines;
    private corpus;
    private normalizedQuery;
    private matches;
    search(lines: readonly string[], query: string): AltScreenSearchResult;
}
export declare function findAltScreenSearchMatches(lines: readonly string[], query: string): AltScreenSearchMatch[];
export declare function getAltScreenSearchMatchKey(match: AltScreenSearchMatch): string;
export declare class AltScreenSearchComponent implements Component, Focusable {
    private readonly input;
    private readonly onQueryChange;
    private readonly navigationButtonStyle;
    private resultCount;
    private resultIndex;
    private previousButtonStart;
    private previousButtonEnd;
    private nextButtonStart;
    private nextButtonEnd;
    private hoveredNavigationDirection;
    private _focused;
    constructor(onQueryChange: (query: string) => void, navigationButtonStyle?: (text: string, hovered: boolean) => string);
    get focused(): boolean;
    set focused(value: boolean);
    setResult(index: number, count: number): void;
    getNavigationDirectionAt(row: number, column: number): -1 | 1 | undefined;
    setHoveredNavigationDirection(direction: -1 | 1 | undefined): boolean;
    handleInput(data: string): void;
    invalidate(): void;
    render(width: number): string[];
}
//# sourceMappingURL=alt-screen-search.d.ts.map