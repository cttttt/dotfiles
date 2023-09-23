-- Colors
vim.cmd.colorscheme('evening')

-- Prefs
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.hls = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.winblend = 1
vim.opt.completeopt = 'menu,preview,menuone'

-- Tabs / Spacing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 8

-- Keybindings
vim.g.mapleader = ';'

vim.keymap.set('n', '<leader>bb', function ()
  vim.cmd('b#')
end, {})

vim.keymap.set('n', '<leader>n', function ()
  require("nvim-tree.api").tree.toggle()
end, {})

vim.keymap.set('n', '<leader>N', function ()
  require("nvim-tree.api").tree.find_file()
end, {})

vim.keymap.set('v', '<C-c>', '"+y', {})

vim.keymap.set('n', '<C-t>', function ()
  vim.fn["fzf#run"]({sink = 'e'})
end, {})



-- Plugin Setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins
vim.cmd.packadd('packer.nvim')

-- table.unpack may not be available in older versions of lua
table.unpack = table.unpack or unpack

pcall(function()
    require('mason').setup()
    require('nvim-web-devicons').setup()
    require('lualine').setup()
    require('gitsigns').setup()
    require('bufferline').setup({
      options = {
        numbers = 'buffer_id',
        close_icon = '',
        buffer_close_icon = '󰅖',
      },
    })
    require('nvim-tree').setup({
      git = {
        enable = true
      },
    })

    for server, settings in pairs({
      gopls = {
        flags = {
          debounce_text_changes = 150,
        },
      },
      rust_analyzer = {},
      solargraph = {},
      pylsp = {},
      tsserver = {},
    }) do
      require('lspconfig')[server]
          .setup(settings)
    end
end)

require('packer').startup(function()
  use('nvim-lualine/lualine.nvim')
  use('lewis6991/gitsigns.nvim')
  use('wbthomason/packer.nvim')
  use('junegunn/fzf.vim')
  use('ryanoasis/vim-devicons')
  use('jvirtanen/vim-hcl')
  use('williamboman/mason.nvim')
  use('williamboman/mason-lspconfig.nvim')
  use('elzr/vim-json')
  use('tpope/vim-rhubarb')
  use('tpope/vim-fugitive')
  use('neovim/nvim-lspconfig')
  use('vim-scripts/bufexplorer.zip')
  use('akinsho/bufferline.nvim')

  use({
    'folke/trouble.nvim',
    requires = {
      'nvim-tree/nvim-web-devicons'
    }
  })
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install')
        .update({ with_sync = true })()
    end
  })
  use({
    'windwp/nvim-autopairs',
    config = function ()
      require("nvim-autopairs").setup({})
    end
  })
  use({
    'nvim-tree/nvim-tree.lua',
    config = function () 
      require("nvim-tree").setup()
    end
  })
  use({
    'junegunn/fzf',
    dir = '~/.fzf',
    run = './install --all'
  })
end)

-- Quality of Life

-- enter insert mode when opening a terminal
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd.startinsert()
  end
})

-- some filetypes require actual tabs
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make,go',
  callback = function ()
    vim.opt.expandtab = false
    vim.opt.tabstop = 8
    vim.opt.shiftwidth = 8
    vim.opt.softtabstop = 8
  end
})

-- for some reason, the maintainer of rhubarb has
-- an aversion to the original capitalization of Gbrowse
vim.api.nvim_create_user_command('Gbrowse', function(opts)
  local cmd = 'GBrowse'

  if opts.bang then
    cmd = cmd .. '!'
  end

  vim.cmd(cmd)
end, { bang = true })

-- for some reason, rhubarb uses netrw's Browse to open
-- things, like urls. vim-git requires me to disable netrw.
vim.api.nvim_create_user_command('Browse', function(opts)
  vim.system({'open', table.unpack(opts.fargs)}, {}, nil)
end, { bang = true, nargs = 1 })
