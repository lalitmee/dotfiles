import { type Static, Type } from "typebox";
declare const CompactionModelOverrideSchema: Type.TObject<{
    reserveTokens: Type.TOptional<Type.TInteger>;
    keepRecentTokens: Type.TOptional<Type.TInteger>;
}>;
declare const CompactionSettingsSchema: Type.TObject<{
    enabled: Type.TOptional<Type.TBoolean>;
    reserveTokens: Type.TOptional<Type.TInteger>;
    keepRecentTokens: Type.TOptional<Type.TInteger>;
    modelOverrides: Type.TOptional<Type.TRecord<"^.*$", Type.TObject<{
        reserveTokens: Type.TOptional<Type.TInteger>;
        keepRecentTokens: Type.TOptional<Type.TInteger>;
    }>>>;
}>;
declare const BranchSummarySettingsSchema: Type.TObject<{
    reserveTokens: Type.TOptional<Type.TNumber>;
    skipPrompt: Type.TOptional<Type.TBoolean>;
}>;
declare const ProviderRetrySettingsSchema: Type.TObject<{
    timeoutMs: Type.TOptional<Type.TNumber>;
    maxRetries: Type.TOptional<Type.TNumber>;
    maxRetryDelayMs: Type.TOptional<Type.TNumber>;
}>;
declare const RetrySettingsSchema: Type.TObject<{
    enabled: Type.TOptional<Type.TBoolean>;
    maxRetries: Type.TOptional<Type.TNumber>;
    baseDelayMs: Type.TOptional<Type.TNumber>;
    maxAgentDelayMs: Type.TOptional<Type.TNumber>;
    provider: Type.TOptional<Type.TObject<{
        timeoutMs: Type.TOptional<Type.TNumber>;
        maxRetries: Type.TOptional<Type.TNumber>;
        maxRetryDelayMs: Type.TOptional<Type.TNumber>;
    }>>;
    maxDelayMs: Type.TOptional<Type.TNumber>;
}>;
declare const TerminalSettingsSchema: Type.TObject<{
    showImages: Type.TOptional<Type.TBoolean>;
    imageWidthCells: Type.TOptional<Type.TNumber>;
    clearOnShrink: Type.TOptional<Type.TBoolean>;
    showTerminalProgress: Type.TOptional<Type.TBoolean>;
    hyperlinks: Type.TOptional<Type.TUnion<[Type.TBoolean, Type.TLiteral<"auto">]>>;
    images: Type.TOptional<Type.TUnion<[Type.TLiteral<"kitty">, Type.TLiteral<"iterm2">, Type.TLiteral<"auto">, Type.TLiteral<false>]>>;
    trueColor: Type.TOptional<Type.TUnion<[Type.TBoolean, Type.TLiteral<"auto">]>>;
}>;
declare const ImageSettingsSchema: Type.TObject<{
    autoResize: Type.TOptional<Type.TBoolean>;
    blockImages: Type.TOptional<Type.TBoolean>;
}>;
declare const ThinkingBudgetsSettingsSchema: Type.TObject<{
    minimal: Type.TOptional<Type.TNumber>;
    low: Type.TOptional<Type.TNumber>;
    medium: Type.TOptional<Type.TNumber>;
    high: Type.TOptional<Type.TNumber>;
}>;
declare const MarkdownSettingsSchema: Type.TObject<{
    codeBlockIndent: Type.TOptional<Type.TString>;
    mermaid: Type.TOptional<Type.TUnion<[Type.TLiteral<"off">, Type.TLiteral<"final">, Type.TLiteral<"streaming">]>>;
}>;
declare const WarningSettingsSchema: Type.TObject<{
    anthropicExtraUsage: Type.TOptional<Type.TBoolean>;
}>;
declare const CodemodeModeSchema: Type.TUnion<[Type.TLiteral<"on">, Type.TLiteral<"only">]>;
declare const CodemodeSettingsSchema: Type.TObject<{
    mode: Type.TOptional<Type.TUnion<[Type.TLiteral<"on">, Type.TLiteral<"only">]>>;
    inlineBudget: Type.TOptional<Type.TNumber>;
}>;
declare const PackageSourceSchema: Type.TUnion<[Type.TString, Type.TObject<{
    source: Type.TString;
    autoload: Type.TOptional<Type.TBoolean>;
    extensions: Type.TOptional<Type.TArray<Type.TString>>;
    skills: Type.TOptional<Type.TArray<Type.TString>>;
    prompts: Type.TOptional<Type.TArray<Type.TString>>;
    themes: Type.TOptional<Type.TArray<Type.TString>>;
}>]>;
export declare const SettingsSchema: Type.TObject<{
    $schema: Type.TOptional<Type.TString>;
    lastChangelogVersion: Type.TOptional<Type.TString>;
    defaultProvider: Type.TOptional<Type.TString>;
    defaultModel: Type.TOptional<Type.TString>;
    defaultThinkingLevel: Type.TOptional<Type.TEnum<["off", "minimal", "low", "medium", "high", "xhigh", "max"]>>;
    modelThinkingLevels: Type.TOptional<Type.TRecord<"^.*$", Type.TEnum<["off", "minimal", "low", "medium", "high", "xhigh", "max"]>>>;
    transport: Type.TOptional<Type.TUnion<[Type.TLiteral<"auto">, Type.TLiteral<"sse">, Type.TLiteral<"websocket">, Type.TLiteral<"websocket-cached">]>>;
    sessionShareDestination: Type.TOptional<Type.TUnion<[Type.TLiteral<"auto">, Type.TLiteral<"gist">, Type.TLiteral<"radius">]>>;
    steeringMode: Type.TOptional<Type.TUnion<[Type.TLiteral<"all">, Type.TLiteral<"one-at-a-time">]>>;
    followUpMode: Type.TOptional<Type.TUnion<[Type.TLiteral<"all">, Type.TLiteral<"one-at-a-time">]>>;
    theme: Type.TOptional<Type.TString>;
    compaction: Type.TOptional<Type.TObject<{
        enabled: Type.TOptional<Type.TBoolean>;
        reserveTokens: Type.TOptional<Type.TInteger>;
        keepRecentTokens: Type.TOptional<Type.TInteger>;
        modelOverrides: Type.TOptional<Type.TRecord<"^.*$", Type.TObject<{
            reserveTokens: Type.TOptional<Type.TInteger>;
            keepRecentTokens: Type.TOptional<Type.TInteger>;
        }>>>;
    }>>;
    branchSummary: Type.TOptional<Type.TObject<{
        reserveTokens: Type.TOptional<Type.TNumber>;
        skipPrompt: Type.TOptional<Type.TBoolean>;
    }>>;
    retry: Type.TOptional<Type.TObject<{
        enabled: Type.TOptional<Type.TBoolean>;
        maxRetries: Type.TOptional<Type.TNumber>;
        baseDelayMs: Type.TOptional<Type.TNumber>;
        maxAgentDelayMs: Type.TOptional<Type.TNumber>;
        provider: Type.TOptional<Type.TObject<{
            timeoutMs: Type.TOptional<Type.TNumber>;
            maxRetries: Type.TOptional<Type.TNumber>;
            maxRetryDelayMs: Type.TOptional<Type.TNumber>;
        }>>;
        maxDelayMs: Type.TOptional<Type.TNumber>;
    }>>;
    hideThinkingBlock: Type.TOptional<Type.TBoolean>;
    showCacheMissNotices: Type.TOptional<Type.TBoolean>;
    externalEditor: Type.TOptional<Type.TString>;
    shellPath: Type.TOptional<Type.TString>;
    quietStartup: Type.TOptional<Type.TUnion<[Type.TBoolean, Type.TLiteral<"header">]>>;
    defaultProjectTrust: Type.TOptional<Type.TUnion<[Type.TLiteral<"ask">, Type.TLiteral<"always">, Type.TLiteral<"never">]>>;
    shellCommandPrefix: Type.TOptional<Type.TString>;
    npmCommand: Type.TOptional<Type.TArray<Type.TString>>;
    collapseChangelog: Type.TOptional<Type.TBoolean>;
    enableInstallTelemetry: Type.TOptional<Type.TBoolean>;
    enableAnalytics: Type.TOptional<Type.TBoolean>;
    trackingId: Type.TOptional<Type.TString>;
    packages: Type.TOptional<Type.TArray<Type.TUnion<[Type.TString, Type.TObject<{
        source: Type.TString;
        autoload: Type.TOptional<Type.TBoolean>;
        extensions: Type.TOptional<Type.TArray<Type.TString>>;
        skills: Type.TOptional<Type.TArray<Type.TString>>;
        prompts: Type.TOptional<Type.TArray<Type.TString>>;
        themes: Type.TOptional<Type.TArray<Type.TString>>;
    }>]>>>;
    extensions: Type.TOptional<Type.TArray<Type.TString>>;
    deviceId: Type.TOptional<Type.TString>;
    skills: Type.TOptional<Type.TUnion<[Type.TArray<Type.TString>, Type.TObject<{
        enableSkillCommands: Type.TOptional<Type.TBoolean>;
        customDirectories: Type.TOptional<Type.TArray<Type.TString>>;
    }>]>>;
    prompts: Type.TOptional<Type.TArray<Type.TString>>;
    themes: Type.TOptional<Type.TArray<Type.TString>>;
    enableSkillCommands: Type.TOptional<Type.TBoolean>;
    terminal: Type.TOptional<Type.TObject<{
        showImages: Type.TOptional<Type.TBoolean>;
        imageWidthCells: Type.TOptional<Type.TNumber>;
        clearOnShrink: Type.TOptional<Type.TBoolean>;
        showTerminalProgress: Type.TOptional<Type.TBoolean>;
        hyperlinks: Type.TOptional<Type.TUnion<[Type.TBoolean, Type.TLiteral<"auto">]>>;
        images: Type.TOptional<Type.TUnion<[Type.TLiteral<"kitty">, Type.TLiteral<"iterm2">, Type.TLiteral<"auto">, Type.TLiteral<false>]>>;
        trueColor: Type.TOptional<Type.TUnion<[Type.TBoolean, Type.TLiteral<"auto">]>>;
    }>>;
    images: Type.TOptional<Type.TObject<{
        autoResize: Type.TOptional<Type.TBoolean>;
        blockImages: Type.TOptional<Type.TBoolean>;
    }>>;
    enabledModels: Type.TOptional<Type.TArray<Type.TString>>;
    defaultTools: Type.TOptional<Type.TArray<Type.TString>>;
    doubleEscapeAction: Type.TOptional<Type.TUnion<[Type.TLiteral<"fork">, Type.TLiteral<"tree">, Type.TLiteral<"none">]>>;
    treeFilterMode: Type.TOptional<Type.TUnion<[Type.TLiteral<"default">, Type.TLiteral<"no-tools">, Type.TLiteral<"user-only">, Type.TLiteral<"labeled-only">, Type.TLiteral<"all">]>>;
    thinkingBudgets: Type.TOptional<Type.TObject<{
        minimal: Type.TOptional<Type.TNumber>;
        low: Type.TOptional<Type.TNumber>;
        medium: Type.TOptional<Type.TNumber>;
        high: Type.TOptional<Type.TNumber>;
    }>>;
    editorPaddingX: Type.TOptional<Type.TNumber>;
    outputPad: Type.TOptional<Type.TUnion<[Type.TLiteral<0>, Type.TLiteral<1>]>>;
    autocompleteMaxVisible: Type.TOptional<Type.TNumber>;
    showHardwareCursor: Type.TOptional<Type.TBoolean>;
    markdown: Type.TOptional<Type.TObject<{
        codeBlockIndent: Type.TOptional<Type.TString>;
        mermaid: Type.TOptional<Type.TUnion<[Type.TLiteral<"off">, Type.TLiteral<"final">, Type.TLiteral<"streaming">]>>;
    }>>;
    warnings: Type.TOptional<Type.TObject<{
        anthropicExtraUsage: Type.TOptional<Type.TBoolean>;
    }>>;
    codemode: Type.TOptional<Type.TObject<{
        mode: Type.TOptional<Type.TUnion<[Type.TLiteral<"on">, Type.TLiteral<"only">]>>;
        inlineBudget: Type.TOptional<Type.TNumber>;
    }>>;
    sessionDir: Type.TOptional<Type.TString>;
    httpProxy: Type.TOptional<Type.TString>;
    httpIdleTimeoutMs: Type.TOptional<Type.TUnion<[Type.TNumber, Type.TLiteral<"disabled">]>>;
    cacheWarming: Type.TOptional<Type.TUnion<[Type.TLiteral<"off">, Type.TLiteral<"streaming">, Type.TLiteral<"idle">]>>;
    websocketConnectTimeoutMs: Type.TOptional<Type.TUnion<[Type.TNumber, Type.TLiteral<"disabled">]>>;
    tuiMode: Type.TOptional<Type.TUnion<[Type.TLiteral<"regular">, Type.TLiteral<"fullscreen">]>>;
    fullscreenExitOutput: Type.TOptional<Type.TUnion<[Type.TLiteral<"transcript">, Type.TLiteral<"resume-hint">]>>;
    fullscreenScrollbar: Type.TOptional<Type.TUnion<[Type.TLiteral<"auto">, Type.TLiteral<"always">, Type.TLiteral<"hidden">]>>;
    fullscreenCopyOnSelect: Type.TOptional<Type.TBoolean>;
    fullscreenWheelScrollLines: Type.TOptional<Type.TUnion<[Type.TNumber, Type.TLiteral<"auto">]>>;
    queueMode: Type.TOptional<Type.TUnion<[Type.TLiteral<"all">, Type.TLiteral<"one-at-a-time">]>>;
    websockets: Type.TOptional<Type.TBoolean>;
}>;
type SettingsInput = Static<typeof SettingsSchema>;
export interface CompactionModelOverride extends Static<typeof CompactionModelOverrideSchema> {
}
export interface CompactionSettings extends Static<typeof CompactionSettingsSchema> {
}
export interface BranchSummarySettings extends Static<typeof BranchSummarySettingsSchema> {
}
export interface ProviderRetrySettings extends Static<typeof ProviderRetrySettingsSchema> {
}
export interface RetrySettings extends Omit<Static<typeof RetrySettingsSchema>, "maxDelayMs"> {
}
export interface TerminalSettings extends Static<typeof TerminalSettingsSchema> {
}
export interface ImageSettings extends Static<typeof ImageSettingsSchema> {
}
export interface ThinkingBudgetsSettings extends Static<typeof ThinkingBudgetsSettingsSchema> {
}
export type MermaidRenderingMode = NonNullable<Static<typeof MarkdownSettingsSchema>["mermaid"]>;
export interface MarkdownSettings extends Static<typeof MarkdownSettingsSchema> {
}
export interface WarningSettings extends Static<typeof WarningSettingsSchema> {
}
export type CodemodeMode = Static<typeof CodemodeModeSchema>;
export interface CodemodeSettings extends Static<typeof CodemodeSettingsSchema> {
}
export type DefaultProjectTrust = NonNullable<SettingsInput["defaultProjectTrust"]>;
export type QuietStartup = NonNullable<SettingsInput["quietStartup"]>;
export type TransportSetting = NonNullable<SettingsInput["transport"]>;
export type SessionShareDestination = NonNullable<SettingsInput["sessionShareDestination"]>;
export type PackageSource = Static<typeof PackageSourceSchema>;
export type FullscreenExitOutput = NonNullable<SettingsInput["fullscreenExitOutput"]>;
export type TuiMode = NonNullable<SettingsInput["tuiMode"]>;
export type CacheWarmingMode = NonNullable<SettingsInput["cacheWarming"]>;
export interface Settings extends Omit<SettingsInput, "queueMode" | "retry" | "skills" | "websockets"> {
    retry?: RetrySettings;
    skills?: string[];
}
export {};
//# sourceMappingURL=settings-schema.d.ts.map