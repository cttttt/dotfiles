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
  require("nvim-tree.api").tree.find_file({
    open = true,
    focus = true,
    update_root = true,
  })
end, {})

vim.keymap.set('v', '<C-c>', '"+y', {})

vim.keymap.set('n', '<C-t>', function ()
  require('telescope.builtin').find_files({
    hidden = true,
  })
end, {})

vim.keymap.set('n', '<C-P>', function ()
  require('telescope.builtin').builtin()
end, {})

vim.keymap.set('n', '<leader>lg', function ()
  vim.cmd('term lazygit')
end, {})

vim.keymap.set("n", "<Leader>cr", function ()
  vim.lsp.buf.rename()
end, {})

vim.keymap.set("n", "<Leader>t", function ()
  vim.cmd('Terminal')
end, {})

-- Plugin Setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins

-- install lazy

local nvim_config_path = vim.fn.stdpath('data')
local lazypath = nvim_config_path .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- configure plugins

require("lazy").setup({
  { 'williamboman/mason.nvim', config = true },
  { 
    'nvim-lualine/lualine.nvim',
    config = true,
    opts = {
      options = {
        disabled_filetypes = {
          'NvimTree',
        }
      }
    },
  },
  { 'lewis6991/gitsigns.nvim', config = true },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      local select_one_or_multi = function(prompt_bufnr)
        local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not vim.tbl_isempty(multi) then
          actions.close(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        else
          actions.select_default(prompt_bufnr)
        end
      end

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
              ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
              ['<Tab>'] = actions.toggle_selection + actions.move_selection_better,
              ["<CR>"] = select_one_or_multi,
            },
          },
        },
      })
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  'nvim-lua/plenary.nvim',
  'wbthomason/packer.nvim',
  'ryanoasis/vim-devicons',
  'jvirtanen/vim-hcl',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'elzr/vim-json',
  {
    'tpope/vim-rhubarb',
    config = function ()
      vim.cmd.ab({'Gbrowse', 'GBrowse'})
    end
  },
  'tpope/vim-fugitive',
  { 'neovim/nvim-lspconfig', 
    config = function ()
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
    end
  },
  'vim-scripts/bufexplorer.zip',
  {
    'akinsho/bufferline.nvim',
     opts = {
       options = {
         numbers = 'buffer_id',
         close_icon = '',
         buffer_close_icon = '󰅖',
       },
     }
  },
  'windwp/nvim-autopairs',
  {
    'nvim-tree/nvim-tree.lua',
    config = true,
    opts = {
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      renderer = {
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_opened_files = "all",
      },
      filters = {
        git_ignored = false,
      },
      diagnostics = {
        enable = true,
      }
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },
  { 'nvim-tree/nvim-web-devicons', config = true },
  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
     build = function()
       require('nvim-treesitter.install')
         .update({ with_sync = true })()
     end
  },
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      vim.keymap.set({ "v", "n" }, "<Leader>ca", require("actions-preview").code_actions)
    end
  },
  {
    'sainnhe/everforest',
    config = function ()
      vim.cmd.colorscheme('everforest')
      vim.opt.background = 'dark'
    end
  },
  {
    'notjedi/nvim-rooter.lua',
    config = true,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function ()
      require('telescope')
        .load_extension('fzf')
    end,
  }
})

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
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 8
  end
})

-- -- table.unpack may not be available in older versions of lua
table.unpack = table.unpack or unpack

-- for some reason, rhubarb uses netrw's Browse to open
-- things, like urls. vim-tree requires me to disable netrw.
vim.api.nvim_create_user_command('Browse', function(opts)
  vim.ui.open(table.unpack(opts.fargs))
end, { bang = true, nargs = 1 })

vim.api.nvim_create_user_command('Ag', function (opts)
  require('telescope.builtin').live_grep({
    default_text = opts.args,
  })
end, { nargs = '?' })

-- opens a terminal below the current buffer.  instead of using autochdir, just
-- make a command that does this directory.
vim.api.nvim_create_user_command('Terminal', function (opts)
  -- Until I discover ways to do this more directly using the API...
  local dir = vim.fn.expand("%:h:p")

  vim.cmd('split')

  if dir ~= '' then
    vim.cmd({
      cmd = 'lcd',
      args = {
        dir,
      }
    })
  end

  vim.cmd(vim.api.nvim_replace_termcodes('norm! <C-W>J', true, false, true))
  vim.cmd('terminal')
end, { nargs = '?' })
