return {
  'nvim-neo-tree/neo-tree.nvim',
  config = function ()
    vim.keymap.set('n', '<leader>n', function ()
      vim.cmd.Neotree('toggle')
    end, {})

    vim.keymap.set('n', '<leader>N', function ()
      vim.cmd.Neotree('reveal')
    end, {})
  end,
  opts = {
    filesystem = {
      use_libuv_file_watcher = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  }
}
