import type { AgentSessionRuntimeDiagnostic } from "./agent-session-services.ts";
import type { SettingsManager } from "./settings-manager.ts";
export declare function collectSettingsDiagnostics(settingsManager: SettingsManager): AgentSessionRuntimeDiagnostic[];
/**
 * Remove duplicate type/message diagnostics while preserving their first occurrence.
 * Startup and runtime settings managers can report the same file error.
 */
export declare function deduplicateDiagnostics(diagnostics: readonly AgentSessionRuntimeDiagnostic[]): AgentSessionRuntimeDiagnostic[];
//# sourceMappingURL=settings-diagnostics.d.ts.map