import { type Component, type TUI, type TuiMouseEvent, type TuiMouseEventResult } from "@earendil-works/pi-tui";
/**
 * Fullscreen 3D easter eggs: the pi logo (header logo click) and Armin (/arminsayshi). Both are bitmaps built from
 * one block per pixel. The current screen dissolves into braille dust while the model spins in the center and its
 * blocks play a sliding puzzle. Leaving plays the same timeline backwards, so the screen reassembles.
 *
 * The pi logo lifts off the header, flies to the center, and grows; the dust spreads out from the header logo.
 * Armin grows out of a speck at the center; the dust spreads out from the center.
 *
 * The blocks are ray cast per braille dot. A braille cell holds 2x4 roughly square dots, so one pixel of a
 * half-block bitmap is exactly 2x2 dots, and the header logo (4x2 cells) is 8x8 dots when it lifts off.
 */
type Rgb = readonly [number, number, number];
/** Grid position of a block: column and row in the bitmap, and layer (-1, 0, 1) in depth. */
type Cell3 = readonly [number, number, number];
/** A bitmap built from one block per foreground pixel. Each is a block that the puzzle slides around. */
interface Model {
    /** Bitmap size in pixels. */
    columns: number;
    rows: number;
    blocks: Array<{
        home: Cell3;
        color: Rgb;
    }>;
    /** Camera distance from the model's center, in pixels. */
    cameraDistance: number;
    /** Farthest distance of any block corner from the center, with blocks on the outer depth layers. */
    radius: number;
    /** Largest share of the screen width the spinning model covers. */
    widthShare: number;
    /** Number of blocks the puzzle moves per step, given a random number from 0 to 1. */
    puzzleMoves: (random: number) => number;
    /**
     * Top-left cell of the model's half-block rendering on screen. The model lifts off from there and replaces it.
     * Undefined to grow out of the center.
     */
    origin: {
        column: number;
        row: number;
    } | undefined;
}
/**
 * Which easter egg to play. The pi logo lifts off the header logo, whose top-left cell is at `column`, `row`.
 */
export type EasterEgg3d = {
    kind: "pi-logo";
    column: number;
    row: number;
} | {
    kind: "armin";
};
/**
 * Show the animation as a fullscreen overlay until it is dismissed. The overlay takes focus and mouse input and
 * returns focus when hidden, so the rest of the UI keeps running underneath untouched.
 */
export declare function playEasterEgg3d(tui: TUI, screen: readonly string[], egg: EasterEgg3d): Promise<void>;
export declare class EasterEgg3dAnimation implements Component {
    private readonly tui;
    /** The screen to dissolve, as rendered lines. */
    private readonly screen;
    private readonly model;
    private readonly foreground;
    private readonly background;
    private readonly onDone;
    private readonly startTime;
    private lastRender;
    private timer;
    private exit;
    private shuffle;
    private screenWidth;
    private screenHeight;
    /** Star per cell index, or undefined. */
    private stars;
    private cells;
    private readonly ansiCache;
    private readonly raster;
    constructor(tui: TUI, screen: readonly string[], model: Model, colors: {
        foreground: Rgb;
        background: Rgb;
    }, onDone: () => void);
    /** Play the exit animation. A second call skips it. */
    close(): void;
    handleInput(data: string): void;
    handleMouse(event: TuiMouseEvent): TuiMouseEventResult;
    invalidate(): void;
    render(width: number): string[];
    private elapsed;
    private exitProgress;
    private finish;
    /** Each block's displacement from its place in the model at `time`, in grid units. */
    private blockOffsets;
    private flyProgress;
    private starAlpha;
    private hintAlpha;
    private pose;
    private hint;
    /** A sparse, deterministic starfield: one braille dot in about STAR_DENSITY of all cells. */
    private prepareStars;
    private prepareCells;
    private pack;
    private ansi;
}
export {};
//# sourceMappingURL=easter-egg-3d.d.ts.map