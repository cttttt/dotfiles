local is_vscode = vim.g.vscode

if is_vscode then
  return {}
end

return {
  'lewis6991/gitsigns.nvim',
  config = true,
  opts = {
    numhl = true,
  },
}
