if not (vim.pack and vim.pack.add) then
    error("This Neovim configuration requires vim.pack.add.", 0)
end

vim.opt.packlockfile = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
vim.g.http_codes = { use = "snacks" }

for _, plugin in ipairs({
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "rrhelper",
    "spellfile_plugin",
    "tar",
    "tarPlugin",
    "tohtml",
    "tutor",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}) do
    vim.g["loaded_" .. plugin] = 1
end

local sources = {
    { src = "https://github.com/numToStr/Navigator.nvim.git" },
    { src = "https://github.com/Davidyz/VectorCode.git", version = vim.version.range("*") },
    { src = "https://github.com/andymass/vim-matchup.git" },
    { src = "https://github.com/barrettruth/diffs.nvim.git" },
    { src = "https://github.com/chrisgrieser/nvim-rip-substitute.git" },
    { src = "https://github.com/christoomey/vim-sort-motion.git" },
    { src = "https://github.com/cshuaimin/ssr.nvim.git" },
    { src = "https://github.com/dlyongemallo/diffview-plus.nvim.git", version = "release/v0.38" },
    { src = "https://github.com/famiu/bufdelete.nvim.git" },
    { src = "https://github.com/folke/flash.nvim.git" },
    { src = "https://github.com/folke/ts-comments.nvim.git" },
    { src = "https://github.com/gbprod/yanky.nvim.git" },
    { src = "https://github.com/justinmk/guh.nvim.git" },
    { src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary.git" },
    { src = "https://github.com/kevinhwang91/nvim-bqf.git" },
    { src = "https://github.com/yorickpeterse/nvim-pqf.git" },
    { src = "https://github.com/kevinhwang91/nvim-ufo.git" },
    { src = "https://github.com/kevinhwang91/promise-async.git" },
    { src = "https://github.com/kkharji/sqlite.lua.git" },
    { src = "https://github.com/L3MON4D3/LuaSnip.git" },
    { src = "https://github.com/lewis6991/gitsigns.nvim.git" },
    { src = "https://github.com/MagicDuck/grug-far.nvim.git" },
    { src = "https://github.com/mikavilpas/blink-ripgrep.nvim.git" },
    { src = "https://github.com/NeogitOrg/neogit.git" },
    { src = "https://github.com/nvim-lualine/lualine.nvim.git" },
    { src = "https://github.com/polarmutex/git-worktree.nvim.git", version = vim.version.range("^2") },
    { src = "https://github.com/pwntester/octo.nvim.git" },
    { src = "https://github.com/rafamadriz/friendly-snippets.git" },
    { src = "https://github.com/Rawnly/gist.nvim.git" },
    { src = "https://github.com/romainl/vim-cool.git" },
    { src = "https://github.com/saghen/blink.cmp.git", version = vim.version.range("*") },
    { src = "https://github.com/stevearc/oil.nvim.git" },
    { src = "https://github.com/stevearc/quicker.nvim.git" },
    { src = "https://github.com/tiagovla/scope.nvim.git" },
    { src = "https://github.com/tpope/vim-abolish.git" },
    { src = "https://github.com/tpope/vim-scriptease.git" },
    { src = "https://github.com/ve5li/better-goto-file.nvim.git" },
    { src = "https://github.com/XXiaoA/atone.nvim.git" },
    { src = "https://github.com/lalitmee/browse.nvim.git" },
    { src = "https://github.com/bngarren/checkmate.nvim.git" },
    { src = "https://github.com/lalitmee/cobalt2.nvim.git" },
    { src = "https://github.com/jinzhongjia/codecompanion-gitcommit.nvim.git" },
    { src = "https://github.com/ravitemer/codecompanion-history.nvim.git" },
    { src = "https://github.com/lalitmee/codecompanion-spinners.nvim.git" },
    { src = "https://github.com/olimorris/codecompanion.nvim.git", version = "v18.3.1" },
    { src = "https://github.com/mistricky/codesnap.nvim.git", version = "v2.1.1" },
    { src = "https://github.com/tjdevries/colorbuddy.nvim.git", version = "v1.0.0" },
    { src = "https://github.com/stevearc/conform.nvim.git" },
    { src = "https://github.com/willothy/flatten.nvim.git" },
    { src = "https://github.com/ray-x/go.nvim.git" },
    { src = "https://github.com/NMAC427/guess-indent.nvim.git" },
    { src = "https://github.com/m4xshen/hardtime.nvim.git" },
    { src = "https://github.com/ThePrimeagen/harpoon.git", version = "harpoon2" },
    { src = "https://github.com/barrett-ruth/http-codes.nvim.git" },
    { src = "https://github.com/hakonharnes/img-clip.nvim.git" },
    { src = "https://github.com/mizlan/iswap.nvim.git" },
    { src = "https://github.com/Redoxahmii/json-to-types.nvim.git" },
    { src = "https://github.com/folke/lazydev.nvim.git" },
    { src = "https://github.com/kawre/leetcode.nvim.git" },
    { src = "https://github.com/iamcco/markdown-preview.nvim.git" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim.git" },
    { src = "https://github.com/williamboman/mason.nvim.git" },
    { src = "https://github.com/ravitemer/mcphub.nvim.git" },
    { src = "https://github.com/liangxianzhe/nap.nvim.git" },
    { src = "https://github.com/danymat/neogen.git" },
    { src = "https://github.com/MunifTanjim/nui.nvim.git" },
    { src = "https://github.com/NvChad/nvim-colorizer.lua.git" },
    { src = "https://github.com/neovim/nvim-lspconfig.git" },
    { src = "https://github.com/kyazdani42/nvim-web-devicons.git", version = "master" },
    { src = "https://github.com/kylechui/nvim-surround.git" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context.git" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git", version = "main" },
    { src = "https://github.com/akinsho/org-bullets.nvim.git" },
    { src = "https://github.com/hamidi-dev/org-list.nvim.git" },
    { src = "https://github.com/danilshvalov/org-modern.nvim.git" },
    { src = "https://github.com/chipsenkbeil/org-roam.nvim.git" },
    { src = "https://github.com/hamidi-dev/org-super-agenda.nvim.git" },
    { src = "https://github.com/nvim-orgmode/orgmode.git" },
    { src = "https://github.com/lunarmodules/lua-mimetypes.git" },
    { src = "https://github.com/manoelcampos/xml2lua.git" },
    { src = "https://github.com/stevearc/overseer.nvim.git", version = "v1.6.0" },
    { src = "https://github.com/folke/persistence.nvim.git" },
    { src = "https://github.com/nvim-lua/plenary.nvim.git" },
    { src = "https://github.com/nvim-neotest/nvim-nio.git" },
    { src = "https://github.com/ThePrimeagen/refactoring.nvim.git", version = "master" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git" },
    { src = "https://github.com/dont-be-evil-company/kulala.nvim.git" },
    { src = "https://github.com/mrcjkb/rustaceanvim.git", version = vim.version.range("^5") },
    { src = "https://github.com/LintaoAmons/scratch.nvim.git" },
    { src = "https://github.com/NStefan002/screenkey.nvim.git" },
    { src = "https://github.com/folke/sidekick.nvim.git" },
    { src = "https://github.com/folke/snacks.nvim.git" },
    { src = "https://github.com/godlygeek/tabular.git" },
    { src = "https://github.com/johmsalas/text-case.nvim.git" },
    { src = "https://github.com/folke/todo-comments.nvim.git" },
    { src = "https://github.com/laktak/tome.git" },
    { src = "https://github.com/Wansmer/treesj.git" },
    { src = "https://github.com/folke/trouble.nvim.git" },
    { src = "https://github.com/ckolkey/ts-node-action.git" },
    { src = "https://github.com/tpope/vim-dadbod.git" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-completion.git" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-ui.git" },
    { src = "https://github.com/tpope/vim-repeat.git" },
    { src = "https://github.com/baskerville/vim-sxhkdrc.git" },
    { src = "https://github.com/folke/which-key.nvim.git" },
    { src = "https://github.com/Exafunction/windsurf.vim.git" },
}

local local_dev_root = vim.fn.expand("~/Projects/Personal/Github")
for index = #sources, 1, -1 do
    local source = sources[index]
    local owner, repo = source.src:match("github.com/([^/]+)/([^/]+)%.git$")
    local local_path = owner == "lalitmee" and (local_dev_root .. "/" .. repo) or nil
    if local_path and vim.fn.isdirectory(local_path) == 1 then
        vim.opt.rtp:prepend(local_path)
        table.remove(sources, index)
    end
end

if vim.env.HOME == "/home/lalitmee" then
    sources[#sources + 1] = { src = "https://github.com/wakatime/vim-wakatime.git" }
    sources[#sources + 1] = { src = "https://github.com/nvim-flutter/flutter-tools.nvim.git" }
end

local early_sources = {}
for index = #sources, 1, -1 do
    local source = sources[index]
    if source.src:match("/plenary%.nvim%.git$") or source.src:match("/nui%.nvim%.git$")
        or source.src:match("/nvim%-nio%.git$") or source.src:match("/lua%-mimetypes%.git$") then
        table.insert(early_sources, 1, table.remove(sources, index))
    elseif source.src:match("/xml2lua%.git$") then
        table.insert(early_sources, 1, table.remove(sources, index))
    end
end

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(event)
        local spec, kind = event.data.spec, event.data.kind
        if kind ~= "install" and kind ~= "update" then
            return
        end

        local name, path = spec.name, event.data.path
        local build = {
            ["codecompanion.nvim"] = function()
                local patch = vim.fn.stdpath("config") .. "/lua/patches/codecompanion/skip_oauth.patch"
                return { "patch", "--forward", "--batch", "-p1", "-i", patch }, path
            end,
            ["codesnap.nvim"] = function()
                return { "make", "build_generator" }, path
            end,
            ["json-to-types.nvim"] = function()
                return { "sh", "install.sh", "npm" }, path
            end,
            ["markdown-preview.nvim"] = function()
                return { "yarn", "install" }, path .. "/app"
            end,
            ["mcphub.nvim"] = function()
                return { "npm", "install", "-g", "mcp-hub@latest" }, path
            end,
        }
        if name == "nvim-treesitter" then
            if vim.fn.executable("tree-sitter") == 0 then
                local installers = {
                    { "npm", "install", "-g", "tree-sitter-cli" },
                    { "yarn", "global", "add", "tree-sitter-cli" },
                    { "cargo", "install", "tree-sitter-cli" },
                }
                for _, command in ipairs(installers) do
                    if vim.fn.executable(command[1]) == 1 then
                        vim.system(command, { text = true }):wait()
                        break
                    end
                end
            end
            vim.cmd("packadd nvim-treesitter")
            vim.cmd("TSUpdate")
            return
        end

        local command_factory = build[name]
        if command_factory then
            local command, cwd = command_factory()
            local result = vim.system(command, { cwd = cwd, text = true }):wait()
            if result.code ~= 0 then
                local message = name == "codecompanion.nvim" and "CodeCompanion patch failed: " or (name .. " build failed: ")
                vim.notify(message .. result.stderr, vim.log.levels.ERROR)
            elseif name == "codecompanion.nvim" then
                vim.notify("Patched codecompanion.nvim successfully", vim.log.levels.INFO)
            end
        end
    end,
})

vim.g.codeium_disable_bindings = 1
vim.g.codeium_filetypes_disabled_by_default = true
vim.pack.add(early_sources, { load = true, confirm = false })
for _, module in ipairs({ "lua-mimetypes", "xml2lua" }) do
    local module_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. module
    package.path = module_path .. "/?.lua;" .. module_path .. "/?/init.lua;" .. package.path
end
vim.pack.add(sources, { load = true, confirm = false })
require("colorbuddy").colorscheme("cobalt2")
