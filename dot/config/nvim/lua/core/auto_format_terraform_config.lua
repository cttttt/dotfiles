-- so i'm not embarassed by ci
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tf', '*.tfvars', '*.go' },
  callback = function()
    vim.lsp.buf.format()
  end
})
