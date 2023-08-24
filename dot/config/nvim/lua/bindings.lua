vim.g.mapleader = ";"
vim.api.nvim_set_keymap('n', '<Leader>lg', ':term lazygit<CR>i', {})
vim.api.nvim_set_keymap('n', '<Leader>bb', ':b#<CR>', {})
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', {})

-- fzf
vim.api.nvim_set_keymap('n', '<C-t>', ':FZF<CR>', {})

-- ranger
vim.api.nvim_set_keymap('n', '<Leader>F', ':Ranger<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>f', ':RangerCurrentFile<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>cd', ':RangerCD<CR>', {})

-- nerdtree
vim.api.nvim_set_keymap('n', '<Leader>n', ':NerdTreeFocus<CR>', {})
