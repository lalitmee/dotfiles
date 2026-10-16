"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.outputText = outputText;
/** Joins output_text blocks in content order, without filtering phase, fetching, or mutating the message. */
function outputText(message) {
    return message.content.map((block) => (block.type === 'output_text' ? block.text : '')).join('');
}
//# sourceMappingURL=output-text.js.map