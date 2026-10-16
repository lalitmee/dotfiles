"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createCanonicalResponseContext = createCanonicalResponseContext;
exports.getOutputText = getOutputText;
exports.ensureCanonicalOutputText = ensureCanonicalOutputText;
exports.cloneResponse = cloneResponse;
exports.updateCachedOutputTextLength = updateCachedOutputTextLength;
exports.updateOutputText = updateOutputText;
const output_text_index_1 = require("./output-text-index.js");
function createCanonicalResponseContext() {
    return {
        canonicalSnapshot: undefined,
        outputTextLengths: new WeakMap(),
        outputTextIndex: new output_text_index_1.OutputTextIndex(),
    };
}
function getOutputText(context, output) {
    if (output.type !== 'message') {
        return '';
    }
    let text = '';
    for (const content of output.content) {
        if (content.type === 'output_text') {
            text += content.text;
        }
    }
    context.outputTextLengths.set(output, text.length);
    return text;
}
function ensureCanonicalOutputText(context, snapshot) {
    if (context.canonicalSnapshot === snapshot) {
        return;
    }
    const outputTextIndex = new output_text_index_1.OutputTextIndex();
    let text = '';
    for (const output of snapshot.output) {
        const outputText = getOutputText(context, output);
        text += outputText;
        outputTextIndex.append(outputText.length);
    }
    // Comparing independently accumulated strings can scan all preceding text on
    // every delta. The recount is authoritative, so assign it without comparing.
    snapshot.output_text = text;
    context.outputTextIndex = outputTextIndex;
    context.canonicalSnapshot = snapshot;
}
function cloneResponse(context, response) {
    context.canonicalSnapshot = undefined;
    context.outputTextLengths = new WeakMap();
    context.outputTextIndex = new output_text_index_1.OutputTextIndex();
    const snapshot = structuredClone(response);
    if (!Object.getOwnPropertyDescriptor(snapshot, 'output_text') ||
        snapshot.output_text === null ||
        snapshot.output_text === undefined) {
        ensureCanonicalOutputText(context, snapshot);
    }
    else if (snapshot.output.length === 0 && snapshot.output_text === '') {
        context.canonicalSnapshot = snapshot;
    }
    return snapshot;
}
function updateCachedOutputTextLength(context, output, outputIndex, previousText, nextText) {
    const length = context.outputTextLengths.get(output);
    if (length !== undefined) {
        const nextLength = length - previousText.length + nextText.length;
        context.outputTextLengths.set(output, nextLength);
        context.outputTextIndex.update(outputIndex, nextLength);
    }
}
function replaceOutputTextSuffix(snapshot, previousText, nextText) {
    if (previousText.length === 0) {
        snapshot.output_text += nextText;
        return;
    }
    snapshot.output_text =
        snapshot.output_text.slice(0, snapshot.output_text.length - previousText.length) + nextText;
}
function getPrecedingContentTextLength(context, output, contentIndex, nextText) {
    if (contentIndex === undefined || output?.type !== 'message') {
        return 0;
    }
    if (contentIndex < output.content.length - contentIndex - 1) {
        let precedingContentLength = 0;
        for (let index = 0; index < contentIndex; index += 1) {
            const precedingContent = output.content[index];
            if (precedingContent?.type === 'output_text') {
                precedingContentLength += precedingContent.text.length;
            }
        }
        return precedingContentLength;
    }
    let followingContentLength = 0;
    for (let index = contentIndex + 1; index < output.content.length; index += 1) {
        const followingContent = output.content[index];
        if (followingContent?.type === 'output_text') {
            followingContentLength += followingContent.text.length;
        }
    }
    const outputTextLength = context.outputTextLengths.get(output) ?? getOutputText(context, output).length;
    return outputTextLength - followingContentLength - nextText.length;
}
function updateOutputText(context, snapshot, outputIndex, previousText, nextText, contentIndex) {
    if (previousText === nextText) {
        return;
    }
    const output = snapshot.output[outputIndex];
    if (outputIndex === snapshot.output.length - 1 &&
        (contentIndex === undefined || (output?.type === 'message' && contentIndex === output.content.length - 1))) {
        replaceOutputTextSuffix(snapshot, previousText, nextText);
        return;
    }
    const precedingContentLength = getPrecedingContentTextLength(context, output, contentIndex, nextText);
    const offset = context.outputTextIndex.prefixSum(outputIndex) + precedingContentLength;
    if (offset + previousText.length === snapshot.output_text.length) {
        replaceOutputTextSuffix(snapshot, previousText, nextText);
        return;
    }
    snapshot.output_text =
        snapshot.output_text.slice(0, offset) +
            nextText +
            snapshot.output_text.slice(offset + previousText.length);
}
//# sourceMappingURL=canonical-output-text.js.map