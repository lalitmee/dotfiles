#!/usr/bin/env python3
"""
Window Class Discovery Tool for i3
Scans all currently open windows and displays their class, title, and instance information.
Use this to find the correct window class names for workspace assignments.
"""

import i3ipc

def discover_window_classes():
    """
    Discover and display information about all currently open windows.
    """
    i3 = i3ipc.Connection()
    tree = i3.get_tree()
    
    print("=== Window Class Discovery ===\n")
    
    windows_found = []
    
    for con in tree.leaves():
        if con.window_class:
            window_info = {
                'class': con.window_class,
                'instance': con.window_instance or 'N/A',
                'title': con.name or 'N/A',
                'workspace': con.workspace().name if con.workspace() else 'N/A'
            }
            windows_found.append(window_info)
    
    if not windows_found:
        print("No windows found with window classes.")
        return
    
    # Group by class for easier analysis
    classes = {}
    for window in windows_found:
        cls = window['class']
        if cls not in classes:
            classes[cls] = []
        classes[cls].append(window)
    
    # Display results
    print(f"Found {len(windows_found)} windows with {len(classes)} unique classes:\n")
    
    for i, (cls, windows) in enumerate(classes.items(), 1):
        print(f"{i}. Class: '{cls}'")
        for j, window in enumerate(windows, 1):
            print(f"   {j}. Instance: '{window['instance']}'")
            print(f"      Title: '{window['title']}'")
            print(f"      Workspace: '{window['workspace']}'")
        print()
    
    # Show assignments.json format
    print("=== For assignments.json ===")
    print("Add these entries to your assignments.json:")
    for cls in classes.keys():
        print(f'    "{cls.lower()}": ["{cls}"],')
    print()

if __name__ == "__main__":
    discover_window_classes()