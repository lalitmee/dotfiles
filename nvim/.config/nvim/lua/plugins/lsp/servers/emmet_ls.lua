local wk = require("which-key")

local lsp_utils = require("plugins.lsp.utils")

local on_attach = lsp_utils.on_attach

return {
    on_attach = function(client, bufnr)
        wk.register({
            [","] = {
                [","] = {
                    function()
                        client.request(
                            "textDocument/completion",
                            vim.lsp.util.make_position_params(),
                            function(_, result)
                                local textEdit = result[1].textEdit
                                local snip_string = textEdit.newText
                                textEdit.newText = ""
                                vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
                                require("luasnip").lsp_expand(snip_string)
                            end,
                            bufnr
                        )
                    end,
                    "Expand emmet",
                },
            },
        }, { mode = "i", noremap = true, buffer = bufnr })
        on_attach(client, bufnr)
    end,
}
