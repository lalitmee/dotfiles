export interface RenderLatexOptions {
    /** Stack fractions and operator limits vertically for display math (default: false). */
    display?: boolean;
}
/**
 * Render a basic LaTeX math expression as terminal-friendly Unicode text.
 * Returns undefined when the expression contains unsupported or malformed syntax.
 */
export declare function renderLatex(source: string, options?: RenderLatexOptions): string | undefined;
//# sourceMappingURL=latex.d.ts.map