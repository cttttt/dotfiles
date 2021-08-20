vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'elzr/vim-json'
  use 'bling/vim-airline'
  use 'Raimondi/delimitMate'
  use {
    'junegunn/fzf',
    dir = '~/.fzf',
    run = './install --all'
  }
  use 'junegunn/fzf.vim'
  use 'chase/focuspoint-vim'
  use 'chase/vim-airline-focuspoint'
  use 'vim-scripts/bufexplorer.zip'
  use 'tpope/vim-git'
  use 'ryanoasis/vim-devicons'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-fugitive'
  use {
    'cttttt/ranger.vim',
    branch = 'add-ranger-cd'
  }

  -- required by ranger
  use 'rbgrouleff/bclose.vim'
end)
