"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WebRTCError = void 0;
const error_1 = require("../../core/error.js");
/** A local SDK/transport failure. Server error events remain unchanged in onEvent(). */
class WebRTCError extends error_1.OpenAIError {
    /** Creates a safe diagnostic while retaining the original cause separately. */
    constructor(code, phase, message, cause) {
        super(message);
        /** Distinguishes this error from API errors and application callback exceptions. */
        this.name = 'WebRTCError';
        this.code = code;
        this.phase = phase;
        this.cause = cause;
    }
}
exports.WebRTCError = WebRTCError;
//# sourceMappingURL=errors.js.map