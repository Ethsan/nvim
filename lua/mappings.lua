local map = vim.api.nvim_set_keymap
local default_options = {noremap = true, silent = true}
local expr_options = {noremap = true, expr = true, silent = true}

map("n", "j", "gj", default_options)
map("n", "k", "gk", default_options)

map("t", "<C-w>", "<C-\\><C-n><C-w>", default_options)
