import { type ImageDimensions } from "../terminal-image.ts";
import type { Component } from "../tui.ts";
/**
 * Converts base64 image data to base64 PNG data, or returns null if it cannot.
 * Called synchronously during rendering.
 */
export type ImageTranscoder = (base64Data: string, mimeType: string) => string | null;
/**
 * Register the converter used for non-PNG images on Kitty-protocol terminals, which only accept PNG.
 * Without one, such images render as text fallbacks.
 */
export declare function setImageTranscoder(transcoder: ImageTranscoder | undefined): void;
export interface ImageTheme {
    fallbackColor: (str: string) => string;
}
export interface ImageOptions {
    maxWidthCells?: number;
    maxHeightCells?: number;
    filename?: string;
    /** Kitty image ID. If provided, reuses this ID (for animations/updates). */
    imageId?: number;
}
export declare class Image implements Component {
    private base64Data;
    private mimeType;
    private dimensions;
    private theme;
    private options;
    private imageId?;
    /** Converted PNG data for Kitty. Failures are not stored so a later transcoder can retry. */
    private pngData?;
    private cachedLines?;
    private cachedWidth?;
    constructor(base64Data: string, mimeType: string, theme: ImageTheme, options?: ImageOptions, dimensions?: ImageDimensions);
    /** Get the Kitty image ID used by this image (if any). */
    getImageId(): number | undefined;
    invalidate(): void;
    render(width: number): string[];
}
//# sourceMappingURL=image.d.ts.map