/** Read plain text from the system clipboard. */
export declare function readClipboardText(): Promise<string | null>;
/** Read file paths, such as Finder file copies, from the native clipboard. */
export declare function readClipboardFilePaths(): Promise<string[] | null>;
export declare function copyToClipboard(text: string): Promise<void>;
//# sourceMappingURL=clipboard.d.ts.map