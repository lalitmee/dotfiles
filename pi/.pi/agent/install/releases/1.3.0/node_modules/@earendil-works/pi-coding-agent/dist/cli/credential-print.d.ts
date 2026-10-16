import type { ModelRuntime } from "../core/model-runtime.ts";
import type { Args } from "./args.ts";
import { type AuthCommandKind } from "./auth-command.ts";
type CredentialPrintKind = Exclude<AuthCommandKind, "check">;
/**
 * Resolve one configured provider credential.
 *
 * This intentionally calls ModelRuntime.getAuth(), which refreshes and persists
 * OAuth credentials with less than five minutes remaining through the normal request-auth path.
 */
export declare function resolveCredentialForPrint(args: Args, modelRuntime: ModelRuntime, kind: CredentialPrintKind, minExpiryMs?: number, signal?: AbortSignal): Promise<string>;
export {};
//# sourceMappingURL=credential-print.d.ts.map