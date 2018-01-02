" vim:foldmethod=marker
"

" Helps airline glyphs display in Windows
set encoding=utf8

" setup tips {{{
"
" Before this .vimrc can be used:
"
" - Install vim-plug:
"
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" - And to install the included plugins:
"
"   vim +PlugInstall
"
" - After editing the config, to uninstall unused plugins:
"
"   vim +PlugClean
"
" - Install fzf:
"
"   - On OSX: brew update && install fzf
"   - On Linux: git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
"   - On Windows: I dunno
"
" }}}

" vim-plug {{{

call plug#begin('~/.config/nvim/plugged')

" plugins {{{

Plug 'nightsense/vim-crunchbang'        " theme
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
Plug 'fatih/vim-go'                     " go toolchain integration
Plug '/usr/local/opt/fzf'
            \ | Plug '$HOME/.fzf' 
            \ | Plug 'junegunn/fzf.vim' " fuzzy finder
Plug 'tpope/vim-rhubarb'                " Gbrowse support for GitHub
Plug 'nightsense/vimspectr'             " the last theme
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug '/usr/local/Cellar/global/6.6.1/share/gtags/gtags.vim'

" }}}

call plug#end()

" }}}

" plugin configuration {{{

" airline {{{
let g:airline_powerline_fonts = 1                   " use special symbols
set laststatus=2                                    " always show airline
let g:airline#extensions#tabline#enabled = 1        " show buffers up top
let g:airline#extensions#tabline#fnamemod = ':t'    " only show the filename
let g:airline#extensions#tabline#buffer_nr_show = 1 " show index of buffers
" }}}

" ack {{{
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" }}}

" fzf {{{
let g:fzf_action = {
  \ 'ctrl-p': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" }}}

" ale {{{
let g:ale_linters = {'go': ['gofmt', 'go lint', 'go vet', 'go build']}
let g:ale_lint_delay=2000
" }}}


" }}}

" bindings  {{{
let mapleader=';'
nmap <C-t> :Files<CR>
nmap <C-e> :NERDTree<CR>
nmap <Leader>e :NERDTreeFind<CR>
nmap <Leader><C-e> :NERDTreeFind<CR>
let NERDTreeQuitOnOpen=1
nmap <Leader>u :UndotreeToggle<CR>
nmap gm :LivedownToggle<CR>
nmap <Leader>bb :b#<CR>
nmap <Leader>b3 :b#<CR>
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
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_exclude_patterns = ['scp://.*']
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

set directory-=.
let &directory=substitute(&directory,',','//,','')

" Try and speed up ctrlp by using ag
if executable("ag")
    let g:ctrlp_user_command = 'ag %s -U -i --nocolor --nogroup --hidden --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store --ignore "**/*.pyc" -g ""'
endif

if has('python')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

" Bite the bullet and use line numbers
set number

" Make screen redraws faster with all these complex colours
set lazyredraw

let g:deoplete#enable_at_startup = 1
" }}}

" asthetics {{{

set termguicolors

" colorscheme jaime
" colorscheme dracula
" colorscheme crunchbang
" colorscheme basic-dark

let g:vimspectr30curve_dark_StatusLine = 'yellow'
colorscheme vimspectr30curve-dark

" let g:airline_theme='molokai'
" let g:airline_theme='bubblegum'

" colorscheme flattened_dark
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
hi Search term=bold cterm=bold ctermbg=LightYellow ctermfg=Black guibg=#ffff00 guifg=black

" Use a vertical bar for vertical splits
"
" This looks better, but a space isn't recognized as a line by iTerm.  So the
" natural selection feature doesn't work.
"
" set fillchars+=vert:\
"

" While scrolling, VIM blanks the background sometimes.  This fixes that
" behaviour.
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
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

" windows-specific-settings {{{
if has('win32')
    let $PATH = 'C:\Program Files (x86)\Git\bin;' . $PATH
    set shell=C:\Progra~1\Git\bin\bash.exe
endif
" }}}

" - chris
