# Feature Implementation Plan: i3 First Window Assignment (Refined)

This plan has been refined to address the concern of tracking environment-specific files, such as Python virtual environments, within the dotfiles repository.

## 📋 Todo Checklist
- [x] ✅ Step 1: Update `.gitignore` to exclude virtual environments.
- [x] ✅ Step 2: Create Virtual Environment and Install Dependencies.
- [x] ✅ Step 3: Create the assignments configuration file.
- [x] ✅ Step 4: Create the Python script.
- [x] ✅ Step 5: Make the script executable.
- [x] ✅ Step 6: Modify the i3 configuration to remove the old `assign` commands.
- [x] ✅ Step 7: Add the script to i3's startup sequence.
- [x] ✅ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant files are the i3 configuration files located in `i3/.config/i3/`. The main configuration file is `i3/.config/i3/config`, which includes other files. The problematic configuration is in `i3/.config/i3/autostart/workspaces.conf`. The new script and its configuration will be stored in `i3/.config/i3/scripts/`.

### Current Architecture
The current setup uses i3's `assign` command to move all windows of a specific class to a designated workspace. This is not conditional and applies to every new window, which is the behavior the user wants to change. The refined plan makes the solution more modular by separating the assignment configuration from the script logic.

### Dependencies & Integration Points
The proposed solution will introduce a new dependency on Python 3 and the `i3ipc` library. The script will integrate with i3 through the i3 IPC socket. The Python dependencies will be managed in a virtual environment, which will be ignored by git.

### Considerations & Challenges
- The user needs to have Python 3 installed.
- The `i3ipc` library needs to be installed via pip into a virtual environment.
- The script needs to be robust and handle potential errors gracefully, especially if the JSON configuration file is missing or malformed.
- The script needs to be made executable.
- The Python virtual environment should not be tracked in the git repository.

## 📝 Implementation Plan

### Prerequisites
- Python 3 must be installed on the system.
- `pip` for Python 3 must be installed.

### Step-by-Step Implementation

1.  **Step 1: Update `.gitignore`**
    - **File to modify**: `.gitignore`
    - **Changes needed**: To avoid tracking Python virtual environments in the repository, add the following pattern to your `.gitignore` file. This keeps the repository clean from large, system-specific directories. A similar rule for `.whisper-venv/` already exists, so we will add a more generic one.
      ```gitignore
      # Python virtual environments
      **/*venv/
      ```

2.  **Step 2: Create Virtual Environment and Install Dependencies**
    - First, create a virtual environment within the `scripts` directory. This will keep the dependencies isolated from the system-wide packages.
      ```bash
      python3 -m venv i3/.config/i3/scripts/venv
      ```
    - **Note**: The `venv` directory will not be tracked by git because of the rule added to `.gitignore` in the previous step.
    - Next, use the `pip` executable from the virtual environment to install the `i3ipc` library.
      ```bash
      i3/.config/i3/scripts/venv/bin/pip install i3ipc
      ```

3.  **Step 3**: Create the assignments configuration file.
    - **File to create**: `i3/.config/i3/scripts/assignments.json`
    - **Changes needed**: Add the following JSON content to the file. This file will store the mapping of window classes to workspaces, making it easy to add or change assignments without modifying the Python script.

      ```json
      {
          "slack": "1",
          "brave-browser": "2",
          "ghostty": "3",
          "vivaldi": "4"
      }
      ```

4.  **Step 4**: Create the Python script.
    - **File to create**: `i3/.config/i3/scripts/i3-smart-assign.py`
    - **Changes needed**: Add the following Python code to the file. This script will be executed with the python interpreter from the virtual environment.

      ```python
      #!/usr/bin/env python3
      import i3ipc
      import json
      import os

      def load_assignments():
          """
          Loads assignments from the JSON file.
          """
          try:
              script_dir = os.path.dirname(os.path.realpath(__file__))
              assignments_file = os.path.join(script_dir, "assignments.json")
              with open(assignments_file, 'r') as f:
                  return {k.lower(): v for k, v in json.load(f).items()}
          except (FileNotFoundError, json.JSONDecodeError) as e:
              # You can add logging here if you want
              print(f"Error loading assignments: {e}")
              return {}

      def get_windows_by_class(i3, window_class):
          """
          Get all windows that match a given class.
          """
          windows = []
          for con in i3.get_tree().leaves():
              if con.window_class and con.window_class.lower() == window_class.lower():
                  windows.append(con)
          return windows

      def on_window_new(i3, event, assignments):
          """
          Called when a new window is opened.
          """
          window_class = event.container.window_class
          if not window_class:
              return

          window_class = window_class.lower()

          if window_class in assignments:
              # Check if there are other windows of the same class already open
              windows = get_windows_by_class(i3, window_class)
              if len(windows) == 1:
                  # This is the first window of its class, move it
                  workspace = assignments[window_class]
                  event.container.command(f'move container to workspace {workspace}')

      if __name__ == "__main__":
          i3 = i3ipc.Connection()
          assignments = load_assignments()
          
          # The lambda function is used to pass the assignments dictionary to the callback
          i3.on(i3ipc.Event.WINDOW_NEW, lambda i3, event: on_window_new(i3, event, assignments))
          
          i3.main()
      ```

5.  **Step 5**: Make the script executable.
    - Run the following command in the terminal:
      ```bash
      chmod +x i3/.config/i3/scripts/i3-smart-assign.py
      ```

6.  **Step 6**: Modify the i3 configuration to remove the old `assign` commands.
    - **File to modify**: `i3/.config/i3/autostart/workspaces.conf`
    - **Changes needed**: Comment out or remove the `assign` lines as before.

7.  **Step 7**: Add the script to i3's startup sequence.
    - **File to modify**: `i3/.config/i3/autostart/applications.conf`
    - **Changes needed**: Add the following line, ensuring you use the Python executable from the virtual environment to run the script.

      ```
      exec_always --no-startup-id $HOME/.config/i3/scripts/venv/bin/python $HOME/.config/i3/scripts/i3-smart-assign.py
      ```
      The section could look like this:
      ```
      #-------------------------------------------------------------------------------
      #  NOTE: 1. Essential system setup (early and light)
      #-------------------------------------------------------------------------------
      exec_always --no-startup-id setxkbmap -option caps:escape
      exec sxhkd
      exec --no-startup-id xset r rate 350 30
      exec --no-startup-id pulseaudio --start
      exec_always --no-startup-id $HOME/.config/i3/scripts/venv/bin/python $HOME/.config/i3/scripts/i3-smart-assign.py
      ```

### Testing Strategy
1.  After making the changes, restart i3 (`$mod+Shift+r`).
2.  Open an application that is in `assignments.json` (e.g., Slack). The first window should open on the designated workspace.
3.  Go to a different workspace.
4.  Open a second window of the same application. It should open on the current workspace, not the one defined in the script.
5.  Modify `assignments.json` to add a new application or change a workspace. Restart i3. The new behavior should be applied without changing the python script.
6.  Check that the `i3/.config/i3/scripts/venv` directory is not tracked by `git` (`git status --ignored` should show it).
7.  Check the i3 logs for any errors related to the script.

## 🎯 Success Criteria
The feature is successfully implemented when:
- The first window of a configured application opens on its designated workspace.
- Subsequent windows of the same application open on the workspace that is currently active.
- The window assignments can be modified by editing the `assignments.json` file without needing to change the Python script.
- The Python virtual environment directory (`venv`) is not tracked by git.
- The i3 session runs without any errors related to the new script.
