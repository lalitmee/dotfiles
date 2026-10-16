import { OpenAIError } from "../../core/error.mjs";
/** A local SDK/transport failure. Server error events remain unchanged in onEvent(). */
export class WebRTCError extends OpenAIError {
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
//# sourceMappingURL=errors.mjs.map