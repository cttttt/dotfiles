-- opens a terminal below the current window with a cwd of current buffer's
-- file's directory.
--
-- this is an alternative to using autochdir that doesn't cause plugins to
-- break
vim.api.nvim_create_user_command('Terminal', function (opts)
  if vim.bo.filetype == 'neo-tree' then
    return
  end

  local original_window = vim.api.nvim_get_current_win()
  vim.cmd('split')
  vim.api.nvim_set_current_win(original_window)

  local cur_file_dir = vim.fn.expand("%:p:h")
  ---@cast cur_file_dir string

  -- special buffers will not have a filesystem path. in these cases, we should
  -- not try to change to the dirname of the current file.
  if not(cur_file_dir == nil) and cur_file_dir:find('^/') then
    vim.cmd({ cmd = 'lcd', args = { cur_file_dir } })
  end

  vim.cmd({
    cmd = 'terminal',
    args = opts.fargs,
  })
end, { nargs = '*' })
