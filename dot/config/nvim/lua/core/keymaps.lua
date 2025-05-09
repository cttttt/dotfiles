vim.keymap.set('n', '<leader>bb', function ()
  vim.cmd('b#')
end, {})

vim.keymap.set('v', '<C-c>', '"+y', {})

vim.keymap.set('n', '<leader>lg', function ()
  vim.cmd.Terminal({args = {"lazygit"}})
end, {})

vim.keymap.set("n", "<Leader>cd", function ()
  require("lsp_lines").toggle()
end, {})

vim.keymap.set("n", "<Leader>cr", function ()
  vim.lsp.buf.rename()
end, {})

vim.keymap.set('n', '<leader>h', function ()
  vim.lsp.buf.hover()
end, {})

if not vim.g.vscode then
  vim.keymap.set("n", "<Leader>T", function ()
    vim.cmd('Terminal')
  end, {})

  vim.keymap.set("n", "<Leader>t", function ()
    vim.cmd('TmuxTerminal')
  end, {})
end
