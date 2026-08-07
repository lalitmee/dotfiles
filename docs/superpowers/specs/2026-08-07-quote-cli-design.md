# Design Spec: Offline Quote CLI with Daily Category Rotation

This document outlines the architecture, data format, selection logic, and shell integration for the updated offline quote CLI.

## 1. Goals & Requirements

* **Fully Offline**: Display inspiring quotes without querying any remote API on terminal startup, avoiding network delays and API rate limits.
* **Daily Category Rotation**: Automatically rotate through 8 defined categories (one category per calendar day) so that all terminals opened on the same day share a consistent theme.
* **Fresh Quote on Open**: Within today's active category, select a new random quote each time a new terminal is opened.
* **Override Support**: Support manual command-line arguments to view specific categories or list all available themes.
* **Interactive Only**: Avoid displaying quotes on automated/non-interactive shell launches.
* **Robust Error Handling**: Exit silently if files are missing or empty on startup to prevent blocking terminal shell initialization.

## 2. Directory & File Structure

All files will be managed inside the existing `bin` stow package under the path `bin/.config/bin/`.

```text
bin/.config/bin/
├── gum_style (Existing helper for styling output)
├── quote (Executable shell script)
└── quotes/ (Directory storing offline quote databases)
    ├── confidence.txt (Quotes on self-confidence and self-belief)
    ├── humor.txt (Tech-focused humor and developer wit)
    ├── learning.txt (Growth mindset, dealing with failure, and curiosity)
    ├── motivation.txt (General inspiration and drive)
    ├── philosophy.txt (Stoic philosophy and ancient wisdom)
    ├── programming.txt (Quotes from programmers and computer science pioneers)
    ├── productivity.txt (Deep work, focus, and time management)
    └── wisdom.txt (Quotes from great leaders like Gates, Buffett, Jobs, etc.)
```

## 3. Database Format

Each file in the `quotes/` directory is a plain text file. Quotes are formatted with one entry per line, using the ` | ` (space-pipe-space) delimiter to separate the quote from the author:

```text
Talk is cheap. Show me the code. | Linus Torvalds
The only way to do great work is to love what you do. | Steve Jobs
Rule No. 1: Never lose money. Rule No. 2: Never forget Rule No. 1. | Warren Buffett
```

## 4. CLI Logic and Selection Algorithm

The Zsh script `quote` will implement the following flow:

### 4.1. Option & Argument Parsing
* **No arguments**: Runs the daily rotation algorithm.
* **`-l` or `--list`**: Scans the `quotes/` folder, lists all category names (stripping the `.txt` extension), and exits.
* **`-h` or `--help`**: Displays help documentation.
* **`<category>`** (e.g. `quote motivation`): Validates if the file `quotes/<category>.txt` exists. If it exists, uses it; otherwise, prints an error message and lists available categories.

### 4.2. Daily Category Rotation Algorithm
When run without arguments:
1. Scan `quotes/*.txt` files, sorting them alphabetically to build a stable list of categories.
2. Get the current day of the year (`date +%j`), parsed as a base-10 integer to prevent octal errors:
   ```zsh
   local day_of_year=$(( 10#$(date +%j) ))
   ```
3. Compute the active index using modulo arithmetic:
   ```zsh
   local num_categories=${#categories[@]}
   local index=$(( (day_of_year % num_categories) + 1 ))
   local active_category="${categories[$index]}"
   ```

### 4.3. Reading & Styling the Quote
1. Check if the chosen category file exists and has lines. If it doesn't:
   * On startup: Exit silently with code 0.
   * On manual call: Print an error message.
2. Select a random line using `shuf -n 1`.
3. Split the selected line using ` | ` into `quote_text` and `quote_author`.
4. Render the output using the existing `gum_style` helper with Cobalt2-themed parameters:
   ```zsh
   gum_style "$quote_string" "$QUOTE_COLOR" "$AUTHOR_COLOR"
   ```

## 5. Shell Integration

Add the following block to the end of `zsh/.zshrc`:

```zsh
# Show daily quote on interactive shell startup
if [[ -o interactive ]] && command -v quote &>/dev/null; then
    quote
fi
```
