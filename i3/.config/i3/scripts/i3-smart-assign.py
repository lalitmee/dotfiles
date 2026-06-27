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

def get_windows_by_class(i3, assignment_data):
    """
    Get all windows that match the class names or instance names in assignment_data.
    """
    windows = []
    
    # Extract class names and instance names from assignment_data
    class_names = []
    instance_names = []
    
    if isinstance(assignment_data, dict) and ('classes' in assignment_data or 'instances' in assignment_data):
        class_names = assignment_data.get('classes', [])
        instance_names = assignment_data.get('instances', [])
    elif isinstance(assignment_data, list):
        class_names = assignment_data
    else:
        class_names = [assignment_data]
    
    for con in i3.get_tree().leaves():
        if con.window_class and class_names:
            window_class_lower = con.window_class.lower()
            for class_name in class_names:
                if isinstance(class_name, str) and window_class_lower == class_name.lower():
                    windows.append(con)
                    break
        elif con.window_instance and instance_names:
            window_instance_lower = con.window_instance.lower()
            for instance_name in instance_names:
                if isinstance(instance_name, str) and window_instance_lower == instance_name.lower():
                    windows.append(con)
                    break
    return windows

def find_matching_assignment(window_class, window_instance, assignments):
    """
    Find which assignment key matches the given window class or window instance.
    Instance matching is prioritized over class matching.
    Returns (assignment_key, assignment_data) or (None, None).
    """
    window_class_lower = window_class.lower() if window_class else ""
    window_instance_lower = window_instance.lower() if window_instance else ""
    
    # 1. Prioritize instance matching
    if window_instance_lower:
        for assignment_key, assignment_data in assignments.items():
            if isinstance(assignment_data, dict) and 'instances' in assignment_data:
                for instance_name in assignment_data['instances']:
                    if window_instance_lower == instance_name.lower():
                        return assignment_key, assignment_data
                        
    # Special rule: If it's a Brave/Chrome PWA (starts with 'crx_') and didn't match any instance assignment,
    # do NOT fall back to matching its general browser class.
    if window_instance_lower.startswith('crx_'):
        return None, None
        
    # 2. Fallback to class matching
    if window_class_lower:
        for assignment_key, assignment_data in assignments.items():
            if isinstance(assignment_data, dict) and 'classes' in assignment_data:
                for class_name in assignment_data['classes']:
                    if window_class_lower == class_name.lower():
                        return assignment_key, assignment_data
            elif isinstance(assignment_data, list):
                for class_name in assignment_data:
                    if window_class_lower == class_name.lower():
                        return assignment_key, assignment_data
            elif isinstance(assignment_data, str):
                if window_class_lower == assignment_data.lower():
                    return assignment_key, [assignment_data]
    
    return None, None

def on_window_new(i3, event, assignments):
    """
    Called when a new window is opened.
    """
    window_class = event.container.window_class
    window_title = event.container.name
    window_instance = event.container.window_instance
    
    if not window_class:
        logger.debug(f"Window without class detected: {window_title}")
        return

    logger.info(f"New window: class='{window_class}', instance='{window_instance}', title='{window_title}'")
    
    # Find matching assignment
    assignment_key, assignment_data = find_matching_assignment(window_class, window_instance, assignments)
    
    if assignment_key:
        logger.info(f"Found assignment: '{assignment_key}' matches class '{window_class}'")
        
        # Check if there are other windows of the same class already open
        windows = get_windows_by_class(i3, assignment_data)
        logger.debug(f"Found {len(windows)} windows for class '{window_class}'")
        
        # Fix: Count windows BEFORE the current one is added
        # We need to exclude the current window from the count
        existing_windows = [w for w in windows if w.id != event.container.id]
        
        if len(existing_windows) == 0:
            # This is the first window of its class, move it
            if isinstance(assignment_data, dict) and 'workspace' in assignment_data:
                workspace = assignment_data['workspace']
            else:
                # Fallback for old format
                workspace = assignment_key
            
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
