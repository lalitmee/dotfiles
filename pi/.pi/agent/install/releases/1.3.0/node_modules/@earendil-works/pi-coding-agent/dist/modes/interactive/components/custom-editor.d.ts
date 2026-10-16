import { Editor, type EditorOptions, type EditorTheme, type TUI } from "@earendil-works/pi-tui";
import type { AppKeybinding, KeybindingsManager } from "../../../core/keybindings.ts";
import type { StatusIndicator } from "./status-indicator.ts";
export type CustomEditorOptions = EditorOptions & {
    /** Render working, compaction, summarization, and retry status in the editor's top border. */
    embedWorkingStatus?: boolean;
};
/**
 * Custom editor that handles app-level keybindings for coding-agent.
 */
export declare class CustomEditor extends Editor {
    private keybindings;
    private workingStatusIndicator;
    readonly embedWorkingStatus: boolean;
    actionHandlers: Map<AppKeybinding, () => void>;
    onEscape?: () => void;
    onCtrlD?: () => void;
    onPasteImage?: () => void;
    /** Handler for extension-registered shortcuts. Returns true if handled. */
    onExtensionShortcut?: (data: string) => boolean;
    constructor(tui: TUI, theme: EditorTheme, keybindings: KeybindingsManager, options?: CustomEditorOptions);
    setWorkingStatusIndicator(indicator: StatusIndicator | undefined): void;
    protected renderTopBorder(width: number, hiddenLineCount: number): string;
    /**
     * Register a handler for an app action.
     */
    onAction(action: AppKeybinding, handler: () => void): void;
    handleInput(data: string): void;
}
//# sourceMappingURL=custom-editor.d.ts.map