/**
 * The `codemode` tool as an extension. The CLI loads it as a built-in extension; SDK users
 * add `createCodemodeExtension()` to their extension factories.
 *
 * `codemode` is registered inactive. Activate it with `--tools`, the `defaultTools` setting, or
 * `setActiveTools()`; the MCP extension activates it when MCP tools are only reachable from scripts.
 */
import type { ExtensionFactory } from "../../core/extensions/types.ts";
import type { CodemodeMode } from "../../core/settings-manager.ts";
export interface CodemodeExtensionOptions {
    /** Overrides the `codemode.mode` setting. */
    mode?: CodemodeMode;
    /** Overrides the `codemode.inlineBudget` setting. */
    inlineBudget?: number;
    /** Expose the model catalog and classifiers to scripts as `models`. Default: `true`. */
    models?: boolean;
}
export declare function createCodemodeExtension(options?: CodemodeExtensionOptions): ExtensionFactory;
declare const _default: ExtensionFactory;
export default _default;
//# sourceMappingURL=index.d.ts.map