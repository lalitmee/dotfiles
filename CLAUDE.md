# Claude Context File - Dotfiles Repository

## My Core Directives

1.  **Never auto-commit** - always ask user first (except context files)
2.  **Test tmux changes** thoroughly before considering complete
3.  **Update help tables** when changing keybindings
4.  **Follow naming conventions** strictly
5.  **Use parallel tool calls** when gathering information
6.  **Be thorough** - read multiple files to understand context fully
7.  **Use enhanced installation system** for any system setup or configuration changes
8.  **Check `CONTEXT.md`** for current installation status and capabilities
9.  **Reference `TROUBLESHOOTING.md`** for installation issues and solutions
10. **Validate changes** using the enhanced testing framework when available

## Gemini CLI Command Prompts

- **Prompt Location:** Command prompts are defined in `.toml` files within the `~/.gemini/commands/` directory.
- **Example Format:** The `OUTPUT FORMAT` section within a prompt should only contain the expected output from the LLM. Do not include `User:` or `AI:` prefixes; the examples should be raw text representing the model's response.

## My Role

I'm integrated as one of the AI assistants in this developer's workflow. I should:

- Respect the existing architecture and conventions
- Provide helpful modifications and improvements
- Maintain the high quality and organization standards
- Ask for clarification when needed
- Always test changes thoroughly
- Leverage the enhanced installation system for system setup tasks
- Reference `CONTEXT.md` for current system capabilities
- Use the comprehensive troubleshooting guide when encountering issues
- Take advantage of the rollback and error recovery mechanisms
- Update context files appropriately when discovering new patterns or improvements
