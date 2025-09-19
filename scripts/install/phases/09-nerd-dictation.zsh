#!/bin/zsh
# Phase 9: Nerd Dictation Setup
# Installs and configures the nerd-dictation speech-to-text tool.

source "$(dirname "$0")/../utils.zsh"

gum_style "🎤 Phase 9: Nerd Dictation Setup"
gum_style "Installing speech-to-text tool..."

# 1. Install System Dependencies
gum_style "Installing system dependencies..."
execute_command \
    "sudo apt-get update && sudo apt-get install -y python3-pip python3-venv portaudio19-dev sox flac xdotool wget unzip" \
    "System dependencies installed successfully." \
    "Failed to install system dependencies."

# 2. Create required directories in home folder
gum_style "Creating local directories..."
execute_command "mkdir -p ~/.venvs ~/.local/bin ~/.local/share/vosk" \
    "Local directories created successfully." \
    "Failed to create local directories."

# 3. Set up Python Virtual Environment
VENV_DIR="$HOME/.venvs/nerd-dictation"
gum_style "Setting up Python virtual environment at $VENV_DIR..."
if [ ! -d "$VENV_DIR" ]; then
    execute_command \
        "python3 -m venv $VENV_DIR" \
        "Python venv created successfully." \
        "Failed to create Python venv."
else
    gum_style "Python venv already exists."
fi

# 4. Install Python Dependencies
gum_style "Installing Python dependencies (vosk, srt)..."
execute_command \
    "$VENV_DIR/bin/pip install vosk srt" \
    "Python dependencies installed successfully." \
    "Failed to install Python dependencies."

# 5. Download and set up Vosk model
MODEL_DIR="$HOME/.local/share/vosk/model"
MODEL_URL="https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
TEMP_ZIP="/tmp/vosk-model.zip"
gum_style "Downloading Vosk language model..."
if [ ! -d "$MODEL_DIR" ]; then
    execute_command \
        "wget -O $TEMP_ZIP $MODEL_URL" \
        "Vosk model downloaded successfully." \
        "Failed to download Vosk model."

    gum_style "Extracting model..."
    # Extract and find the directory name
    unzip -o $TEMP_ZIP -d "$HOME/.local/share/vosk/"
    EXTRACTED_DIR_NAME=$(unzip -l $TEMP_ZIP | awk 'NR==4{print $4}' | cut -d'/' -f1)
    # Rename to 'model'
    if [ -n "$EXTRACTED_DIR_NAME" ] && [ -d "$HOME/.local/share/vosk/$EXTRACTED_DIR_NAME" ]; then
        mv "$HOME/.local/share/vosk/$EXTRACTED_DIR_NAME" "$MODEL_DIR"
        gum_style "Model extracted and renamed to 'model'."
    else
        gum_style "Error: Could not find extracted model directory." >&2
        exit 1
    fi
    rm $TEMP_ZIP
else
    gum_style "Vosk model directory already exists."
fi

# 6. Download nerd-dictation script
NERD_DICTATION_PATH="$HOME/.local/bin/nerd-dictation"
NERD_DICTATION_URL="https://raw.githubusercontent.com/ideasman42/nerd-dictation/main/nerd-dictation"
gum_style "Downloading nerd-dictation script..."
if [ ! -f "$NERD_DICTATION_PATH" ]; then
    execute_command \
        "wget -O $NERD_DICTATION_PATH $NERD_DICTATION_URL" \
        "nerd-dictation script downloaded successfully." \
        "Failed to download nerd-dictation script."
    execute_command \
        "chmod +x $NERD_DICTATION_PATH" \
        "nerd-dictation script made executable." \
        "Failed to make nerd-dictation script executable."
else
    gum_style "nerd-dictation script already exists."
fi

# 7. Create the 'dictate' wrapper script
DICTATE_WRAPPER_PATH="$HOME/.local/bin/dictate"
gum_style "Creating 'dictate' wrapper script..."
cat << 'EOF' > "$DICTATE_WRAPPER_PATH"
#!/bin/bash
# Wrapper script to toggle nerd-dictation

PID_FILE="/tmp/nerd-dictation.pid"
VENV_PYTHON="$HOME/.venvs/nerd-dictation/bin/python"
NERD_DICTATION_SCRIPT="$HOME/.local/bin/nerd-dictation"

# Check if the process is still running, otherwise clean up PID file
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ! ps -p "$PID" > /dev/null;
    then
        # Process is not running, remove stale PID file
        rm -f "$PID_FILE"
    fi
fi

if [ -f "$PID_FILE" ]; then
    # PID file exists, so the process should be running. Kill it.
    PID=$(cat "$PID_FILE")
    kill "$PID"
    rm -f "$PID_FILE"
    notify-send -u low -t 2000 "Dictation Stopped"
else
    # PID file does not exist. Start the process.
    # The script will run in the background.
    # We set a very long pause duration to achieve 'indefinite' listening.
    notify-send -u low -t 2000 "🎙️ Dictation Started..."
    nohup "$VENV_PYTHON" "$NERD_DICTATION_SCRIPT" --pause-duration=3600 &> /tmp/nerd-dictation.log &
    echo $! > "$PID_FILE"
fi
EOF

execute_command \
    "chmod +x $DICTATE_WRAPPER_PATH" \
    "'dictate' wrapper script created and made executable." \
    "Failed to create 'dictate' wrapper script."


gum_style "✅ Phase 9: Nerd Dictation Setup completed successfully!"
gum_style "Run 'stow nerd-dictation' and add a hotkey for '~/.local/bin/dictate' to use."
