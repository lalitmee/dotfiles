interface ZipEntry {
    name: string;
    data: string | Uint8Array;
}
export declare function writeZipArchive(filePath: string, entries: readonly ZipEntry[]): Promise<void>;
export {};
//# sourceMappingURL=zip.d.ts.map