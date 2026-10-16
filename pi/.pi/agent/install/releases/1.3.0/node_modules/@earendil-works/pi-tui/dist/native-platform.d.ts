export type ModifierKey = "shift" | "command" | "control" | "option";
export interface NativeClipboard {
    /** Undefined means unavailable, null means no text; transfer failures reject. */
    getText(): Promise<string | null | undefined>;
    /** Undefined means unavailable, null means no image; transfer failures reject. */
    getImage(): Promise<Uint8Array | null | undefined>;
    /** POSIX paths of file URLs on the clipboard. Undefined means unsupported, null means no files. */
    getFilePaths?(): Promise<string[] | null | undefined>;
    /** Linux uses command-line tools to retain clipboard ownership instead. */
    setText?(text: string): Promise<void>;
}
type NativePlatformHelper = NativeClipboard & {
    enableVirtualTerminalInput?: () => boolean;
    isModifierPressed?: (name: ModifierKey) => boolean;
};
export declare function getNativePlatformHelper(): NativePlatformHelper | undefined;
/** Load a clipboard helper without opening the display until a read is requested. */
export declare function getNativeClipboard(): NativeClipboard | undefined;
export {};
//# sourceMappingURL=native-platform.d.ts.map