/**
 * CLI argument parsing and help display
 */
import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import type { ExtensionFlag } from "../core/extensions/types.ts";
import { type TuiMode } from "../core/settings-manager.ts";
export type Mode = "text" | "json" | "rpc";
export interface Args {
    provider?: string;
    model?: string;
    apiKey?: string;
    systemPrompt?: string;
    appendSystemPrompt?: string[];
    thinking?: ThinkingLevel;
    continue?: boolean;
    resume?: boolean;
    help?: boolean;
    version?: boolean;
    mode?: Mode;
    name?: string;
    noSession?: boolean;
    session?: string;
    sessionId?: string;
    fork?: string;
    sessionDir?: string;
    models?: string[];
    tools?: string[];
    excludeTools?: string[];
    noTools?: boolean;
    noBuiltinTools?: boolean;
    extensions?: string[];
    noExtensions?: boolean;
    noMcp?: boolean;
    print?: boolean;
    export?: string;
    noSkills?: boolean;
    skills?: string[];
    promptTemplates?: string[];
    noPromptTemplates?: boolean;
    themes?: string[];
    useTheme?: string;
    noThemes?: boolean;
    noContextFiles?: boolean;
    listModels?: string | true;
    offline?: boolean;
    tuiMode?: TuiMode;
    verbose?: boolean;
    projectTrustOverride?: boolean;
    messages: string[];
    fileArgs: string[];
    /** Unknown flags (potentially extension flags) - map of flag name to value */
    unknownFlags: Map<string, boolean | string>;
    diagnostics: Array<{
        type: "warning" | "error";
        message: string;
    }>;
}
export declare function isValidThinkingLevel(level: string): level is ThinkingLevel;
export declare function normalizeSessionName(value: string): string | undefined;
export declare function parseArgs(args: string[]): Args;
export declare function printHelp(extensionFlags?: ExtensionFlag[]): void;
//# sourceMappingURL=args.d.ts.map