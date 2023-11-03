-- allows vim to write to the terminal's clipboard
return {
  'ojroques/nvim-osc52',
  config = function ()
    require('osc52').setup({
        tmux_passthrough = true,
        silent = true,
    })

    local copy = function(lines, _)
      require('osc52').copy(table.concat(lines, '\n'))
    end

    local paste = function()
      local nil_reg = vim.fn.getreg('')

      ---@cast nil_reg string
      return {vim.fn.split(nil_reg, '\n'), vim.fn.getregtype('')}
    end

    vim.g.clipboard = {
      name = 'osc52',
      copy = {['+'] = copy, ['*'] = copy},
      paste = {['+'] = paste, ['*'] = paste},
    }
  end
}
