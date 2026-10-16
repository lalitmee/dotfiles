import type { CredentialStore } from "@earendil-works/pi-ai";
import { ModelRuntime } from "../core/model-runtime.ts";
import type { Args } from "./args.ts";
export type AuthCheckStatus = "ready" | "not_ready" | "invalid";
export type AuthCheckReason = "provider_not_found" | "credentials_not_configured" | "credential_not_available" | "invalid_state";
export interface AuthCheckResult {
    status: AuthCheckStatus;
    provider: string;
    reason?: AuthCheckReason;
    authType?: "api_key" | "oauth";
}
export declare function checkProviderAuth(args: Args, modelRuntime: ModelRuntime, options?: {
    refresh: boolean;
}): Promise<AuthCheckResult>;
export declare function getProviderCredential(providerId: string, modelRuntime: ModelRuntime, credentials: CredentialStore, options: {
    refresh: boolean;
}): Promise<string | undefined>;
export declare function createAuthCheckModelRuntime(credentials: CredentialStore): Promise<ModelRuntime>;
//# sourceMappingURL=auth-check.d.ts.map