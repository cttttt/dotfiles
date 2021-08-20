pcall(function ()
  vim.cmd('colorscheme focuspoint')
end)

-- keep buffers open when opening new files
vim.opt.hidden = true

-- indentation
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hls = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 8
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.winblend = 1

-- do not expand tabs for file formats that require tabs
function no_expand_tab(type)
  vim.cmd("autocmd FileType " .. type .. " set noexpandtab")
  vim.cmd("autocmd FileType " .. type .. " set tabstop=8")
  vim.cmd("autocmd FileType " .. type .. " set shiftwidth=8")
  vim.cmd("autocmd FileType " .. type .. " set softtabstop=8")
end

no_expand_tab_files = { 'make', 'go' }

for _, format in ipairs(no_expand_tab_files) do
  no_expand_tab(format)
end

-- certain configuration files contain json, but aren't considered json by vim
function set_filetype_json(filename)
  vim.cmd("autocmd BufEnter " .. filename .. " setlocal filetype=json")
end

json_filenames = { '.jshintrc', '.eslintrc' }

for _, filename in ipairs(json_filenames) do
  set_filetype_json(filename)
end

-- ranger

-- do not automatically map <Leader>f
vim.g.ranger_map_keys = 0
vim.g.ranger_replace_netrw = 1

-- bufexplorer

-- show help by default
vim.g.bufExplorerDefaultHelp = 1

-- show buffers with no loaded file
vim.g.bufExplorerShowNoName = 1

-- airline
vim.api.nvim_set_var('airline#extensions#tabline#enabled', 1)
vim.api.nvim_set_var('airline#extensions#tabline#overflow_marker', '…')
vim.api.nvim_set_var('airline#extensions#tabline#buffer_nr_show', 1)
vim.api.nvim_set_var('airline#extensions#tabline#buffer_nr_format', '%s·')
vim.api.nvim_set_var('airline#extensions#tabline#buffer_min_count', 2)
vim.api.nvim_set_var('airline#extensions#tabline#buffers_label', 'bufs')
vim.api.nvim_set_var(
  'airline#extensions#tabline#ignore_bufadd_pat',
  'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
)
