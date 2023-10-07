return { 
  'nvim-lualine/lualine.nvim',
  config = true,
  opts = {
    options = {
      disabled_filetypes = {
        'NvimTree',
      },
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
    },
  },
}
