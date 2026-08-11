#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import math
import i3ipc

STATE_FILE = "/tmp/i3_scratchpad_overview_state.json"
OVERVIEW_WORKSPACE = "Scratchpads"

def is_scratchpad_window(con):
    p = con.parent
    while p:
        if p.scratchpad_state != "none":
            return True
        p = p.parent
    return False

def get_scratchpad_windows(i3):
    return [con for con in i3.get_tree().leaves() if is_scratchpad_window(con)]

def distribute_windows(windows):
    n = len(windows)
    if n == 0:
        return []
    c = math.ceil(math.sqrt(n))
    base_size = n // c
    remainder = n % c
    cols = []
    idx = 0
    for i in range(c):
        size = base_size + (1 if i < remainder else 0)
        cols.append(windows[idx : idx + size])
        idx += size
    return cols

def main():
    i3 = i3ipc.Connection()
    
    if os.path.exists(STATE_FILE):
        # Toggle OFF: Restore scratchpads and return to original workspace
        try:
            with open(STATE_FILE, "r") as f:
                state = json.load(f)
            original_workspace = state.get("original_workspace")
            window_ids = state.get("window_ids", [])
            
            # Find currently existing windows in the tree to avoid stale IDs
            current_ids = {con.id for con in i3.get_tree().leaves()}
            
            # Move all saved scratchpad windows back to the scratchpad
            for win_id in window_ids:
                if win_id in current_ids:
                    i3.command(f"[con_id={win_id}] move scratchpad")
            
            # Switch back to the original workspace
            if original_workspace:
                i3.command(f"workspace \"{original_workspace}\"")
                
        except Exception as e:
            subprocess.run(["notify-send", "Scratchpad Overview Error", str(e)])
        finally:
            if os.path.exists(STATE_FILE):
                os.remove(STATE_FILE)
    else:
        # Toggle ON: Bring all scratchpads to the overview workspace in a balanced grid layout
        scratch_windows = get_scratchpad_windows(i3)
        if not scratch_windows:
            subprocess.run([
                "notify-send",
                "Scratchpad Overview",
                "No scratchpad windows are currently running.",
                "-t", "2000"
            ])
            sys.exit(0)
            
        # Get the currently focused workspace name
        focused = i3.get_tree().find_focused()
        original_workspace = focused.workspace().name if focused else None
        
        # Don't switch if we are already on the overview workspace
        if original_workspace == OVERVIEW_WORKSPACE:
            sys.exit(0)
            
        # Save the state
        state = {
            "original_workspace": original_workspace,
            "window_ids": [win.id for win in scratch_windows]
        }
        with open(STATE_FILE, "w") as f:
            json.dump(state, f)
            
        # Switch to the overview workspace and enforce horizontal layout
        i3.command(f"workspace {OVERVIEW_WORKSPACE}")
        i3.command("layout splith")
        
        # Distribute windows into a grid layout
        cols = distribute_windows(scratch_windows)
        
        # Move the first window of each column to the workspace and tile them
        for col in cols:
            first_win = col[0]
            i3.command(f"[con_id={first_win.id}] move container to workspace {OVERVIEW_WORKSPACE}")
            i3.command(f"[con_id={first_win.id}] floating disable")
            
        # Stack windows vertically in each column
        for col in cols:
            if len(col) > 1:
                curr_focus_id = col[0].id
                for next_win in col[1:]:
                    i3.command(f"[con_id={curr_focus_id}] focus")
                    i3.command("split v")
                    i3.command(f"[con_id={next_win.id}] move container to workspace {OVERVIEW_WORKSPACE}")
                    i3.command(f"[con_id={next_win.id}] floating disable")
                    curr_focus_id = next_win.id

if __name__ == "__main__":
    main()
