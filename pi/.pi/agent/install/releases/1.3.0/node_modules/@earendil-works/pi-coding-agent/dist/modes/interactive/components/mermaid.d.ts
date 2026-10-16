import type { MarkdownTransformer } from "../../../core/extensions/types.ts";
import type { MermaidRenderingMode } from "../../../core/settings-manager.ts";
import type { Theme } from "../theme/theme.ts";
interface MermaidTransformerOptions {
    getMode: () => MermaidRenderingMode;
    theme?: Theme;
}
/** Create a transformer that replaces top-level Mermaid code blocks with Unicode terminal diagrams. */
export declare function createMermaidMarkdownTransformer(options: MermaidTransformerOptions): MarkdownTransformer;
export {};
//# sourceMappingURL=mermaid.d.ts.map