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
      -- yamlls = {},
      helm_ls = {},
    }) do
      require('lspconfig')[server]
      .setup(settings)
    end

    vim.diagnostic.config({
      severity_sort = true,
      update_in_insert = true,
    })
  end,
  dependencies = {
    "folke/neodev.nvim",
    "towolf/vim-helm",
  },
}
