# Real-Time Whisper Transcription

This directory contains scripts for real-time audio transcription using Whisper. It provides a primary implementation that types dictated text into any application, and a secondary test implementation for comparison purposes.

## Features

- **Real-time dictation**: Speak and have the text typed into your active window.
- **Toggle on/off**: Easily start and stop the transcription service.
- **Customizable models**: Choose from different Whisper model sizes (`tiny`, `base`, `small`, `medium`, `large`).
- **Microphone selection**: Specify which microphone to use.
- **Desktop notifications**: Get feedback on the transcription status.

## Prerequisites

Before you begin, ensure you have the following dependencies installed:

- **`zsh`**: The scripts are written for Zsh.
- **`python`**: Python 3.8+
- **`xdotool`**: For simulating keyboard input.
- **`notify-send`**: For desktop notifications (usually part of `libnotify`).
- **PulseAudio (`pactl`)**: For audio device management.

You can typically install these on a Debian/Ubuntu system with:
```bash
sudo apt-get update && sudo apt-get install -y zsh python3 python3-pip xdotool libnotify-bin pulseaudio-utils
```

## Setup

1.  **Create a Python Virtual Environment:**
    It is highly recommended to use a virtual environment to manage Python dependencies. The scripts expect the environment to be located at `~/.venvs/whisper`.

    ```bash
    python3 -m venv ~/.venvs/whisper
    ```

2.  **Install Python Dependencies:**
    Activate the virtual environment and install the required packages from `requirements.txt`.

    ```bash
    source ~/.venvs/whisper/bin/activate
    pip install -r requirements.txt
    deactivate
    ```
    *(Note: The `requirements.txt` is in the `whisper` directory.)*

3.  **Make Scripts Executable:**
    Ensure the scripts have execute permissions. The scripts are located in `whisper/.config/bin/`.

    ```bash
    chmod +x whisper/.config/bin/whisper
    chmod +x whisper/.config/bin/whisper-start
    chmod +x whisper/.config/bin/whisper-toggle.sh
    ```

4.  **Configuration (Important for General Users):**
    The main script (`whisper`) has a hardcoded path to a helper script: `WRAPPER_SCRIPT="$HOME/dotfiles/whisper/.config/bin/whisper-start"`. If you clone this repository to a different location, you **must** update this path inside the `whisper` script to reflect the correct location on your system.

## Usage

There are two main scripts provided. The primary one is `whisper` for general use, and `whisper-toggle.sh` is for testing.

### Main Script: `whisper`

This is the main script for daily use. It captures audio, transcribes it, and types the result into the currently focused application. It's a toggle script: run it once to start, and run it again to stop.

**To run:**
```bash
/path/to/your/dotfiles/whisper/.config/bin/whisper
```
It's recommended to bind this script to a keyboard shortcut for easy access.

**Options:**

- `--model=<size>`: Specifies the Whisper model to use.
  - **Default**: `base`
  - **Options**: `tiny`, `base`, `small`, `medium`, `large`
  - **Example**: `whisper --model=small`

- `--microphone=<name>`: Specifies the PulseAudio source name for the microphone.
  - **Default**: `noise_cancelled_source`
  - You can find available source names with `pactl list sources | grep "Name:"`.
  - **Example**: `whisper --microphone=alsa_input.pci-0000_00_1f.3.analog-stereo`

- `--no-type`: If this flag is present, the script will transcribe the audio but will not type it out. This is useful if you only want to see the output in the logs.
  - **Example**: `whisper --no-type`


**Example Usage:**
```bash
# Start/stop transcription with the default base model
whisper

# Start/stop transcription with the small model
whisper --model=small

# Start/stop using a different microphone and model
whisper --microphone=alsa_input.pci-0000_00_1f.3.analog-stereo --model=small
```

### Test Script: `whisper-toggle.sh`

This script is a wrapper for a test implementation based on `davabase/whisper_real_time`. It does **not** type the output. Instead, it prints the transcription to the console and logs to `/tmp/whisper-davabase.log`. It is useful for comparing model accuracy and performance without the typing functionality.

Like the main script, this is a toggle.

**To run:**
```bash
/path/to/your/dotfiles/whisper/.config/bin/whisper-toggle.sh
```

**Options:**

- `--model=<size>`: Specifies the Whisper model.
  - **Default**: `base`
  - **Options**: `tiny`, `base`, `small`, `medium`, `large`
  - **Example**: `whisper-toggle.sh --model=medium`

- `--microphone=<name>`: Specifies the microphone input name.
  - **Default**: `pulse` (a common default for PulseAudio)
  - **Example**: `whisper-toggle.sh --microphone=alsa_input.pci-0000_00_1f.3.analog-stereo`

## How it Works

### `whisper` (Main script)
- When started, it launches a background Python process via the `whisper-start` helper script.
- This process listens to the specified microphone.
- Transcribed text is typed out using `xdotool`.
- It creates a PID file at `/tmp/whisper.pid` to manage its state.
- When run again, it reads the PID and terminates the background process.
- Debug logs are available at `/tmp/whisper_debug.log`.

### `whisper-toggle.sh` (Test script)
- This script directly runs the `transcribe_demo.py` Python script.
- It does not perform any typing.
- It uses `/tmp/whisper-davabase.pid` for state management and logs to `/tmp/whisper-davabase.log`.
