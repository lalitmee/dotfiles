#!/usr/bin/env python3
import i3ipc
import json
import os
import logging
import datetime

def setup_logging():
    """
    Setup logging to both console and file.
    """
    log_file = "/tmp/i3-smart-assign.log"
    
    # Configure logging
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file),
            logging.StreamHandler()
        ]
    )
    
    return logging.getLogger(__name__)

def load_assignments():
    """
    Loads assignments from the JSON file.
    """
    try:
        script_dir = os.path.dirname(os.path.realpath(__file__))
        assignments_file = os.path.join(script_dir, "assignments.json")
        with open(assignments_file, 'r') as f:
            assignments = json.load(f)
            logger.info(f"Loaded assignments: {assignments}")
            return assignments
    except (FileNotFoundError, json.JSONDecodeError) as e:
        logger.error(f"Error loading assignments: {e}")
        return {}

def get_windows_by_class(i3, class_names):
    """
    Get all windows that match any of the given class names.
    """
    windows = []
    for con in i3.get_tree().leaves():
        if con.window_class:
            window_class_lower = con.window_class.lower()
            for class_name in class_names:
                if window_class_lower == class_name.lower():
                    windows.append(con)
                    break
    return windows

def find_matching_assignment(window_class, assignments):
    """
    Find which assignment key matches the given window class.
    Returns (assignment_key, workspace) or (None, None).
    """
    window_class_lower = window_class.lower()
    
    for assignment_key, class_names in assignments.items():
        if isinstance(class_names, list):
            for class_name in class_names:
                if window_class_lower == class_name.lower():
                    return assignment_key, class_names
        else:
            # Handle old format (string)
            if window_class_lower == class_names.lower():
                return assignment_key, [class_names]
    
    return None, None

def on_window_new(i3, event, assignments):
    """
    Called when a new window is opened.
    """
    window_class = event.container.window_class
    window_title = event.container.name
    
    if not window_class:
        logger.debug(f"Window without class detected: {window_title}")
        return

    logger.info(f"New window: class='{window_class}', title='{window_title}'")
    
    # Find matching assignment
    assignment_key, class_names = find_matching_assignment(window_class, assignments)
    
    if assignment_key:
        logger.info(f"Found assignment: '{assignment_key}' matches class '{window_class}'")
        
        # Check if there are other windows of the same class already open
        windows = get_windows_by_class(i3, class_names)
        logger.debug(f"Found {len(windows)} windows for class '{window_class}'")
        
        # Fix: Count windows BEFORE the current one is added
        # We need to exclude the current window from the count
        existing_windows = [w for w in windows if w.id != event.container.id]
        
        if len(existing_windows) == 0:
            # This is the first window of its class, move it
            workspace = assignments[assignment_key]
            if isinstance(workspace, list):
                workspace = workspace[0]  # Take first workspace if it's a list
            
            logger.info(f"Moving first '{window_class}' window to workspace '{workspace}'")
            try:
                event.container.command(f'move container to workspace {workspace}')
                logger.info(f"Successfully moved '{window_class}' to workspace '{workspace}'")
            except Exception as e:
                logger.error(f"Failed to move '{window_class}' to workspace '{workspace}': {e}")
        else:
            logger.info(f"Additional '{window_class}' window (count: {len(existing_windows)+1}), not moving")
    else:
        logger.debug(f"No assignment found for class '{window_class}'")

if __name__ == "__main__":
    # Setup logging first
    logger = setup_logging()
    logger.info("=== i3 Smart Assign Script Started ===")
    
    # Load assignments
    assignments = load_assignments()
    
    if not assignments:
        logger.error("No assignments loaded, exiting")
        exit(1)
    
    # Setup i3 connection
    try:
        i3 = i3ipc.Connection()
        logger.info("Connected to i3 successfully")
    except Exception as e:
        logger.error(f"Failed to connect to i3: {e}")
        exit(1)

    # The lambda function is used to pass the assignments dictionary to the callback
    i3.on(i3ipc.Event.WINDOW_NEW, lambda i3, event: on_window_new(i3, event, assignments))
    
    logger.info("Listening for window events...")
    i3.main()
