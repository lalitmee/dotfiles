# Brave PWAs Scratchpads Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate all remaining Pake applications (Gemini, WhatsApp, Excalidraw, Music for Programming, and NotebookLM) to Brave PWAs and configure them for toggleable scratchpad/workspace behavior.

**Architecture:**
1. Update `sxhkdrc` shortcuts to launch Brave PWAs by their specific `--app-id` and search by their `--instance` (`crx_*`).
2. Update i3's `scratchpads.conf` to float and size the Brave PWA scratchpads.
3. Update `i3-smart-assign.py` to prioritize `instance` matching over `class` matching and ignore unmatched Chrome/Brave PWAs (those starting with `crx_`), preventing them from being swept by general browser class routing rules.
4. Update `assignments.json` to assign the Excalidraw Brave PWA to Workspace 6 using its instance ID.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass), Python (i3ipc).

## Global Constraints
- Do not commit or push changes without explicit user approval.
- Ask for confirmation before making any changes.
- After modifying any code, verify the syntax to ensure correctness and prevent regressions.

---

### Task 1: Update sxhkdrc Configuration

**Files:**
- Modify: [sxhkdrc](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc#L280-L372)

- [ ] **Step 1: Replace all Pake launchers with Brave PWA launchers**

  In [sxhkdrc](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc), replace the following sections:

  **NotebookLM (`super + ctrl + n`):**
  ```
  # >> assistant -> notebooklm
  super + ctrl + n
      i3run --summon --instance pake-notebooklm -- pake-notebooklm
  ```
  with:
  ```
  # >> assistant -> notebooklm (brave pwa)
  super + ctrl + n
      i3run --summon --instance crx_gjcmcplpgihbecacndmmbaenpfgimlec -- brave-browser --app-id=gjcmcplpgihbecacndmmbaenpfgimlec
  ```

  **Music for Programming (`super + shift + m`):**
  ```
  # >> music player -> music for programming
  super + shift + m
      i3run --summon --instance pake-programmusic -- pake-programmusic
  ```
  with:
  ```
  # >> music player -> music for programming (brave pwa)
  super + shift + m
      i3run --summon --instance crx_jhcembbiknekhcfklaahjjojbciaphaa -- brave-browser --app-id=jhcembbiknekhcfklaahjjojbciaphaa
  ```

  **Gemini (`super + g`):**
  ```
  # >> assistant -> gemini
  super + g
      i3run --summon --instance pake-gemini -- pake-gemini
  ```
  with:
  ```
  # >> assistant -> gemini (brave pwa)
  super + g
      i3run --summon --instance crx_gdfaincndogidkdcdkhapmbffkckdkhn -- brave-browser --app-id=gdfaincndogidkdcdkhapmbffkckdkhn
  ```

  **WhatsApp (`super + i`):**
  ```
  # >> communication -> whatsapp
  super + i
      i3run --summon --instance pake-whatsapp -- pake-whatsapp
  ```
  with:
  ```
  # >> communication -> whatsapp (brave pwa)
  super + i
      i3run --summon --instance crx_hnpfjngllnobngcgfapefoaidbinmjnm -- brave-browser --app-id=hnpfjngllnobngcgfapefoaidbinmjnm
  ```

  **Excalidraw (`super + x`):**
  ```
  # >> design -> excalidraw
  super + x
      i3run --summon --instance pake-excalidraw -- pake-excalidraw
  ```
  with:
  ```
  # >> design -> excalidraw (brave pwa)
  super + x
      i3run --summon --instance crx_dnfpoenibinnbbckgbhendmlljoobcfg -- brave-browser --app-id=dnfpoenibinnbbckgbhendmlljoobcfg
  ```

- [ ] **Step 2: Verify the file diff**

  Run: `git diff sxhkd/.config/sxhkd/sxhkdrc`
  Expected: All 5 hotkeys are updated to run Brave PWAs.

- [ ] **Step 3: Commit changes**

  Ask the user for approval first, then run:
  ```bash
  git add sxhkd/.config/sxhkd/sxhkdrc
  git commit -m "feat(sxhkd): replace remaining pake launchers with brave PWAs"
  ```

---

### Task 2: Update i3 scratchpads.conf Configuration

**Files:**
- Modify: [scratchpads.conf](file:///home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf#L29-L35)

- [ ] **Step 1: Replace window rules for Pake apps with Brave PWA rules**

  In [scratchpads.conf](file:///home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf), replace:
  ```
  # >> pake applications
  # for_window [class="(?i)pake-gemini"] floating enable, resize set 1800 1000, move position center
  for_window [class="(?i)pake-whatsapp"] floating enable, resize set 1800 1000, move position center
  for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
  for_window [class="(?i)pake-programmusic"] floating enable, resize set 1800 1000, move position center
  for_window [class="(?i)pake-notebooklm"] floating enable, resize set 1800 1000, move position center
  ```
  with:
  ```
  # >> pake applications (deprecated)
  # for_window [class="(?i)pake-gemini"] floating enable, resize set 1800 1000, move position center
  # for_window [class="(?i)pake-whatsapp"] floating enable, resize set 1800 1000, move position center
  # for_window [class="(?i)pake-programmusic"] floating enable, resize set 1800 1000, move position center
  # for_window [class="(?i)pake-notebooklm"] floating enable, resize set 1800 1000, move position center

  # >> brave pwa scratchpads
  for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
  for_window [instance="crx_gdfaincndogidkdcdkhapmbffkckdkhn"] floating enable, resize set 1800 1000, move position center
  for_window [instance="crx_hnpfjngllnobngcgfapefoaidbinmjnm"] floating enable, resize set 1800 1000, move position center
  for_window [instance="crx_jhcembbiknekhcfklaahjjojbciaphaa"] floating enable, resize set 1800 1000, move position center
  for_window [instance="crx_gjcmcplpgihbecacndmmbaenpfgimlec"] floating enable, resize set 1800 1000, move position center
  ```

- [ ] **Step 2: Verify the file diff**

  Run: `git diff i3/.config/i3/scratchpads.conf`

- [ ] **Step 3: Commit changes**

  Ask the user for approval first, then run:
  ```bash
  git add i3/.config/i3/scratchpads.conf
  git commit -m "feat(i3): map brave PWAs to floating scratchpads"
  ```

---

### Task 3: Update i3-smart-assign.py and assignments.json

**Files:**
- Modify: [i3-smart-assign.py](file:///home/lalitmee/dotfiles/i3/.config/i3/scripts/i3-smart-assign.py)
- Modify: [assignments.json](file:///home/lalitmee/dotfiles/i3/.config/i3/scripts/assignments.json)

- [ ] **Step 1: Update i3-smart-assign.py to support instance matching and ignore other PWAs**

  In [i3-smart-assign.py](file:///home/lalitmee/dotfiles/i3/.config/i3/scripts/i3-smart-assign.py), update `find_matching_assignment` to:
  ```python
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
  ```

  Also update `get_windows_by_class` to match both classes and instances:
  ```python
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
  ```

  And update `on_window_new` calls to pass the instance parameter:
  ```python
      window_class = event.container.window_class
      window_title = event.container.name
      window_instance = event.container.window_instance
      
      if not window_class:
          logger.debug(f"Window without class detected: {window_title}")
          return

      logger.info(f"New window: class='{window_class}', instance='{window_instance}', title='{window_title}'")
      
      # Find matching assignment
      assignment_key, assignment_data = find_matching_assignment(window_class, window_instance, assignments)
  ```

- [ ] **Step 2: Update assignments.json to route Excalidraw PWA to workspace 6**

  In [assignments.json](file:///home/lalitmee/dotfiles/i3/.config/i3/scripts/assignments.json), replace the `"pake-excalidraw"` key:
  ```json
      "pake-excalidraw": {
          "classes": ["pake-excalidraw", "Pake-excalidraw"],
          "workspace": "6"
      }
  ```
  with:
  ```json
      "excalidraw": {
          "instances": ["crx_dnfpoenibinnbbckgbhendmlljoobcfg"],
          "workspace": "6"
      }
  ```

- [ ] **Step 3: Verify the file diffs**

  Run:
  ```bash
  git diff i3/.config/i3/scripts/i3-smart-assign.py
  git diff i3/.config/i3/scripts/assignments.json
  ```

- [ ] **Step 4: Commit changes**

  Ask the user for approval first, then run:
  ```bash
  git add i3/.config/i3/scripts/i3-smart-assign.py i3/.config/i3/scripts/assignments.json
  git commit -m "feat(i3): support PWA instance routing in smart assignment script"
  ```

---

### Task 4: Reload and Verify

- [ ] **Step 1: Reload configurations**

  Run:
  ```bash
  i3-msg reload && pkill -USR1 -x sxhkd
  ```

- [ ] **Step 2: Restart the i3 smart assign Python script**

  Run:
  ```bash
  pkill -f i3-smart-assign.py
  ~/.config/i3/scripts/venv/bin/python ~/.config/i3/scripts/i3-smart-assign.py &
  ```

- [ ] **Step 3: Test each hotkey**

  Verify each of the following:
  1. `super + g`: Launches Brave Gemini PWA, floats, centers, and displays.
  2. `super + ctrl + n`: Launches Brave NotebookLM PWA, floats, centers, and displays.
  3. `super + shift + m`: Launches Brave Music for Programming PWA, floats, centers, and displays.
  4. `super + i`: Launches Brave WhatsApp Web PWA, floats, centers, and displays.
  5. `super + x`: Launches Brave Excalidraw PWA, tile-routes it to workspace 6.
