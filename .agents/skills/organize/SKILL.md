---
name: organize
description: Intelligently organizes files in directories based on content type, date, and purpose with safe automation
---

Organize and structure files in the specified directory.

## CRITICAL FORMAT REQUIREMENTS:
1. MUST use the `question` tool for EVERY user interaction — never ask questions as plain text

Please help organize files systematically:

1. **Directory Analysis:**
   - List all files and subdirectories: !`find "<target>" -type f | head -30`
   - Check current directory structure: !`ls -la "<target>"`
   - Identify file types and extensions: !`find "<target>" -type f | sed 's/.*.//' | sort | uniq -c | sort -nr`
   - Check file sizes and dates: !`ls -lah "<target>" | head -15`

2. **File Classification:**
   Categorize files by:
   - **Document Types:** PDFs, Word docs, spreadsheets, presentations
   - **Media Files:** Photos, videos, audio files
   - **Archives:** ZIP, RAR, tar files
   - **Code Files:** Source code, config files, scripts
   - **Data Files:** CSV, JSON, databases
   - **System Files:** Logs, temporary files, backups

3. **Content Analysis:**
   - Examine file contents where possible: !`file "<target>"/* | head -10`
   - Check creation and modification dates
   - Identify duplicate files: !`find "<target>" -type f -exec basename {} ; | sort | uniq -d | head -10`
   - Look for naming patterns and conventions

4. **Organization Strategy:**
   Use the `question` tool to present organization strategy options to the user:
   - **By Type:** Documents/, Images/, Videos/, Code/
   - **By Date:** 2024/, 2023/, Archive/
   - **By Project:** Project-A/, Project-B/, Personal/
   - **By Status:** Current/, Completed/, Draft/
   - **Hybrid:** Combine approaches for optimal organization

5. **Cleanup Opportunities:**
   - Identify temporary files that can be deleted
   - Find empty directories: !`find "<target>" -type d -empty`
   - Locate large files that might need archiving
   - Spot obvious junk files (.DS_Store, Thumbs.db, etc.)
   - Check for outdated or obsolete files

6. **Smart Suggestions:**
   - Group related files together
   - Suggest meaningful folder names
   - Identify files that should be archived
   - Recommend backup priorities
   - Flag important files that need special handling

7. **Safe Organization Commands:**
   Generate safe file operations:
   - Create directory structure first
   - Use `mv` commands with full paths
   - Include dry-run options for testing
   - Handle filename conflicts gracefully
   - Preserve important file attributes

8. **Automation Script:**
   Create a bash script that:
   - Creates necessary directories
   - Moves files to appropriate locations
   - Handles name conflicts safely
   - Logs all operations
   - Provides undo capabilities

9. **User Confirmation:**
   Before executing any file operations, use the `question` tool to present the proposed changes and ask the user to confirm. Include a dry-run option.

10. **Quality Control:**
    - Verify no files are lost during organization
    - Check that permissions are preserved
    - Ensure important files remain accessible
    - Test that organization makes sense
    - Validate against common file access patterns

11. **Maintenance Plan:**
    - Suggest ongoing organization rules
    - Recommend regular cleanup schedules
    - Provide templates for future file naming
    - Create guidelines for team consistency

Please provide:
- Detailed organization plan with rationale
- Safe commands to execute the organization
- Backup recommendations before making changes
- Maintenance suggestions for keeping organized

Example output:
```bash
# Create directory structure
mkdir -p "<target>/Documents/{PDF,Word,Spreadsheets}"
mkdir -p "<target>/Media/{Photos,Videos}"

# Organize files safely
mv "<target>"/*.pdf "<target>/Documents/PDF/"
```
