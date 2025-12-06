import sys
import argparse
from faster_whisper import WhisperModel

def main():
    parser = argparse.ArgumentParser(description="Transcribe audio using faster-whisper")
    parser.add_argument("audio_file", help="Path to the audio file")
    parser.add_argument("--model", default="small.en", help="Model size (default: small.en)")
    parser.add_argument("--initial_prompt", default="", help="Initial prompt for context")
    parser.add_argument("--output_file", required=True, help="Path to save the transcription")

    args = parser.parse_args()

    # Run on CPU with INT8 quantization for speed
    model = WhisperModel(args.model, device="cpu", compute_type="int8")

    segments, info = model.transcribe(
        args.audio_file,
        initial_prompt=args.initial_prompt,
        language="en"
    )

    text = ""
    for segment in segments:
        text += segment.text + " "

    with open(args.output_file, "w") as f:
        f.write(text.strip())

if __name__ == "__main__":
    main()
