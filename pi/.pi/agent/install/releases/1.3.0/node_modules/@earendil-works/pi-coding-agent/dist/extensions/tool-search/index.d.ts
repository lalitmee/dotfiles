/**
 * The `tool_search` tool as an extension. The CLI loads it as a built-in extension; SDK users add
 * `createToolSearchExtension()` to their extension factories.
 *
 * `tool_search` is registered inactive. Activate it with `--tools`, the `defaultTools` setting, or
 * `setActiveTools()`.
 */
import type { ExtensionFactory } from "../../core/extensions/types.ts";
export declare function createToolSearchExtension(): ExtensionFactory;
declare const _default: ExtensionFactory;
export default _default;
//# sourceMappingURL=index.d.ts.map