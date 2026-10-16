/**
 * System prompt construction and project context loading
 */
import { type Skill } from "./skills.ts";
export interface BuildSystemPromptOptions {
    /** Custom system prompt (replaces the default prefix). */
    customPrompt?: string;
    /** Exact full prompt replacement set by a before_agent_start handler. */
    forceSystemPrompt?: string;
    /** Tools to include in prompt. Default: [read, bash, edit, write]. */
    selectedTools?: string[];
    /**
     * Selected tools whose declarations requests leave out (`prepareLoadout` hidden declarations).
     * They are reachable only through another tool, so the tool list and rules leave them out too.
     */
    hiddenTools?: string[];
    /** Optional one-line tool snippets keyed by tool name. */
    toolSnippets?: Record<string, string>;
    /** Guideline bullets contributed by each tool, keyed by tool name. */
    toolGuidelines?: Record<string, string[]>;
    /** Additional guideline bullets appended to the default system prompt rules. */
    promptGuidelines?: string[];
    /** Text appended from user configuration before project context, skills, and cwd. */
    appendSystemPrompt?: string;
    /** Additional XML-wrapped prompt sections keyed by tag name. */
    sections?: Record<string, string>;
    /** Working directory. */
    cwd: string;
    /** Pre-loaded context files. */
    contextFiles?: Array<{
        path: string;
        content: string;
    }>;
    /** Pre-loaded skills. */
    skills?: Skill[];
}
export type NormalizedBuildSystemPromptOptions = BuildSystemPromptOptions & {
    selectedTools: string[];
    hiddenTools: string[];
    toolSnippets: Record<string, string>;
    toolGuidelines: Record<string, string[]>;
    promptGuidelines: string[];
    appendSystemPrompt: string;
    sections: Record<string, string>;
    contextFiles: Array<{
        path: string;
        content: string;
    }>;
    skills: Skill[];
};
/**
 * Ordered system prompt sections, keyed by name. `preamble` is untagged text; every other
 * section is wrapped in a tag of the same name so the model can match later updates to it.
 * These become `SystemMessage.sections` in the transcript.
 */
export type SystemPromptSections = Record<string, string>;
/** Normalize prompt input into the mutable, collection-complete shape exposed to extensions. */
export declare function normalizeBuildSystemPromptOptions(input: BuildSystemPromptOptions): NormalizedBuildSystemPromptOptions;
/** Build the ordered, independently replaceable sections of the structured system prompt. */
export declare function buildSystemPromptSections(input: BuildSystemPromptOptions): SystemPromptSections;
/**
 * The complete prompt state for `input`. A forced prompt is opaque and lives in `content`
 * with no sections; otherwise `content` is empty and the structured sections carry the prompt.
 */
export declare function buildSystemPromptState(input: BuildSystemPromptOptions): {
    content: string;
    sections?: SystemPromptSections;
};
/** Build the system prompt text, rendered exactly as the transcript's system message replays it. */
export declare function buildSystemPrompt(input: BuildSystemPromptOptions): string;
/**
 * Diff the sections the model currently has (replayed from the transcript, so never null)
 * against the desired ones. Returns a `SystemMessage.sections` patch, or undefined when
 * nothing changed.
 */
export declare function diffSystemPromptSections(previous: Record<string, string | null>, current: SystemPromptSections): Record<string, string | null> | undefined;
//# sourceMappingURL=system-prompt.d.ts.map