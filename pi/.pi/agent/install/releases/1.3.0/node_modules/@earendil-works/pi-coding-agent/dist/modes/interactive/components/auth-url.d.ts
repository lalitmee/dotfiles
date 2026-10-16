import { Container, type TUI } from "@earendil-works/pi-tui";
/**
 * A sign-in URL with a click hint and a copy hint. Hosts call `copy()` when `app.message.copy` is
 * pressed, since a long URL wraps and often cannot be selected or clicked as a whole (SSH, tmux).
 */
export declare class AuthUrlComponent extends Container {
    readonly url: string;
    private readonly tui;
    private readonly hint;
    constructor(tui: TUI, url: string);
    private setHint;
    copy(): Promise<void>;
}
//# sourceMappingURL=auth-url.d.ts.map