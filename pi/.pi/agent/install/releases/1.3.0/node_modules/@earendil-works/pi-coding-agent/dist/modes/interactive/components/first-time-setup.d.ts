import { Container } from "@earendil-works/pi-tui";
export interface FirstTimeSetupResult {
    theme: string;
    shareAnalytics: boolean;
}
export interface FirstTimeSetupOptions {
    onThemePreview: (themeName: string) => void;
    onSubmit: (result: FirstTimeSetupResult) => void;
    onCancel: () => void;
}
/** First-time setup dialog: theme choice and analytics opt-in. */
export declare class FirstTimeSetupComponent extends Container {
    private step;
    private themeIndex;
    private analyticsIndex;
    private readonly options;
    constructor(options: FirstTimeSetupOptions);
    /** Rebuild on theme changes, e.g. when the system theme receives the terminal's colors. */
    invalidate(): void;
    private update;
    private addOptionList;
    private moveSelection;
    handleInput(keyData: string): void;
}
//# sourceMappingURL=first-time-setup.d.ts.map