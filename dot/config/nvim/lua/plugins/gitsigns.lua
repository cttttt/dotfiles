if not vim.g.vscode then
  return {
    'lewis6991/gitsigns.nvim',
    config = true,
    opts = {
      numhl = true,
    },
  }
else
  return {}
end
