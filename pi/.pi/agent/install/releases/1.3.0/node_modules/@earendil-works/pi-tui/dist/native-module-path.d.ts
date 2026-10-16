export interface NativeModuleCandidateOptions {
    moduleUrl?: string;
    execPath?: string;
    resolvePackage?: (specifier: string) => string;
}
export declare function getNativeModuleCandidates(nativePath: string, options?: NativeModuleCandidateOptions): string[];
//# sourceMappingURL=native-module-path.d.ts.map