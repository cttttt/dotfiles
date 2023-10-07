-- enter insert mode when opening a terminal
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd.startinsert()
    vim.wo.number = false
  end
})

