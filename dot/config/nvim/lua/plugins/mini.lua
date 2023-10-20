return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.completion').setup({
      lsp_completion = {
        source_func = 'omnifunc',
      }
    })
  end,
}
