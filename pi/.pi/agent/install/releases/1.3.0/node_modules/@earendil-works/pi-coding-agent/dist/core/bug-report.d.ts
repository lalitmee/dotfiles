import type { AgentMessage, StreamFn, ThinkingLevel } from "@earendil-works/pi-agent-core";
import { type RetryPolicy } from "@earendil-works/pi-ai";
import type { Api, Model } from "@earendil-works/pi-ai/compat";
import type { CrashRecord } from "./crash-log.ts";
import type { Extension } from "./extensions/types.ts";
import type { ModelRuntime } from "./model-runtime.ts";
import type { ReadonlySessionManager } from "./session-manager.ts";
import type { Settings } from "./settings-manager.ts";
export declare const BUG_REPORT_CUSTOM_ENTRY_TYPE = "pi.bug-report";
/** Strip credentials and secret-looking query parameters from a URL. */
export declare function redactUrl(value: string): string;
/** Copy a JSON value while removing values that may contain credentials. */
export declare function redactJsonValue(value: unknown): unknown;
interface CollectBugReportMetadataOptions {
    id?: string;
    hint?: string;
    sessionId: string;
    cwd: string;
    includeSession: boolean;
    includeSummary: boolean;
    messageCount: number;
    model?: Model<Api>;
    modelRuntime: ModelRuntime;
    thinkingLevel: ThinkingLevel;
    extensions: readonly Extension[];
    extensionErrors: ReadonlyArray<{
        path: string;
        error: string;
    }>;
    globalSettings: Settings;
    projectSettings: Settings;
}
export declare function collectBugReportMetadata(options: CollectBugReportMetadataOptions): {
    schemaVersion: number;
    id: string;
    createdAt: string;
    hint: string | null;
    environment: {
        version: string;
        userAgent: string;
        runtime: string;
        platform: NodeJS.Platform;
        arch: NodeJS.Architecture;
        osRelease: string;
        osVersion: string;
        shell: string | null;
        terminal: {
            term: string | null;
            program: string | null;
            programVersion: string | null;
            colorterm: string | null;
            tmux: boolean;
            ssh: boolean;
            ci: boolean;
        };
        piEnvironmentVariables: string[];
    };
    session: {
        id: string;
        included: boolean;
        summaryIncluded: boolean;
        messageCount: number;
        cwd?: string | undefined;
    };
    model: {
        provider: string;
        id: string;
        name: string;
        api: Api;
        baseUrl: string;
        reasoning: boolean;
        input: ("image" | "text")[];
        contextWindow: number;
        maxTokens: number;
        samplingParams: unknown;
        compat: unknown;
        thinkingLevelMap: {
            high?: string | null | undefined;
            low?: string | null | undefined;
            max?: string | null | undefined;
            medium?: string | null | undefined;
            minimal?: string | null | undefined;
            off?: string | null | undefined;
            xhigh?: string | null | undefined;
        } | null;
        headerNames: string[];
    } | null;
    provider: {
        id: string;
        name: string;
        baseUrl: string | null;
        headerNames: string[];
        authTypes: ("api_key" | "oauth")[];
        authStatus: import("./provider-composer.ts").AuthStatus;
        usingOAuth: boolean;
        registeredByExtension: boolean;
    } | null;
    thinkingLevel: ThinkingLevel;
    extensions: {
        path: string;
        source: string;
        scope: import("./source-info.ts").SourceScope;
        origin: import("./source-info.ts").SourceOrigin;
        hidden: boolean;
    }[];
    extensionErrors: {
        path: string;
        error: string;
    }[];
    settings: {
        global: Settings;
        project: Settings;
    };
};
/** Collect failed assistant turns without collecting conversation content. */
export declare function collectBugReportDiagnostics(sessionManager: ReadonlySessionManager, crashes?: readonly CrashRecord[]): {
    schemaVersion: number;
    sessionId: string;
    entryCount: number;
    assistantMessageCount: number;
    assistant: {
        entryId: string;
        timestamp: string;
        provider: string;
        model: string;
        api: Api;
        stopReason: import("@earendil-works/pi-ai").StopReason;
        rawStopReason?: string | undefined;
        errorMessage?: string | undefined;
        diagnostics: import("@earendil-works/pi-ai").AssistantMessageDiagnostic[];
    }[];
    crashes: {
        timestamp: string;
        version: string;
        kind: "uncaught_exception" | "fatal_error";
        message: string;
        stack: string | null;
        sessionFile: string | null;
        cwd: string;
    }[];
};
export type BugReportMetadata = ReturnType<typeof collectBugReportMetadata>;
export type BugReportDiagnostics = ReturnType<typeof collectBugReportDiagnostics>;
export interface BugReportBundle {
    metadata: BugReportMetadata;
    diagnostics: BugReportDiagnostics;
    sessionJsonl?: string;
    summary?: string;
}
export interface BugReportSessionEntryData {
    id: string;
    createdAt: string;
    hint: string | null;
    sessionIncluded: boolean;
    summaryIncluded: boolean;
    delivery: "zip" | "upload";
    path?: string;
}
interface BugReportFile {
    name: string;
    contentType: string;
    data: string;
}
/** Files shared by upload and zip export. */
export declare function bugReportFiles(bundle: BugReportBundle): BugReportFile[];
export declare function writeBugReportArchive(bundle: BugReportBundle, filePath: string): Promise<void>;
export declare function bugReportArchiveFileName(id: string): string;
interface GenerateBugReportSummaryOptions {
    messages: readonly AgentMessage[];
    hint?: string;
    model: Model<Api>;
    apiKey?: string;
    headers?: Record<string, string>;
    env?: Record<string, string>;
    signal: AbortSignal;
    thinkingLevel?: ThinkingLevel;
    streamFn?: StreamFn;
    retry?: RetryPolicy;
    sessionId?: string;
}
/** Ask the session model for a report when the user does not share the transcript. */
export declare function generateBugReportSummary(options: GenerateBugReportSummaryOptions): Promise<string>;
export {};
//# sourceMappingURL=bug-report.d.ts.map