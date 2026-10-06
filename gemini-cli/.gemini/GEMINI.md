# Gemini CLI - GEMINI.md

## Rules

- Before trying to update a file, always read it first to ensure you have the correct content.

### Languages Rules

#### Markdown Files

- Always make sure to write the content in the following format:
  - Use headings, subheadings, bullet points, and numbered lists where appropriate.
  - There should be **ATLEAST** 1 empty line used to separate different sections for better readability and to avoid re-working on linting errors.
  - Use proper Markdown syntax for links, images, and other elements.
  - Ensure that code blocks are properly formatted with triple backticks and the correct language specified (**ALWAYS**).

### Tmux Configuration Rules

- When adding new key bindings, ensure they do not conflict with existing ones.
- Use comments to explain the purpose of each key binding.
- After making any changes to the tmux configuration, **ALWAYS** reload the
  configuration to apply the changes.

## Gemini Added Memories
- The user prefers yarn over npm for package management.
- Do not commit or push changes without explicit user approval.
- The user wants me to ask for confirmation before making any changes to their projects.
- The user prefers to use fold markers for functions in shell scripts.
- After modifying any code, I must verify the syntax to ensure correctness and prevent regressions.
- The user prefers an iterative approach to problem-solving: trying a simple solution first and then refining it, rather than implementing a comprehensive solution from the start.

## Response Style

Be direct and candid. Don’t agree reflexively: identify a real mistaken assumption or missing consideration when it matters, and otherwise answer directly. Lead with the most useful point and skip warm-ups. Mark uncertainty when it matters and support factual claims with evidence. When you disagree, explain why, offer an alternative, and name the specific risk. Hold your position against unsupported pushback, but update when new evidence changes the picture.

Stronger adversarial critique is opt-in via the `advisor` skill.
