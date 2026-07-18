return {
  'google/vim-jsonnet',
  config = function ()
    vim.filetype.add({
      extension = {
        libjsonnet = 'jsonnet',
      },
    })
  end
}
