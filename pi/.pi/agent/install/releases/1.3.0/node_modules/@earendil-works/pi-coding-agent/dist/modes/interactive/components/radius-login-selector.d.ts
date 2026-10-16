/**
 * The `/login` menu with the animated "Sign in with Radius" option. Internal to the interactive mode: the shimmer
 * is Radius-only and is not exposed to other selectors.
 */
import { type TUI } from "@earendil-works/pi-tui";
import { ExtensionSelectorComponent } from "./extension-selector.ts";
/** The "Sign in with Radius" option: `label` is the full option, starting with the animated `text`. */
type RadiusOption = {
    label: string;
    text: string;
};
/** Top-level `/login` selector whose Radius option shimmers in the Radius logo colors while it is selected. */
export declare function createLoginMenuSelector(tui: TUI, title: string, options: string[], radiusOption: RadiusOption, onSelect: (option: string) => void, onCancel: () => void): ExtensionSelectorComponent;
export {};
//# sourceMappingURL=radius-login-selector.d.ts.map