/**
 * Plays audio from a Node.js readable stream, fetch response, or `File`.
 *
 * This helper is supported only in Node.js-compatible runtimes and requires
 * the `ffplay` executable from FFmpeg to be available on `PATH`. Audio is
 * streamed to `ffplay` without first buffering the complete input.
 *
 * @param input Audio data in a format recognized by `ffplay`.
 * @throws {Error} If playback is unsupported, `ffplay` cannot start or exits
 * unsuccessfully, the response has no body, or reading the audio input fails.
 */
export declare function playAudio(input: NodeJS.ReadableStream | Response | File): Promise<void>;
/** Controls microphone selection and when an in-progress recording is finalized. */
type RecordAudioOptions = {
    /** Stops recording when aborted; successful termination returns the captured audio. */
    signal?: AbortSignal;
    /** Zero-based audio-input index (ALSA card number on Linux); defaults to `0`. */
    device?: number;
    /** Positive recording duration in milliseconds; nonpositive values disable the timeout. */
    timeout?: number;
};
/**
 * Records microphone audio into a mono, 24 kHz WAV `File` named `audio.wav`.
 *
 * This helper is supported only in Node.js-compatible runtimes and requires
 * the `ffmpeg` executable from FFmpeg to be available on `PATH`. Recording
 * continues until the FFmpeg process exits, the supplied signal is aborted, or
 * a positive timeout elapses. Successful cancellation returns the audio captured
 * so far; if sending `SIGTERM` throws, recording rejects with that error.
 *
 * @param options Audio-input device, optional abort signal, and recording timeout.
 * @returns The captured WAV file with MIME type `audio/wav`.
 * @throws {Error} If recording is unsupported, `ffmpeg` cannot start or exits
 * unsuccessfully before an intentional stop, or sending it `SIGTERM` throws.
 */
export declare function recordAudio(options?: RecordAudioOptions): Promise<File>;
export {};
//# sourceMappingURL=audio.d.ts.map