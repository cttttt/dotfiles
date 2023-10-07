-- -- table.unpack may not be available in older versions of lua
table.unpack = table.unpack or unpack

-- for some reason, rhubarb uses netrw's Browse to open
-- things, like urls. vim-tree requires me to disable netrw.
vim.api.nvim_create_user_command('Browse', function(opts)
  vim.ui.open(table.unpack(opts.fargs))
end, { bang = true, nargs = 1 })

