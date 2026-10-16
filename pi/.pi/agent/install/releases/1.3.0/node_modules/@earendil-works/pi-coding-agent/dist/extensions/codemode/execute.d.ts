/**
 * Runs one codemode script in the sandbox. Split from tool.ts and loaded through
 * execute.lazy.ts so the sandbox runtime only loads when a script runs.
 */
import type { AgentToolResult } from "@earendil-works/pi-agent-core";
import type { ExtensionToolContext } from "../../core/extensions/types.ts";
import type { SessionEntry } from "../../core/session-manager.ts";
import { type CodemodeToolDetails, type CodemodeToolInput, type CodemodeToolOptions } from "./tool.ts";
/** Values of `load()`: the `codemode-store` entries on the branch, applied from the root. */
export declare function readCodemodeStore(branch: readonly SessionEntry[]): Record<string, unknown>;
/**
 * Run one script. Without a session context (a plain Agent or a direct call) scripts cannot call
 * tools, `store()` starts empty, and writes are dropped.
 */
export declare function executeCodemode(toolCallId: string, input: CodemodeToolInput, signal: AbortSignal | undefined, onUpdate: ((result: AgentToolResult<CodemodeToolDetails>) => void) | undefined, ctx: ExtensionToolContext | undefined, options?: CodemodeToolOptions): Promise<AgentToolResult<CodemodeToolDetails>>;
//# sourceMappingURL=execute.d.ts.map