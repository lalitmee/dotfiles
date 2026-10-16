/**
 * Detect if we're running as a Bun compiled binary.
 * Bun binaries have import.meta.url containing "$bunfs", "~BUN", or "%7EBUN" (Bun's virtual filesystem path)
 */
export declare const isBunBinary: boolean;
/** Detect if Bun is the runtime (compiled binary or bun run) */
export declare const isBunRuntime: boolean;
export declare const isBundledNode: boolean;
export type InstallMethod = "bun-binary" | "npm" | "pnpm" | "yarn" | "bun" | "unknown";
interface SelfUpdateCommandStep {
    command: string;
    args: string[];
    display: string;
}
export interface SelfUpdateCommand extends SelfUpdateCommandStep {
    steps?: SelfUpdateCommandStep[];
}
export type SelfUpdatePackageTarget = string | {
    packageName: string;
    installSpec?: string;
};
export declare function detectInstallMethod(): InstallMethod;
export declare function getSelfUpdateCommand(packageName: string, npmCommand?: string[], updatePackageTarget?: SelfUpdatePackageTarget): SelfUpdateCommand | undefined;
export declare function getSelfUpdateUnavailableInstruction(packageName: string, npmCommand?: string[], updatePackageTarget?: SelfUpdatePackageTarget): string;
export declare function getUpdateInstruction(packageName: string): string;
/**
 * Get the base directory for resolving package assets (themes, package.json, README.md, CHANGELOG.md).
 * - For Bun binary: returns the directory containing the executable
 * - For Node.js: returns the package root containing package.json
 * - Ignores Bun binary metadata copied into dist/ when the package root is available
 */
export declare function findNodePackageDir(startDir: string): string;
export declare function getPackageDir(): string;
/**
 * Get path to built-in themes directory (shipped with package)
 * - For Bun binary: theme/ next to executable
 * - For Node.js (dist/): dist/modes/interactive/theme/
 * - For source (src/): src/modes/interactive/theme/
 */
export declare function getThemesDir(): string;
/**
 * Get path to HTML export template directory (shipped with package)
 * - For Bun binary: export-html/ next to executable
 * - For Node.js (dist/): dist/core/export-html/
 * - For source (src/): src/core/export-html/
 */
export declare function getExportTemplateDir(): string;
/** Get path to package.json */
export declare function getPackageJsonPath(): string;
/** Get path to README.md */
export declare function getReadmePath(): string;
/** Get path to docs directory */
export declare function getDocsPath(): string;
/** Get path to examples directory */
export declare function getExamplesPath(): string;
/** Get path to CHANGELOG.md */
export declare function getChangelogPath(): string;
/**
 * Get path to built-in interactive assets directory.
 * - For Bun binary: assets/ next to executable
 * - For Node.js (dist/): dist/modes/interactive/assets/
 * - For source (src/): src/modes/interactive/assets/
 */
export declare function getInteractiveAssetsDir(): string;
/** Get path to a bundled interactive asset */
export declare function getBundledInteractiveAssetPath(name: string): string;
/** Called by the Bun entry with the path of the QuickJS wasm file embedded in the compiled executable. */
export declare function setEmbeddedQuickJSWasmPath(path: string): void;
/**
 * Get path to `quickjs-wasi/quickjs.wasm`, the VM that runs codemode scripts. Resolved once so the
 * compiled module cached per path keeps working after an update removes this install (#10439).
 */
export declare function getQuickJSWasmPath(): string;
/** Resolve the codemode worker entry for a release runtime. */
export declare function resolveCodemodeWorkerSpecifier(runtime: "bun-binary" | "bundled-node" | "unbundled", moduleUrl: string): string | URL | undefined;
/**
 * Get the codemode worker entry, or undefined to use the worker that ships next to pi-codemode.
 * The Bun and Node release builds both pass the worker as an extra entrypoint.
 */
export declare function getCodemodeWorkerSpecifier(): string | URL | undefined;
export type InstallChange = {
    kind: "updated";
    version: string;
} | {
    kind: "removed";
};
/**
 * Detect that the package this process runs from changed on disk, for example after `pi update`
 * in another terminal. Code loaded on demand can then be missing or from another version.
 *
 * Checks the package.json read at startup. Resolving it again would walk up past a deleted install
 * and could find an unrelated package.json, such as one in the home directory.
 */
export declare function detectInstallChange(packageJsonPath?: string | undefined): InstallChange | undefined;
export declare const PACKAGE_NAME: string;
export declare const APP_NAME: string;
export declare const APP_TITLE: string;
export declare const CONFIG_DIR_NAME: string;
export declare const VERSION: string;
export declare const ENV_AGENT_DIR: string;
export declare const ENV_SESSION_DIR: string;
export declare function expandTildePath(path: string): string;
/** Get the share viewer URL for a gist ID. */
export declare function getShareViewerUrl(gistId: string): string;
/** Get the agent config directory (e.g., ~/.pi/agent/) */
export declare function getAgentDir(): string;
/** Get path to user's custom themes directory */
export declare function getCustomThemesDir(): string;
/** Get path to models.json */
export declare function getModelsPath(): string;
/** Get path to auth.json */
export declare function getAuthPath(): string;
/** Get path to settings.json */
export declare function getSettingsPath(): string;
/** Get path to tools directory */
export declare function getToolsDir(): string;
/** Get path to managed binaries directory (fd, rg) */
export declare function getBinDir(): string;
/** Get path to prompt templates directory */
export declare function getPromptsDir(): string;
/** Get path to sessions directory */
export declare function getSessionsDir(): string;
/** Get path to debug log file */
export declare function getDebugLogPath(): string;
export {};
//# sourceMappingURL=config.d.ts.map