import type { AssistantMessage } from "@earendil-works/pi-ai";
import { Container, type MarkdownTheme } from "@earendil-works/pi-tui";
import type { MarkdownTransformer } from "../../../core/extensions/types.ts";
/**
 * Component that renders a complete assistant message
 */
export declare class AssistantMessageComponent extends Container {
    private contentContainer;
    private hideThinkingBlock;
    private markdownTheme;
    private hiddenThinkingLabel;
    private outputPad;
    private markdownTransformers;
    private lastMessage?;
    private hasToolCalls;
    private isStreaming;
    private thinkingVisibilityOverrides;
    constructor(message?: AssistantMessage, hideThinkingBlock?: boolean, markdownTheme?: MarkdownTheme, hiddenThinkingLabel?: string, outputPad?: number, markdownTransformers?: readonly MarkdownTransformer[]);
    invalidate(): void;
    setHideThinkingBlock(hide: boolean): void;
    setHiddenThinkingLabel(label: string): void;
    setOutputPad(padding: number): void;
    render(width: number): string[];
    updateContent(message: AssistantMessage, isStreaming?: boolean): void;
}
//# sourceMappingURL=assistant-message.d.ts.map