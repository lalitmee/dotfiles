if vim.g.neovide then
    -- font
    vim.o.guifont = "Operator Mono Lig Book:h11"
    -- vim.o.guifont = "IosevkaTerm NF:h11"

    -- floating blur
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- transparency
    vim.g.neovide_opacity = 0.7

    -- theme
    vim.g.neovide_theme = "auto"
end
