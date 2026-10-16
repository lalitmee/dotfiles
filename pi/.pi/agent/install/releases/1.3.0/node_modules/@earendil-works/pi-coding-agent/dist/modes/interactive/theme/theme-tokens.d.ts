export interface ThemeTokenDescriptor {
    slot: "foreground" | "background";
    description: string;
    fallback?: string;
}
export type ThemeTokenDescriptors = Readonly<Record<string, ThemeTokenDescriptor>>;
/** Theme token metadata in the same order used by theme files and the published JSON Schema. */
export declare const THEME_TOKENS: {
    readonly accent: {
        readonly slot: "foreground";
        readonly description: "Primary accent color (logo, selected items, cursor)";
    };
    readonly border: {
        readonly slot: "foreground";
        readonly description: "Normal borders";
    };
    readonly borderAccent: {
        readonly slot: "foreground";
        readonly description: "Highlighted borders";
    };
    readonly borderMuted: {
        readonly slot: "foreground";
        readonly description: "Subtle borders";
    };
    readonly success: {
        readonly slot: "foreground";
        readonly description: "Success states";
    };
    readonly error: {
        readonly slot: "foreground";
        readonly description: "Error states";
    };
    readonly warning: {
        readonly slot: "foreground";
        readonly description: "Warning states";
    };
    readonly muted: {
        readonly slot: "foreground";
        readonly description: "Secondary/dimmed text";
    };
    readonly dim: {
        readonly slot: "foreground";
        readonly description: "Very dimmed text (more subtle than muted)";
    };
    readonly text: {
        readonly slot: "foreground";
        readonly description: "Default text color (usually empty string)";
    };
    readonly thinkingText: {
        readonly slot: "foreground";
        readonly description: "Thinking block text color";
    };
    readonly scrollbarTrack: {
        readonly slot: "foreground";
        readonly description: "Fullscreen scrollbar track foreground (falls back to muted when omitted)";
        readonly fallback: "muted";
    };
    readonly scrollbarThumb: {
        readonly slot: "foreground";
        readonly description: "Fullscreen scrollbar thumb foreground (falls back to text when omitted)";
        readonly fallback: "text";
    };
    readonly selectedBg: {
        readonly slot: "background";
        readonly description: "Selected item background";
    };
    readonly searchMatchBg: {
        readonly slot: "background";
        readonly description: "Transcript search match background and current-match text (falls back to selectedBg when omitted)";
        readonly fallback: "selectedBg";
    };
    readonly searchMatchText: {
        readonly slot: "foreground";
        readonly description: "Transcript search match text and current-match background (falls back to text when omitted)";
        readonly fallback: "text";
    };
    readonly userMessageBg: {
        readonly slot: "background";
        readonly description: "User message background";
    };
    readonly userMessageText: {
        readonly slot: "foreground";
        readonly description: "User message text color";
    };
    readonly customMessageBg: {
        readonly slot: "background";
        readonly description: "Custom message background (hook-injected messages)";
    };
    readonly customMessageText: {
        readonly slot: "foreground";
        readonly description: "Custom message text color";
    };
    readonly customMessageLabel: {
        readonly slot: "foreground";
        readonly description: "Custom message type label color";
    };
    readonly toolPendingBg: {
        readonly slot: "background";
        readonly description: "Tool execution box (pending state)";
    };
    readonly toolSuccessBg: {
        readonly slot: "background";
        readonly description: "Tool execution box (success state)";
    };
    readonly toolErrorBg: {
        readonly slot: "background";
        readonly description: "Tool execution box (error state)";
    };
    readonly toolTitle: {
        readonly slot: "foreground";
        readonly description: "Tool execution box title color";
    };
    readonly toolOutput: {
        readonly slot: "foreground";
        readonly description: "Tool execution box output text color";
    };
    readonly mdHeading: {
        readonly slot: "foreground";
        readonly description: "Markdown heading text";
    };
    readonly mdLink: {
        readonly slot: "foreground";
        readonly description: "Markdown link text";
    };
    readonly mdLinkUrl: {
        readonly slot: "foreground";
        readonly description: "Markdown link URL";
    };
    readonly mdCode: {
        readonly slot: "foreground";
        readonly description: "Markdown inline code";
    };
    readonly mdCodeBlock: {
        readonly slot: "foreground";
        readonly description: "Markdown code block content";
    };
    readonly mdCodeBlockBorder: {
        readonly slot: "foreground";
        readonly description: "Markdown code block fences";
    };
    readonly mdQuote: {
        readonly slot: "foreground";
        readonly description: "Markdown blockquote text";
    };
    readonly mdQuoteBorder: {
        readonly slot: "foreground";
        readonly description: "Markdown blockquote border";
    };
    readonly mdHr: {
        readonly slot: "foreground";
        readonly description: "Markdown horizontal rule";
    };
    readonly mdListBullet: {
        readonly slot: "foreground";
        readonly description: "Markdown list bullets/numbers";
    };
    readonly toolDiffAdded: {
        readonly slot: "foreground";
        readonly description: "Added lines in tool diffs";
    };
    readonly toolDiffRemoved: {
        readonly slot: "foreground";
        readonly description: "Removed lines in tool diffs";
    };
    readonly toolDiffContext: {
        readonly slot: "foreground";
        readonly description: "Context lines in tool diffs";
    };
    readonly syntaxComment: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: comments";
    };
    readonly syntaxKeyword: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: keywords";
    };
    readonly syntaxFunction: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: function names";
    };
    readonly syntaxVariable: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: variable names";
    };
    readonly syntaxString: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: string literals";
    };
    readonly syntaxNumber: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: number literals";
    };
    readonly syntaxType: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: type names";
    };
    readonly syntaxOperator: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: operators";
    };
    readonly syntaxPunctuation: {
        readonly slot: "foreground";
        readonly description: "Syntax highlighting: punctuation";
    };
    readonly thinkingOff: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: off";
    };
    readonly thinkingMinimal: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: minimal";
    };
    readonly thinkingLow: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: low";
    };
    readonly thinkingMedium: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: medium";
    };
    readonly thinkingHigh: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: high";
    };
    readonly thinkingXhigh: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: xhigh";
    };
    readonly thinkingMax: {
        readonly slot: "foreground";
        readonly description: "Thinking level border: max (falls back to thinkingXhigh when omitted)";
        readonly fallback: "thinkingXhigh";
    };
    readonly bashMode: {
        readonly slot: "foreground";
        readonly description: "Editor border color in bash mode";
    };
};
export type ThemeToken = keyof typeof THEME_TOKENS;
export type ThemeColor = {
    [K in ThemeToken]: (typeof THEME_TOKENS)[K]["slot"] extends "foreground" ? K : never;
}[ThemeToken];
export type ThemeBg = Exclude<ThemeToken, ThemeColor>;
type OptionalToken = {
    [K in ThemeToken]: (typeof THEME_TOKENS)[K] extends {
        fallback: string;
    } ? K : never;
}[ThemeToken];
type RequiredToken = Exclude<ThemeToken, OptionalToken>;
export type ThemeColorValues<Value> = {
    [K in RequiredToken]: Value;
} & {
    [K in OptionalToken]?: Value;
};
export type ResolvedThemeColorValues<Value> = Record<ThemeToken, Value>;
export {};
//# sourceMappingURL=theme-tokens.d.ts.map