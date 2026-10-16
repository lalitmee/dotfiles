import type { TerminalColorMode } from "./colors.ts";
export type ImageProtocol = "kitty" | "iterm2" | null;
export interface TerminalCapabilities {
    images: ImageProtocol;
    trueColor: boolean;
    hyperlinks: boolean;
}
export interface CellDimensions {
    widthPx: number;
    heightPx: number;
}
export interface ImageDimensions {
    widthPx: number;
    heightPx: number;
}
export interface ImageRenderOptions {
    maxWidthCells?: number;
    maxHeightCells?: number;
    preserveAspectRatio?: boolean;
    /** Kitty image ID. If provided, reuses/replaces existing image with this ID. */
    imageId?: number;
    /** Whether Kitty should apply its default cursor movement after placement. */
    moveCursor?: boolean;
}
export declare function getCellDimensions(): CellDimensions;
export declare function setCellDimensions(dims: CellDimensions): void;
export declare function detectCapabilities(tmuxForwardsHyperlink?: () => boolean): TerminalCapabilities;
export declare function getCapabilities(): TerminalCapabilities;
export declare function getTerminalColorMode(capabilities?: TerminalCapabilities): TerminalColorMode;
export declare function resetCapabilitiesCache(): void;
/** Override selected auto-detected capabilities. */
export declare function setCapabilityOverrides(overrides: Partial<TerminalCapabilities>): void;
/** Override the cached capabilities. Useful in tests to exercise both code paths. */
export declare function setCapabilities(caps: TerminalCapabilities): void;
export declare function isImageLine(line: string): boolean;
/**
 * Generate a random image ID for Kitty graphics protocol.
 * Uses random IDs to avoid collisions between different module instances
 * (e.g., main app vs extensions).
 */
export declare function allocateImageId(): number;
export declare function encodeKitty(base64Data: string, options?: {
    columns?: number;
    rows?: number;
    imageId?: number;
    /** Whether Kitty should apply its default cursor movement after placement. Default: true. */
    moveCursor?: boolean;
}): string;
/**
 * Delete a Kitty graphics image by ID.
 * Uses uppercase 'I' to also free the image data.
 */
export declare function deleteKittyImage(imageId: number): string;
/**
 * Delete all visible Kitty graphics images.
 * Uses uppercase 'A' to also free the image data.
 */
export declare function deleteAllKittyImages(): string;
/** Delete all visible Kitty placements while retaining their uploaded image data. */
export declare function deleteAllKittyPlacements(): string;
export declare function encodeITerm2(base64Data: string, options?: {
    width?: number | string;
    height?: number | string;
    name?: string;
    preserveAspectRatio?: boolean;
    inline?: boolean;
}): string;
export interface ImageCellSize {
    columns: number;
    rows: number;
}
export interface KittyImageMetadata extends ImageCellSize {
    imageId: number;
    widthPx: number;
    heightPx: number;
}
export interface KittyImagePlacement {
    imageId: number;
    transmissionGeneration: number;
    transmissionBytes: number;
    estimatedDecodedBytes: number;
    rows: number;
    sequence: string;
    replacementLine: string;
}
export declare function registerKittyImageMetadata(metadata: KittyImageMetadata): void;
export declare function getKittyImageMetadata(line: string): KittyImageMetadata | undefined;
/** Read the number of rows covered by an image placement without scanning its payload. */
export declare function getKittyImagePlacementRows(line: string): number | undefined;
/** Build a placement-only command for an image line emitted by {@link renderImage}. */
export declare function getKittyImagePlacement(line: string): KittyImagePlacement | undefined;
export declare function cropKittyImageLine(line: string, hiddenRows: number, visibleRows: number): string;
export declare function calculateImageCellSize(imageDimensions: ImageDimensions, maxWidthCells: number, maxHeightCells?: number, cellDimensions?: CellDimensions, optimizeAspectRatio?: boolean): ImageCellSize;
export declare function calculateImageRows(imageDimensions: ImageDimensions, targetWidthCells: number, cellDimensions?: CellDimensions): number;
export declare function getPngDimensions(base64Data: string): ImageDimensions | null;
export declare function getJpegDimensions(base64Data: string): ImageDimensions | null;
export declare function getGifDimensions(base64Data: string): ImageDimensions | null;
export declare function getWebpDimensions(base64Data: string): ImageDimensions | null;
export declare function getImageDimensions(base64Data: string, mimeType: string): ImageDimensions | null;
export declare function renderImage(base64Data: string, imageDimensions: ImageDimensions, options?: ImageRenderOptions): {
    sequence: string;
    columns: number;
    rows: number;
    imageId?: number;
} | null;
/**
 * Wrap text in an OSC 8 hyperlink sequence.
 * The text is rendered as a clickable hyperlink in terminals that support OSC 8
 * (Ghostty, Kitty, WezTerm, iTerm2, VSCode, and others).
 * In terminals that do not support OSC 8, the escape sequences are ignored
 * and only the plain text is displayed.
 *
 * @param text - The visible text to display
 * @param url - The URL to link to
 */
export declare function hyperlink(text: string, url: string): string;
/**
 * Text fallback when the terminal cannot render inline images.
 * Absolute paths are shown shortened (~/...) and, when OSC 8 hyperlinks are
 * available, linked to file:// so the full path remains openable.
 */
export declare function imageFallback(mimeType: string, dimensions?: ImageDimensions, filename?: string): string;
//# sourceMappingURL=terminal-image.d.ts.map