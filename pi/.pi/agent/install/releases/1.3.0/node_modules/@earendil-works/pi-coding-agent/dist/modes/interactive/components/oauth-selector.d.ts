import type { ApiKeyAuth, AuthCheck, OAuthAuth } from "@earendil-works/pi-ai";
import { Container, type Focusable } from "@earendil-works/pi-tui";
export type AuthSelectorProvider = {
    id: string;
    name: string;
    authType: "oauth" | "api_key";
    method?: ApiKeyAuth | OAuthAuth;
    status?: AuthCheck;
    /**
     * Whether the provider's OAuth sign-in is backed by a subscription. `false` labels it as an account;
     * unset keeps the "subscription" label.
     */
    subscription?: boolean;
};
export declare function formatAuthSelectorProviderType(authType: AuthSelectorProvider["authType"], subscription?: boolean): string;
/** Themed suffix describing whether and how a login option is configured, for example " ✓ configured". */
export declare function formatAuthSelectorProviderStatus(provider: AuthSelectorProvider): string;
/**
 * Component that renders an auth provider selector
 */
export declare class OAuthSelectorComponent extends Container implements Focusable {
    private searchInput;
    private _focused;
    get focused(): boolean;
    set focused(value: boolean);
    private listContainer;
    private allProviders;
    private filteredProviders;
    private selectedIndex;
    private mode;
    private onSelectCallback;
    private onCancelCallback;
    private showAuthTypeLabels;
    constructor(mode: "login" | "logout", providers: AuthSelectorProvider[], onSelect: (providerId: string, authType: AuthSelectorProvider["authType"]) => void, onCancel: () => void, initialSearchInput?: string);
    private filterProviders;
    private updateList;
    handleInput(keyData: string): void;
}
//# sourceMappingURL=oauth-selector.d.ts.map