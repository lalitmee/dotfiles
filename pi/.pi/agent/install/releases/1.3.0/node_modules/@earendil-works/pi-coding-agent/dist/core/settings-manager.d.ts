import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import type { Model } from "@earendil-works/pi-ai";
import type { ScrollViewScrollbar, TerminalCapabilities, WheelScrollLines } from "@earendil-works/pi-tui";
import type { CacheWarmingMode, DefaultProjectTrust, FullscreenExitOutput, MermaidRenderingMode, PackageSource, QuietStartup, SessionShareDestination, Settings, ThinkingBudgetsSettings, TransportSetting, TuiMode, WarningSettings } from "./settings-schema.ts";
export type { BranchSummarySettings, CacheWarmingMode, CodemodeMode, CodemodeSettings, CompactionModelOverride, CompactionSettings, DefaultProjectTrust, FullscreenExitOutput, ImageSettings, MarkdownSettings, MermaidRenderingMode, PackageSource, ProviderRetrySettings, QuietStartup, RetrySettings, SessionShareDestination, Settings, TerminalSettings, ThinkingBudgetsSettings, TransportSetting, TuiMode, WarningSettings, } from "./settings-schema.ts";
/** Cache-warming profile. "idle" also warms between agent runs. */
export declare const CACHE_WARMING_MODES: readonly ["off", "streaming", "idle"];
/** Tools enabled at startup when `defaultTools` does not change them. */
export declare const DEFAULT_TOOL_NAMES: readonly string[];
/** Whether a tool selection entry is a `+name` or `-name` modifier. */
export declare function isToolModifier(entry: unknown): boolean;
/**
 * Validate a tool list from `--tools` or the SDK `tools` option. It is either an allowlist of plain
 * names and patterns or a list of only `+name`/`-name` entries with exact names. Returns the
 * problem, or undefined when the list is valid.
 */
export declare function getToolListError(entries: readonly string[]): string | undefined;
/**
 * Apply the `+name` and `-name` entries of `entries` to `base` in order: `+name` adds a tool and
 * `-name` removes one. Other entries are ignored.
 */
export declare function applyToolModifiers(base: readonly string[], entries: readonly string[]): string[];
export type SettingsScope = "global" | "project";
export interface SettingsManagerCreateOptions {
    projectTrusted?: boolean;
}
export interface SettingsStorage {
    withLock(scope: SettingsScope, fn: (current: string | undefined) => string | undefined): void;
}
export interface SettingsError {
    scope: SettingsScope;
    path?: string;
    error: Error;
}
export declare class FileSettingsStorage implements SettingsStorage {
    private globalSettingsPath;
    private projectSettingsPath;
    constructor(cwd: string, agentDir: string);
    private acquireLockSyncWithRetry;
    withLock(scope: SettingsScope, fn: (current: string | undefined) => string | undefined): void;
}
export declare class InMemorySettingsStorage implements SettingsStorage {
    private global;
    private project;
    withLock(scope: SettingsScope, fn: (current: string | undefined) => string | undefined): void;
}
export declare class SettingsManager {
    private storage;
    private globalSettings;
    private projectSettings;
    private settings;
    private projectTrusted;
    private modifiedFields;
    private modifiedNestedFields;
    private modifiedProjectFields;
    private modifiedProjectNestedFields;
    private globalSettingsLoadError;
    private projectSettingsLoadError;
    private writeQueue;
    private errors;
    private settingsPaths;
    private constructor();
    /** Create a SettingsManager that loads from files */
    static create(cwd: string, agentDir?: string, options?: SettingsManagerCreateOptions): SettingsManager;
    /** Create a SettingsManager from an arbitrary storage backend */
    static fromStorage(storage: SettingsStorage, options?: SettingsManagerCreateOptions): SettingsManager;
    /** Create a manager while retaining optional file paths for reported storage errors. */
    private static fromStorageWithPaths;
    /** Create an in-memory SettingsManager (no file I/O) */
    static inMemory(settings?: Partial<Settings>, options?: SettingsManagerCreateOptions): SettingsManager;
    private static loadFromStorage;
    private static tryLoadFromStorage;
    /** Migrate old settings format to new format */
    private static migrateSettings;
    /** A copy of the effective settings: global and project settings merged, with overrides. */
    getSettings(): Settings;
    getGlobalSettings(): Settings;
    getProjectSettings(): Settings;
    isProjectTrusted(): boolean;
    setProjectTrusted(trusted: boolean): void;
    reload(): Promise<void>;
    /** Apply additional overrides on top of current settings */
    applyOverrides(overrides: Partial<Settings>): void;
    /** Mark a global field as modified during this session */
    private markModified;
    /** Mark a project field as modified during this session */
    private markProjectModified;
    private assertProjectTrustedForWrite;
    private recordError;
    private clearModifiedScope;
    private enqueueWrite;
    private cloneModifiedNestedFields;
    private persistScopedSettings;
    private save;
    private saveProjectSettings;
    private updateProjectSettings;
    flush(): Promise<void>;
    drainErrors(): SettingsError[];
    getLastChangelogVersion(): string | undefined;
    setLastChangelogVersion(version: string): void;
    getSessionDir(): string | undefined;
    getDefaultProvider(): string | undefined;
    getDefaultModel(): string | undefined;
    setDefaultProvider(provider: string): void;
    setDefaultModel(modelId: string): void;
    setDefaultModelAndProvider(provider: string, modelId: string): void;
    getSteeringMode(): "all" | "one-at-a-time";
    setSteeringMode(mode: "all" | "one-at-a-time"): void;
    getFollowUpMode(): "all" | "one-at-a-time";
    setFollowUpMode(mode: "all" | "one-at-a-time"): void;
    getThemeSetting(): string | undefined;
    getTheme(): string | undefined;
    setTheme(theme: string): void;
    getDefaultThinkingLevel(): ThinkingLevel | undefined;
    setDefaultThinkingLevel(level: ThinkingLevel): void;
    getModelThinkingLevel(provider: string, modelId: string): ThinkingLevel | undefined;
    getAllModelThinkingLevels(): Record<string, ThinkingLevel>;
    setModelThinkingLevel(provider: string, modelId: string, level: ThinkingLevel): void;
    removeModelThinkingLevel(provider: string, modelId: string): void;
    getTransport(): TransportSetting;
    setTransport(transport: TransportSetting): void;
    getSessionShareDestination(): SessionShareDestination;
    setSessionShareDestination(destination: SessionShareDestination): void;
    getCompactionEnabled(): boolean;
    setCompactionEnabled(enabled: boolean): void;
    private getCompactionTokenSetting;
    getCompactionReserveTokens(model?: Pick<Model<string>, "provider" | "id">): number;
    getCompactionKeepRecentTokens(model?: Pick<Model<string>, "provider" | "id">): number;
    /** Resolve each token setting through model override, ordinary setting, then built-in default. */
    getCompactionSettings(model?: Pick<Model<string>, "provider" | "id">): {
        enabled: boolean;
        reserveTokens: number;
        keepRecentTokens: number;
    };
    getBranchSummarySettings(): {
        reserveTokens: number;
        skipPrompt: boolean;
    };
    getBranchSummarySkipPrompt(): boolean;
    getRetryEnabled(): boolean;
    setRetryEnabled(enabled: boolean): void;
    getRetrySettings(): {
        enabled: boolean;
        maxRetries: number;
        baseDelayMs: number;
        maxAgentDelayMs: number;
    };
    getHttpIdleTimeoutMs(): number;
    setHttpIdleTimeoutMs(timeoutMs: number): void;
    /** Read from global settings only because warming costs money. */
    getCacheWarmingMode(): CacheWarmingMode;
    setCacheWarmingMode(mode: CacheWarmingMode): void;
    getProviderRetrySettings(): {
        timeoutMs?: number;
        maxRetries?: number;
        maxRetryDelayMs: number;
    };
    getWebSocketConnectTimeoutMs(): number | undefined;
    getHideThinkingBlock(): boolean;
    getShowCacheMissNotices(): boolean;
    getExternalEditorCommand(): string;
    setHideThinkingBlock(hide: boolean): void;
    setShowCacheMissNotices(show: boolean): void;
    getShellPath(): string | undefined;
    setShellPath(path: string | undefined): void;
    getQuietStartup(): QuietStartup;
    setQuietStartup(quiet: QuietStartup): void;
    getDefaultProjectTrust(): DefaultProjectTrust;
    setDefaultProjectTrust(defaultProjectTrust: DefaultProjectTrust): void;
    getShellCommandPrefix(): string | undefined;
    setShellCommandPrefix(prefix: string | undefined): void;
    getNpmCommand(): string[] | undefined;
    setNpmCommand(command: string[] | undefined): void;
    getCollapseChangelog(): boolean;
    setCollapseChangelog(collapse: boolean): void;
    getEnableInstallTelemetry(): boolean;
    setEnableInstallTelemetry(enabled: boolean): void;
    getEnableAnalytics(): boolean;
    getTrackingId(): string | undefined;
    /** Set the analytics opt-in preference; generates a tracking identifier on first opt-in */
    setEnableAnalytics(enabled: boolean): void;
    /**
     * Stable ID of this installation, e.g. sent to OpenAI as its agent host ID.
     * Created on first use. Project settings are ignored so a committed project
     * settings file cannot give every clone the same ID.
     */
    getOrCreateDeviceId(): string;
    getPackages(): PackageSource[];
    setPackages(packages: PackageSource[]): void;
    setProjectPackages(packages: PackageSource[]): void;
    getExtensionPaths(): string[];
    setExtensionPaths(paths: string[]): void;
    setProjectExtensionPaths(paths: string[]): void;
    getSkillPaths(): string[];
    setSkillPaths(paths: string[]): void;
    setProjectSkillPaths(paths: string[]): void;
    getPromptTemplatePaths(): string[];
    setPromptTemplatePaths(paths: string[]): void;
    setProjectPromptTemplatePaths(paths: string[]): void;
    getThemePaths(): string[];
    setThemePaths(paths: string[]): void;
    setProjectThemePaths(paths: string[]): void;
    getEnableSkillCommands(): boolean;
    setEnableSkillCommands(enabled: boolean): void;
    getThinkingBudgets(): ThinkingBudgetsSettings | undefined;
    getTerminalCapabilityOverrides(): Partial<TerminalCapabilities>;
    getShowImages(): boolean;
    setShowImages(show: boolean): void;
    getImageWidthCells(): number;
    setImageWidthCells(width: number): void;
    getClearOnShrink(): boolean;
    setClearOnShrink(enabled: boolean): void;
    getShowTerminalProgress(): boolean;
    setShowTerminalProgress(enabled: boolean): void;
    getTuiMode(): TuiMode;
    setTuiMode(mode: TuiMode): void;
    getFullscreenExitOutput(): FullscreenExitOutput;
    setFullscreenExitOutput(output: FullscreenExitOutput): void;
    getFullscreenScrollbar(): ScrollViewScrollbar;
    setFullscreenScrollbar(mode: ScrollViewScrollbar): void;
    getFullscreenCopyOnSelect(): boolean;
    setFullscreenCopyOnSelect(enabled: boolean): void;
    getFullscreenWheelScrollLines(): WheelScrollLines;
    setFullscreenWheelScrollLines(lines: WheelScrollLines): void;
    getImageAutoResize(): boolean;
    setImageAutoResize(enabled: boolean): void;
    getBlockImages(): boolean;
    setBlockImages(blocked: boolean): void;
    getEnabledModels(): string[] | undefined;
    /** The resolved `defaultTools` selection, or undefined when no settings layer sets it. */
    getDefaultTools(): string[] | undefined;
    setEnabledModels(patterns: string[] | undefined): void;
    getDoubleEscapeAction(): "fork" | "tree" | "none";
    setDoubleEscapeAction(action: "fork" | "tree" | "none"): void;
    getTreeFilterMode(): "default" | "no-tools" | "user-only" | "labeled-only" | "all";
    setTreeFilterMode(mode: "default" | "no-tools" | "user-only" | "labeled-only" | "all"): void;
    getShowHardwareCursor(): boolean;
    setShowHardwareCursor(enabled: boolean): void;
    getEditorPaddingX(): number;
    setEditorPaddingX(padding: number): void;
    getOutputPad(): 0 | 1;
    setOutputPad(padding: 0 | 1): void;
    getAutocompleteMaxVisible(): number;
    setAutocompleteMaxVisible(maxVisible: number): void;
    getCodeBlockIndent(): string;
    getMermaidRenderingMode(): MermaidRenderingMode;
    setMermaidRenderingMode(mode: MermaidRenderingMode): void;
    getWarnings(): WarningSettings;
    setWarnings(warnings: WarningSettings): void;
}
//# sourceMappingURL=settings-manager.d.ts.map