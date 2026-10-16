import type { AuthResult } from "@earendil-works/pi-ai";
import type { Args } from "./args.ts";
export type AuthCommandKind = "check" | "api_key" | "bearer_token";
export interface AuthCommand {
    kind: AuthCommandKind;
    args: string[];
    json: boolean;
    credentials: boolean;
    noRefresh: boolean;
    minExpiryMs?: number;
}
export declare class AuthCommandError extends Error {
}
export declare function getAuthCommandName(kind: AuthCommandKind): string;
export declare function getAuthCommandUsage(kind: AuthCommandKind): string;
export declare function isAuthCommandHelp(args: string[]): boolean;
export declare function printAuthCommandHelp(): void;
export declare function parseAuthCommand(args: string[]): AuthCommand | undefined;
export declare function validateAuthCommandArgs(args: Args, kind: AuthCommandKind): {
    provider?: string;
    model?: string;
};
export declare function getAuthCredential(auth: AuthResult | undefined): string | undefined;
//# sourceMappingURL=auth-command.d.ts.map