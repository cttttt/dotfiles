local is_vscode = vim.g.vscode

if is_vscode then
  return {}
end

return {
  'williamboman/mason-lspconfig.nvim',
  opts = {
    ensure_installed = {
      'gopls',
      'rust_analyzer',
      'solargraph',
      'basedpyright',
      'ts_ls',
      'terraformls',
      'lua_ls',
      'helm_ls',
      'yamlls',
      'jsonnet_ls',
      'clangd',
    },
  },
}
