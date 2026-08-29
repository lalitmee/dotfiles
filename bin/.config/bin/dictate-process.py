import sys
import re
import argparse
from faster_whisper import WhisperModel

FILLERS_RE = re.compile(r"\b(?:um+|uh+|uhh+|umm+|hmm+|er+|eh+|ah+)\b", re.IGNORECASE)
DUP_RE = re.compile(r"\b(the|that|and|to|i|a|an|it|is|of|for|you|in|we|my|so|this|there)\b\s+\1\b", re.IGNORECASE)


def clean_text(text):
    text = FILLERS_RE.sub(" ", text)
    for _ in range(3):
        new = DUP_RE.sub(r"\1", text)
        if new == text:
            break
        text = new
    return re.sub(r"\s+", " ", text).strip()


def main():
    parser = argparse.ArgumentParser(description="Transcribe audio using faster-whisper")
    parser.add_argument("audio_file", help="Path to the audio file")
    parser.add_argument("--model", default="medium", help="Model size (default: medium)")
    parser.add_argument("--initial_prompt", default="", help="Initial prompt for context")
    parser.add_argument("--output_file", required=True, help="Path to save the transcription")

    args = parser.parse_args()

    # Run on CPU with INT8 quantization for speed
    model = WhisperModel(args.model, device="cpu", compute_type="int8")

    segments, info = model.transcribe(
        args.audio_file,
        initial_prompt=args.initial_prompt,
        language="en",
        vad_filter=True,
        condition_on_previous_text=False
    )

    text = ""
    for segment in segments:
        text += segment.text + " "

    with open(args.output_file, "w") as f:
        f.write(clean_text(text))

if __name__ == "__main__":
    main()
