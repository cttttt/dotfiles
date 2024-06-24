return {
  'williamboman/mason-lspconfig.nvim',
   opts = {
     ensure_installed = {
      "gopls",
      "rust_analyzer",
      "solargraph",
      "basedpyright",
      "tsserver",
      "terraformls",
      "lua_ls",
      "helm_ls",
      "yamlls",
     }
   }
}
