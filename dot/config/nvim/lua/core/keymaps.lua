local map = vim.keymap.set

map('n', '<leader>bb', '<cmd>b#<cr>')
map('v', '<C-c>', '"+y')
map('n', '<leader>lg', '<cmd>Terminal lazygit<cr>')
map('n', '<Leader>cd', '<cmd>LspLines toggle<cr>')
map('n', '<Leader>cr', vim.lsp.buf.rename)
map('n', '<leader>h', vim.lsp.buf.hover)

if not vim.g.vscode then
  map('n', '<Leader>T', '<cmd>Terminal<cr>')
  map('n', '<Leader>t', '<cmd>TmuxTerminal<cr>')
  map('n', '<Leader>cp', '<cmd>Copilot panel<cr>')
  map('n', '<Leader>ts', '<cmd>Telescope<cr>')
  map('n', '<Leader>tr', '<cmd>Telescope resume<cr>')
end
