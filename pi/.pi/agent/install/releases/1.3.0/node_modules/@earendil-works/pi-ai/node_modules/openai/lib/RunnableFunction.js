"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParsingToolFunction = void 0;
exports.isRunnableFunctionWithParse = isRunnableFunctionWithParse;
/** Returns whether a runnable function provides a parser for its raw argument string. */
function isRunnableFunctionWithParse(fn) {
    return typeof fn.parse === 'function';
}
/**
 * This is helper class for passing a `function` and `parse` where the `function`
 * argument type matches the `parse` return type.
 */
class ParsingToolFunction {
    /** Wraps a parsed-argument function definition in the function-tool shape. */
    constructor(input) {
        /** Identifies the wrapped tool as a callable function. */
        this.type = 'function';
        this.function = input;
    }
}
exports.ParsingToolFunction = ParsingToolFunction;
//# sourceMappingURL=RunnableFunction.js.map