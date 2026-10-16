/**
 * Interactive mode for the coding agent.
 * Handles TUI rendering and user interaction, delegating business logic to AgentSession.
 */
import { type ImageContent } from "@earendil-works/pi-ai/compat";
import { type Terminal } from "@earendil-works/pi-tui";
import { type AgentSessionRuntime } from "../../core/agent-session-runtime.ts";
import type { AgentSessionRuntimeDiagnostic } from "../../core/agent-session-services.ts";
import { SessionManager } from "../../core/session-manager.ts";
import type { FullscreenExitOutput, TuiMode } from "../../core/settings-manager.ts";
import { type LatestPiRelease } from "../../utils/version-check.ts";
export { createInteractiveTui, createInteractiveTuiReference } from "./tui-renderer.ts";
export declare function formatCrashExtensionHint(extensionMatches: readonly string[] | undefined): string | undefined;
export declare function formatResumeCommand(sessionManager: SessionManager): string | undefined;
/**
 * Options for InteractiveMode initialization.
 */
export interface InteractiveModeOptions {
    /** Providers that were migrated to auth.json (shows warning) */
    migratedProviders?: string[];
    /** Diagnostics collected before the interactive TUI was initialized. */
    startupDiagnostics?: AgentSessionRuntimeDiagnostic[];
    /** Warning message if session model couldn't be restored */
    modelFallbackMessage?: string;
    /** Cwd to trust after reload if it gained a .pi directory during this implicitly trusted session. */
    autoTrustOnReloadCwd?: string;
    /** Initial message to send on startup (can include @file content) */
    initialMessage?: string;
    /** Images to attach to the initial message */
    initialImages?: ImageContent[];
    /** Additional messages to send after the initial message */
    initialMessages?: string[];
    /** Force verbose startup (overrides quietStartup setting) */
    verbose?: boolean;
    /** TUI layout mode. */
    tuiMode?: TuiMode;
    /** Initial interactive theme setting for this invocation. */
    initialThemeSetting?: string;
    /** Terminal implementation. Defaults to the current process terminal. */
    terminal?: Terminal;
}
export declare class InteractiveMode {
    private runtimeHost;
    private renderer;
    private ui;
    private mainScreenRenderState;
    private loadedResourcesContainer;
    private chatContainer;
    private documentContainer;
    private transcriptScrollView;
    private fullscreenLayoutRoot;
    private pendingMessagesContainer;
    private statusContainer;
    private defaultEditor;
    private editor;
    private editorComponentFactory;
    private autocompleteProvider;
    private autocompleteProviderWrappers;
    private fdPath;
    private editorContainer;
    private activeSelectorToken?;
    private activeSelectorDispose?;
    private footer;
    private footerContainer;
    private footerDataProvider;
    private keybindings;
    private version;
    private isInitialized;
    private onInputCallback?;
    private pendingUserInputs;
    private activeStatusIndicator;
    private activeWorkingIndicatorEmbedded;
    private readonly idleStatus;
    private workingMessage;
    private workingVisible;
    private workingIndicatorOptions;
    private readonly defaultWorkingMessage;
    private readonly defaultHiddenThinkingLabel;
    private hiddenThinkingLabel;
    private lastSigintTime;
    private lastEscapeTime;
    private changelogMarkdown;
    private startupNoticesShown;
    private anthropicSubscriptionWarningShown;
    private lastStatusSpacer;
    private lastStatusText;
    private lastStatusMessage;
    private managedToolStatusStarted;
    private streamingComponent;
    private readonly entriesRenderedByBoundaryCompaction;
    private streamingMessage;
    private pendingTools;
    private toolOutputExpanded;
    private hideThinkingBlock;
    private outputPad;
    private readonly mermaidMarkdownTransformer;
    private skillCommands;
    private unsubscribe?;
    private signalCleanupHandlers;
    private isBashMode;
    private bashComponent;
    private pendingBashComponents;
    private autoCompactionEscapeHandler?;
    private retryEscapeHandler?;
    private compactionQueuedMessages;
    private shutdownRequested;
    /** Reports working, blocked, done, and error states to terminals that support OSC 7501. */
    private readonly programStatus;
    /** The `/bug` hint is shown at most once per session so error output stays readable. */
    private bugReportHintShown;
    private installChangeWarningShown;
    private extensionSelector;
    private extensionInput;
    private extensionEditor;
    private extensionTerminalInputSubscriptions;
    private extensionWidgetsAbove;
    private extensionWidgetsBelow;
    private widgetContainerAbove;
    private widgetContainerBelow;
    private customFooter;
    private headerContainer;
    private builtInHeader;
    private customHeader;
    private options;
    private readonly onRightClickPaste;
    private autoTrustOnReloadCwd;
    private themeController;
    private get session();
    private get agent();
    private get sessionManager();
    private get settingsManager();
    constructor(runtimeHost: AgentSessionRuntime, options?: InteractiveModeOptions);
    private getAutocompleteSourceTag;
    private prefixAutocompleteDescription;
    private getBuiltInCommandConflictDiagnostics;
    private createBaseAutocompleteProvider;
    private setupAutocompleteProvider;
    private showStartupNoticesIfNeeded;
    private mountInteractiveTui;
    private stopInteractiveTui;
    private switchTuiMode;
    init(): Promise<void>;
    /**
     * Update terminal title with session name and cwd.
     */
    private updateTerminalTitle;
    /**
     * Run the interactive mode. This is the main entry point.
     * Initializes the UI, shows warnings, processes initial messages, and starts the interactive loop.
     */
    run(): Promise<void>;
    private checkForPackageUpdates;
    private checkTmuxKeyboardSetup;
    /**
     * Get changelog entries to display on startup.
     * Only shows new entries since last seen version, skips for resumed sessions.
     */
    private getChangelogForDisplay;
    private reportInstallTelemetry;
    private getMarkdownThemeWithSettings;
    private formatDisplayPath;
    private formatExtensionDisplayPath;
    private formatContextPath;
    private getStartupExpansionState;
    /** Startup header (logo, version, key hints). Hidden only by quietStartup: true. */
    private shouldShowStartupHeader;
    /** Startup details (model scope, loaded resources). Hidden by quietStartup: true or "header". */
    private shouldShowStartupDetails;
    /**
     * Get a short path relative to the package root for display.
     */
    private getShortPath;
    private getCompactPathLabel;
    private getCompactPackageSourceLabel;
    private getCompactExtensionLabel;
    private getCompactDisplayPathSegments;
    private getCompactNonPackageExtensionLabel;
    private getCompactExtensionLabels;
    private getDisplaySourceInfo;
    private getScopeGroup;
    private isPackageSource;
    private buildScopeGroups;
    private formatScopeGroups;
    private findSourceInfoForPath;
    private formatPathWithSource;
    private formatDiagnostics;
    private showLoadedResources;
    /**
     * Initialize the extension system with TUI-based UI context.
     */
    private bindCurrentSessionExtensions;
    private applyFullscreenScrollbarSetting;
    /** Lets extension images use the PNG transcoder; tool results register it themselves. */
    private ensurePngTranscoder;
    private applyRuntimeSettings;
    private rebindCurrentSession;
    private handleFatalRuntimeError;
    private getCrashExtensionHint;
    /** Persist a crash so the next start can point the user at `/bug`. Returns false when nothing was written. */
    private recordCrash;
    private crashReportInstructions;
    private suggestBugReport;
    private maybeSuggestBugReport;
    /**
     * After an error, check whether an update replaced or removed this install while the session ran.
     * Code loaded on demand then fails with missing modules until restart (#10439). Returns true when
     * the install changed.
     */
    private maybeShowInstallChangeWarning;
    private renderCurrentSessionState;
    /**
     * Get a registered tool definition by name (for custom rendering).
     */
    /**
     * Extension-registered definition, falling back to the built-in one. The renderer components take
     * whatever this returns, so they never reach into the tool registry themselves.
     */
    private getRegisteredToolDefinition;
    private getMarkdownTransformers;
    /**
     * Set up keyboard shortcuts registered by extensions.
     */
    private setupExtensionShortcuts;
    /**
     * Set extension status text in the footer.
     */
    private setExtensionStatus;
    private setEditorWorkingStatusIndicator;
    private showStatusIndicator;
    private clearStatusIndicator;
    private showWorkingStatusIndicator;
    private setWorkingVisible;
    private setWorkingIndicator;
    private setHiddenThinkingLabel;
    /**
     * Set an extension widget (string array or custom component).
     */
    private setExtensionWidget;
    private clearExtensionWidgets;
    private resetExtensionUI;
    private static readonly MAX_WIDGET_LINES;
    /**
     * Render all extension widgets to the widget container.
     */
    private renderWidgets;
    private renderWidgetContainer;
    /**
     * Set a custom footer component, or restore the built-in footer.
     */
    private setExtensionFooter;
    /**
     * Set a custom header component, or restore the built-in header.
     */
    private setExtensionHeader;
    private addExtensionTerminalInputListener;
    private rebindExtensionTerminalInputListeners;
    private clearExtensionTerminalInputListeners;
    /**
     * Create the ExtensionUIContext for extensions.
     */
    private createProjectTrustContext;
    private createExtensionUIContext;
    /**
     * Show a selector for extensions.
     */
    private showExtensionSelector;
    /**
     * Hide the extension selector.
     */
    private hideExtensionSelector;
    /**
     * Show a confirmation dialog for extensions.
     */
    private showExtensionConfirm;
    private promptForMissingSessionCwd;
    /**
     * Show a text input for extensions.
     */
    private showExtensionInput;
    /**
     * Hide the extension input.
     */
    private hideExtensionInput;
    /**
     * Show a multi-line editor for extensions (with Ctrl+G support).
     */
    private showExtensionEditor;
    /**
     * Hide the extension editor.
     */
    private hideExtensionEditor;
    /**
     * Set a custom editor component from an extension.
     * Pass undefined to restore the default editor.
     */
    private setCustomEditorComponent;
    /**
     * Show a notification for extensions.
     */
    private showExtensionNotify;
    /** Show a custom component with keyboard focus. Overlay mode renders on top of existing content. */
    private showExtensionCustom;
    /**
     * Show an extension error in the UI.
     */
    private showExtensionError;
    private setupKeyHandlers;
    private handleRightClickPaste;
    private handleClipboardPaste;
    private handleStartupSubmit;
    private setupEditorSubmitHandler;
    private subscribeToAgent;
    private handleEvent;
    /** Extract text content from a user message */
    private getUserMessageText;
    /** Show a managed-tool status update in the chat. */
    private showManagedToolStatus;
    /**
     * Show a status message in the chat.
     *
     * If multiple status messages are emitted back-to-back (without anything else being added to the chat),
     * we update the previous status line instead of appending new ones to avoid log spam.
     */
    private showStatus;
    private addCustomEntryToChat;
    private addMessageToChat;
    private renderSessionItems;
    /**
     * Render session entries to chat. Used for initial load and rebuild after compaction.
     * @param entries Compaction-aware session entries to render
     * @param options.updateFooter Update footer state
     * @param options.populateHistory Add user messages to editor history
     */
    private renderSessionEntries;
    private addCacheWarmingUsage;
    /**
     * Render billing usage for a compaction or branch summary. The notice is derived
     * from persisted summary usage and is not stored as a separate session entry.
     */
    private addCompactionCostNotice;
    private static countDroppedThinkingBlocks;
    private maybeShowThinkingDropNotice;
    /**
     * Show a transcript notice when a completed assistant message paid for a
     * significant cache miss. Only states observable facts: the miss itself,
     * a model switch, or an idle gap past the cache TTL.
     */
    private maybeShowCacheMissNotice;
    private addCacheMissNotice;
    renderInitialMessages(): void;
    private renderProjectTrustWarningIfNeeded;
    getUserInput(): Promise<string>;
    private rebuildChatFromMessages;
    private handleCtrlC;
    private handleCtrlD;
    /**
     * Gracefully shutdown the agent.
     * Stops the TUI before emitting shutdown events so extension UI cleanup cannot
     * repaint the final frame while the process is exiting.
     */
    private isShuttingDown;
    private shutdown;
    private emergencyTerminalExit;
    /**
     * Last-resort handler for uncaught exceptions. The TUI puts stdin into raw
     * mode and hides the cursor; without this handler, an uncaught throw from
     * anywhere (e.g. an extension's async `ChildProcess.on("exit")` callback)
     * tears down the process while leaving the terminal in raw mode with no
     * cursor, requiring `stty sane && reset` to recover.
     *
     * Unlike emergencyTerminalExit, the terminal is still alive here, so we
     * call ui.stop() to restore cooked mode, the cursor, and disable bracketed
     * paste / Kitty / modifyOtherKeys sequences.
     */
    private uncaughtCrash;
    /**
     * Check if shutdown was requested and perform shutdown if so.
     */
    private checkShutdownRequested;
    private registerSignalHandlers;
    private unregisterSignalHandlers;
    private handleCtrlZ;
    private handleFollowUp;
    private handleDequeue;
    private updateEditorBorderColor;
    private cycleThinkingLevel;
    private cycleModel;
    private toggleToolOutputExpansion;
    private setToolsExpanded;
    /** Update rendered assistant messages without rebuilding live tool components. */
    private updateThinkingBlockVisibility;
    private toggleThinkingBlockVisibility;
    private handleOpenExternalEditor;
    clearEditor(): void;
    showError(errorMessage: string): void;
    showWarning(warningMessage: string): void;
    showNewVersionNotification(release: LatestPiRelease): void;
    showPackageUpdateNotification(packages: string[]): void;
    /**
     * Get all queued messages (read-only).
     * Combines session queue and compaction queue.
     */
    private getAllQueuedMessages;
    /**
     * Clear all queued messages and return their contents.
     * Clears both session queue and compaction queue.
     */
    private clearAllQueues;
    private updatePendingMessagesDisplay;
    private restoreQueuedMessagesToEditor;
    private queueCompactionMessage;
    private isExtensionCommand;
    private flushCompactionQueue;
    /** Move pending bash components from pending area to chat */
    private flushPendingBashComponents;
    private disposeActiveSelector;
    /**
     * Shows a selector component in place of the editor.
     * @param create Factory that receives a `done` callback and returns the component and focus target
     */
    private showSelector;
    private showSettingsSelector;
    private handleThinkingCommand;
    private selectThinkingLevel;
    private showThinkingSelector;
    private handleModelCommand;
    private findExactModelMatch;
    /** Update the footer's available provider count from the current snapshot without refreshing catalogs. */
    private updateAvailableProviderCount;
    private maybeWarnAboutAnthropicSubscriptionAuth;
    private maybeSaveImplicitProjectTrustAfterReload;
    private showTrustSelector;
    private showModelSelector;
    private showModelsSelector;
    private showUserMessageSelector;
    private handleCloneCommand;
    private showTreeSelector;
    private showSessionSelector;
    private handleResumeSession;
    private getLoginProviderOptions;
    private getLogoutProviderOptions;
    private findLoginProviderOptions;
    private handleLoginCommand;
    /** `onBack` reopens the selector the login was started from when the user cancels it. */
    private startProviderLogin;
    private showLoginAuthTypeSelector;
    private showLoginProviderSelector;
    private showOAuthSelector;
    private completeProviderAuthentication;
    private showAmbientAuthDialog;
    private showApiKeyLoginDialog;
    private showAuthSelect;
    private showAuthPrompt;
    private notifyAuthDialog;
    private loginProvider;
    private showLoginDialog;
    /**
     * Offer to point the Radius MCP server in the global mcp.json at the Radius login, adding the server
     * when missing. Nothing is asked when a global server already uses this login.
     */
    private offerRadiusMcpServer;
    private handleReloadCommand;
    private handleExportCommand;
    private getPathCommandArgument;
    private handleImportCommand;
    private handleShareCommand;
    private handleBugCommand;
    private handleCopyCommand;
    private handleNameCommand;
    private handleSessionCommand;
    private handleChangelogCommand;
    /**
     * Get capitalized display string for an app keybinding action.
     */
    private getAppKeyDisplay;
    /**
     * Get capitalized display string for an editor keybinding action.
     */
    private getEditorKeyDisplay;
    private handleHotkeysCommand;
    private handleClearCommand;
    private handleDebugCommand;
    private handleArminSaysHi;
    private handleDementedDelves;
    private handleBashCommand;
    private handleCompactCommand;
    stop(fullscreenExitOutput?: FullscreenExitOutput): void;
}
//# sourceMappingURL=interactive-mode.d.ts.map