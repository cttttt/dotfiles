return {
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
        layout_strategy = "vertical",
        mappings = {
          i = {
            ['<C-a>'] = actions.select_all,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_better,
            ["<CR>"] = select_one_or_multi,
          },
        },
      },
      pickers = {
        buffers = {
          show_all_buffers = true,
          sort_mru = true,
          mappings = {
            n = {
              ["d"] = "delete_buffer",
            },
            i = {
              ["<C-d>"] = "delete_buffer",
            },
          }
        },
      },
    })

    vim.keymap.set('n', '<C-t>', function ()
      require('telescope.builtin').find_files({
        hidden = true,
      })
    end, {})

    vim.keymap.set('n', '<C-p>', function ()
      require('telescope.builtin').builtin()
    end, {})

    vim.keymap.set("n", "<Leader>be", function ()
      require('telescope.builtin').buffers()
    end, {})

    vim.api.nvim_create_user_command('Ag', function (opts)
      require('telescope.builtin').live_grep({
        default_text = opts.args,
      })
    end, { nargs = '?' })
  end,
  dependencies = { 'nvim-lua/plenary.nvim' },
}
