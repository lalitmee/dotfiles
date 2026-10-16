export interface LatestPiRelease {
    version: string;
    packageName?: string;
    note?: string;
}
/** Include useful errno details hidden behind Node's generic "fetch failed" error. */
export declare function formatVersionCheckError(error: unknown): string;
export declare function comparePackageVersions(leftVersion: string, rightVersion: string): number | undefined;
export declare function isNewerPackageVersion(candidateVersion: string, currentVersion: string): boolean;
export declare function getLatestPiRelease(currentVersion: string, options?: {
    timeoutMs?: number;
    retry?: boolean;
}): Promise<LatestPiRelease | undefined>;
export declare function getLatestPiVersion(currentVersion: string, options?: {
    timeoutMs?: number;
    retry?: boolean;
}): Promise<string | undefined>;
export declare function checkForNewPiVersion(currentVersion: string): Promise<LatestPiRelease | undefined>;
//# sourceMappingURL=version-check.d.ts.map