import { APP_NAME } from "../config.js";
import { configureHttpDispatcher } from "../core/http-dispatcher.js";
export function setupCli() {
    process.title = APP_NAME;
    process.env.PI_CODING_AGENT = "true";
    process.env.AI_AGENT = "pi";
    process.emitWarning = (() => { });
    // Configure undici before provider SDKs issue requests. Settings are applied
    // once SettingsManager has loaded global/project configuration.
    configureHttpDispatcher();
}
//# sourceMappingURL=setup.js.map