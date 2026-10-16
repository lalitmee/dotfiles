import type { Container, EditorComponent, TUI } from "@earendil-works/pi-tui";
import type { AgentSession } from "../../core/agent-session.ts";
import type { KeybindingsManager } from "../../core/keybindings.ts";
interface BugReportContext {
    session: AgentSession;
    ui: TUI;
    editorContainer: Container;
    editor: EditorComponent;
    keybindings: KeybindingsManager;
    showStatus: (message: string) => void;
    showError: (message: string) => void;
}
/** Run the `/bug` flow: consent, optional summary, then upload or export. */
export declare function reportBug(context: BugReportContext, initialHint?: string): Promise<void>;
export {};
//# sourceMappingURL=bug-report.d.ts.map