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
    }) do
      require('lspconfig')[server]
      .setup(settings)
    end
  end
}
