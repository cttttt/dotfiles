return {
  'dgagn/diagflow.nvim',
  event = 'LspAttach',
  config = true,
  opts = {
    scope = 'line',
    show_sign = true,
    enable = function()
      return vim.bo.filetype ~= "lazy" and vim.bo.filetype ~= "neo-tree"
    end,
  },
}
