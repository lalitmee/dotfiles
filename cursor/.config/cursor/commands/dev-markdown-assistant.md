---
description: Formatting to follow while writing Markdown files
alwaysApply: false
---

# Markdown Formatting Standards

When writing or editing Markdown files, strictly follow these formatting rules to ensure clean, lint-free documents:

## Heading Rules

- **Always add blank lines**: Insert one blank line before AND after every heading
- Example:

  ```markdown
  content here

  ## Heading

  more content
  ```

## Code Block Rules

- **Language specification**: Always specify language for fenced code blocks
  - Use appropriate language: `bash`, `javascript`, `typescript`, `python`, `json`, `text`, etc.
  - Use `text` for plain text or when no specific language applies
- **Blank lines**: Add one blank line before AND after every code fence
- Example:

  ```markdown
  text content

  \`\`\`bash
  command here
  \`\`\`

  more text
  ```

## List Rules

- **Blank lines around lists**: Add one blank line before the first list item and after the last list item
- **Consistent markers**: Use `-` for unordered lists, numbers for ordered lists
- **Indentation**: Use 2 spaces for nested list items
- Example:

  ```markdown
  paragraph text

  - First item
  - Second item
    - Nested item
  - Third item

  next paragraph
  ```

## Subsection (h3, h4) Rules

- **Blank line below heading**: Always add one blank line after subsection headings before content
- Example:

  ```markdown
  ### Subsection Title

  Content starts here with blank line above
  ```

## General Rules

- **No multiple blank lines**: Never use more than one consecutive blank line
- **No trailing spaces**: Remove trailing whitespace from lines
- **Consistent line breaks**: Use Unix-style line breaks (LF, not CRLF)

## Auto-Apply

When creating or editing ANY Markdown file:

1. Automatically insert blank lines around headings
2. Always add language tags to code blocks
3. Add blank lines around lists
4. Remove multiple consecutive blank lines
5. Verify formatting before completing the edit

## Verification

After creating/editing Markdown:

- Mentally verify blank lines around all headings
- Check all code blocks have language tags
- Ensure lists have surrounding blank lines
- Confirm no multiple blank lines exist
