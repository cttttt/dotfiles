return {
  'williamboman/mason-lspconfig.nvim',
   opts = {
     ensure_installed = {
      "gopls",
      "rust_analyzer",
      "solargraph",
      "basedpyright",
      "ts_ls",
      "terraformls",
      "lua_ls",
      "helm_ls",
      "yamlls",
     }
   }
}
