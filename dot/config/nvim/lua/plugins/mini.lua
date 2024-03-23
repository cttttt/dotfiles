return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.completion').setup({
      lsp_completion = {
        source_func = 'omnifunc',
      }
    })

    -- see :help mini.nvim-disabling-recipes the mini-completion help
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'neo-tree*',
      callback = function ()
        vim.b.minicompletion_disable = true
      end
    })

  end,
}
