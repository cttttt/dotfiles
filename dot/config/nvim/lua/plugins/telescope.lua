return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    local select_one_or_multi = function(prompt_bufnr)
      local state = require('telescope.actions.state')
      local picker = state.get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()

      if not vim.tbl_isempty(multi) then
        actions.close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format('edit %s', j.path))
          end
        end
      else
        actions.select_default(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = {
        layout_strategy = 'vertical',
        mappings = {
          i = {
            ['<C-a>'] = actions.select_all,
            ['<C-q>'] = function(prompt_bufnr)
              actions.send_selected_to_qflist(prompt_bufnr)
              actions.open_qflist()
            end,
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
            ['<S-Tab>'] = function(prompt_bufnr)
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_worse(prompt_bufnr)
            end,
            ['<Tab>'] = function(prompt_bufnr)
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_better(prompt_bufnr)
            end,
            ['<CR>'] = select_one_or_multi,
          },
        },
      },
      pickers = {
        buffers = {
          show_all_buffers = true,
          sort_mru = true,
          mappings = {
            n = { ['d'] = 'delete_buffer' },
            i = { ['<C-d>'] = 'delete_buffer' },
          },
        },
      },
    })

    vim.keymap.set('n', '<C-t>', require('telescope.builtin').find_files, { desc = 'Find files (hidden)' })
    vim.keymap.set('n', '<C-p>', require('telescope.builtin').builtin, { desc = 'Telescope commands' })
    vim.keymap.set('n', '<Leader>be', require('telescope.builtin').buffers, { desc = 'Buffers' })

    vim.api.nvim_create_user_command('Ag', function(opts)
      require('telescope.builtin').live_grep({ default_text = opts.args })
    end, { nargs = '?' })
  end,
}
