My Dotfiles
===========

My `.vimrc`, `.screenrc` and other miscellaneous configuration files.

Installation
============

- Install `vim`.
- Install `Vundle`:

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

- Clone this repository somewhere.
- Install `tmux`.
- Run the `install.sh` script.
- Install the required bundles by running `vim +PluginClean! +PluginInstall
  +qa`.
- On Windows, install the [Meslo Powerline Fonts](https://github.com/powerline/fonts).
- Enjoy!


Maintaining
===========

- After installing, editing files in `dotfiles/` will edit dotfiles under `~`.
- Added files to `dotfiles/`?  Rerun `install.sh`.

<!--
:vim:tw:80
-->
