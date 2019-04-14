" vim:foldmethod=marker
"

" Helps airline glyphs display in Windows
set encoding=utf8

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
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-rhubarb'                " Gbrowse support for GitHub
Plug 'buc0/my-vim-colors'
Plug 'chase/focuspoint-vim'
Plug 'hashivim/vim-terraform'
Plug 'dyng/ctrlsf.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'        " a better file manager
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
" }}}

call plug#end()

" }}}

" }}}

" bindings  {{{
let mapleader=';'
nmap <C-t> :FZF<CR>
nmap <C-e> :NERDTree<CR>
nmap <Leader>e :NERDTreeFind<CR>
nmap <Leader><C-e> :NERDTreeFind<CR>
let NERDTreeQuitOnOpen=1
nmap <Leader>bb :b#<CR>
nmap <Leader>b3 :b#<CR>

autocmd FileType go nnoremap <C-]> :LspDefinition<CR>
autocmd FileType go nnoremap <Leader>h :LspHover<CR>
autocmd FileType go nnoremap <Leader>m :LspCodeAction<CR>
autocmd FileType go nnoremap <Leader>a :LspCodeAction<CR>
autocmd BufWritePre *.go :LspDocumentFormat
autocmd FileType go noremap gq :LspDocumentFormatSync
" }}}

" prefs {{{
set hidden

" For some reason, on the version of vim I have on my server, json files are
" taken as Javascript.
autocmd BufNewFile,BufRead *.json set ft=json

" Finally caving and expanding tabs, for everything but makefiles
autocmd FileType make set noexpandtab
autocmd FileType make set tabstop=8
autocmd FileType make set shiftwidth=8
autocmd FileType make set softtabstop=8

autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby set softtabstop=2
autocmd FileType eruby set shiftwidth=2
autocmd FileType eruby set softtabstop=2

" Hide node_modules directories in NERDTree.  Show them with 'f'.
let NERDTreeIgnore=['^node_modules$[[dir]]', '^.git[[dir]]']
let NERDTreeShowHidden=1

" Show the help for BufExplorer by default.  The bindings are kinda arbitrary.
let g:bufExplorerDefaultHelp=1

" I think one of the whole points of BufExplorer is to make it easy to delete
" NoName buffers.
let g:bufExplorerShowNoName=1

" Ignore editorconfig settings for special views
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*', '*\.go']

set directory-=.
let &directory=substitute(&directory,',','//,','')

" Bite the bullet and use line numbers
set number

" Make screen redraws faster with all these complex colours
" set lazyredraw

if has("nvim")
  let g:deoplete#enable_at_startup = 1
endif

" Enable mouse support
set mouse=a

let g:ale_pattern_options = {'\.go$': {'ale_enabled': 1}}

if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
endif

let g:lsp_signs_enabled = 0

autocmd FileType go setlocal omnifunc=lsp#complete

let g:airline#extensions#tabline#enabled = 1
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

" - chris
