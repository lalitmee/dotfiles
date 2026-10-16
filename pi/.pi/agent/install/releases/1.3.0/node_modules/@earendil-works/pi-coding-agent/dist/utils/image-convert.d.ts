import { type ImageTranscoder } from "@earendil-works/pi-tui";
export declare function convertImageBytesToPng(bytes: Uint8Array): Promise<Uint8Array | null>;
/**
 * Convert image to PNG format for terminal display.
 * Kitty graphics protocol requires PNG format (f=100).
 */
export declare function convertToPng(base64Data: string, mimeType: string): Promise<{
    data: string;
    mimeType: string;
} | null>;
/**
 * Load photon and return a synchronous PNG transcoder for pi-tui's Kitty image rendering.
 * Returns undefined if photon cannot be loaded.
 */
export declare function loadPngTranscoder(): Promise<ImageTranscoder | undefined>;
/**
 * On Kitty-protocol terminals, register photon as pi-tui's image transcoder so non-PNG images render.
 * Loads photon once. `onRegistered` runs after registration so callers can re-render images that
 * showed text fallbacks; it is not called if the transcoder was already registered or cannot load.
 */
export declare function ensurePngTranscoder(onRegistered: () => void): void;
//# sourceMappingURL=image-convert.d.ts.map