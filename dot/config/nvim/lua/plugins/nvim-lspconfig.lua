return {
  'neovim/nvim-lspconfig',
  config = function ()
    for server, settings in pairs({
      gopls = {
        settings = {
        },
      },
      rust_analyzer = {},
      solargraph = {},
      basedpyright = {},
      tsserver = {},
      terraformls = {},
      lua_ls = {},
    }) do
      require('lspconfig')[server]
      .setup(settings)
    end

    vim.diagnostic.config({
      severity_sort = true,
    })
  end,
  dependencies = {
    "folke/neodev.nvim",
  },
}
