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
