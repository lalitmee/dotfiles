local M = {
    "phaazon/mind.nvim",
    cmd = {
        "MindOpenMain",
        "MindOpenProject",
        "MindOpenSmartProject",
    },
}

function M.config()
    require("mind").setup({
        ui = { width = 40 },
        keymaps = {
            normal = {
                T = function(args)
                    require("mind.ui").with_cursor(function(line)
                        local tree = args.get_tree()
                        local node = require("mind.node").get_node_by_line(tree, line)

                        if node.icon == nil or node.icon == " " then
                            node.icon = " "
                        elseif node.icon == " " then
                            node.icon = " "
                        end

                        args.save_tree()
                        require("mind.ui").rerender(tree, args.opts)
                    end)
                end,
            },
        },
    })
end

function M.init()
    -- create a new entry in Journal if it doesn't exist otherwise edit it
    lk.command("MindJournal", function()
        require("mind").wrap_main_tree_fn(function(args)
            local tree = args.get_tree()
            local path = vim.fn.strftime("/Journal/%Y/%b/%d")
            local _, node = require("mind.node").get_node_by_path(tree, path, true)
            if node == nil then
                vim.notify("cannot open journal 🙁", vim.log.levels.WARN)
                return
            end
            require("mind.commands").open_data(tree, node, args.data_dir, args.save_tree, args.opts)
            args.save_tree()
        end)
    end, {})

    lk.command("MindOpenFromMain", function()
        require("mind").wrap_main_tree_fn(function(args)
            require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
        end)
    end, {})

    lk.command("MindOpenFromSmart", function()
        require("mind").wrap_smart_project_tree_fn(function(args)
            require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
        end)
    end, {})

    lk.command("MindCopyFromMain", function()
        require("mind").wrap_main_tree_fn(function(args)
            require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
        end)
    end, {})

    lk.command("MindCopyFromMain", function()
        require("mind").wrap_smart_project_tree_fn(function(args)
            require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
        end)
    end, {})

    lk.command("MindCreateInSmart", function()
        require("mind").wrap_smart_project_tree_fn(function(args)
            require("mind.commands").create_node_index(
                args.get_tree(),
                require("mind.node").MoveDir.INSIDE_END,
                args.save_tree,
                args.opts
            )
        end)
    end, {})

    lk.command("MindCreateInMain", function()
        require("mind").wrap_main_tree_fn(function(args)
            require("mind.commands").create_node_index(
                args.get_tree(),
                require("mind.node").MoveDir.INSIDE_END,
                args.save_tree,
                args.opts
            )
        end)
    end, {})

    lk.command("MindInitializeProject", function()
        vim.notify("initializing project tree")
        require("mind").wrap_smart_project_tree_fn(function(args)
            local tree = args.get_tree()
            local mind_node = require("mind.node")

            local _, tasks = mind_node.get_node_by_path(tree, "/Tasks", true)
            tasks.icon = "陼"

            local _, backlog = mind_node.get_node_by_path(tree, "/Tasks/Backlog", true)
            backlog.icon = " "

            local _, on_going = mind_node.get_node_by_path(tree, "/Tasks/On-going", true)
            on_going.icon = " "

            local _, done = mind_node.get_node_by_path(tree, "/Tasks/Done", true)
            done.icon = " "

            local _, cancelled = mind_node.get_node_by_path(tree, "/Tasks/Cancelled", true)
            cancelled.icon = " "

            local _, notes = mind_node.get_node_by_path(tree, "/Notes", true)
            notes.icon = " "

            args.save_tree()
        end)
    end, {})
end

return M
