/** Runtime defaults shared by settings accessors and the published JSON Schema. */
export declare const SETTINGS_DEFAULTS: {
    readonly transport: "auto";
    readonly sessionShareDestination: "auto";
    readonly steeringMode: "one-at-a-time";
    readonly followUpMode: "one-at-a-time";
    readonly compaction: {
        readonly enabled: true;
        readonly reserveTokens: 16384;
        readonly keepRecentTokens: 20000;
    };
    readonly branchSummary: {
        readonly reserveTokens: 16384;
        readonly skipPrompt: false;
    };
    readonly retry: {
        readonly enabled: true;
        readonly maxRetries: 3;
        readonly baseDelayMs: 2000;
        readonly maxAgentDelayMs: 60000;
        readonly provider: {
            readonly maxRetryDelayMs: 60000;
        };
    };
    readonly hideThinkingBlock: false;
    readonly showCacheMissNotices: false;
    readonly quietStartup: false;
    readonly defaultProjectTrust: "ask";
    readonly collapseChangelog: false;
    readonly enableInstallTelemetry: true;
    readonly enableAnalytics: false;
    readonly enableSkillCommands: true;
    readonly terminal: {
        readonly showImages: true;
        readonly imageWidthCells: 60;
        readonly clearOnShrink: false;
        readonly showTerminalProgress: false;
    };
    readonly images: {
        readonly autoResize: true;
        readonly blockImages: false;
    };
    readonly doubleEscapeAction: "tree";
    readonly treeFilterMode: "default";
    readonly editorPaddingX: 0;
    readonly outputPad: 1;
    readonly autocompleteMaxVisible: 5;
    readonly markdown: {
        readonly codeBlockIndent: "  ";
        readonly mermaid: "streaming";
    };
    readonly warnings: {
        readonly anthropicExtraUsage: true;
    };
    readonly codemode: {
        readonly mode: "on";
        readonly inlineBudget: 3000;
    };
    readonly cacheWarming: "streaming";
    readonly tuiMode: "fullscreen";
    readonly fullscreenExitOutput: "transcript";
    readonly fullscreenScrollbar: "auto";
    readonly fullscreenCopyOnSelect: true;
    readonly fullscreenWheelScrollLines: "auto";
};
//# sourceMappingURL=settings-defaults.d.ts.map