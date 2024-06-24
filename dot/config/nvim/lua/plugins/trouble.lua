return {
  'folke/trouble.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = true,
  keys = {
    {
      "<leader>ct",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
  },
  lazy = false,
}
