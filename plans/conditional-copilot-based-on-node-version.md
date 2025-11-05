# Feature Implementation Plan: Conditional Copilot based on Node Version

## 📋 Todo Checklist
- [x] ✅ Implement a parameterized node version check function in a global utility file
- [x] ✅ Implement the function into the LSP servers configuration
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant files are:
- `/Users/lalit.kumar1/dotfiles/nvim/.config/nvim/lua/plugins/lsp/servers/init.lua`: This file configures the LSP servers.
- `/Users/lalit.kumar1/dotfiles/nvim/.config/nvim/lua/plugins/lsp/utils.lua`: A utility file for LSP-related functions.

### Current Architecture
The `init.lua` file returns a Lua table for LSP server configurations. The `utils.lua` file exports a module `M` that can be extended with our new function. By parameterizing the version check, we make the utility function more flexible and reusable.

### Dependencies & Integration Points
- The solution will depend on the `node` executable being in the system's `PATH`.
- The implementation will use Lua's `io.popen` to execute `node -v`.

### Considerations & Challenges
- **Error Handling**: The script should handle cases where `node` is not installed or the version string is unexpected.
- **Performance**: The impact of an external process call on startup is expected to be negligible.
- **Reusability**: Placing the function in `utils.lua` and parameterizing it makes it highly reusable for other plugins or configurations that may have different Node.js version requirements.

## 📝 Implementation Plan

### Prerequisites
- Neovim is set up with the existing configuration structure.
- `node` is installed on the system.

### Step-by-Step Implementation
1. **Step 1**: Add the parameterized `check_node_version` function to the LSP utility file.
   - **Files to modify**: `/Users/lalit.kumar1/dotfiles/nvim/.config/nvim/lua/plugins/lsp/utils.lua`
   - **Changes needed**: Add the following Lua function to the `M` module. This function accepts a `required_version` number, executes `node -v`, parses the major version, and returns `true` if the system's node version is greater than or equal to the required version.

   ```lua
   function M.check_node_version(required_version)
    local handle = io.popen("node -v")
    if not handle then
        return false
    end
    local output = handle:read("*a")
    handle:close()

    if output then
        local major_version = string.match(output, "v(%d+)")
        if major_version and tonumber(major_version) >= required_version then
            return true
        end
    end

    return false
end
   ```

2. **Step 2**: Conditionally enable the Copilot LSP server using the parameterized function.
   - **Files to modify**: `/Users/lalit.kumar1/dotfiles/nvim/.config/nvim/lua/plugins/lsp/servers/init.lua`
   - **Changes needed**: Require the `utils` module and use the new function, passing `22` as the required version, to set the `copilot` value.

   ```lua
   -- At the top of the file, with other requires:
   local utils = require("plugins.lsp.utils")

   -- In the returned table, modify the copilot line:
   -- from
   copilot = true,

   -- to
   copilot = utils.check_node_version(22),
   ```

### Testing Strategy
1. Open Neovim in a project with a Node.js version less than 22. Run `:LspInfo` and verify that Copilot is not an attached client.
2. Open Neovim in a project with Node.js version 22 or greater. Run `:LspInfo` and verify that Copilot is attached.
3. (Optional) Change the argument in `init.lua` to a different version (e.g., `utils.check_node_version(20)`) and verify the behavior changes accordingly.

## 🎯 Success Criteria
- The Copilot LSP server only starts if the Node.js version is 22 or higher.
- Neovim starts without errors, regardless of `node`'s installation status or version.
- The `check_node_version` function is reusable for different version checks from other parts of the configuration.