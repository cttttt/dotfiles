" vim:foldmethod=marker

" setup tips {{{
"
" Before this .vimrc can be used:
"
" - Install vim-plug:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" - And to install the included plugins:
"   vim +PlugInstall
"
" - After editing the config, to uninstall unused plugins:
"   vim +PlugClean
"
" }}}

" vim-plug {{{
if has("nvim")
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" helpers {{{
function! InstallLanguageServers(info)
  if a:info.status == 'installed' || a:info.force
    " install gopls
    let l:gopls_package = "golang.org/x/tools"
    let l:gopls_src_dir = expand("~/src/" . l:gopls_package)
    let l:my_bingo_branch = "bingo-use-imports-for-full-file-format"

    " setup a directory under the GOPATH for gopls.
    "
    " start by creating an official go workspace
    call system("go get -u " . l:gopls_package)
    "
    " then add a few imporatnt remotes
    "
    " - official github mirror
    call system("git -C " . l:gopls_src_dir . " remote add golang git@github.com:golang/tools")
    "
    " - official and important fork (bingo branch is where it's at)
    call system("git -C " . l:gopls_src_dir . " remote add saibing git@github.com:saibing/tools")
    "
    " - my fork
    call system("git -C " . l:gopls_src_dir . " remote add cttttt git@github.com:cttttt/tools")
    "
    " - switch to a branch from my fork that uses Imports for formatting
    call system("git -C " . l:gopls_src_dir . " fetch cttttt")
    call system("git -C " . l:gopls_src_dir . " checkout -B cttttt/" . l:my_bingo_branch)
    "
    " - install the result
    call system("go install golang.org/x/tools/cmd/gopls")
  endif
endfunction
" }}}

" plugins {{{
Plug 'pangloss/vim-javascript'          " javascript movement/syntax
Plug 'elzr/vim-json'                    " hide quotes in json files
Plug 'scrooloose/nerdtree'              " file explorer
Plug 'xuyuanp/nerdtree-git-plugin'      " show git status in nerdtree
Plug 'bling/vim-airline'                " status bars
Plug 'vim-airline/vim-airline-themes'   " status bar themes
Plug 'Raimondi/delimitMate'             " paren/bracket matching
Plug 'tpope/vim-fugitive'               " git helpers
Plug 'vim-scripts/bufexplorer.zip'      " interactive buffer list
Plug 'editorconfig/editorconfig-vim'    " interpret editor agnostic configs
Plug 'tpope/vim-git'                    " syntax files for git commit messages
Plug 'ryanoasis/vim-devicons'           " glyphs for nerdtree/airline
Plug 'w0rp/ale'                         " async linting engine
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                 " fuzzy finder support
Plug 'tpope/vim-rhubarb'                " Gbrowse support for GitHub
Plug 'chase/focuspoint-vim'
Plug 'hashivim/vim-terraform'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'        " a better file manager
Plug 'prabirshrestha/vim-lsp', { 'do': function('InstallLanguageServers') }
                                        " language server support
Plug 'prabirshrestha/async.vim'         "  abstracts over async apis in vim/nvim
" }}}

call plug#end()
" }}}

" bindings  {{{
let mapleader=';'
nmap <C-t> :FZF<CR>
nmap <C-e> :NERDTree<CR>
nmap <Leader>e :NERDTreeFind<CR>
nmap <Leader><C-e> :NERDTreeFind<CR>
let NERDTreeQuitOnOpen=1
let NERDTreeHijackNetrw=0
nmap <Leader>f :RangerCurrentFile<CR>

" ctrl-shift-6 is hard to type
nmap <Leader>bb :b#<CR> 
vmap <C-c> "+y

autocmd FileType go nnoremap <C-]> :LspDefinition<CR>
autocmd FileType go nnoremap <Leader>h :LspHover<CR>
autocmd FileType go nnoremap <Leader>m :LspCodeAction<CR>
autocmd FileType go nnoremap <Leader>a :LspCodeAction<CR>
autocmd BufWritePre *.go :LspDocumentFormat
autocmd FileType go nnoremap gq :LspDocumentFormatSync
" }}}

" prefs {{{
" Helps airline glyphs display in Windows
set encoding=utf8

" Keep buffers open when opening new files (emulating tabs in other editors)
set hidden

" For some reason, on the version of vim I have on my server, json files are
" taken as Javascript.
autocmd BufNewFile,BufRead *.json set ft=json

" Finally caving and expanding tabs, for everything but makefiles, and go
autocmd FileType make set noexpandtab
autocmd FileType make set tabstop=8
autocmd FileType make set shiftwidth=8
autocmd FileType make set softtabstop=8

autocmd FileType go set noexpandtab
autocmd FileType go set tabstop=8
autocmd FileType go set shiftwidth=8
autocmd FileType go set softtabstop=8

" Use even smaller tabstops for ruby
autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby set softtabstop=2
autocmd FileType eruby set shiftwidth=2
autocmd FileType eruby set softtabstop=2

" Hide node_modules directories in NERDTree.  Show them with 'f'.
let NERDTreeIgnore=['^node_modules$[[dir]]', '^.git[[dir]]']
let NERDTreeShowHidden=1

" Show the help for BufExplorer by default.  The bindings are kinda arbitrary.
let g:bufExplorerDefaultHelp=1

" One of the whole points of BufExplorer is to make it easy to delete NoName
" buffers.
let g:bufExplorerShowNoName=1

" Ignore editorconfig settings for special views
" Also ignore editorconfig settings for Go source.  I've set things up so that
" we format on save, so that should reduce the need for editorconfig.
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*', '*\.go']
set directory-=.
let &directory=substitute(&directory,',','//,','')

" Use line numbers
set number

" Enable mouse support
set mouse=a

" Configure vim-lsp for Go
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
endif

" Neovim doesn't support the signs API vim-lsp uses.  When this is supported,
" we can disable ale for go source and re-enable lsp's signs support.
let g:lsp_signs_enabled = 0

" Use vim-lsp for CTRL+X,O while editing go source
autocmd FileType go setlocal omnifunc=lsp#complete

" Customize airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s·'
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffers_label = 'bufs'

" Open ranger instead of netrw
let g:ranger_replace_netrw = 1

" Disable the default mapping for <Leader>f
let g:ranger_map_keys = 0
" }}}

" asthetics {{{
set termguicolors
colorscheme focuspoint
syntax on

" In gvim, use a font the includes the special powerline symbols.
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline\ Nerd\ Font\ Complete\ Mono:h11,MesloLGS_NF:h9:cANSI,Meslo_LG_S_for_Powerline:h9:cANSI,Menlo\ for\ Powerline:h11,Meslo\ LG\ S\ Regular\ for\ Powerline:h11

" Show normal mode commands
set showcmd

" Highlight all matches after a search
set hls

" Hide the toolbar in the GUI
set guioptions-=T

" Highlight the current line
set cursorline

" Use bold instead of underline to highlight
hi Search term=bold cterm=bold ctermbg=LightYellow ctermfg=Black gui=bold guibg=#ffff99 guifg=black

" Make vertical split borders look like a column w/o characters in it.  There
" need to be actual pipe characters in it or iTerm won't know they're lines
" and the natural selection feature will not work.
hi VertSplit cterm=reverse gui=reverse guifg=grey30 guibg=grey30

" While scrolling, VIM blanks the background sometimes.  This fixes that
" behaviour.
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  set t_ut=
endif
" }}}

" indentation {{{
" 4 space tabstops, but still display tab characters with an 8
" character tabstop.
"
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

autocmd FileType go setlocal tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab
" }}}

" file specific settings {{{
augroup file_specific_settings
    autocmd!
    autocmd BufEnter .jshintrc setlocal filetype=json
    autocmd BufEnter .eslintrc setlocal filetype=json
augroup END
" }}}

" - by chris w/ ♥
