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
      pylsp = {},
      tsserver = {},
      terraformls = {},
      lua_ls = {},
      actionlint = {},
    }) do
      require('lspconfig')[server]
      .setup(settings)
    end
  end,
  dependencies = {
    "folke/neodev.nvim",
  },
}
