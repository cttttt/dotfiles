pcall(function ()
  vim.cmd('colorscheme sonokai')
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
vim.opt.completeopt = 'menu,preview,menuone'

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
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#overflow_marker'] = '…'
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
vim.g['airline#extensions#tabline#buffer_nr_format'] = '%s·'
vim.g['airline#extensions#tabline#buffer_min_count'] = 2
vim.g['airline#extensions#tabline#buffers_label'] = 'bufs'
vim.g['airline#extensions#tabline#ignore_bufadd_pat'] = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'

-- treesitter
pcall(function ()
  require'nvim-treesitter.configs'.setup {
    ignore_install = { },
    highlight = {
      enable = true,
      disable = { },
    },
    indent = {
      enable = false
    }
  }
end)

-- lsp
pcall(function ()
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

local lsp_servers = { 'gopls', 'rust_analyzer', 'solargraph', 'pylsp' }
local lsp_settings = {
  gopls = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  },
  rust_analyzer = {
    on_attach = on_attach,
  },
  solargraph = {
    on_attach = on_attach,
  },
  pylsp = {
    on_attach = on_attach,
  },
}

for _, lsp in ipairs(lsp_servers) do
  nvim_lsp[lsp].setup(lsp_settings[lsp])
end

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

end)


pcall(function ()
-- mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()
end
)
